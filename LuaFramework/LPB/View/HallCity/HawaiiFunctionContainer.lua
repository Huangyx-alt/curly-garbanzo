require "View/HallCity/HallFunctionContainer"
local HawaiiConsoleView = require "View/HallCity/HawaiiConsoleView"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"

HawaiiFunctionContainer = HallFunctionContainer:New()
local this = HawaiiFunctionContainer

function HawaiiFunctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.lobby)
    
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = HawaiiConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil

end

--[[
function HawaiiFunctionContainer:InitFunctionIcon(belong,leftHangPoint,rightHangPoint,rightHangPoint2)
    self._functionIcon = FunctionIconView:New(belong,leftHangPoint,rightHangPoint)
    --self._functionIcon:ShowIcon()
end

function HawaiiFunctionContainer:EnableFunctionIcon()
    self._functionIcon:OnEnable()
end

function HawaiiFunctionContainer:DisableFunctionIcon()
    self._functionIcon:OnDisable()
end

function HawaiiFunctionContainer:DestroyFunctionIcon()
    self._functionIcon:Dispose()
    self._functionIcon = nil
end

function HawaiiFunctionContainer:TopQuickTaskCheckActivity(go)
    self._topQuickTask:CheckActivity(go)
end

function HawaiiFunctionContainer:Play1CardSkipLoadShow(go)
    self._play1card:SkipLoadShow(go)
end

function HawaiiFunctionContainer:Play2CardSkipLoadShow(go)
    self._play2card:SkipLoadShow(go)
end

function HawaiiFunctionContainer:Play4CardSkipLoadShow(go)
    self._play4card:SkipLoadShow(go)
end

function HawaiiFunctionContainer:Play1CardGetPosition()
    return self._play1card:GetPosition()
end

function HawaiiFunctionContainer:Play2CardGetPosition()
    return self._play2card:GetPosition()
end

function HawaiiFunctionContainer:Play4CardGetPosition()
    return self._play4card:GetPosition()
end

function HawaiiFunctionContainer:Play1CardGameObject()
    return self._play1card.go
end

function HawaiiFunctionContainer:Play2CardGameObject()
    return self._play2card.go
end

function HawaiiFunctionContainer:Play4CardGameObject()
    return self._play4card.go
end

function HawaiiFunctionContainer:Play1CardCheckCoupon()
    self._play1card:CheckCoupon(true)
end

function HawaiiFunctionContainer:Play2CardCheckCoupon()
    self._play2card:CheckCoupon(true)
end

function HawaiiFunctionContainer:Play4CardCheckCoupon()
    self._play4card:CheckCoupon(true)
end

function HawaiiFunctionContainer:Play1CardSetInfo(betRate)
    self._play1card:SetInfo(betRate)
end

function HawaiiFunctionContainer:Play2CardSetInfo(betRate)
    self._play2card:SetInfo(betRate)
end

function HawaiiFunctionContainer:Play4CardSetInfo(betRate)
    self._play4card:SetInfo(betRate)
end

function HawaiiFunctionContainer:Play1CardDoCardClick()
    self._play1card:DoCardClick()
end

function HawaiiFunctionContainer:Play2CardDoCardClick()
    self._play2card:DoCardClick()
end

function HawaiiFunctionContainer:Play4CardDoCardClick()
    self._play4card:DoCardClick()
end

function HawaiiFunctionContainer:Play1CardReplaceBtnPlayEvent(isReplace)
    self._play1card:ReplaceBtnPlayEvent(isReplace)
end

function HawaiiFunctionContainer:Play2CardReplaceBtnPlayEvent(isReplace)
    self._play2card:ReplaceBtnPlayEvent(isReplace)
end

function HawaiiFunctionContainer:Play2CardRayCast()
    self._play2card:Set2CardRayCast()
end

function HawaiiFunctionContainer:Play4CardRayCast()
    self._play4card:Set2CardRayCast()
end

function HawaiiFunctionContainer:Play1CardNumberAvailable(callback)
    self._play1card:SetPlayCardsNumberAvailable()
end

function HawaiiFunctionContainer:Play2CardNumberAvailable(callback)
    self._play2card:SetPlayCardsNumberAvailable(callback)
end

function HawaiiFunctionContainer:Play4CardNumberAvailable(callback)
    self._play4card:SetPlayCardsNumberAvailable(callback)
end

function HawaiiFunctionContainer:Play1CardNumberDisable(callback)
    self._play1card:SetPlayCardsNumberDisable(callback)
end

function HawaiiFunctionContainer:Play2CardNumberDisable(callback)
    self._play2card:SetPlayCardsNumberDisable(callback)
end

function HawaiiFunctionContainer:Play4CardNumberDisable(callback)
    self._play4card:SetPlayCardsNumberDisable(callback)
end

function HawaiiFunctionContainer:BetRateOperatorSkipLoadShow(go)
    self._betRateOperator:SkipLoadShow(go)
end

function HawaiiFunctionContainer:SetBetRateInfo(cardspend,betRate,rate,enter)
    self._betRateOperator:SetBetRateInfo(cardspend,betRate,rate,enter)
end

function HawaiiFunctionContainer:JackpotConsoleSkipLoadShow(go)
    self._jackpotConsole:SkipLoadShow(go,true)
end

function HawaiiFunctionContainer:ShowJackpotConsole()
    self._jackpotConsole:Show()
end

function HawaiiFunctionContainer:LobbyAdvertiseSkipLoadShow(go)
    self._lobbyAdvertise:SkipLoadShow(go,false)
end

function HawaiiFunctionContainer:CheckLobbyAdvertise()
    self._lobbyAdvertise:CheckLobbyAdvertise()
end

function HawaiiFunctionContainer:GiftpackSkipLoadShow(go)
    self._giftpack:SkipLoadShow(go)
end
--]]