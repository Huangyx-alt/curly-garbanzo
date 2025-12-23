--[[
Descripttion: 扑克技能，向下方盖2*2的章 技能表现
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月5日10:35:57
LastEditors: gaoshuai
LastEditTime: 2025年8月5日10:35:57
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdPlaySkill101 : CommandBase
local CmdPlaySkill101 = BaseClass("CmdPlaySkill101", base)
local CommandConst = CommandConst

---OnCmdExecute
---@param args table {skill_id = skill_id,cardId = cardId,cellIndex = cellIndex,powerId = powerId,extraPos = extraPos}
function CmdPlaySkill101:OnCmdExecute(args)
    args = args or {}
    local skill_id, cardId, cellIndex, powerId, extraPos = args.skill_id, args.cardId, args.cellIndex, args.powerId, args.extraPos
    local cardPower = args.cardPower
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cellObj = cardView:GetCardCell(tonumber(cardId), cellIndex)
    local cardObj = cardView:GetCardMap(cardId)

    local data = Csv.GetData("new_skill", skill_id, "skill_xyz")
    extraPos = {}
    table.walk(data, function(offset)
        local ori_x = math.modf((cellIndex - 1) / 5)
        local ori_y = math.modf((cellIndex - 1) % 5)
        local new_x = ori_x + offset[1]
        local new_y = ori_y - offset[2]
        if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
            local new_index = new_x * 5 + new_y + 1
            table.insert(extraPos, new_index)
        end
    end)
    
    if GetTableLength(extraPos) == 0 then
        return self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end
    
    local animName = "3ge"  --播放哪个动画      
    if GetTableLength(extraPos) == 1 then
        local index = extraPos[1]
        if index == 25 then --最后一个格子不播动画
            if cellIndex == 24 then  --最后一行
                animName = "1Right"
            else
                animName = "1Down"
            end
        elseif index % 5 == 0 then  --最后一行
            animName = "1Down"
        else
            local temp = math.modf((index - 1) / 5)
            if temp == 4 then  --最后一列
                animName = "1Right"
            end
        end
    end
    
    local waitList = { 0.7, 0.5, 0.5 } --盖章时间0.7, 1.2, 1.7
    local root = cardView:GetEffectPlayRoot(cardId, BingoBangEntry.BattleContainerType.PuEffectContainer)
    BattleEffectCache:GetSkillPrefab_BingoBang(cardId, "Poker", cellObj, 3, function(obj)
        if not IsNull(obj) then
            UISound.play("dauberhit")
            Event.Brocast(EventName.CardEffect_MapClick_Effect, cardId, 2)
            fun.play_animator(obj, animName, true)
            coroutine.start(function()
                table.walk(extraPos, function(signPos, k)
                    coroutine.wait(waitList[k])
                    --local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, signPos)
                    --if cellData:IsNotSign() then
                        cardView:OnClickCardIgnoreJudgeByIndex(cardId, signPos, powerId)
                    --end
                    cardPower:ChangeCellState(cardId, cellIndex, cardPower.CellState.Signed)
                end)
                self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        else
            self:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
        end
    end)
end

return CmdPlaySkill101