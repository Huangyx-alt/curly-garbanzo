--[[
Descripttion: LuckyBang触发盖章
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月20日16:00:34
LastEditors: gaoshuai
LastEditTime: 2025年8月20日16:00:34
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdSignSequence = require "Logic.Command.Battle.InBattle.Sign.CmdSignSequence"

---@type CommandBase
local base = CommandBase
---@class CmdLuckyBangTriggerSign : CommandBase
local CmdLuckyBangTriggerSign = BaseClass("CmdLuckyBangTriggerSign", base)
local CommandConst = CommandConst

function CmdLuckyBangTriggerSign:OnCmdExecute(args)
    args = args or {}
    BingoBangEntry.IsInBattleSignSequence = true

    local cardid, cardNum, cardCell = args.cardid, args.cardNum, args.cardCell
    local double_num, index, mask = args.double_num, args.index, args.mask
    local model = ModelList.BattleModel:GetCurrModel()
    local cardView = args.cardView
    
    --流程
    local sequence = CommandSequence.New({ LogTag = "CmdLuckyBangTriggerSign Sequence", })

    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            --点击音效，卡牌震动
            cardView:CheckCardKickMusic(cardid, index)
            local effectType = model:HasCardCellGift(cardid, index)
            Event.Brocast(EventName.CardEffect_MapClick_Effect, cardid, effectType and 3 or 1, index)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdLuckyBangTriggerSign 1",
    }))
    
    sequence:AddCommand(CmdSignSequence.New({
        args = { total = { 
            { cardId = cardid, index = index, number = cardNum, mask = mask, needGiftShowOver = true } 
        } },
        LogTag = "CmdLuckyBangTriggerSign 2",
    }))

    --结束
    sequence:AddDoneFunc(function()
        BingoBangEntry.IsInBattleSignSequence = false
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdLuckyBangTriggerSign