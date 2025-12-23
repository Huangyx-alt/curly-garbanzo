local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

LeetoleManConsoleView = JackpotConsoleView:New(nil)
local this = LeetoleManConsoleView

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

function LeetoleManConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:BuildFsm()
    self:StartCountDown()
    self:RemoveUselessRaycast()
end

function LeetoleManConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot,self.OnMaxBetRateEnableJackpot,self)
    self:DisposeFsm()
    self.betrate = nil
    self:RemoveCountDownTimer()
end

function LeetoleManConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play",playId,"jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("LeetoleManHallAtlas")
    end
end

function LeetoleManConsoleView:SetMaxBetRateJackpot()
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

function LeetoleManConsoleView:SetSmallBetRateJackpot()
    if self.betrate ~= ModelList.CityModel:GetBetRate() then
        self.betrate = ModelList.CityModel:GetBetRate()
        if self.go.name == "ultra_jackpot_console" then
            AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
        else
            AnimatorPlayHelper.Play(self.anima, {"in","jackpot_console_ltrin"}, false, nil)
        end
        fun.set_active(self.jackpot_dish.transform,true,false)
        fun.set_active(self.jackpot_lock.transform,false,false)
        self:SetJackpotInfo()
    end   
end

function LeetoleManConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end