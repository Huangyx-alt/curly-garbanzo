--[[
Descripttion: 战斗开始倒计时
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月29日16:30:23
LastEditors: gaoshuai
LastEditTime: 2025年7月29日16:30:23
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@type CommandBase
local base = CommandBase
---@class CmdStartCountDown : CommandBase
local CmdStartCountDown = BaseClass("CmdStartCountDown", base)

local CommandConst = CommandConst
local private = {}

function CmdStartCountDown:OnCmdExecute()
    local cfg = table.find(Csv["new_bingosleft"], function(k, v)
        local time_range = v.time_range
        return BingoBangEntry.IntervalBetweenTwoBattle >= time_range[1] and BingoBangEntry.IntervalBetweenTwoBattle <= time_range[2]
    end)
    cfg = cfg or Csv["new_bingosleft"][1]
    
    local countDownTime = math.random(cfg.start_time[1], cfg.start_time[2])
    local bingoLeftDiff = math.random(cfg.start_bingosleft[1], cfg.start_bingosleft[2])
    log.r("[CmdStartCountDown] countDownTime:", countDownTime)
    log.r("[CmdStartCountDown] bingoLeftDiff:", bingoLeftDiff)
    Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease, bingoLeftDiff, countDownTime)
    
    local timer
    timer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        Event.Brocast(EventName.CallNumber_Update_Count_Down, countDownTime)

        if countDownTime == 0 then
            Event.Brocast(Notes.BINGO_TIME_COUNT_OVER)
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

return CmdStartCountDown