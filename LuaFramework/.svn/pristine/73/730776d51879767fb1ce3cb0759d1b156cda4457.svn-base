local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardTier3State = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardTier3State")

function TournamentClaimRewardTier3State:OnEnter(fsm)
    fsm:GetOwner():PlayTier3Reward()
end

function TournamentClaimRewardTier3State:OnLeave(fsm)
end
return TournamentClaimRewardTier3State