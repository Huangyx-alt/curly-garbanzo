local CollectRewardsAdBaseState = require "View/CollectRewardsView/CollectRewardsAdBaseState"
local CollectRewardsAdStiffState = Clazz(CollectRewardsAdBaseState,"CollectRewardsAdStiffState")
local this = CollectRewardsAdStiffState

function CollectRewardsAdStiffState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CollectRewardsAdStiffState:OnEnter(fsm,previous,params)
    if 1 == params then
    
    else
        fsm:GetOwner():OnCollectReward()
    end
end

function CollectRewardsAdStiffState:OnLeave(fsm)
    
end

function CollectRewardsAdStiffState:Complete(fsm)
    if fsm then
        fsm:GetOwner():Finish()
    end
end
return this