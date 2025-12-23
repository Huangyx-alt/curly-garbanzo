
local FunctionIconCuisinesBaseState = require("State/FunctionIconCuisinesView/FunctionIconCuisinesBaseState")
local FunctionIconCuisinesIdelState = Clazz(FunctionIconCuisinesBaseState,"FunctionIconCuisinesIdelState")

function FunctionIconCuisinesIdelState:ChangeCityLock(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesLockState")
    end
end

function FunctionIconCuisinesIdelState:ChangeCityOpen(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesChangeState")
    end
end

function FunctionIconCuisinesIdelState:OnEnter(fsm)
    fsm:GetOwner():PlayIdle()
end

function FunctionIconCuisinesIdelState:OnLeave(fsm)
end

return FunctionIconCuisinesIdelState