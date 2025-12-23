require "View/CommonView/WatchADUtility"
require "State/Common/CommonState"

local MainTaskLevelUpView = BaseView:New("MainTaskLevelUpView", "MainTaskLevelUpAtlas")
local this = MainTaskLevelUpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
local getRewardTaskInfo = nil

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_LEVEL_UP)
local CmdLevelAttribute = require("Logic/PeripheralSystem/CmdLevelAttribute")


local view = require("View/CommonView/CollectRewardsItem")
local curLevel = nil


local isRegister = false;
this.auto_bind_ui_items = {
    "btn_tapContinue2",
    "currentLevel",
    "nextLevel",
    "textLevel",
    "itemPrefab",
    "rewrdContent",
    "anima",
    "bottomShow1",
    "bottomShow2",
    "btn_tapContinue1",

}

function MainTaskLevelUpView:Awake()
    self:on_init()
end

function MainTaskLevelUpView:OnEnable(params)
    self:SetInfo()
    CommonState.BuildFsm(self, "MainTaskLevelUpView")

    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        AnimatorPlayHelper.Play(self.anima, { "enter", "MainTaskLevelUpViewenter" }, false, function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm, "CommonOriginalState")
        end)
    end)
    self:InitLevelAttr()
    UISound.play("level_up")
end

function MainTaskLevelUpView:SetInfo()
    local taskInfo = ModelList.TaskModel.GetMainTask()
    if taskInfo then
        local task_need = Csv.GetData("new_task", taskInfo.taskId, "task_need")
        self.textLevel.text = task_need[1] -- string.format("Level%s", task_need[1])
        curLevel = task_need[1]
        if taskInfo.reward then
            local rewardNum = GetTableLength(taskInfo.reward)
            self.levelUpRewardList = self.levelUpRewardList or {}
            local createdNum = GetTableLength(self.levelUpRewardList)
            local waitCreatNum = 0
            if rewardNum < createdNum then
                --奖励数量小于格子数量
                for i = 1 , createdNum do
                    if taskInfo.reward[i] then
                        fun.set_active(self.levelUpRewardList[i].go, true)
                        self.levelUpRewardList[i]:SetReward(taskInfo.reward[i])
                    else
                        fun.set_active(self.levelUpRewardList[i].go, false)
                    end
                end
            elseif rewardNum > createdNum then
                --奖励数量大于格子数量
                waitCreatNum = rewardNum - createdNum
            else
                for i = 1 , createdNum do
                    fun.set_active(self.levelUpRewardList[i].go, true)
                    self.levelUpRewardList[i]:SetReward(taskInfo.reward[i])
                end
            end
            if waitCreatNum > 0 then
                for i = 1 , waitCreatNum do
                    local curIndex = createdNum + i
                    local rewardData = taskInfo.reward[curIndex]
                    local go = fun.get_instance(self.itemPrefab,self.rewrdContent)
                    local rewardItem = view:New()
                    rewardItem:SetReward(taskInfo.reward[curIndex])
                    rewardItem:SkipLoadShow(go,true,nil)
                    self.levelUpRewardList[curIndex] = rewardItem
                end
            end
            log.log("奖励格子 " , string.format("奖励数量:%s 已有格子数量:%s 需要创建数量:%s", rewardNum, createdNum , waitCreatNum))
        end
    end
end

function MainTaskLevelUpView:OnDisable()
    Event.Brocast(EventName.Event_popup_levelup_finish)
    CommonState.DisposeFsm(self)
    getRewardTaskInfo = nil
    self:StopTimer()
    self:RemoveEvent()
end

function MainTaskLevelUpView:OnDestroy()

    if self.cmdCurrentLevelAttribute then
        self.cmdCurrentLevelAttribute:CloseCmd()
        self.cmdCurrentLevelAttribute = nil
    end
    if self.cmdNextLevelAttribute then
        self.cmdNextLevelAttribute:CloseCmd()
        self.cmdNextLevelAttribute = nil
    end
    for k , v in pairs(self.levelUpRewardList) do
        v:CloseView()
    end
    self.levelUpRewardList = {}
end

function MainTaskLevelUpView:StopTimer()
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

function MainTaskLevelUpView:OnSubmitTask()
    AddLockCountOneStep()
    self:AddEvent()
    getRewardTaskInfo = ModelList.TaskModel.GetMainTask()
    local data = { { taskType = TASK_TYPE.TASK_TYPE_MAIN, taskGroup = getRewardTaskInfo.taskGroup, taskId = getRewardTaskInfo.taskId, createTime = getRewardTaskInfo.createTime } }
    ModelList.TaskModel.C2S_SubmitTask(data)
end

function MainTaskLevelUpView:AddEvent()
    if isRegister == true then
        return;
    end

    isRegister = true
    Event.AddListener(EventName.Event_GetTaskRewardSucceed, self.ClaimRewardResult, self)
    Event.AddListener(EventName.Event_GetTaskRewardFail, self.ClaimRewardFailResult, self)
end

function MainTaskLevelUpView:RemoveEvent()
    isRegister = false
    Event.RemoveListener(EventName.Event_GetTaskRewardSucceed, self.ClaimRewardResult, self)
    Event.RemoveListener(EventName.Event_GetTaskRewardFail, self.ClaimRewardFailResult, self)
end

function MainTaskLevelUpView:ClaimRewardResult()
    self:StopTimer()
    self:RemoveEvent()
    self._fsm:GetCurState():DoCommonState1Action(self._fsm, "CommonState2State", function()
        local delay = 0
        for k ,v in pairs(self.levelUpRewardList) do
            local coroutine_fun = function()
                local temDelay = delay
                delay = delay + 0.2
                --local flyitem = value.id
                local flyitem = v:GetRewardItemId()
                local flyEffectPos = v.go.transform.position
                coroutine.wait(temDelay)
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, flyEffectPos, flyitem, function()
                    Event.Brocast(EventName.Event_currency_change)
                end)
            end
            coroutine.resume(coroutine.create(coroutine_fun))
        end
        delay = delay + 0.2
        coroutine.wait(delay)
        local taskInfo = ModelList.TaskModel.GetMainTask()
        if taskInfo and taskInfo.completed and taskInfo.rewarded == false then
            self:SetInfo()
            self:InitLevelAttr()
            AnimatorPlayHelper.Play(self.anima, { "enter", "MainTaskLevelUpViewenter" }, false, function()
                self._fsm:GetCurState():DoCommonState2Action(self._fsm, "CommonOriginalState")
            end)
        else
            AnimatorPlayHelper.Play(self.anima, { "end", "MainTaskLevelUpViewend" }, false, function()
                Facade.SendNotification(NotifyName.CloseUI, this)
            end)
        end
    end)
end

function MainTaskLevelUpView:ClaimRewardFailResult()
    AnimatorPlayHelper.Play(self.anima, { "end", "MainTaskLevelUpViewend" }, false, function()
        Facade.SendNotification(NotifyName.CloseUI, this)
    end)
end



function MainTaskLevelUpView:on_btn_tapContinue1_click()
    self:on_btn_tapContinue2_click()
end

function MainTaskLevelUpView:on_btn_tapContinue2_click()
    if self._fsm then
        log.log("升级状态机变化  " , self._fsm:GetCurState().name)
        self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
            self:OnSubmitTask()
        end)
    else
        if this then
            Facade.SendNotification(NotifyName.CloseUI, this)
        end
    end
end


function MainTaskLevelUpView:InitLevelAttr()
    local isNewAttrLevel = self:CheckIsNewAttrLevel(curLevel)
    if not isNewAttrLevel then
        fun.set_active(self.bottomShow2, false)
        fun.set_active(self.bottomShow1, true)
        return
    end
    
    --新的加成
    fun.set_active(self.bottomShow2, true)
    fun.set_active(self.bottomShow1, false)
    
    if not self.cmdCurrentLevelAttribute then
        self.cmdCurrentLevelAttribute = CmdLevelAttribute.New()
    end
    if not self.cmdNextLevelAttribute then
        self.cmdNextLevelAttribute = CmdLevelAttribute.New()
    end
    self.cmdCurrentLevelAttribute:OnCmdExecute(self.currentLevel , curLevel - 1)

    self.cmdNextLevelAttribute:OnCmdExecute(self.nextLevel , curLevel)
end

function MainTaskLevelUpView:CheckIsNewAttrLevel(level)
    local config = Csv.new_level
    local beforeShopAdd = config[level - 1].shop_added
    local levelShopAdd = config[level].shop_added
    if levelShopAdd > beforeShopAdd then
        return true
    end
    return false
end


return this
