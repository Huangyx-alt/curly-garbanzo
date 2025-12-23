
--require "View/CommonView/TopQuickTaskView"
require "View/HallCity/PlayCardsNumberView"
require "View/HallCity/BetRateOperatedView"
local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"
require "View/HallCity/LobbyAdvertiseView"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
local  TopCompetitionView  = require "View.CommonView.TopCompetitionView"

HallFunctionContainer = {}

function HallFunctionContainer:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o:Init()
    return o
end

function HallFunctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.lobby)
    
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = JackpotConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil
end

function HallFunctionContainer:InitFunctionIcon(belong,leftHangPoint,rightHangPoint,rightHangPoint2,centerleftPoint)
    local FunctionIconView = require "View/CommonView/FunctionIconView"
    self._functionIcon = FunctionIconView:New(belong,leftHangPoint,rightHangPoint)
end

function HallFunctionContainer:EnableFunctionIcon()
    self._functionIcon:OnEnable()
end

function HallFunctionContainer:DisableFunctionIcon()
    self._functionIcon:OnDisable()
end

function HallFunctionContainer:DestroyFunctionIcon()
    self._functionIcon:Dispose()
    self._functionIcon = nil
end

function HallFunctionContainer:TopQuickTaskCheckActivity(go)
    self:InitTopCompetition()
    --self._topQuickTask:CheckActivity(go)
    if self._topCompetition then
        self._topCompetition:CheckActivity(go)
    end
end

function HallFunctionContainer:InitTopCompetition()
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local topCompetitionView = dependentFile:GetCompetitionView()
    if topCompetitionView then
        if not self._topCompetition then
            self._topCompetition = topCompetitionView:New(true, ParasitiferType.lobby)
        end
    else
        self._topCompetition = nil 
    end
end

function HallFunctionContainer:Play1CardSkipLoadShow(go)
    self._play1card:SkipLoadShow(go)
end

function HallFunctionContainer:Play2CardSkipLoadShow(go)
    self._play2card:SkipLoadShow(go)
end

function HallFunctionContainer:Play4CardSkipLoadShow(go)
    self._play4card:SkipLoadShow(go)
end

function HallFunctionContainer:Play1CardGetPosition()
    return self._play1card:GetPosition()
end

function HallFunctionContainer:Play2CardGetPosition()
    return self._play2card:GetPosition()
end

function HallFunctionContainer:Play4CardGetPosition()
    return self._play4card:GetPosition()
end

function HallFunctionContainer:Play1CardGameObject()
    return self._play1card.go
end

function HallFunctionContainer:Play2CardGameObject()
    return self._play2card.go
end

function HallFunctionContainer:Play4CardGameObject()
    return self._play4card.go
end

function HallFunctionContainer:Play1CardCheckCoupon()
    self._play1card:CheckCoupon(true)
end

function HallFunctionContainer:Play2CardCheckCoupon()
    self._play2card:CheckCoupon(true)
end

function HallFunctionContainer:Play4CardCheckCoupon()
    self._play4card:CheckCoupon(true)
end

function HallFunctionContainer:Play1CardSetInfo(betRate)
    self._play1card:SetInfo(betRate)
end

function HallFunctionContainer:Play2CardSetInfo(betRate)
    self._play2card:SetInfo(betRate)
end

function HallFunctionContainer:Play4CardSetInfo(betRate)
    self._play4card:SetInfo(betRate)
end

function HallFunctionContainer:Play1CardDoCardClick(ignoreCheckRes, cb)
    self._play1card:DoCardClick(ignoreCheckRes, cb)
end

function HallFunctionContainer:Play2CardDoCardClick(ignoreCheckRes, cb)
    self._play2card:DoCardClick(ignoreCheckRes, cb)
end

function HallFunctionContainer:Play4CardDoCardClick(ignoreCheckRes, cb)
    self._play4card:DoCardClick(ignoreCheckRes, cb)
end

function HallFunctionContainer:Play1CardReplaceBtnPlayEvent(isReplace)
    self._play1card:ReplaceBtnPlayEvent(isReplace)
end

function HallFunctionContainer:Play2CardReplaceBtnPlayEvent(isReplace)
    self._play2card:ReplaceBtnPlayEvent(isReplace)
end

function HallFunctionContainer:Play2CardRayCast()
    self._play2card:Set2CardRayCast()
end

function HallFunctionContainer:Play4CardRayCast()
    self._play4card:Set2CardRayCast()
end

function HallFunctionContainer:Play1CardNumberAvailable(callback)
    self._play1card:SetPlayCardsNumberAvailable()
end

function HallFunctionContainer:Play2CardNumberAvailable(callback)
    self._play2card:SetPlayCardsNumberAvailable(callback)
end

function HallFunctionContainer:Play4CardNumberAvailable(callback)
    self._play4card:SetPlayCardsNumberAvailable(callback)
end

function HallFunctionContainer:Play1CardNumberDisable(callback)
    self._play1card:SetPlayCardsNumberDisable(callback)
end

function HallFunctionContainer:Play2CardNumberDisable(callback)
    self._play2card:SetPlayCardsNumberDisable(callback)
end

function HallFunctionContainer:Play4CardNumberDisable(callback)
    self._play4card:SetPlayCardsNumberDisable(callback)
end

function HallFunctionContainer:BetRateOperatorSkipLoadShow(go)
    self._betRateOperator:SkipLoadShow(go)
end

function HallFunctionContainer:SetBetRateInfo(betRate, enter)
    self._betRateOperator:SetBetRateInfo(betRate, enter)
end

function HallFunctionContainer:JackpotConsoleSkipLoadShow(go)
    self._jackpotConsole:ResetInitState()
    self._jackpotConsole:SkipLoadShow(go, true)
    if self._jackpotConsole.SwitchUltrabetConsoleParent then
        self._jackpotConsole:SwitchUltrabetConsoleParent()
    end
end

function HallFunctionContainer:ShowJackpotConsole()
    self._jackpotConsole:Show()
end

function HallFunctionContainer:JackpotConsoleSetInfo()
    self._jackpotConsole:SetJackpotInfo()
end

function HallFunctionContainer:LobbyAdvertiseSkipLoadShow(go)
    self._lobbyAdvertise:SkipLoadShow(go,false)
end

function HallFunctionContainer:CheckLobbyAdvertise()
    self._lobbyAdvertise:CheckLobbyAdvertise()
end

function HallFunctionContainer:GiftpackSkipLoadShow(go)
    self._giftpack:SkipLoadShow(go)
end

function HallFunctionContainer:Getplay1card()
    return self._play1card
end
function HallFunctionContainer:Getplay2card()
    return self._play2card
end

function HallFunctionContainer:Getplay4card()
    return self._play4card
end

function HallFunctionContainer:ChangeSmallGameType()
    self._jackpotConsole:OnMiniGameTypeChange()
end
