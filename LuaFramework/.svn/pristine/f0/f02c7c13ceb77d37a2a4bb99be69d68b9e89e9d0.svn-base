local BaseGamePassBaseRewardsBaseState = require "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsBaseState"
local BaseGamePassBaseRewardsExtraState = Clazz(BaseGamePassBaseRewardsBaseState, "BaseGamePassBaseRewardsExtraState")

function BaseGamePassBaseRewardsExtraState:OnEnter(fsm)
    fsm:GetOwner():OnExtraSpin()
end

function BaseGamePassBaseRewardsExtraState:OnLeave(fsm)
end

function BaseGamePassBaseRewardsExtraState:Complete(fsm)
    if fsm then
        fsm:GetOwner():FinishNeedExtraSpin()
    end
end

return BaseGamePassBaseRewardsExtraState