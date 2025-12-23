local FunctionIconCuisinesBaseState = require("State/FunctionIconCuisinesView/FunctionIconCuisinesBaseState")
local FunctionIconCuisinesLockState = Clazz(FunctionIconCuisinesBaseState,"FunctionIconCuisinesLockState")

function FunctionIconCuisinesLockState:ChangeCityLock(fsm)
end

function FunctionIconCuisinesLockState:ChangeCityOpen(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesOpenState")
    end
end

function FunctionIconCuisinesLockState:OnEnter(fsm)
    fsm:GetOwner():PlayLock()
end

function FunctionIconCuisinesLockState:OnLeave(fsm)
end
return FunctionIconCuisinesLockState