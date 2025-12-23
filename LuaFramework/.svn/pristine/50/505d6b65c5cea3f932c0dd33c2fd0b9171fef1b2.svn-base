--[[
Descripttion: 
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年9月18日16:18:14
LastEditors: gaoshuai
LastEditTime: 2025年9月18日16:18:14
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdStartGuideCountDown : CommandBase
local CmdStartGuideCountDown = BaseClass("CmdStartGuideCountDown", base)

local CommandConst = CommandConst
local private = {}

function CmdStartGuideCountDown:OnCmdExecute()
    local countDownTime = 3
    local bingoLeftDiff = 0

    Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease, bingoLeftDiff, countDownTime)
    
    local timer
    timer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        Event.Brocast(EventName.CallNumber_Update_Count_Down, countDownTime)

        if countDownTime == 0 then
            LuaTimer:Remove(timer)
            timer = nil
            return
        end
        
        if countDownTime == 3 then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.BattleCountDownView, function()

            end, false, {
                OnComplete = function()
                    self:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                end
            })
        end
        
        countDownTime = countDownTime - 1
    end, nil, false, LuaTimer.TimerType.Battle)
end

return CmdStartGuideCountDown