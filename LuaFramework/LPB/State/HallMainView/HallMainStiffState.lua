local HallMainBaseState = require "State/HallMainView/HallMainBaseState"
local HallMainStiffState = Clazz(HallMainBaseState,"HallMainStiffState")

function HallMainStiffState:OnEnter(fsm)
end

function HallMainStiffState:OnLeave(fsm)
    fsm:GetOwner():FinishTopQuickTask()
end

function HallMainStiffState:OnTopQuickTaskAnimaFinish(fsm)
    if fsm then
        self:ChangeState(fsm,"HallMainOriginalState")
    end
end
return HallMainStiffState