local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardTier2State = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardTier2State")

function TournamentClaimRewardTier2State:OnEnter(fsm)
    fsm:GetOwner():PlayTier2Reward()
end

function TournamentClaimRewardTier2State:OnLeave(fsm)
end
return TournamentClaimRewardTier2State