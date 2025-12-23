local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardGushState = Clazz(BaseClaimRewardState,"ClaimRewardGushState")

function ClaimRewardGushState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardGushState:OnEnter(fsm)
    fsm:GetOwner():PlayGush()
    UISound.play("gift_box_open")
end

function ClaimRewardGushState:OnLeave(fsm)

end

function ClaimRewardGushState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"ClaimRewardObtainState")
    end
end

return ClaimRewardGushState