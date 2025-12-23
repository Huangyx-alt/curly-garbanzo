require "View/HallCity/HallFunctionContainer"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
require "View/HallCity/SingleWolfConsoleView"

SingleWolfFunctionContainer = HallFunctionContainer:New()

function SingleWolfFunctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.lobby)
    
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = SingleWolfConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil

end