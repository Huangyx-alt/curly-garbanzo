local CollectRewardsAdBaseState = require "View/CollectRewardsView/CollectRewardsAdBaseState"

local CollectRewardsAdExtraState = Clazz(CollectRewardsAdBaseState,"CollectRewardsAdExtraState")
local this = CollectRewardsAdExtraState

function CollectRewardsAdExtraState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CollectRewardsAdExtraState:OnEnter(fsm)
    fsm:GetOwner():OnExtraSpin()
end

function CollectRewardsAdExtraState:OnLeave(fsm)

end

function CollectRewardsAdExtraState:Complete(fsm)
    if fsm then
        fsm:GetOwner():FinishNeedExtraSpin()
    end
end

return this