require "View/HallCity/HallFunctionContainer"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
local WinZoneConsoleView = require "View/HallCity/WinZoneConsoleView"
WinZoneFunctionContainer = HallFunctionContainer:New()

function WinZoneFunctionContainer:Init()
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = WinZoneConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil
end