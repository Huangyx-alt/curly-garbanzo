local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleJumpCityState = Clazz(TournamentSettleBaseState,"TournamentSettleJumpCityState")

function TournamentSettleJumpCityState:OnEnter(fsm)
    fsm:GetOwner():PlayExiteToCity()
end

function TournamentSettleJumpCityState:OnLeave(fsm)
end
return TournamentSettleJumpCityState