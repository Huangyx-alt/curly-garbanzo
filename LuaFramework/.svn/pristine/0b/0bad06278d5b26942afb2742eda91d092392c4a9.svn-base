local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardEnterState = Clazz(BaseClaimRewardState,"ClaimRewardEnterState")

function ClaimRewardEnterState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
    UISound.play("gift_box")
end

function ClaimRewardEnterState:OnLeave(fsm)
    
end

function ClaimRewardEnterState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardOriginalState")
    end
end

return ClaimRewardEnterState