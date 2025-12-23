
local BaseRedDot = require("RedDot/BaseRedDot")
local TaskRedDot = Clazz(BaseRedDot,"TaskRedDot")
local this = TaskRedDot

--local stageReward = {}

function TaskRedDot:Check(node,param)
    local daily_reddot = ModelList.TaskModel.GetRewardInfo(TaskToggle.daily)
    local weekly_reddot = ModelList.TaskModel.GetRewardInfo(TaskToggle.weekly)
    local daily_stage = ModelList.TaskModel.IsStageRwardAvailable(TaskToggle.daily)
    local weekly_stage = ModelList.TaskModel.IsStageRwardAvailable(TaskToggle.weekly)

    --local main_reddot = ModelList.TaskModel.GetRewardInfo(TaskToggle.main)
    --[[
    if stageReward[TaskToggle.daily] == nil then
        TaskRedDot:CheckStageReward(TaskToggle.daily,daily_reddot)
    end
    if stageReward[TaskToggle.weekly] == nil then
        TaskRedDot:CheckStageReward(TaskToggle.weekly,weekly_reddot)
    end
    --]]

    if node.param == RedDotParam.task_daily then
        TaskRedDot:SetSingleNodeActive(node,
            daily_reddot.canGetReward or
            --stageReward[TaskToggle.daily]
            daily_stage
        )
    elseif node.param == RedDotParam.task_weekly then
        TaskRedDot:SetSingleNodeActive(node,
            weekly_reddot.canGetReward or
            --stageReward[TaskToggle.weekly]
            weekly_stage
        )    
    else
        TaskRedDot:SetSingleNodeActive(node,
        daily_reddot.canGetReward or
                weekly_reddot.canGetReward or 
                --main_reddot.canGetReward or 
                --stageReward[TaskToggle.daily] or 
                --stageReward[TaskToggle.weekly]
                daily_stage or
                weekly_stage
        )
    end
end

function TaskRedDot:Refresh(nodeList,param)
    --stageReward = {}
    for key, value in pairs(nodeList) do
        TaskRedDot:Check(value,param)
    end
end

--[[
function TaskRedDot:CheckStageReward(tasktype,data)
    local stage = ModelList.TaskModel.GetStageRewardByType(tasktype)
    local isReward = false
    for key, value in pairs(stage) do
        if not value.rewarded then
            if value.stage == 50 and (data.completed / math.max(data.count,1) >= 0.499 ) then
                isReward = true
                break
            elseif value.stage == 100 and (data.completed / math.max(data.count,1) >= 0.99 ) then
                isReward = true
                break     
            end
        end
    end
    stageReward[tasktype] = isReward
end
--]]

return TaskRedDot