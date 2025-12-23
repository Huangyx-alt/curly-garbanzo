local BaseGamePassBaseRewardsBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsBaseState"
local BaseGamePassBaseRewardsStiffState = Clazz(BaseGamePassBaseRewardsBaseState, "BaseGamePassBaseRewardsStiffState")

function BaseGamePassBaseRewardsStiffState:OnEnter(fsm, previous, params)
    if 1 == params then
    else
        fsm:GetOwner():OnCollectReward()
    end
end

function BaseGamePassBaseRewardsStiffState:OnLeave(fsm)
end

function BaseGamePassBaseRewardsStiffState:Complete(fsm)
    if fsm then
        fsm:GetOwner():Finish()
    end
end

return BaseGamePassBaseRewardsStiffState