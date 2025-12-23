local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleClimbRankState = Clazz(TournamentSettleBaseState,"TournamentSettleClimbRankState")

function TournamentSettleClimbRankState:OnEnter(fsm)
    fsm:GetOwner():StartClimb()
end

function TournamentSettleClimbRankState:OnLeave(fsm)
end

function TournamentSettleClimbRankState:ClimbNext(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleCheckTierState")
    end
end

return TournamentSettleClimbRankState