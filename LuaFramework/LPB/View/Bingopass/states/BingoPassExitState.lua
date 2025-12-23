local BingoPassBaseState = require "View/Bingopass/states/BingoPassBaseState"
local BingoPassExitState = Clazz(BingoPassBaseState,"BingoPassExitState")

function BingoPassExitState:OnEnter(fsm)
    fsm:GetOwner():PlayBingoPassExit()
end

function BingoPassExitState:OnLeave(fsm)
end
return  BingoPassExitState