local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

ThievesConsoleView = JackpotConsoleView:New(nil)
local this = ThievesConsoleView

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

function ThievesConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:BuildFsm()
    self:StartCountDown()
    self:RemoveUselessRaycast()
end

function ThievesConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot,self.OnMaxBetRateEnableJackpot,self)
    self:DisposeFsm()
    self.betrate = nil
    self:RemoveCountDownTimer()
end

function ThievesConsoleView:SetJackpotInfo()
    self:SetJackpotReward()
end

function ThievesConsoleView:SetMaxBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {"in","jackpot_console_Candyin"}, false, nil)
        end
        self:SetJackpotInfo()
    end
end

function ThievesConsoleView:SetSmallBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {"in","jackpot_console_Candyin"}, false, nil)
        end
        fun.set_active(self.jackpot_dish,true,false)
        fun.set_active(self.jackpot_lock,false,false)
        self:SetJackpotInfo()
    end   
end

function ThievesConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end