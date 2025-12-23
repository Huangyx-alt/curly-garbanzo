
local TaskStageRewardView = BaseView:New("TaskStageRewardView")
local this = TaskStageRewardView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "stage_slider",
    "btn_stage1",
    "btn_stage2",
    "text_stage_tip",
    "stage1effect",
    "stage2effect",
    "stage1_anima",
    "stage2_anima",
    "btn_collect1",
    "btn_collect2"
}

function TaskStageRewardView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TaskStageRewardView:Awake()
    self:on_init()
end

function TaskStageRewardView:OnEnable()
    self._init = true
    self:SetStageReward(self._taskStage)
end

function TaskStageRewardView:OnDisable()
    self._init = nil
    self._taskStage = nil
    self:RemoveEvent()
end

function TaskStageRewardView:SetStageReward(taskType)
    self._taskStage = taskType
    if self._init and taskType then
        local rewarddata = ModelList.TaskModel.GetRewardInfo(taskType) 
        if rewarddata.count then
            self._process = rewarddata.completed / math.max(rewarddata.count,1)
            self.stage_slider.fillAmount = self._process
        end
        local stateData = ModelList.TaskModel.GetStageRewardByType(taskType)
        if stateData then
            for key, value in pairs(stateData) do
                if value.stage == 50 then
                    --fun.set_active(self.btn_stage1.transform, not value.rewarded,false)
                    Util.SetUIImageGray(self.btn_stage1, value.rewarded)
                    if not value.rewarded then
                        fun.set_active(self.stage1effect.transform,self._process >= 0.499,false)
                        if self._process >= 0.499 then
                            AnimatorPlayHelper.Play(self.stage1_anima,{"efbtnstage1full","efTaskbtnstage1full"},false,nil)
                            fun.set_active(self.btn_collect1.transform,true)
                        else
                            AnimatorPlayHelper.Play(self.stage1_anima,{"idle","efTaskbtnstage1idle"},false,nil)
                            fun.set_active(self.btn_collect1.transform,false)
                        end
                    else
                        AnimatorPlayHelper.Play(self.stage1_anima,{"idle","efTaskbtnstage1idle"},false,nil)
                        fun.set_active(self.btn_collect1.transform,false)
                    end
                elseif value.stage == 100 then
                    --fun.set_active(self.btn_stage2.transform, not value.rewarded,false)
                    Util.SetUIImageGray(self.btn_stage2, value.rewarded)
                    if not value.rewarded then
                        fun.set_active(self.stage2effect.transform,self._process >= 0.99,false)
                        if self._process >= 0.99 then
                            AnimatorPlayHelper.Play(self.stage2_anima,{"efbtnstage1full","efTaskbtnstage1full"},false,nil)
                            fun.set_active(self.btn_collect2.transform,true)
                        else
                            AnimatorPlayHelper.Play(self.stage2_anima,{"idle","efTaskbtnstage1idle"},false,nil)
                            fun.set_active(self.btn_collect2.transform,false)
                        end
                    else
                        AnimatorPlayHelper.Play(self.stage2_anima,{"idle","efTaskbtnstage1idle"},false,nil)
                        fun.set_active(self.btn_collect2.transform,false)
                    end
                end
            end
        else
            --fun.set_active(self.btn_stage1.transform, false,false)
            --fun.set_active(self.btn_stage2.transform, false,false)
            Util.SetUIImageGray(self.btn_stage1, true)
            Util.SetUIImageGray(self.btn_stage2, true)
        end
    end
end

function TaskStageRewardView:on_btn_stage1_click()
    if self._process and self._process >= 0.499 then
        local stateData = ModelList.TaskModel.GetStageRewardByType(self._taskStage,50)
        if stateData and not stateData.rewarded then
            self:AddEvent()
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,stateData.reward,function()
                ModelList.TaskModel.C2S_ClaimStageReward(self._taskStage,50)
            end)  
        end
    else
        local stateData = ModelList.TaskModel.GetStageRewardByType(self._taskStage,50)
        if stateData and not stateData.rewarded then
            local params = {
                rewards = stateData.reward, 
                pos = self.btn_stage1.transform.position, 
                dir = RewardShowTipOrientation.down, 
                offset = Vector3.New(0,180,0),
                bg_width = 280,
                exclude = {self.btn_stage1}
            }
            Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
        end      
    end
end

function TaskStageRewardView:on_btn_collect1_click()
    self:on_btn_stage1_click()
end

function TaskStageRewardView:on_btn_stage2_click()
    if self._process >= 0.99 then
        local stateData = ModelList.TaskModel.GetStageRewardByType(self._taskStage,100)
        if stateData and not stateData.rewarded then
            self:AddEvent()
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,stateData.reward,function()
                ModelList.TaskModel.C2S_ClaimStageReward(self._taskStage,100)
            end)
        end
    else
        local stateData = ModelList.TaskModel.GetStageRewardByType(self._taskStage,100)
        if stateData and not stateData.rewarded then
            local params = {
                rewards = stateData.reward, 
                pos = self.btn_stage2.transform.position, 
                dir = RewardShowTipOrientation.down, 
                offset = Vector3.New(0,180,0),
                bg_width = 280,
                exclude = {self.btn_stage2}
            }
            Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
        end   
    end
end

function TaskStageRewardView:on_btn_collect2_click()
    self:on_btn_stage2_click()
end

function TaskStageRewardView:ClaimRewardResult()
    self:RemoveEvent()
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
end

function TaskStageRewardView:AddEvent()
    Event.AddListener(EventName.Event_GetTaskRewardSucceed,self.ClaimRewardResult,self)
end

function TaskStageRewardView:RemoveEvent()
    Event.RemoveListener(EventName.Event_GetTaskRewardSucceed,self.ClaimRewardResult,self)
end

return this