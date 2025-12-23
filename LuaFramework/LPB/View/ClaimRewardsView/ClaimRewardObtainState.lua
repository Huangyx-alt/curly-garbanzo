
local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardObtainState = Clazz(BaseClaimRewardState,"ClaimRewardObtainState")

function ClaimRewardObtainState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardObtainState:OnEnter(fsm)
    self._timer = Invoke(function()
        self:DoClick(fsm)
    end,0.35)
end

function ClaimRewardObtainState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function ClaimRewardObtainState:OnDispose()
    self:OnLeave(nil)
end

function ClaimRewardObtainState:DoClick(fsm)
    if fsm then
        fsm:GetOwner():ObtainReward()
        self:ChangeState(fsm,"ClaimRewardStiffState","ClaimRewardObtainState")
    end
end

return ClaimRewardObtainState