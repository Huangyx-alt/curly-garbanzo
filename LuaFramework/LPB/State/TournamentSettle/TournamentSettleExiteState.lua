local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleExiteState = Clazz(TournamentSettleBaseState,"TournamentSettleExiteState")

function TournamentSettleExiteState:OnEnter(fsm)
    fsm:GetOwner():PlayExite()
end

function TournamentSettleExiteState:OnLeave(fsm)
end
return TournamentSettleExiteState