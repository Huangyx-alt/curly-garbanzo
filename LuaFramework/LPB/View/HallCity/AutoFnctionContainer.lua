require "View/HallCity/HallFunctionContainer"
require "View/HallCity/PlayCardsNumberAutoView"
local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"

local AutoFnctionContainer = HallFunctionContainer:New()

function AutoFnctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.autoLobby)
    
    self._play8card = PlayCardsNumberAutoView:New(CardGenre.eightcard)
    self._play6card = PlayCardsNumberAutoView:New(CardGenre.sixcard)
    self._play4card = PlayCardsNumberAutoView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = JackpotConsoleView:New(JackepotHost.autoLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil
end

function AutoFnctionContainer:InitTopCompetition()
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local topCompetitionView = dependentFile:GetCompetitionView()
    if topCompetitionView then
        if not self._topCompetition then
            self._topCompetition = topCompetitionView:New(true, ParasitiferType.autoLobby)
        end
    else
        self._topCompetition = nil
    end
end

function AutoFnctionContainer:Play8CardSkipLoadShow(go)
    self._play8card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play4CardSkipLoadShow(go)
    self._play4card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play6CardSkipLoadShow(go)
    self._play6card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play8CardGetPosition()
    return self._play8card:GetPosition()
end

function AutoFnctionContainer:Play4CardGetPosition()
    return self._play4card:GetPosition()
end

function AutoFnctionContainer:Play6CardGetPosition()
    return self._play6card:GetPosition()
end

function AutoFnctionContainer:Play8CardGameObject()
    return self._play8card.go
end

function AutoFnctionContainer:Play4CardGameObject()
    return self._play4card.go
end

function AutoFnctionContainer:Play6CardGameObject()
    return self._play6card.go
end

function AutoFnctionContainer:Play8CardCheckCoupon()
    self._play8card:CheckCoupon(true)
end

function AutoFnctionContainer:Play4CardCheckCoupon()
    self._play4card:CheckCoupon(true)
end

function AutoFnctionContainer:Play6CardCheckCoupon()
    self._play6card:CheckCoupon(true)
end

function AutoFnctionContainer:Play8CardSetInfo(betRate)
    self._play8card:SetInfo(betRate)
end

function AutoFnctionContainer:Play4CardSetInfo(betRate)
    self._play4card:SetInfo(betRate)
end

function AutoFnctionContainer:Play6CardSetInfo(betRate)
    self._play6card:SetInfo(betRate)
end

function AutoFnctionContainer:Play8CardDoCardClick()
    self._play8card:DoCardClick()
end

function AutoFnctionContainer:Play4CardDoCardClick()
    self._play4card:DoCardClick()
end

function AutoFnctionContainer:Play6CardDoCardClick()
    self._play6card:DoCardClick()
end

function AutoFnctionContainer:Play4CardRayCast()
    self._play4card:Set2CardRayCast()
end

function AutoFnctionContainer:Play8CardNumberAvailable(callback)
    self._play8card:SetPlayCardsNumberAvailable()
end

function AutoFnctionContainer:Play4CardNumberAvailable(callback)
    self._play4card:SetPlayCardsNumberAvailable(callback)
end

function AutoFnctionContainer:Play6CardNumberAvailable(callback)
    self._play6card:SetPlayCardsNumberAvailable(callback)
end

function AutoFnctionContainer:Play8CardNumberDisable(callback)
    self._play8card:SetPlayCardsNumberDisable(callback)
end

function AutoFnctionContainer:Play4CardNumberDisable(callback)
    self._play4card:SetPlayCardsNumberDisable(callback)
end

function AutoFnctionContainer:Play6CardNumberDisable(callback)
    self._play6card:SetPlayCardsNumberDisable(callback)
end

return AutoFnctionContainer
--[[
require "View/CommonView/TopQuickTaskView"
require "View/HallCity/PlayCardsNumberAutoView"
require "View/HallCity/BetRateOperatedView"
require "View/HallCity/JackpotConsoleView"
require "View/HallCity/LobbyAdvertiseView"
require "View/CommonView/GiftPackEnterView"

local _topQuickTask = TopQuickTaskView:New(true,ParasitiferType.autoLobby)
local _play8card = PlayCardsNumberAutoView:New(CardGenre.eightcard)
local _play4card = PlayCardsNumberAutoView:New(CardGenre.fourcard)
local _play6card = PlayCardsNumberAutoView:New(CardGenre.sixcard)
local _betRateOperator = BetRateOperatedView:New()
local _jackpotConsole = JackpotConsoleView:New(JackepotHost.autoLobby)
local _lobbyAdvertise = LobbyAdvertiseView:New()
local _giftpack = GiftPackEnterView:New()
local _functionIcon = nil

local AutoFnctionContainer = {}

function AutoFnctionContainer:InitFunctionIcon(belong,leftHangPoint,rightHangPoint,rightHangPoint2)
    _functionIcon = FunctionIconView:New(belong,leftHangPoint,rightHangPoint)
    --_functionIcon:ShowIcon()
end

function AutoFnctionContainer:EnableFunctionIcon()
    _functionIcon:OnEnable()
end

function AutoFnctionContainer:DisableFunctionIcon()
    _functionIcon:OnDisable()
end

function AutoFnctionContainer:DestroyFunctionIcon()
    _functionIcon:Dispose()
    _functionIcon = nil
end

function AutoFnctionContainer:TopQuickTaskCheckActivity(go)
    _topQuickTask:CheckActivity(go)
end

function AutoFnctionContainer:Play8CardSkipLoadShow(go)
    _play8card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play4CardSkipLoadShow(go)
    _play4card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play6CardSkipLoadShow(go)
    _play6card:SkipLoadShow(go)
end

function AutoFnctionContainer:Play8CardGetPosition()
    return _play8card:GetPosition()
end

function AutoFnctionContainer:Play4CardGetPosition()
    return _play4card:GetPosition()
end

function AutoFnctionContainer:Play6CardGetPosition()
    return _play6card:GetPosition()
end

function AutoFnctionContainer:Play8CardGameObject()
    return _play8card.go
end

function AutoFnctionContainer:Play4CardGameObject()
    return _play4card.go
end

function AutoFnctionContainer:Play6CardGameObject()
    return _play6card.go
end

function AutoFnctionContainer:Play8CardCheckCoupon()
    _play8card:CheckCoupon(true)
end

function AutoFnctionContainer:Play4CardCheckCoupon()
    _play4card:CheckCoupon(true)
end

function AutoFnctionContainer:Play6CardCheckCoupon()
    _play6card:CheckCoupon(true)
end

function AutoFnctionContainer:Play8CardSetInfo(betRate)
    _play8card:SetInfo(betRate)
end

function AutoFnctionContainer:Play4CardSetInfo(betRate)
    _play4card:SetInfo(betRate)
end

function AutoFnctionContainer:Play6CardSetInfo(betRate)
    _play6card:SetInfo(betRate)
end

function AutoFnctionContainer:Play8CardDoCardClick()
    _play8card:DoCardClick()
end

function AutoFnctionContainer:Play4CardDoCardClick()
    _play4card:DoCardClick()
end

function AutoFnctionContainer:Play6CardDoCardClick()
    _play6card:DoCardClick()
end

function AutoFnctionContainer:Play4CardRayCast()
    _play4card:Set2CardRayCast()
end

function AutoFnctionContainer:Play8CardNumberAvailable(callback)
    _play8card:SetPlayCardsNumberAvailable()
end

function AutoFnctionContainer:Play4CardNumberAvailable(callback)
    _play4card:SetPlayCardsNumberAvailable(callback)
end

function AutoFnctionContainer:Play6CardNumberAvailable(callback)
    _play6card:SetPlayCardsNumberAvailable(callback)
end

function AutoFnctionContainer:Play8CardNumberDisable(callback)
    _play8card:SetPlayCardsNumberDisable(callback)
end

function AutoFnctionContainer:Play4CardNumberDisable(callback)
    _play4card:SetPlayCardsNumberDisable(callback)
end

function AutoFnctionContainer:Play6CardNumberDisable(callback)
    _play6card:SetPlayCardsNumberDisable(callback)
end

function AutoFnctionContainer:BetRateOperatorSkipLoadShow(go)
    _betRateOperator:SkipLoadShow(go)
end

function AutoFnctionContainer:SetBetRateInfo(cardspend,betRate,rate,enter)
    _betRateOperator:SetBetRateInfo(cardspend,betRate,rate,enter)
end

function AutoFnctionContainer:JackpotConsoleSkipLoadShow(go)
    _jackpotConsole:SkipLoadShow(go,false)
end

function AutoFnctionContainer:ShowJackpotConsole()
    _jackpotConsole:Show()
end

function AutoFnctionContainer:LobbyAdvertiseSkipLoadShow(go)
    _lobbyAdvertise:SkipLoadShow(go,false)
end

function AutoFnctionContainer:CheckLobbyAdvertise()
    _lobbyAdvertise:CheckLobbyAdvertise()
end

function AutoFnctionContainer:GiftpackSkipLoadShow(go)
    _giftpack:SkipLoadShow(go)
end

return AutoFnctionContainer
--]]