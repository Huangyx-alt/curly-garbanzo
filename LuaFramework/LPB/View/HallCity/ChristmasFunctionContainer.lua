require "View/HallCity/HallFunctionContainer"
local ChristmasConsoleView = require "View/HallCity/ChristmasConsoleView"
local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
local ChristmasFunctionContainer = HallFunctionContainer:New()

function ChristmasFunctionContainer:Init()
    --self._topQuickTask = TopQuickTaskView:New(true,ParasitiferType.lobby)
    
    self._play1card = PlayCardsNumberView:New(CardGenre.onecard)
    self._play2card = PlayCardsNumberView:New(CardGenre.twocard)
    self._play4card = PlayCardsNumberView:New(CardGenre.fourcard)
    self._betRateOperator = BetRateOperatedView:New()
    self._jackpotConsole = ChristmasConsoleView:New(JackepotHost.mainLobby)
    self._lobbyAdvertise = LobbyAdvertiseView:New()
    self._giftpack = GiftPackEnterView:New()
    self._functionIcon = nil
end

return ChristmasFunctionContainer