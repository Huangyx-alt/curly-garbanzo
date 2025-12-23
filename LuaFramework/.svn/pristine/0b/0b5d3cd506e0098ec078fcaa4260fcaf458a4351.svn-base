--[[
Descripttion: 战斗开始前入场后格子表现
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月16日15:40:17
LastEditors: gaoshuai
LastEditTime: 2025年7月16日15:40:17
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdStartMapEffect : CommandBase
local CmdStartMapEffect = BaseClass("CmdStartMapEffect", base)

local CommandConst = CommandConst
local private = {}

function CmdStartMapEffect:OnCmdExecute()
    local sequence = CommandSequence.New({ LogTag = "CmdStartMapEffect CommandSequence", })

    --拼图碎片边框
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            Event.Brocast(EventName.Show_Puzzle_Reward, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        end,
        LogTag = "CmdStartEntryEffect 1",
    }))
    
    --展示格子上的初始奖励道具
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            Event.Brocast(EventName.CardEffect_Drop_All_Cell_Item, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        end,
        LogTag = "CmdStartMapEffect 2",
    }))

    --maxbet效果展示
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            Event.Brocast(EventName.Show_Max_Bet_Effect, function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        end,
        LogTag = "CmdStartEntryEffect 3",
    }))

    ----杯赛道具展示
    --sequence:AddCommand(FunctionCommand.New({
    --    executeFunc = function(cmd)
    --        Event.Brocast(EventName.Competition_battle_start_effect, function()
    --            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    --        end)
    --    end,
    --    LogTag = "CmdStartMapEffect 2",
    --}))

    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)

    --开始
    sequence:Execute()
end

return CmdStartMapEffect