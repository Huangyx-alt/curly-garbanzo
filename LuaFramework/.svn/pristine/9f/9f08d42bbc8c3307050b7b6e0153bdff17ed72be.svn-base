local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardFlyRewardState = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardFlyRewardState")

function TournamentClaimRewardFlyRewardState:OnEnter(fsm)
    fsm:GetOwner():FlyReward()
end

function TournamentClaimRewardFlyRewardState:OnLeave(fsm)
end
return TournamentClaimRewardFlyRewardState