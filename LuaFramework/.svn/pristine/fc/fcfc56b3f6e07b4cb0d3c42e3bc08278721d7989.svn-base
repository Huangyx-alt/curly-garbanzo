
local BaseClaimRewardState = require "View/ClaimRewardsView/BaseClaimRewardState"
local ClaimRewardStiffState = Clazz(BaseClaimRewardState,"ClaimRewardStiffState")

function ClaimRewardStiffState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardStiffState:OnEnter(fsm,previous,...)
    self._change2state = ({...})[1]
    self._timer = Invoke(function()
        if self and fsm then
            self:ChangeState(fsm,self._change2state or "ClaimRewardObtainState")
        end
    end,2)
end

function ClaimRewardStiffState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    self._change2state  = nil
end

return ClaimRewardStiffState