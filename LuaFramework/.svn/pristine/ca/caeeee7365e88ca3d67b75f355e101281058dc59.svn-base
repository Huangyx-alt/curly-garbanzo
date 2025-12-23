require "State/Common/CommonState"

local TaskView = BaseView:New("TaskView","TaskAtlas")
local this = TaskView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
local _taskToggleIndex = TaskToggle.daily
local _previousIndex = nil

local taskItemEntityCache = nil

local taskStageReward = require "View/Task/TaskStageRewardView"

local all_task_complete = nil

local isPopupTask = nil

this.auto_bind_ui_items = {
    "Toggle_Daily",
    "Toggle_Weekly",
    "Toggle_Achievements",
    "Toggle_Main",
    "content",
    "task_items",
    "btn_close",
    "text_refresh",
    "stageRewards",
    "anima",
    "img_reddot_daily",
    "img_reddot_weekly"
}

function TaskView:Awake(obj)
    self:on_init()
end

function TaskView:OnEnable(params)
    isPopupTask = params
    Facade.RegisterView(self)
    self:RegisterRedDotNode()
    CommonState.BuildFsm(self,"TaskView")
    taskStageReward:SkipLoadShow(self.stageRewards)
    self:SetToggleCallBack()
    self:SetTaskCurrentToggle()
    self:SetTaskInfo()
    Event.AddListener(EventName.Event_TaskUpdate,self.RefreshTaskInfo,self)

    AnimatorPlayHelper.Play(self.anima,"TaskViewenter",false,function()     

    end)
    self:RebindSprite()
end

function TaskView:OnDisable()
    Facade.RemoveView(self)
    self:UnRegisterRedDotNode()
    CommonState.DisposeFsm(self)
    taskItemEntityCache = nil
    _previousIndex = nil
    all_task_complete = nil
    isPopupTask = nil
    Event.RemoveListener(EventName.Event_TaskUpdate,self.RefreshTaskInfo,self)
    Event.Brocast(EventName.Event_popup_task_tip_finish)
end

function TaskView:on_close()

end

function TaskView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.task_reddot_event,"TaskView",self.img_reddot_daily,RedDotParam.task_daily)
    RedDotManager:RegisterNode(RedDotEvent.task_reddot_event,"TaskView",self.img_reddot_weekly,RedDotParam.task_weekly)
end

function TaskView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.task_reddot_event,"TaskView",RedDotParam.task_daily)
    RedDotManager:UnRegisterNode(RedDotEvent.task_reddot_event,"TaskView",RedDotParam.task_weekly)
end

function TaskView:RefreshTaskInfo()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,nil,function()
        self:SetTaskInfo()
        RedDotManager:Refresh(RedDotEvent.task_reddot_event)
    end)
end

function TaskView:OnApplicationFocus(focus)
    if focus then
        if _taskToggleIndex or self:SetTaskCurrentToggle() then
            --self:SetTaskInfo()
        end
    end
end

function TaskView:SetTaskCurrentToggle()
    local togIndex = ModelList.TaskModel.IsAnyReward() or TaskToggle.daily
    _taskToggleIndex = self.taskToggleIndex or togIndex
    self.taskToggleIndex = nil
    if _taskToggleIndex == TaskToggle.daily then
        self.Toggle_Daily.isOn = true
    elseif _taskToggleIndex == TaskToggle.weekly then
        self.Toggle_Weekly.isOn = true
    elseif _taskToggleIndex == TaskToggle.achievements then
        self.Toggle_Achievements.isOn = true
    elseif _taskToggleIndex == TaskToggle.main then
        --self.Toggle_Main.isOn = true
    end
end

function TaskView:SetToggleCallBack()
    local toggles = {self.Toggle_Daily,self.Toggle_Weekly,self.Toggle_Achievements,self.Toggle_Main}
    for index, value in ipairs(toggles) do
        self.luabehaviour:AddToggleChange(value.gameObject,function(go,check)
            self:ToggleChange(go,check)
        end)
    end
end

function TaskView:ToggleChange(go,check)
    if check then
        _previousIndex = _taskToggleIndex
        _taskToggleIndex = TaskToggle.daily
        if go == self.Toggle_Daily.gameObject then
            _taskToggleIndex = TaskToggle.daily
        elseif go == self.Toggle_Weekly.gameObject then
            _taskToggleIndex = TaskToggle.weekly
        elseif go == self.Toggle_Achievements.gameObject then
            _taskToggleIndex = TaskToggle.achievements
        elseif go == self.Toggle_Main.gameObject then
            --_taskToggleIndex = TaskToggle.main
        end
        if _previousIndex ~= _taskToggleIndex then
            self:SetTaskInfo()
        end
    end
end

function TaskView:on_btn_close_click()
    AnimatorPlayHelper.Play(self.anima,"TaskViewexit",false,function()     
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function TaskView:SetTaskInfo()

    local taskList = nil
    local endtime = 0
    if _taskToggleIndex == TaskToggle.daily then
        if fun.is_null(self.stageRewards) then return end
        fun.set_active(self.stageRewards,true)
        taskList  = ModelList.TaskModel.GetDailyTask()
        endtime = ModelList.TaskModel.GetDailyEndTime()
    elseif _taskToggleIndex == TaskToggle.weekly then
        if fun.is_null(self.stageRewards) then return end
        fun.set_active(self.stageRewards,true)
        taskList  = ModelList.TaskModel.GetWeeklyTask()
        endtime = ModelList.TaskModel.GetWeeklyEndTime()
    end

    if taskList  then
        if fun.is_null(taskStageReward.go) then return end
        taskStageReward:SetStageReward(_taskToggleIndex)
        self:SetTaskItems(taskList)
    end

    if endtime > 0 then
        local t = math.max(0,endtime - os.time());
        local day = fun.format_time_day(t)
        local hour = fun.format_time_hour(t)
        local minute = fun.format_time_minute(t)
        if fun.is_null(self.text_refresh) then return end
        if day >= 1 then
            self.text_refresh.text = string.format("Refreshes in : %sd",day)
        elseif hour >= 1 then
            self.text_refresh.text = string.format("Refreshes in : %sh",hour)
        elseif minute >= 1 then
            self.text_refresh.text = string.format("Refreshes in : %sm",minute)
        else
            self.text_refresh.text = string.format("Refreshes in : %ss",t)
        end
    end
end

function TaskView:SetTaskItems(taskDataList,oldProcess)
    if taskDataList then
        local count = 0
        for key, value in pairs(taskDataList) do
            if not value.rewarded then
                count = count + 1
                local view = self:GetItemViewInstance(count)
                if view then
                    view:SetTaskData(value,_taskToggleIndex,isPopupTask)
                end
            end
        end
        if taskItemEntityCache and count < #taskItemEntityCache then
            for i = count + 1, #taskItemEntityCache do
                fun.set_active(taskItemEntityCache[i].transform,false,false)
            end
        end

        if count <= 0 then
            if not all_task_complete then
                Cache.load_prefabs(AssetList["TaskAllcompletec"],"TaskAllcompletec",function(obj)
                    if obj then
                        all_task_complete = fun.get_instance(obj,self.content)
                    end
                end)
            else
                fun.set_active(all_task_complete.transform,true,false)
            end
        elseif all_task_complete then
            fun.set_active(all_task_complete.transform,false,false)
        end
    else
        log.r("====================================>>任务列表为nil")    
    end
end

function TaskView:GetItemViewInstance(index)
    local view = require "View/Task/TaskItemView"
    local view_instance = nil
    if taskItemEntityCache == nil then
        taskItemEntityCache = {}
    end
    if taskItemEntityCache[index] == nil then
        local item = fun.get_instance(self.task_items,self.content)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        taskItemEntityCache[index] = view_instance
    else
        view_instance = taskItemEntityCache[index]
    end
    fun.set_active(view_instance:GetTransform(),true,false)
    return view_instance
end



--- 此处会有一个丢资源白图问题，重新绑定一次
function TaskView:RebindSprite()
    --if self.go then
    --    local child = fun.find_child(self.go,"SafeArea/Image")
    --    if child then
    --        self:RebindChildSprite("SafeArea/title","rTitle")
    --        self:RebindChildSprite("SafeArea/ToggleGroup/Toggle_Daily/Checkmark","rBQbutton02")
    --        self:RebindChildSprite("SafeArea/ToggleGroup/Toggle_Daily/Checkmark_on","rBQbutton01")
    --        self:RebindChildSprite("SafeArea/ToggleGroup/Toggle_Weekly/Checkmark","rBQbutton02")
    --        self:RebindChildSprite("SafeArea/ToggleGroup/Toggle_Weekly/Checkmark_on","rBQbutton01")
    --        self:RebindChildSprite("SafeArea/background","rBGDi02")
    --        self:RebindChildSprite("SafeArea/stageRewards","rBannerBG")
    --        self:RebindChildSprite("SafeArea/stageRewards/background","rBannerBG")
    --        self:RebindChildSprite("SafeArea/stageRewards/rBannerCoins01","rBannerCoins01")
    --        self:RebindChildSprite("SafeArea/stageRewards/rBannerCoins02","rBannerCoins02")
    --        self:RebindChildSprite("SafeArea/stageRewards/btn_stage1/rBannerDiZuo","rBannerDiZuo")
    --        self:RebindChildSprite("SafeArea/stageRewards/btn_stage1/icon","rBannerBox01")
    --        self:RebindChildSprite("SafeArea/stageRewards/btn_stage2/rBannerDiZuo","rBannerDiZuo")
    --        self:RebindChildSprite("SafeArea/stageRewards/btn_stage2/icon","rBannerBox02")
    --        self:RebindChildSprite("SafeArea/stageRewards/stage_slider/Background","rBlueJinDuDi")
    --        self:RebindChildSprite("SafeArea/stageRewards/stage_slider/Fill Area/Fill","rBlueJinDu")
    --        self:RebindChildSprite("SafeArea/stageRewards/stage_slider/img_cut1","rBannerJinDuXian02")
    --        self:RebindChildSprite("SafeArea/stageRewards/stage_slider/img_cut2","rBannerJinDuXian02")
    --        self:RebindChildSprite("SafeArea/Scroll View","rBGDi03")
    --        self:RebindChildSprite("SafeArea/Scroll View/rBGDi03","rBGDi03")
    --        self:RebindChildSprite("SafeArea/Scroll View/Viewport","rBGDi03")
    --    end
    --end
end

function TaskView:RebindChildSprite(path, spriteName)
    local child = fun.find_child(self.go,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            img.sprite = AtlasManager:GetSpriteByName("TaskAtlas",spriteName)
        end
    end
end

function TaskView.OnClickGoButton(taskSubtype)
    --if taskSubtype == TaskSubType.buy8Card or taskSubtype == TaskSubType.buy12Card then
    --    --Facade.SendNotification(NotifyName.SceneCity.Click_auto_Enter)
    --    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,false,101,ModelList.CityModel.GetPlayIdByCity(101))
    --else
    --    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,true)
    --end
    this:on_btn_close_click()
end

this.NotifyList = {
   {notifyName = NotifyName.TaskView.Click_go_button, func = this.OnClickGoButton}
}

return this

