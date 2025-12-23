
TaskTipEnterState = Clazz(BaseFsmState,"TaskTipEnterState")
TaskTipEnterState.delayTimer = nil

function TaskTipEnterState:OnEnter(fsm,previous)
    local tipState = fun.read_value(DATA_KEY.task_today_show_state)
    local lastData = ModelList.TaskModel.GetDailyTask()
    local hasDaily = false
    if lastData and #lastData>0 then
        for i = 1, #lastData do
            if  not lastData[i].rewarded then
                hasDaily = true
                break
            end
        end
    end
    if not hasDaily then
        lastData = ModelList.TaskModel.GetWeeklyTask()
    end

    if tipState == 2  then
        fun.save_value(DATA_KEY.task_today_show_state,0)

        fsm:GetOwner():SetTaskItems(lastData,false)
        TaskTipEnterState:CheckFull(fsm)
    elseif  ModelList.TaskModel:NeedShowDailyTipShow() then
        fun.save_value(DATA_KEY.task_today_show_state,0)
        fsm:GetOwner():SetTaskItems(lastData,true)
        TaskTipEnterState:PlayGrow(fsm)
    else
        fsm:GetOwner():SetTaskItems(lastData,true)
        TaskTipEnterState:PlayGrow(fsm)
    end
end


function TaskTipEnterState:CheckFull(fsm)
    fsm:ChangeState("TaskTipCheckFullState")
end

function TaskTipEnterState:PlayGrow(fsm)
    TaskTipEnterState.delayTimer = LuaTimer:SetDelayFunction(1, function()
        fsm:ChangeState("TaskTipGrowState")
        TaskTipEnterState.delayTimer = nil
    end)
end

function TaskTipEnterState:Finish(fsm)
end

function TaskTipEnterState:Change2Stiff(fsm)
    
end

function TaskTipEnterState:FinishStiff(fsm)
end

function TaskTipEnterState:OnTurnCityLeft(fsm)

end

function TaskTipEnterState:OnTurnCityRight(fsm)
    
end

function TaskTipEnterState:OnCityClick(fsm)
end

function TaskTipEnterState:OnFunctionIconClick(fsm,view,params,...)
    
end

function TaskTipEnterState:OnAutoBingoClick(fsm)
    
end

function TaskTipEnterState:Dispose()
    if TaskTipEnterState.delayTimer then
        LuaTimer:Remove(TaskTipEnterState.delayTimer)
        TaskTipEnterState.delayTimer = nil
    end
end