--[[
Descripttion: 
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月12日10:33:48
LastEditors: gaoshuai
LastEditTime: 2025年8月12日10:33:48
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdShowRoundOver : CommandBase
local CmdShowRoundOver = BaseClass("CmdShowRoundOver", base)
local CommandConst = CommandConst

function CmdShowRoundOver:OnCmdExecute()
    BingoBangEntry.IsInBattlePreSettle = false
    BingoBangEntry.IsInBattleSettle = true
    BattleMachineList.GetMchine("BingoLeftTickMachine"):Stop()
    
    local curModel = ModelList.BattleModel:GetCurrModel()
    local IsQuitBattle = ModelList.BattleModel.IsQuitBattle()
    local sequence = CommandSequence.New({ LogTag = "CmdShowRoundOver Sequence", })

    --流程
    sequence:AddFunctionCommand(function(cmd)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.BattleCountDownView, nil, false, {
            IsRoundOver = true,
            OnComplete = function()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end
        })
    end, { LogTag = "CmdShowRoundOver 1", })

    sequence:AddFunctionCommand(function(cmd)
        --curModel:PlayBattleOverSound()
        --Event.Brocast(EventName.SoundMachine_Stop_City_Music, false)
        Event.Brocast(EventName.Switch_View_End_Show)

        --if need_reduce ~= nil and need_reduce then
        --    Facade.SendNotification(NotifyName.Bingo.QuickReduceBingosiToZero)
        --end

        if ViewList.GameQuitView and ViewList.GameQuitView.go and fun.get_active_self(ViewList.GameQuitView.go) then
            Facade.SendNotification(NotifyName.HideUI, ViewList.GameQuitView)
        end

        curModel:SetGameState(GameState.ShowSettle)

        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end, { LogTag = "CmdShowRoundOver 2", })

    sequence:AddFunctionCommand(function(cmd)
        curModel:ReqQuitBingoGame(IsQuitBattle, nil, false, function()
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end)
    end, { LogTag = "CmdShowRoundOver 3", })

    --取消放大镜效果
    sequence:AddFunctionCommand(function(cmd)
        Event.Brocast(EventName.Magnifier_Hide_All_Showed_Cell)
        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
    end, { LogTag = "CmdShowRoundOver 4", })

    --结束
    sequence:AddDoneFunc(function()
        self:ExecuteDone(sequence.executeResult)
    end)
    --开始
    sequence:Execute()
end

return CmdShowRoundOver