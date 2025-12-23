local TournamentClaimRewardBaseState = require("State.TournamentClaimReward.TournamentClaimRewardBaseState")
local TournamentClaimRewardOpenBoxState = Clazz(TournamentClaimRewardBaseState,"TournamentClaimRewardOpenBoxState")

function TournamentClaimRewardOpenBoxState:OnEnter(fsm,previous,...)
    self._tier = select(1,...)
    fsm:GetOwner():RequestTournamentReward()
    self._timer = Invoke(function()
        self:ChangeState(fsm,"TournamentClaimRewardWaitBoxState",self._tier)
    end,3)
end

function TournamentClaimRewardOpenBoxState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    self._tier = nil
end

function TournamentClaimRewardOpenBoxState:OpenRewardBox(fsm,rewardCount)
    if fsm then
        fsm:GetOwner():PlayOpenRewardBox(rewardCount)
    end
end

function TournamentClaimRewardOpenBoxState:OpenRewardSucceed(fsm)
    if fsm then
        self:ChangeState(fsm,"TournamentClaimRewardFlyRewardState")
    end
end
return TournamentClaimRewardOpenBoxState