local BaseGamePassBaseRewardsBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsBaseState"
local BaseGamePassBaseRewardsOriginalState = Clazz(BaseGamePassBaseRewardsBaseState, "BaseGamePassBaseRewardsOriginalState")

function BaseGamePassBaseRewardsOriginalState:OnEnter(fsm)
end

function BaseGamePassBaseRewardsOriginalState:OnLeave(fsm)
end

function BaseGamePassBaseRewardsOriginalState:PlayEnter(fsm,callback)
    self:ChangeState(fsm, "BaseGamePassBaseRewardsStiffState", 1)
    if callback then
        callback()
    end
end

function BaseGamePassBaseRewardsOriginalState:CollectReward(fsm)
    self:ChangeState(fsm, "BaseGamePassBaseRewardsStiffState")
end

function BaseGamePassBaseRewardsOriginalState:ExtraSpin(fsm)
    self:ChangeState(fsm, "BaseGamePassBaseRewardsExtraState")
end

return BaseGamePassBaseRewardsOriginalState