local FunctionIconCuisinesBaseState = require("State/FunctionIconCuisinesView/FunctionIconCuisinesBaseState")
local FunctionIconCuisinesOpenState = Clazz(FunctionIconCuisinesBaseState,"FunctionIconCuisinesOpenState")

function FunctionIconCuisinesOpenState:ChangeCityLock(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesLockState")
    end
end

function FunctionIconCuisinesOpenState:ChangeCityOpen(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesChangeState")
    end
end

function FunctionIconCuisinesOpenState:ChangeComplete(fsm)
    if fsm then
        self:ChangeState(fsm,"FunctionIconCuisinesIdelState")
    end
end


function FunctionIconCuisinesOpenState:OnEnter(fsm)
    fsm:GetOwner():PlayOpen()
end

function FunctionIconCuisinesOpenState:OnLeave(fsm)
end

return FunctionIconCuisinesOpenState