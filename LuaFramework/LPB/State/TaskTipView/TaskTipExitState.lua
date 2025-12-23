
TaskTipExitState = Clazz(BaseHallCityState,"TaskTipExitState")

TaskTipExitState.delayTimer = nil

function TaskTipExitState:OnEnter(fsm)
    TaskTipExitState.delayTimer = LuaTimer:SetDelayFunction(2,function()
        if fsm and fsm:GetOwner() then
            fsm:GetOwner():PlayExit()
        end
        TaskTipExitState.delayTimer = nil
    end)

end

function TaskTipExitState:Dispose()
    if TaskTipExitState.delayTimer then
        LuaTimer:Remove(TaskTipExitState.delayTimer)
        TaskTipExitState.delayTimer = nil
    end
end

function TaskTipExitState:OnLeave(fsm)
    
end

function TaskTipExitState:FinishStiff(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityOriginalState")
    end
end

function TaskTipExitState:Finish(fsm)
    if fsm then
        self:ChangeState(fsm,"HallCityOriginalState")
    end
end