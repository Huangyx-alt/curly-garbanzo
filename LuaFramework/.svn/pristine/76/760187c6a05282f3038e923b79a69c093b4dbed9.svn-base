local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"
local GotYouConsoleView = JackpotConsoleView:New(nil)
local this = GotYouConsoleView

this.ConsoleInActionName = "in"
this.ConsoleInClipName = "jackpot_console_GemQueenin"

this.auto_bind_ui_items = {
    "jackpot_lock",
    "jackpot_dish",
    "dish",
    "text_reward",
    "anima",
    "jackpotBg", -- 背后的背景
    "titleImg",
    "ExtraCount",
    "bearBonus",
    "jBallDi",
    "jBall",
    "Extra_lock",
    "jGeZi",
    "jGeZi2",

    "btn_gotyou_help",
    "LTRBallTitle1",
}

function GotYouConsoleView:New(host)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o._host = host
    return o
end

function GotYouConsoleView:SetSmallBetRateJackpot()
    JackpotConsoleView.SetSmallBetRateJackpot(self)
    self:UpdateExtraRewardState()
end

function GotYouConsoleView:SetMaxBetRateJackpot()
    JackpotConsoleView.SetMaxBetRateJackpot(self)
    self:UpdateExtraRewardState()
end

function GotYouConsoleView:UpdateExtraRewardState()
    local isUltraBetOpen = ModelList.UltraBetModel:IsActivityValidForCurPlay()
    if isUltraBetOpen then
        fun.set_active(self.LTRBallTitle1, true)
        return
    end

    local currRate = ModelList.CityModel:GetBetRate() or 1
    local currMaxBetRate = ModelList.CityModel:GetMaxRateOpen()
    if currRate >= 8 then
        fun.set_active(self.LTRBallTitle1, true)
    elseif currRate < 8 then
        fun.set_active(self.LTRBallTitle1, false)
    end
end

function GotYouConsoleView:on_btn_gotyou_help_click()
    local view = require("View.HallCity.GotYouJackpotHelperView"):New()
    Facade.SendNotification(NotifyName.ShowUI, view)
end

return this