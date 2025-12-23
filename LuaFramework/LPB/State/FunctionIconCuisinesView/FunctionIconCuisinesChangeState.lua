local FunctionIconCuisinesBaseState = require("State/FunctionIconCuisinesView/FunctionIconCuisinesBaseState")
local FunctionIconCuisinesChangeState = Clazz(FunctionIconCuisinesBaseState, "FunctionIconCuisinesChangeState")

function FunctionIconCuisinesChangeState:ChangeCityLock(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesLockState")
    end
end

function FunctionIconCuisinesChangeState:ChangeCityOpen(fsm)
    if fsm then
        fsm:GetOwner():SetInfo()
    end
end

function FunctionIconCuisinesChangeState:ChangeComplete(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesIdelState")
    end
end

function FunctionIconCuisinesChangeState:OnEnter(fsm)
    fsm:GetOwner():PlayChangeCity()
end

function FunctionIconCuisinesChangeState:OnLeave(fsm)
end
return FunctionIconCuisinesChangeState