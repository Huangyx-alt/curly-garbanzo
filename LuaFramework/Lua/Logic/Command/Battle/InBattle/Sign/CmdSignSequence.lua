--[[
Descripttion: 盖章工作流
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月5日14:10:20
LastEditors: gaoshuai
LastEditTime: 2025年8月5日14:10:20
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdSignSequence : CommandBase
local CmdSignSequence = BaseClass("CmdSignSequence", base)
local CommandConst = CommandConst

function CmdSignSequence:OnCmdExecute(args)
    if not args then
        args = self.options.args or {}
    end

    local model = ModelList.BattleModel:GetCurrModel()
    local total = GetTableLength(args.total)
    
    table.walk(args.total, function(v, k)
        local cardid, cellIndex, signType = v.cardId, v.index, 1
        local mark, extraPos = v.mark or 1, v.extraPos
        local cardidStr = tostring(cardid)
        local roundData = model:GetRoundData(cardidStr)
        local cell = model:GetRoundData(cardidStr, cellIndex)
        if cell:GetSignType() > signType then
            return
        end
        
        local oriSignType = cell.sign
        cell:SetSignType(signType)
        cell:SetMark(mark)
        
        local self_bingo = cell.self_bingo
        local giftLen = #cell.gift

        --流程
        local sequence = CommandSequence.New({ LogTag = "CmdSignSequence Sequence " .. k, })

        --处理表现层效果
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                Event.Brocast(EventName.Refresh_CardSign, cardidStr, cellIndex, signType, self_bingo, giftLen)
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end,
            LogTag = "CmdSignSequence 1",
        }))

        --收集道具表现
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                if signType == 1 and cell.gift and #cell.gift > 0 then
                    if ModelList.BattleModel:GetCurrBattleView():IsCardShowing(cardidStr) then
                        --模拟飞道具
                        --Event.Brocast(EventName.Cell_Item_FlyTo_Box, cardidStr, cellIndex, need_fly_item, cell.gift)
                        if v.needGiftShowOver then
                            Event.Brocast(EventName.Cell_Item_Get, cardidStr, cellIndex, cell.gift, function()
                                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                            end)
                        else
                            Event.Brocast(EventName.Cell_Item_Get, cardidStr, cellIndex, cell.gift)
                            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        end
                    else
                        --Event.Brocast(EventName.Hide_Cell_Item_Box, cardidStr, cellIndex, need_fly_item, cell.gift)
                        Event.Brocast(EventName.Hide_Cell_Item_Get, cardidStr, cellIndex, cell.gift)
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end
                else
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            end,
            LogTag = "CmdSignSequence 2",
        }))

        --触发技能
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                local skillCount = GetTableLength(cell.skill_id)
                if skillCount > 0 and oriSignType == 0 then
                    --有宠物技能
                    table.walk(cell.skill_id, function(skillId, k)
                        --log.b("skillId  "..skillId.."  cardidStr "..cardidStr.."  cellIndex "..cellIndex)
                        local powerId = nil
                        if #cell.powerId >= k then
                            powerId = cell.powerId[k]
                        end
                        if ModelList.BattleModel:IsRocket() then
                            extraPos = self:GetRocketExtraPosData(cardid, cellIndex)
                        elseif Csv.GetData("new_skill", skillId, "skill_type") == 1 then
                            extraPos = cell:GetPuExtraPos()
                        elseif Csv.GetData("new_skill", skillId, "skill_type") == 7 then
                            extraPos = cell:GetPuExtraPos()
                        end
                        Event.Brocast(EventName.CardPower_Pet_Skill, skillId, cardidStr, cellIndex, powerId, extraPos, function()
                            skillCount = skillCount - 1
                            if skillCount <= 0 then
                                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                            end
                        end)
                    end)
                else
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            end,
            LogTag = "CmdSignSequence 3",
        }))        
        
        --selfBingo
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                if cell.self_bingo and oriSignType == 0 then
                    local CmdSelfBingoSequence = require "Logic.Command.Battle.InBattle.Sign.CmdSelfBingoSequence"
                    local cmdSelfBingoSequence = CmdSelfBingoSequence.New()
                    cmdSelfBingoSequence:AddDoneFunc(function()
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end)
                    cmdSelfBingoSequence:Execute({
                        cardid = cardid,
                        cellIndex = cellIndex,
                    })
                else
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            end,
            LogTag = "CmdSignSequence 4",
        }))

        --其他
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                if signType == 2 then
                    roundData:BeBingo()
                elseif signType == 3 then
                    roundData:BeJackpot()
                elseif signType == 1 and self_bingo then
                    roundData:BeBingo()
                    cell:SetSignType(2)
                end

                if ModelList.GMModel.isSaveBattleData then
                    Event.Brocast(EventName.Recorder_Data, 5003, {
                        cardId = cardid,
                        cellIndex = cellIndex,
                        signType = signType,
                        need_fly_item = signType,
                        --mark = mark
                    })
                end

                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end,
            LogTag = "CmdSignSequence 5",
        }))

        --计算是否达成了Bingo
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                local gameType = model:GetGameType()
                --普通玩法需要立马检查是否达成bingo
                --某些特殊玩法bingo前会有其他表现
                if gameType == PLAY_TYPE.PLAY_TYPE_NORMAL then
                    --local cbFlag = false
                    model:CalcuateBingo(v.cardId, v.index, {
                        --onBingoShowComplete = function()
                        --    if not cbFlag then
                        --        cbFlag = true
                        --        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        --    end
                        --end
                    })
                end

                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end,
            LogTag = "CmdSignSequence 6",
        }))

        --结束
        sequence:AddDoneFunc(function()
            total = total - 1
            if total <= 0 then
                self:ExecuteDone(sequence.executeResult)
            end
        end)

        --开始
        sequence:Execute()
    end)
end

return CmdSignSequence