local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"
local ChristmasSynthesisConsoleView = JackpotConsoleView:New(nil)
local this = ChristmasSynthesisConsoleView


this.auto_bind_ui_items = {
    "jackpot_lock",
    "jackpot_dish",
    "dish",
    "text_reward",
    "anima",
    "jackpotBg",
    "titleImg",
    "Matchlaotou",
    "btn_christmas_help",
    "Effect",
}

function ChristmasSynthesisConsoleView:New(host)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o._host = host
    return o
end

function ChristmasSynthesisConsoleView:SetSmallBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "ultra_jackpot_consolein" }, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, { self.ConsoleInActionName, self.ConsoleInClipName }, false, nil)
    end

    if ModelList.CityModel:GetEnterGameMode() ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        fun.set_active(self.jackpot_dish.transform, true, false)
        fun.set_active(self.jackpot_lock.transform, false, false)
    end
    self:ShowChristmasSynthesisMan()
    self:SetJackpotInfo()
end

local function ChangePanelSort(obj)
    local canvas1 = fun.get_component(obj, fun.CANVAS)
    if canvas1 then
        canvas1.sortingOrder = 10001
    end
end


function ChristmasSynthesisConsoleView:ShowChristmasSynthesisMan()
    local isUltraBetOpen = ModelList.UltraBetModel:IsActivityValidForCurPlay()
    if isUltraBetOpen then
        fun.set_active(self.Matchlaotou, true)
        fun.set_active(self.Effect, true)
        ChangePanelSort(self.Effect)
        return
    end
    local currRate = ModelList.CityModel:GetBetRate() or 1
    local currMaxBetRate = ModelList.CityModel:GetMaxRateOpen()
    if currRate > currMaxBetRate then --锁住
        fun.set_active(self.Matchlaotou, false)
        fun.set_active(self.Effect, false)
    elseif currRate >= 8 then --出老头
        fun.set_active(self.Matchlaotou, true)
        fun.set_active(self.Effect, true)
        ChangePanelSort(self.Effect)
    elseif currRate < 8 then --不出现小老头
        fun.set_active(self.Matchlaotou, false)
        fun.set_active(self.Effect, false)
    end
end

function ChristmasSynthesisConsoleView:SetMaxBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "ultra_jackpot_consolein" }, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, { self.ConsoleInActionName, self.ConsoleInClipName }, false, nil)
    end

    if ModelList.CityModel:GetEnterGameMode() ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET or (not isAutoFirstEnter) then
        isAutoFirstEnter = true

        fun.set_active(self.jackpot_dish.transform, true, false)
        fun.set_active(self.jackpot_lock.transform, false, false)
    elseif ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        -- self:SetJackpotInfo()
    end
    self:ShowChristmasSynthesisMan()
    self:SetJackpotInfo()
end

function ChristmasSynthesisConsoleView:on_btn_christmas_help_click()
    ViewList.ChristmasSynthesisJackpotHelperView = require(
        "View.HallCity.ChristmasSynthesis.ChristmasSynthesisJackpotHelperView"):New()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ChristmasSynthesisJackpotHelperView)
end

this.ConsoleInActionName = "in"
this.ConsoleInClipName = "jackpot_console_GemQueenin"

return this
