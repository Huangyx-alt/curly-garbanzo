local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleEnterState = Clazz(TournamentSettleBaseState,"TournamentSettleEnterState")

function TournamentSettleEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function TournamentSettleEnterState:OnLeave(fsm)
end

function TournamentSettleEnterState:EnterFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleOriginalState")
    end
end
return TournamentSettleEnterState