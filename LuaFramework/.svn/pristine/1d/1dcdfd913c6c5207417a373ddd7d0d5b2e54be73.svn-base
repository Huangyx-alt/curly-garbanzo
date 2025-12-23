local CollectRewardsAdBaseState = require "View/CollectRewardsView/CollectRewardsAdBaseState"
local CollectRewardsAdOriginalState = Clazz(CollectRewardsAdBaseState,"CollectRewardsAdOriginalState")
local this = CollectRewardsAdOriginalState

function CollectRewardsAdOriginalState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CollectRewardsAdOriginalState:OnEnter(fsm)

end

function CollectRewardsAdOriginalState:OnLeave(fsm)
    
end

function CollectRewardsAdBaseState:PlayEnter(fsm,callback)
    self:ChangeState(fsm,"CollectRewardsAdStiffState",1)
    if callback then
        callback()
    end
end

function CollectRewardsAdOriginalState:CollectReward(fsm)
    self:ChangeState(fsm,"CollectRewardsAdStiffState")
end

function CollectRewardsAdOriginalState:ExtraSpin(fsm)
    self:ChangeState(fsm,"CollectRewardsAdExtraState")
end
return this