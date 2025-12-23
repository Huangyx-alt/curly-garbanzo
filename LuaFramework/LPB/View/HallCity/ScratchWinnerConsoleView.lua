local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

ScratchWinnerConsoleView = JackpotConsoleView:New(nil)
local this = ScratchWinnerConsoleView
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
    "jBallDi",
}

function ScratchWinnerConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:BuildFsm()
    self:StartCountDown()
    self:RemoveUselessRaycast()
end

function ScratchWinnerConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:DisposeFsm()
    self.betrate = nil
    self:RemoveCountDownTimer()
end

function ScratchWinnerConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("ScratchWinnerHallAtlas")
    end
end

function ScratchWinnerConsoleView:SetMaxBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {this.ConsoleInActionName, this.ConsoleInClipName}, false, nil)
        end
        self:SetJackpotInfo()
    end
end

function ScratchWinnerConsoleView:SetSmallBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {this.ConsoleInActionName, this.ConsoleInClipName}, false, nil)
        end
        fun.set_active(self.jackpot_dish.transform, true, false)
        fun.set_active(self.jackpot_lock.transform, false, false)
        self:SetJackpotInfo()
    end   
end

function ScratchWinnerConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end