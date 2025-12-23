local HallMainBaseState = require "State/HallMainView/HallMainBaseState"
local HallMainEnterState = Clazz(HallMainBaseState,"HallMainEnterState")

function HallMainEnterState:EnterFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"HallMainOriginalState")
    end
end

function HallMainEnterState:OnEnter(fsm)
    if fsm then
        fsm:GetOwner():OnEnterHallMain()
    end
end

function HallMainEnterState:OnLeave(fsm)
end
return HallMainEnterState