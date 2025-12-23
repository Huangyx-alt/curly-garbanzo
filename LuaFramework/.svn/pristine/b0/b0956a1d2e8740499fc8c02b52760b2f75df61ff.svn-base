--[[
Descripttion: 战斗开始前入场表现
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月16日15:40:17
LastEditors: gaoshuai
LastEditTime: 2025年7月16日15:40:17
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdStartMapEffect = require "Logic.Command.Battle.Enter.StartSequence.CmdStartMapEffect"

---@type CommandBase
local base = CommandBase
---@class CmdStartEntryEffect : CommandBase
local CmdStartEntryEffect = BaseClass("CmdStartEntryEffect", base)

local CommandConst = CommandConst
local private = {}

function CmdStartEntryEffect:OnCmdExecute()
    --分四步：powerup卡牌展示(一)、之后展示卡包开场动画，卡包飞行到卡牌右上角(二)、展示小丑卡入场(三)、展示小丑卡翻牌(四)
    local sequence = CommandParallel.New({ LogTag = "CmdStartEntryEffect CommandParallel", })
    
    local count = ModelList.BattleModel:GetCurrModel():GetCardCount()
    local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
    onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
    if count == 4 and onlyShow2Card then
        --SwitchCard展示
        sequence:AddCommand(FunctionCommand.New({
            executeFunc = function(cmd)
                Event.Brocast(EventName.Switch_View_Start_Show, function()
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end)
            end,
            LogTag = "CmdStartEntryEffect 1",
        }))
    end
    
    --powerup卡牌展示
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            Event.Brocast(Notes.START_POWERUP_ENABLE, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        end,
        LogTag = "CmdStartEntryEffect 2",
    }))
    
    --放大镜提示
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            Event.Brocast(Notes.START_MIRROR_CHECK)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdStartEntryEffect 3",
    }))
    
    ----卡包展示
    --sequence:AddCommand(FunctionCommand.New({
    --    executeFunc = function(cmd)
    --        Event.Brocast(EventName.Event_Game_Open_Card_Pack_Enter, function()
    --            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    --        end)
    --    end,
    --    LogTag = "CmdStartEntryEffect 4",
    --}))
    --小丑卡入场
    --sequence:AddCommand(FunctionCommand.New({
    --    executeFunc = function(cmd)
    --        Event.Brocast(EventName.Enter_Play_First_Joker_Card, function()
    --            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    --        end)
    --    end,
    --    LogTag = "CmdStartEntryEffect 5",
    --}))
    --小丑卡翻牌
    --sequence:AddCommand(FunctionCommand.New({
    --    executeFunc = function(cmd)
    --        Event.Brocast(EventName.Enter_Play_Joker_Card, function()
    --            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    --        end)
    --    end,
    --    LogTag = "CmdStartEntryEffect 6",
    --}))

    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdStartEntryEffect