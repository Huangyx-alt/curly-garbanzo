--[[
Descripttion: bingo格子触发后表现流程
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月4日09:38:58
LastEditors: gaoshuai
LastEditTime: 2025年9月4日09:38:58
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdSelfBingoSequence : CommandBase
local CmdSelfBingoSequence = BaseClass("CmdSelfBingoSequence", base)
local CommandConst = CommandConst

function CmdSelfBingoSequence:OnCmdExecute(args)
    if not args then
        args = self.options.args or {}
    end
    
    local model = ModelList.BattleModel:GetCurrModel()
    local cardid, cellIndex = args.cardid, args.cellIndex
    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
    local cellObj = cardView:GetCardCell(tonumber(cardid), cellIndex)
    
    --流程
    local sequence = CommandSequence.New({ LogTag = "CmdSelfBingoSequence Sequence ", })
    
    --触发后特效表现
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            BattleEffectCache:GetCachedPrefab_BingoBang(cardid, "SelfBingo", {
                targetObj = cellObj,
                recycleTime = 2,
                parentContainerType = BingoBangEntry.BattleContainerType.PuEffectContainer,
                cb = function(obj)
                    if not IsNull(obj) then
                        LuaTimer:SetDelayFunction(1.5, function()
                            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                        end)
                    else
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end
                end
            })
        end,
        LogTag = "CmdSelfBingoSequence 1",
    }))
    
    ----展示bingo效果
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            model:CalcuateBingo(cardid, cellIndex, {
                onlyCheckSelfBingoCell = true
            })

            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdSelfBingoSequence 2",
    }))

    --结束
    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)
    
    --开始
    sequence:Execute()
end

return CmdSelfBingoSequence