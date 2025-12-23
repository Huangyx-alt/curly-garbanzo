local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardOriginalState = Clazz(BaseClaimRewardState,"ClaimRewardOriginalState")

function ClaimRewardOriginalState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardOriginalState:OnEnter(fsm)

end

function ClaimRewardOriginalState:OnLeave(fsm)

end

function ClaimRewardOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardEnterState")
    end
end

function ClaimRewardOriginalState:DoClick(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardGushState")
    end
end

return ClaimRewardOriginalState