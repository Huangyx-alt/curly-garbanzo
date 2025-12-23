
local TaskItemView = BaseView:New("TaskItemView")
local this = TaskItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

local _taskToggle = nil
local _hideGoBtn = nil

this.auto_bind_ui_items = {
    "btn_claim",
    "slider_progress",
    "img_reward",
    "text_des",
    "text_name",
    "text_progress",
    "text_num",
    "text_reward",
    "btn_go",
    "text_flash",
    "icon_flash"
}

function TaskItemView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TaskItemView:Awake()
    self:on_init()
end

function TaskItemView:OnEnable()
    self._isinit = true
    --self.text_reward:SetKMB(true)
    self:SetTaskData(self._taskData,_taskToggle,_hideGoBtn)
end

function TaskItemView:OnDisable()
    _taskToggle = nil
    _hideGoBtn = nil
    self._isinit = nil
    self:ClaimRewardResult()
end

function TaskItemView:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function TaskItemView:on_btn_claim_click()
    if self._taskData then
        self._waitReward = true
        self:AddEvent()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,self._taskData.reward,function()
            local data = {{taskType = self._taskData.taskType, taskGroup =self._taskData.taskGroup,taskId =self._taskData.taskId,createTime =self._taskData.createTime}}
            ModelList.TaskModel.C2S_SubmitTask(data)
        end)
    end
end

function TaskItemView:on_btn_go_click()
    if self._taskData then
        Facade.SendNotification(NotifyName.TaskView.Click_go_button,self._taskData.taskSubType)
    end
end

function TaskItemView:ClaimRewardResult()
    if self._waitReward then--加个waitReward开关，要不领取最后一个任务时会先走OnDisable移除掉事件就无法接收到通知了
        self._waitReward = nil
        self:RemoveEvent()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
    end
end

function TaskItemView:AddEvent()
    Event.AddListener(EventName.Event_GetTaskRewardSucceed,self.ClaimRewardResult,self)
end

function TaskItemView:RemoveEvent()
    Event.RemoveListener(EventName.Event_GetTaskRewardSucceed,self.ClaimRewardResult,self)
end

function TaskItemView:SetTaskData(data,taskType,hideGoBtn)
    if data then
        self._taskData = data

        _hideGoBtn = hideGoBtn
        _taskToggle = taskType
        if self._isinit then
            local city_name = nil
            self.text_num.text = "" --tostring(data.taskId)
            assert(data.city ~= nil,"data.city异常")
            local task = Csv.GetData("task",data.taskId)
            assert(task ~= nil,"task is nil task id = " .. data.taskId)
            --local res_icon = Csv.GetData("resources",data.reward[1].id,"icon")
            local res_icon = Csv.GetItemOrResource(data.reward[1].id,"icon")
            Cache.SetImageSprite("ItemAtlas",res_icon,self.img_reward)
            self.text_reward.text =  fun.FormatText(data.reward[1])
            --if data.reward[1].id == 3 then
            --    self.text_reward:SetValue(    fun.FormatText(data.reward[1]))
            --else
            --    self.text_reward:SetValue(data.reward[1].value)
            --end
            if data.city > 0 then
                local city = Csv.GetData("city",data.city,"name_description")
                assert(city ~= nil,"city is nil")
                city_name = Csv.GetData("description",city,"description")
                assert(city_name ~= nil,"city_name is nil")
            end
            local des = Csv.GetData("description",task.description)
            assert(des ~= nil,"des is nil")
            self.text_des.text = string.format(des.description,data.target,city_name)
            fun.set_active(self.btn_claim.transform,data.completed,false)
            self.slider_progress.fillAmount = tonumber(data.process) / tonumber(data.target)
            self.text_progress.text = string.format("%s/%s",data.process,data.target)

            fun.set_active(self.icon_flash,(data.reward[2] and {true} or {false})[1])
        --    self.text_flash.text = (data.reward[2] and {tostring( math.ceil( ModelList.BingopassModel:get_booster()/100 *  data.reward[2].value ))} or {""})[1]
            self.text_flash.text = (data.reward[2] and {tostring( math.ceil(  data.reward[2].value ))} or {""})[1]
 
            fun.set_active(self.btn_go,(_hideGoBtn ~= nil and {_hideGoBtn} or {self.slider_progress.fillAmount < 1})[1],false)

            fun.set_active(self.btn_claim,self.slider_progress.fillAmount >= 1,false)
        end
        
    end
end

return this