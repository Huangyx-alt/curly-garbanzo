local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardWaitBoxState = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardWaitBoxState")

function TournamentClaimRewardWaitBoxState:OnEnter(fsm,previous,...)
    self._tier = select(1,...)
end

function TournamentClaimRewardWaitBoxState:OnLeave(fsm)
    self._tier = nil
end

function TournamentClaimRewardWaitBoxState:DoClick(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentClaimRewardOpenBoxState",self._tier)
    end
end
return TournamentClaimRewardWaitBoxState