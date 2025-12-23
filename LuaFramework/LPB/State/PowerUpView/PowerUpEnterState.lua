local PowerUpBaseState = require "State.PowerUpView.PowerUpBaseState"
local PowerUpEnterState = Clazz(PowerUpBaseState,"PowerUpEnterState")

function PowerUpEnterState:OnEnter(fsm)
    fsm:GetOwner():OnEnterPowerUp()
    --ModelList.GuideModel:OpenUI("PowerUpView")
end

function PowerUpEnterState:OnLeave(fsm)
end

function PowerUpEnterState:EnterFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"PowerUpPrimitiveState")
    end
end

return PowerUpEnterState
