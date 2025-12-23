--[[
Descripttion: 技能触发盖章
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月5日12:21:00
LastEditors: gaoshuai
LastEditTime: 2025年8月5日12:21:00
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdSignSequence = require "Logic.Command.Battle.InBattle.Sign.CmdSignSequence"

---@type CommandBase
local base = CommandBase
---@class CmdSkillTriggerSign : CommandBase
local CmdSkillTriggerSign = BaseClass("CmdSkillTriggerSign", base)
local CommandConst = CommandConst

function CmdSkillTriggerSign:OnCmdExecute(args)
    args = args or {}
    BingoBangEntry.IsInBattleSignSequence = true

    local cardid, cardCell = args.cardid, args.cardCell
    local index, mark = args.index, args.mark
    local extraPos, callBack = args.extraPos, args.callBack
    local model = ModelList.BattleModel:GetCurrModel()
    local cardView = args.cardView

    --流程
    local sequence = CommandSequence.New({ LogTag = "CmdSkillTriggerSign Sequence", })

    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local isSigned = model:GetRoundData(cardid, index).sign
            if isSigned == 0 then
                Event.Brocast(EventName.CardSingEffect_CellTip, cardCell, false, 0, 0, cardid, index)
            end
            
            cardView:CheckCardKickMusic(cardid, index)

            if callBack then
                callBack(cardCell, cardid, index)
            end

            local effectType = model:HasCardCellGift(cardid, index)
            Event.Brocast(EventName.CardEffect_MapClick_Effect, cardid, effectType and 3 or 1, index)
            Event.Brocast(EventName.Recorder_Data, 5005, { cardId = cardid, cellIndex = index, mark = mark })

            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdSkillTriggerSign 1",
    }))

    sequence:AddCommand(CmdSignSequence.New({
        args = { total = { { cardId = cardid, index = index, mark = mark, extraPos = extraPos } } },
        LogTag = "CmdSkillTriggerSign 2",
    }))

    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInBattleSignSequence = false
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdSkillTriggerSign