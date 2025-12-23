local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardTier1State = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardTier1State")

function TournamentClaimRewardTier1State:OnEnter(fsm)
    fsm:GetOwner():PlayTier1Reward()
end

function TournamentClaimRewardTier1State:OnLeave(fsm)
end

return TournamentClaimRewardTier1State