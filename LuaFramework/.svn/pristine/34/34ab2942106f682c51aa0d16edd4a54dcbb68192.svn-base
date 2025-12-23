local CollectRewardsAdBaseState = Clazz(BaseFsmState,"")
local this = CollectRewardsAdBaseState

function CollectRewardsAdBaseState:PlayEnter(fsm)
end

function CollectRewardsAdBaseState:Change2Original(fsm)
    if fsm then
        self:ChangeState(fsm,"CollectRewardsAdOriginalState")
    end
end

function CollectRewardsAdBaseState:Change2Forbiden(fsm)
    if fsm then
        self:ChangeState(fsm,"CollectRewardsAdForbidState")
    end
end

function CollectRewardsAdBaseState:CollectReward(fsm)
end

function CollectRewardsAdBaseState:ExtraSpin(fsm)
    
end

function CollectRewardsAdBaseState:Complete(fsm)
    
end

return  this


