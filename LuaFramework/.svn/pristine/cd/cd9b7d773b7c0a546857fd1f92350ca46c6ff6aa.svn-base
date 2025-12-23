--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

local BaseTaskView = class("BaseTaskView", BaseViewEx)--Clazz(BaseView, "")
local this = BaseTaskView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

function BaseTaskView:ctor(id)
    self.id = id
end

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
local remainTimeCountDown = RemainTimeCountDown:New()

---当前短令牌任务类型
this._taskCityPlayId = 0
local _previousIndex = nil
local taskItemEntityCache = nil
local taskStageReward = require "GamePlayShortPass/Base/BasePassTaskReward"
local all_task_complete = nil
local isPopupTask = nil

this.longTaskIconScale = { x = 1, y = 1 }
this.longTaskIconPos = { x = 0, y = 0 }

this._cleanImmediately = true 
this.auto_bind_ui_items = {
    "left_time_txt",
    "btn_close",
    "GiftPackChinaTownView",
    "btn_openpassview",
    "task_items",
    "content",
    "stageRewards",
    "FunctionIcon",
    "btn_bg",
    "FunctionIconget",
    "rewardIconget",
}

function BaseTaskView:Awake(obj)
    self:on_init()
end

function BaseTaskView:OnEnable(params)
    self:BaseEnable(params)
end

function BaseTaskView:BaseEnable(params)
    Facade.RegisterView(self)
    --self:RegisterRedDotNode()
    CommonState.BuildFsm(self, "BaseTaskView")
    self:SetTaskCurrentToggle()

    self:SetTaskInfo()
    Event.AddListener(EventName.Event_TaskUpdate, self.RefreshTaskInfo, self)
    taskStageReward:SkipLoadShow(self.stageRewards)
    self:SetTaskRewardInfo()
    fun.set_active(self.task_items, false)

    ---通用ICON
    local view = ModelList.GameActivityPassModel.GetViewById(self.id, "PassIconView")
    self.childIconView = view:create(self.id,false,"taskview")
    self.childIconView:SkipLoadShow(self.FunctionIcon, true, nil, true)
    self.childIconView:SetCoutDown(ModelList.GameActivityPassModel.GetRemainTime())
    self.childIconView:SetProgress()

    self:RegisterUIEvent()
end


function BaseTaskView:OnDisable()
    Facade.RemoveView(self)
    self:UnRegisterRedDotNode()
    CommonState.DisposeFsm(self)
    taskItemEntityCache = nil
    _previousIndex = nil
    all_task_complete = nil
    isPopupTask = nil
    Event.RemoveListener(EventName.Event_TaskUpdate, self.RefreshTaskInfo, self)
    Event.Brocast(EventName.Event_popup_task_tip_finish)
    self:Close()
    if (self.childIconView) then
        self.childIconView:Close()
    end

    self:UnRegisterUIEvent()
    Event.Brocast(EventName.Event_popup_PopupShortPass_finish)

    if remainTimeCountDown then
        remainTimeCountDown:StopCountDown()
        remainTimeCountDown = nil
    end
end

function BaseTaskView:on_close()

end

function BaseTaskView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.task_reddot_event, "BaseTaskView", self.img_reddot_daily, RedDotParam.task_daily)
    RedDotManager:RegisterNode(RedDotEvent.task_reddot_event, "BaseTaskView", self.img_reddot_weekly, RedDotParam.task_weekly)
end

function BaseTaskView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.task_reddot_event, "BaseTaskView", RedDotParam.task_daily)
    RedDotManager:UnRegisterNode(RedDotEvent.task_reddot_event, "BaseTaskView", RedDotParam.task_weekly)
end

function BaseTaskView:RefreshTaskInfo()
    self._fsm:GetCurState():DoOriginalAction(self._fsm, nil, function()
        self:SetTaskInfo()
        RedDotManager:Refresh(RedDotEvent.task_reddot_event)
    end)
end

function BaseTaskView:OnApplicationFocus(focus)
    if focus then
        if self._taskCityPlayId or self:SetTaskCurrentToggle() then
            --self:SetTaskInfo()
        end
    end
end

function BaseTaskView:SetTaskCurrentToggle()
    self._taskCityPlayId =  ModelList.GameActivityPassModel.GetCurrentId()
end

function BaseTaskView:on_btn_close_click()
    AnimatorPlayHelper.Play(self.anima, "BaseTaskViewexit", false, function()
        Facade.SendNotification(NotifyName.CloseUI, self)
    end)
end

function BaseTaskView:on_btn_bg_click()
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassView")
end

function BaseTaskView:SetTaskInfo()
    local taskList, endtime = ModelList.GameActivityPassModel.GetTaskData()
    if taskList then
        --taskStageReward:SetStageReward(self._taskCityPlayId)
        self:SetTaskItems(taskList)
    end
    self:SetLeftTime(endtime)
end

function BaseTaskView:SetTaskItems(taskDataList, oldProcess)
    if taskDataList then
        local currOrder = 10
        local diffcultCount = 0
        local rewardedCount = 0
        for key, value in pairs(taskDataList) do
            if value.isDifficult then
                diffcultCount = 1
            end
            if (not value.isDifficult and value.taskType ~= 6) and not value.completed and value.order < currOrder  then
                currOrder = value.order
            end
            if value.rewarded  and not value.isDifficult then
                rewardedCount = rewardedCount + 1
            end
        end
        local count = 0
        for key, value in pairs(taskDataList) do
            count = count + 1
            if not value.rewarded and not value.failed then

                if value.rewarded and #taskDataList - diffcultCount - rewardedCount == 0 then
                    local view = self:GetItemViewInstance(count)
                    if view then
                        view:SetTaskData(value, currOrder, self._taskCityPlayId, true,count,self)
                    end
                elseif not value.rewarded then
                    local view = self:GetItemViewInstance(count)
                    if view then
                        view:SetTaskData(value, currOrder, self._taskCityPlayId,nil,count,self)
                    end
                end
            elseif value.rewarded and(
                    ( value.order == #taskDataList -1  and #taskDataList - diffcultCount - rewardedCount == 0 ) or value.isDifficult)   then
                local view = self:GetItemViewInstance(count)
                if view then
                    view:SetTaskData(value, currOrder, self._taskCityPlayId, true,count,self)
                end
            else
                local view = self:GetItemViewInstance(count)
                fun.set_active(view:GetTransform(), false, false)
            end
        end
        if taskItemEntityCache and count < #taskItemEntityCache then
            for i = count + 1, #taskItemEntityCache do
                fun.set_active(taskItemEntityCache[i].transform, false, false)
            end
        end

        if count <= 0 then
            if not all_task_complete then
                Cache.load_prefabs(AssetList["TaskAllcompletec"], "TaskAllcompletec", function(obj)
                    if obj then
                        all_task_complete = fun.get_instance(obj, self.content)
                    end
                end)
            else
                fun.set_active(all_task_complete.transform, true, false)
            end
        elseif all_task_complete then
            fun.set_active(all_task_complete.transform, false, false)
        end
    else
        log.r("====================================>>任务列表为nil")
    end
end

function BaseTaskView:SetTaskRewardInfo()
    if fun.is_null(taskStageReward.go) then
        return
    end
    local passTaskId = ModelList.GameActivityPassModel.GetCurrPassId(self._taskCityPlayId)
    taskStageReward:SetStageReward(passTaskId)
end

function BaseTaskView:GetItemViewInstance(index)
    local view = require "GamePlayShortPass/Base/BaseTaskItem"
    local view_instance = nil
    if taskItemEntityCache == nil then
        taskItemEntityCache = {}
    end
    if taskItemEntityCache[index] == nil then
        local item = fun.get_instance(self.task_items, self.content)
        view_instance = view:New(self.longTaskAtlasName)
        view_instance:SetParent(self)
        view_instance:SkipLoadShow(item)

        taskItemEntityCache[index] = view_instance
    else
        view_instance = taskItemEntityCache[index]
    end
    view_instance:SetIconSize(self.longTaskIconScale)
    view_instance:SetIconPos(self.longTaskIconPos)
    fun.set_active(view_instance:GetTransform(), true, false)
    return view_instance
end

function BaseTaskView:SetLeftTime(endTimeStamp)
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - start_time
    if not remainTimeCountDown then
        remainTimeCountDown = RemainTimeCountDown:New()
    end
    remainTimeCountDown:StartCountDown(CountDownType.cdt2, endTime, self.left_time_txt, function()
        if self then
            self:on_btn_close_click()
        end
    end)
end

function BaseTaskView:GetBuffId()
    return 0
end

function BaseTaskView:GetModel()
    return ModelList.GameActivityPassModel.GetTaskDataComponentById(self.id)
end

function BaseTaskView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function BaseTaskView:on_btn_openpassview_click()
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassView")
end

function BaseTaskView:SliderChange()
    taskStageReward:SetSliderChange()
end

--- 收获任务奖励表现
function BaseTaskView:ClaimRewardResult()
    self.childIconView:SetCoutDown(ModelList.GameActivityPassModel.GetRemainTime())
    taskStageReward:SetSliderChange()
    self:SetRewarding(false)
end

function BaseTaskView:SetRewarding(isRewarding)
    self._isRewarding = isRewarding
end

function BaseTaskView:IsRewarding()
    return self._isRewarding and true or false
end


--- 收获任务奖励表现
function BaseTaskView:RefreshIcon()
    self.childIconView:SetCoutDown(ModelList.GameActivityPassModel.GetRemainTime())
    self.childIconView:SetProgress()
    self:SetTaskRewardInfo()
    fun.set_active(self.FunctionIconget, false)
    fun.set_active(self.FunctionIconget, true)
end

--- 收获任务奖励表现
function BaseTaskView:RefreshRewardIcon()

    fun.set_active(self.rewardIconget, false)
    fun.set_active(self.rewardIconget, true)
end

function BaseTaskView:RegisterUIEvent()
    Event.AddListener(EventName.Event_PassGetTaskRewardSucceed, self.ClaimRewardResult, self)
    Event.AddListener(EventName.Event_PassGetTaskRefreshIcon, self.RefreshIcon, self)
    Event.AddListener(EventName.Event_PassGetTaskRefreshRewardIcon, self.RefreshRewardIcon, self)
end

function BaseTaskView:UnRegisterUIEvent()
    Event.RemoveListener(EventName.Event_PassGetTaskRewardSucceed, self.ClaimRewardResult, self)
    Event.RemoveListener(EventName.Event_PassGetTaskRefreshIcon, self.RefreshIcon, self)
    Event.RemoveListener(EventName.Event_PassGetTaskRefreshRewardIcon, self.RefreshRewardIcon, self)
end

return this
