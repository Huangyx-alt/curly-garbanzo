local TournamentSettleBaseState  = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleOriginalState = Clazz(TournamentSettleBaseState,"TournamentSettleOriginalState")

function TournamentSettleOriginalState:OnEnter(fsm)

end

function TournamentSettleOriginalState:OnLeave(fsm)

end

function TournamentSettleOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleEnterState")
    end
end

function TournamentSettleOriginalState:PlayExite(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleExiteState")
    end
end

function TournamentSettleOriginalState:StartClimb(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleClimbRankState")
    end
end

function TournamentSettleOriginalState:ClimbNext(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentSettleJumpCityState")
    end
end

function TournamentSettleOriginalState:OnShowPlayerInfo(fsm)
    if fsm then
        fsm:GetOwner():OnShowPlayerInfo()
    end
end

function TournamentSettleOriginalState:ShowHelpView(fsm)
    if fsm then
        fsm:GetOwner():OnShowHelpView()
    end
end
return TournamentSettleOriginalState