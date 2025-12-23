local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardTier5State = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardTier5State")

function TournamentClaimRewardTier5State:OnEnter(fsm)
    fsm:GetOwner():PlayTier5Reward()
end

function TournamentClaimRewardTier5State:OnLeave(fsm)
end
return TournamentClaimRewardTier5State