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

---@class BattleCountDownView : BaseDialogView
local BattleCountDownView = BaseDialogView:New("BattleCountDownView")
local this = BattleCountDownView
this.__index = this
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

this.auto_bind_ui_items = {
    "GO",
    "RoundOver",
    "Time",
}

function BattleCountDownView.New()
    local o = {}
    setmetatable(o, BattleCountDownView)
    o.__index = o
    return o;
end

function BattleCountDownView.Awake()
    --Facade.RegisterView(this)
    this:on_init()
end

function BattleCountDownView:OnEnable(params)
    self.params = params or {}
    self:StartTimeDown()
end

function BattleCountDownView:on_close()
    fun.SafeCall(self.params.OnComplete)
    
    --if self.countDownTimer then
    --    LuaTimer:Remove(self.countDownTimer)
    --    self.countDownTimer = nil
    --end
end

function BattleCountDownView:StartTimeDown()
    if self.params and self.params.IsRoundOver then
        fun.play_animator(self.go, "Over", true)
        UISound.play("roundover")
        LuaTimer:SetDelayFunction(2, function()
            Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleCountDownView)
        end)
    else
        fun.play_animator(self.go, "GO", true)
        UISound.play("battlecountdown")
        LuaTimer:SetDelayFunction(3.5, function()
            Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleCountDownView)
        end)
    end

    --local count = 5 --后面改成后端给的数据
    --self:UpdateCountDown(count)
    --self.countDownTimer = LuaTimer:SetDelayLoopFunction(1, 1, count, function ()
    --    count = count - 1
    --    self:UpdateCountDown(count)
    --end, function()
    --    Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleCountDownView)
    --end)
end

function BattleCountDownView:UpdateCountDown(count)
    log.r("[BattleCountDownView] UpdateCountDown:", count)
    if count > 0 then
        fun.set_active(self.Time, true)
        self.Time.text = count
    else
        fun.set_active(self.Time, false)
        fun.set_active(self.GO, true)
    end
end

return this

