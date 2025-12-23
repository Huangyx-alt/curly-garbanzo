require "View/HallCity/HallFunctionContainer"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
require "View/HallCity/GoldenPigConsoleView"
GoldenPigFunctionContainer = HallFunctionContainer:New()

function GoldenPigFunctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.lobby)
    
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = GoldenPigConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil
end