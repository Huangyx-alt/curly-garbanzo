
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconTaskView = FunctionIconBaseView:New()
local this = FunctionIconTaskView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_task",
    "slider",
    "slider_text",
    "img_reddot",
    "anima",
    "TaskTipView"
}

function FunctionIconTaskView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconTaskView:Awake()
    self:on_init()
end

function FunctionIconTaskView:OnEnable()
    self:RegisterRedDotNode()
    self:RegisterEvent()
    
    self:UpdateTaskInfo()
    
    --移动到列表外，否则会被裁剪
    LuaTimer:SetDelayFunction(0.5, function()
        fun.set_parent(self.TaskTipView, self.go.transform.parent.parent.parent.parent)
    end)
    
    if self.TaskTipView and fun.get_active_self(self.TaskTipView) then
        fun.set_active(self.TaskTipView,false)
    end
end

function FunctionIconTaskView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
end

function FunctionIconTaskView:on_close()
    
end

function FunctionIconTaskView:OnDestroy()
    self:Close()
end

function FunctionIconTaskView:UpdateTaskInfo()
    local params1,params2 = ModelList.TaskModel.IsAnyReward()
    if params2 then
        --AnimatorPlayHelper.Play(self.anima,{"tips","FunctionIconCuisines_tips"},false,nil)
    else
        --AnimatorPlayHelper.Play(self.anima,{"FunctionIconCuisines_idel","FunctionIconCuisines_idel"},false,nil)
    end
    --self:LoadTipView()
end

function FunctionIconTaskView:RegisterEvent()
    Event.AddListener(EventName.Event_TaskUpdate,self.UpdateTaskInfo,self)
    Event.AddListener(EventName.Event_TaskTipUpdate,self.LoadTipView,self)
end

function FunctionIconTaskView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_TaskUpdate,self.UpdateTaskInfo,self)
    Event.RemoveListener(EventName.Event_TaskTipUpdate,self.LoadTipView,self)
end

function FunctionIconTaskView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.task_reddot_event,"function_task",self.img_reddot)
end

function FunctionIconTaskView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.task_reddot_event,"function_task")
end

function FunctionIconTaskView:on_btn_task_click()
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "TaskView", false)
end

function FunctionIconTaskView:LoadTipView()
    local tipState = fun.read_value(DATA_KEY.task_today_show_state)
    local unComplete = ModelList.TaskModel.HasDailyTaskOrWeekTask()
    if ( tipState == 2  or  (ModelList.TaskModel.NeedShowDailyTipShow()) )  and unComplete then
         local TaskTipView =  require "View.Task.TaskTipView"
        self.taskTip = TaskTipView:New()
        self.taskTip:Open(self.TaskTipView,self)
        ModelList.TaskModel.ResetShowDailyTipShow(false)
    else
        Event.Brocast(EventName.Event_popup_task_tip_finish)
    end
end


return this