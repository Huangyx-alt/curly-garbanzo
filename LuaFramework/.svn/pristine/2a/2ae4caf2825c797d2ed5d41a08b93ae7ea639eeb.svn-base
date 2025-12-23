local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleCheckTierState = Clazz(TournamentSettleBaseState,"TournamentSettleCheckTierState")

function TournamentSettleCheckTierState:OnEnter(fsm)
    fsm:GetOwner():ClimbStage2()
end

function TournamentSettleCheckTierState:OnLeave(fsm)
end

function TournamentSettleCheckTierState:ClimbNext(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleOriginalState")
    end
end
return TournamentSettleCheckTierState