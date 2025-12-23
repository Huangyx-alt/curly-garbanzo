local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardTier4State = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardTier4State")

function TournamentClaimRewardTier4State:OnEnter(fsm)
    fsm:GetOwner():PlayTier4Reward()
end

function TournamentClaimRewardTier4State:OnLeave(fsm)
end
return TournamentClaimRewardTier4State