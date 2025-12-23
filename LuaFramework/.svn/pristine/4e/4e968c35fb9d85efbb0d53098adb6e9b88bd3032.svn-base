--require "View/HallCity/ChristmasConsoleView"

--ChristmasConsoleView = ChristmasConsoleView:New(JackepotHost.mainLobby)
--local this = ChristmasConsoleView
--this.viewType = CanvasSortingOrderManager.LayerType.None
local JackpotMaxBetRateState = require "State/JackpotConsole/JackpotMaxBetRateState"
local JackpotSmallBetRateState = require "State/JackpotConsole/JackpotSmallBetRateState"

local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

local ChristmasConsoleView = JackpotConsoleView:New(JackepotHost.mainLobby)
local this = ChristmasConsoleView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "jackpot_lock",
    "jackpot_dish",
    "dish",
    "text_reward",
    "anima",
    "jackpotBg", -- 背后的背景
    "titleImg",
    "OtherText",
    "jBallDi",
    "jBall",
    "img_cityName",
}

function ChristmasConsoleView:OnEnable()
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:BuildFsm()
    self:StartCountDown()
    self:RemoveUselessRaycast()
end

function ChristmasConsoleView:OnDisable()
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot,self.OnMaxBetRateEnableJackpot,self)
    self:DisposeFsm()
    self:RemoveCountDownTimer()
end

function ChristmasConsoleView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("ChristmasConsoleView",self,{
        JackpotMaxBetRateState:New(),
        JackpotSmallBetRateState:New()
    })
    if ModelList.CityModel:IsMaxBetRate() then --or ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then 
        self._fsm:StartFsm("JackpotMaxBetRateState")
    else
        self._fsm:StartFsm("JackpotSmallBetRateState")
    end
end

function ChristmasConsoleView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function ChristmasConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play",playId,"jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("HawaiiHallAtlas")
    end
end

function ChristmasConsoleView:SetMaxBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "jackpot_consolein_hawaii"}, false, nil)
    end
    self:SetJackpotInfo()
end

function ChristmasConsoleView:SetSmallBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "ultra_jackpot_consolein"}, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, {"jackpot_consolein", "jackpot_consolein_hawaii"}, false, nil)
    end
    fun.set_active(self.jackpot_dish.transform,true,false)
    fun.set_active(self.jackpot_lock.transform,false,false)
    self:SetJackpotInfo()
end

function ChristmasConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end

return this