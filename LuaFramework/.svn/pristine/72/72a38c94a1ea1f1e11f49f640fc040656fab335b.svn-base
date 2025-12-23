local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

GemQueenConsoleView = JackpotConsoleView:New(nil)
local this = GemQueenConsoleView

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

function GemQueenConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:BuildFsm()
    self:StartCountDown()
    self:RemoveUselessRaycast()
end

function GemQueenConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot,self.OnMaxBetRateEnableJackpot,self)
    self:DisposeFsm()
    self.betrate = nil
    self:RemoveCountDownTimer()
end

function GemQueenConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play",playId,"jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("GemQueenHallAtlas")
    end
end

function GemQueenConsoleView:SetMaxBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {"in","jackpot_console_ltrin"}, false, nil)
        end
        self:SetJackpotInfo()
    end
end

function GemQueenConsoleView:SetSmallBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {"in","jackpot_console_GemQueenin"}, false, nil)
        end
        fun.set_active(self.jackpot_dish.transform,true,false)
        fun.set_active(self.jackpot_lock.transform,false,false)
        self:SetJackpotInfo()
    end   
end

function GemQueenConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end