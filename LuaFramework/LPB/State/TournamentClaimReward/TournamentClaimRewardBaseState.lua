
local TournamentClaimRewardBaseState = Clazz(BaseFsmState,"TournamentClaimRewardBaseState")

function TournamentClaimRewardBaseState:Change2WaitForOpen(fsm,tiers)
    if fsm then
        self:ChangeState(fsm,"TournamentClaimRewardWaitBoxState",tiers)
    end
end

function TournamentClaimRewardBaseState:DoClick(fsm)
end

function TournamentClaimRewardBaseState:OpenRewardBox(fsm,rewardCount)
end

function TournamentClaimRewardBaseState:OpenRewardSucceed(fsm)
end
return TournamentClaimRewardBaseState