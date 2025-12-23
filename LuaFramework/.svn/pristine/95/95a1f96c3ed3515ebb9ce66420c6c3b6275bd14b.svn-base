--[[
Descripttion: 点击格子触发盖章
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
---@class CmdClickTriggerSign : CommandBase
local CmdClickTriggerSign = BaseClass("CmdClickTriggerSign", base)
local CommandConst = CommandConst

function CmdClickTriggerSign:OnCmdExecute(args)
    args = args or {}
    BingoBangEntry.IsInBattleSignSequence = true
    --log.b("[CmdClickTriggerSign] args:", args)

    local cardid, cardNum, cardCell = args.cardid, args.cardNum, args.cardCell
    local double_num, index, mark = args.double_num, args.index, args.mark
    local model = ModelList.BattleModel:GetCurrModel()
    local cardView = args.cardView

    local signCardNumber, clickType
    if model:IsCalledNumber(cardNum) then
        if model:IsSigned(cardid, cardNum) then
            signCardNumber = cardNum
            clickType = 0
        end
    elseif double_num ~= nil and model:IsCalledNumber(double_num) then
        if model:IsSigned(cardid, double_num) then
            signCardNumber = double_num
            clickType = 111
        end
    else
        --没叫到号，结束
        UISound.play("kick_error")
        Event.Brocast(EventName.CardSingEffect_CellTip, cardCell, true, cardNum, double_num, cardid)
        self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        return
    end
    
    --流程
    local sequence = CommandSequence.New({ LogTag = "CmdClickTriggerSign Sequence", })
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --点击音效，卡牌震动
            cardView:CheckCardKickMusic(cardid, index)
            local effectType = model:HasCardCellGift(cardid, index)
            Event.Brocast(EventName.CardEffect_MapClick_Effect, cardid, effectType and 3 or 1, index)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdClickTriggerSign 1",
    }))    
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --增加pu充能
            Event.Brocast(Notes.SYNC_SIGN)
            
            Event.Brocast(EventName.CardSingEffect_CellTip, cardCell, false, cardNum, double_num, cardid)
            
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdClickTriggerSign 2",
    }))

    sequence:AddCommand(CmdSignSequence.New({
        args = { total = { { cardId = cardid, index = index, number = signCardNumber, mark = mark } } },
        LogTag = "CmdClickTriggerSign 3",
    }))
    
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --引导
            if clickType == 0 then
                ModelList.GuideModel.GuideAction(1, "", cardNum)
            end
            
            Event.Brocast(EventName.CallNumberMachine_Quick_Click, 0, cardNum, cardid)
            
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdClickTriggerSign 4",
    }))

    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.ManualDaubCount = BingoBangEntry.ManualDaubCount + 1
        BingoBangEntry.IsInBattleSignSequence = false
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdClickTriggerSign