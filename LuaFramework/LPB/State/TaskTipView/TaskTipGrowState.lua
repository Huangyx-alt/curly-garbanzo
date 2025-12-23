TaskTipGrowState = Clazz(BaseHallCityState,"TaskTipGrowState")

local function GetTaskChange(taskId,currData)
    local curr = nil

    for i = 1, #currData do
        if currData[i].taskId == taskId then
            curr = currData[i]
            break
        end
    end
    return curr
end
TaskTipGrowState.delayTimer = nil

function TaskTipGrowState:IsDailyComplete()
    local currData = ModelList.TaskModel.GetDailyTask()
    for i = 1, #currData do
        if not currData[i].rewarded then
            return false
        end
    end
    return true
end

function TaskTipGrowState:OnEnter(fsm)
    --local lastData = ModelList.TaskModel.GetLastDailyTask()
    local IsDailyComplete = TaskTipGrowState:IsDailyComplete()
    local currData = nil
    if IsDailyComplete then
        currData = ModelList.TaskModel.GetWeeklyTask()
    else
        currData = ModelList.TaskModel.GetDailyTask()
    end
    local taskItemCache = fsm:GetOwner():GetTaskItem()
    for i = 1, #taskItemCache do
        local taskData = taskItemCache[i]:GetTaskData()
        local curr = GetTaskChange(taskData.taskId,currData)
        if curr and  curr.process ~="0" and curr.process ~= curr.oldProcess then
            local oldProcess = curr.oldProcess
            if not oldProcess or oldProcess == "" then oldProcess = "0" end
            taskItemCache[i]:PlayFillEffect(oldProcess,curr.process,curr.target)
        end
    end
    TaskTipGrowState.delayTimer = LuaTimer:SetDelayFunction(0.8,function()
        TaskTipGrowState:PlayExit(fsm)
        TaskTipGrowState.delayTimer = nil
    end)
end

function TaskTipGrowState:OnLeave(fsm)

end

function TaskTipGrowState:PlayExit(fsm)
    if fsm then
        self:ChangeState(fsm,"TaskTipCheckFullState")
    end
end

function TaskTipGrowState:Dispose()
    if TaskTipGrowState.delayTimer then
        LuaTimer:Remove(TaskTipGrowState.delayTimer)
        TaskTipGrowState.delayTimer = nil
    end
end