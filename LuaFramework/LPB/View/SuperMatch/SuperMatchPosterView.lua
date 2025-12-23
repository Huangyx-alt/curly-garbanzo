--- 杯赛顶部进度条
local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskOriginalState = require "State/QuickTaskView/QuickTaskOriginalState"
local QuickTaskAchieveState = require "State/QuickTaskView/QuickTaskAchieveState"
local QuickTaskNoAchieveState = require "State/QuickTaskView/QuickTaskNoAchieveState"
local QuickTaskClaimAwardsState = require "State/QuickTaskView/QuickTaskClaimAwardsState"
local QuickTaskFlyCookyState = require "State/QuickTaskView/QuickTaskFlyCookyState"
local CompetitionExtraRewardState = require "State/QuickTaskView/CompetitionExtraRewardState"
local CompetitionFlyCookieState = require "State/QuickTaskView/CompetitionFlyCookieState"
local CompetitionDoubleEnterState = require "State/QuickTaskView/CompetitionDoubleEnterState"
local CompetitionEnterState = require "State/QuickTaskView/CompetitionEnterState"
local CompetitionSkipState = require "State/QuickTaskView/CompetitionSkipState"
local extra_reward_tip = require "View/Task/TopQuickTaskExtraTipView"
local SuperMatchPosterView = BaseDialogView:New('SuperMatchPosterView', "SuperMatchPoster")

local this = SuperMatchPosterView
--this.viewType = CanvasSortingOrderManager.LayerType.None
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.isCleanRes = true

local slidValue = -1
local quickTask, quickTaskActivity
local isDoubleReward = false
this.isFirst = true
this.CloseMethod = {
    normal = 1,
    enterMain = 2,
    waitReward = 3,
    other = 4,
}

this.auto_bind_ui_items = {
    "btn_play",
    "btn_close",
    "anima",
    "btn_help",
    "btn_foodcollect",
    "slid_food_progress",
    "text_food_percent",
    "text_food_time",
    "img_needitem",
    "img_rewarditem",
    "hangpoint1",
    "extra_rewarditem",
    "extra_rewardname",
    --"text_extra_countdown",
    "content",
    "btn_extrareward",
    "doubleFlag",
    "Doubletubiao",
    "Doubletubiao2",
    "dec_text1",
    "left_timea",
    "left_time_txt",
    "c_goal_left_di",
    "plus",
    "extra_reward",
    "SuperMatchPosterView",
    "CollectDouble",
    "doublePlusCollect",
}

function SuperMatchPosterView:Awake()
    self:on_init()
end

function SuperMatchPosterView:OnEnable()
    self.isShowBuffTime = false
    self:ClearMutualTask()
    isDoubleReward = ModelList.CompetitionModel:GetDoubleRewardBuffTime() > 0
    self:SetDoubleRewardSkin(isDoubleReward)
    self:BuildFsm()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_SUPERMATCH_REWARD_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    self.buffRemainTime = remainTime

    if remainTime > 0 then
        self:SetTaskInfo2()
        self.isShowBuffTime = true
        self.dec_text2.text = Csv.GetDescription(85005)
        fun.set_active(self.dec_text1, false)
    else
        self.dec_text1.text = Csv.GetDescription(85004)
        fun.set_active(self.dec_text2, false)
        self:SetTaskInfo()
        self:RefreshRemainTime()
    end
    local isFirst = (ModelList.ActivityModel:IsActivityFirstOpen(9) or not ModelList.GuideModel:IsGuideComplete(76)) and
        true or false
    if not isFirst and self.isExtraReward then
        self.SuperMatchPosterView:Play("enter1b")
    end
    self:OnTaskUpdate()
    self:RegisterUIEvent()
end

function SuperMatchPosterView:OnShowExtraRewardTip()
    Facade.SendNotification(NotifyName.ShowUI, extra_reward_tip, nil, nil,
        {
            pos = self.btn_extrareward.transform.position,
            icon = self.img_rewarditem,
            time = function () return self.extra_leftTime end
        })
end

function SuperMatchPosterView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("SuperMatchPosterView", self, {
        QuickTaskOriginalState:New(),
        QuickTaskAchieveState:New(),
        QuickTaskNoAchieveState:New(),
        QuickTaskClaimAwardsState:New(),
        QuickTaskFlyCookyState:New(),
        CompetitionExtraRewardState:New(),
        CompetitionFlyCookieState:New(),
        CompetitionDoubleEnterState:New(),
        CompetitionEnterState:New(),
        CompetitionSkipState:New(),
    })
    self._fsm:StartFsm("QuickTaskOriginalState")
end

function SuperMatchPosterView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function SuperMatchPosterView:RefreshRemainTime()
    self:GetRemainTime()
    if self.text_food_countdown then
        self.text_food_countdown.text = fun.format_time(self.leftTime)
    end
    if self.doubleCollectTime > 0 then
        fun.set_active(self.doubleFlag, true)
        fun.set_active(self.CollectDouble, true)
        if self.isExtraReward then
            fun.set_active(self.doublePlusCollect, true)
        end
    end
end

function SuperMatchPosterView:OnHeartBeat(sub)
    if self.isExtraReward then
        if self.extra_leftTime and self.extra_leftTime > 0 then
            if sub then
                self.extra_leftTime = math.max(0, self.extra_leftTime - 1)
            end
            --self.text_extra_countdown.text = fun.format_time(self.extra_leftTime)

            if extra_reward_tip then
                extra_reward_tip:setTime(self.extra_leftTime)
            end
        else
            --self:CheckExtraReward()
            if not self.extra_leftTime then

            end
        end
    end
    if self.leftTime and self.leftTime > 0 then
        if sub then
            self.leftTime = math.max(0, self.leftTime - 1)
        end
        if fun.is_not_null(self.text_food_countdown) then
            self.text_food_countdown.text = fun.format_time(self.leftTime)
        end
    elseif not ModelList.CompetitionModel:IsUnAvailableAndHasReward() then
        if self._timer then
            self._timer:Stop()
            self._timer = nil
        end
        self:GetRemainTime()
    end
end

function SuperMatchPosterView:SetTaskInfo2()
    fun.set_active(self.left_timea, true)
    fun.set_active(self.slid_food_progress.gameObject, false)
    fun.set_active(self.c_goal_left_di, false)
end

function SuperMatchPosterView:SetTaskInfo()
    fun.set_active(self.left_timea, false)
    fun.set_active(self.slid_food_progress.gameObject, true)
    fun.set_active(self.c_goal_left_di, true)
    self.leftTime = nil
    self.extra_leftTime = nil
    if not self or fun.is_null(self.go) then
        return
    end
    quickTask = ModelList.CompetitionModel:GetQuickTaskActive()
    if quickTask then
        local reward_extra_icon = nil
        if quickTask.extraReward and #quickTask.extraReward > 0 then
            reward_extra_icon = self:ConverIdToIcon(quickTask.extraReward[1].id)
        end
        local rewardIcon = { self:ConverIdToIcon(quickTask.reward[1].id), reward_extra_icon }

        if rewardIcon[1] then
            Cache.load_sprite(AssetList[rewardIcon[1]], rewardIcon[1], function (tex)
                if self and fun.is_not_null(self.img_rewarditem) and fun.is_not_null(tex) then
                    self.img_rewarditem.texture = tex.texture
                end
            end)
        end
        if rewardIcon[2] then
            self.isExtraReward = true
            fun.set_active(self.plus, true)
            fun.set_active(self.extra_reward.gameObject, true)

            Cache.load_sprite(AssetList[rewardIcon[2]], rewardIcon[2], function (tex)
                if self and fun.is_not_null(self.extra_rewarditem) and fun.is_not_null(tex) then
                    self.extra_rewarditem.texture = tex.texture
                end
            end)
            fun.set_rect_anchored_position_x(self.content, -120)
            --Anim.move_to_x(self.content, -120, 2,function()
            --
            --end)
        else
            self.isExtraReward = false
            fun.set_active(self.extra_reward, false)
        end

        local num = tonumber(quickTask.progress)
        local targenum = tonumber(quickTask.target)
        num = math.min(num, targenum)
        if slidValue < 0 then
            slidValue = num
            UnityEngine.PlayerPrefs.SetFloat("TopQuickTask", slidValue)
            self:SetProgress(num, targenum)
        else
            self:SetProgress(math.min(slidValue, num), targenum)
        end
        self.text_food_time.text = fun.NumInsertComma(quickTask.reward[1].value or 0) -- tostring(data.reward_description[1][1])
        self.extra_rewardname.text = fun.NumInsertComma(#quickTask.extraReward > 0 and quickTask.extraReward[1].value or
            0)                                                                        --tostring(data.reward_extra_description or 0)
        self:GetRemainTime()                                                          --math.max(0,ModelList.CompetitionModel:GetActivityExpireTime(ActivityTypes.quickTask) - os.time())
    end
end

function SuperMatchPosterView:SetDoubleRewardSkin(isDoubleReward)
    fun.set_active(self.Doubletubiao, isDoubleReward)
    fun.set_active(self.Doubletubiao2, isDoubleReward)
end

function SuperMatchPosterView:ConverIdToIcon(id)
    if id == RESOURCE_TYPE.RESOURCE_TYPE_COINS then
        return "xianshiicon001"
    elseif id == RESOURCE_TYPE.RESOURCE_TYPE_DIAMOND then
        return "xianshiicon008"
    elseif id == RESOURCE_TYPE.RESOURCE_TYPE_HINTTIME then
        return "xianshiicon002"
    elseif id == RESOURCE_TYPE.RESOURCE_TYPE_TICKETS then
        return "xianshiicon003"
    elseif id == RESOURCE_TYPE.RESOURCE_TYPE_AUTO_TICKETS then
        return "xianshiicon004"
    elseif id == RESOURCE_TYPE.RESOURCE_TYPE_ROCKET then
        return "xianshiicon009"
    elseif id == 40 then
        return "xianshiicon014"
        --elseif id == RESOURCE_TYPE.RESOURCE_TYPE_DIAMOND then
        --    return "xianshiicon008"
    else --if id == RESOURCE_TYPE.RESOURCE_TYPE_DIAMOND then
        return "xianshiicon001"
    end
end

function SuperMatchPosterView:OnTaskUpdate(taskType)
    if taskType == nil or taskType == ActivityTypes.quickTask then
        --self:SetTaskInfo()
        --if self.leftTime and self.leftTime > 0 then
        --    if self._timer then
        --        self._timer:Stop()
        --        self._timer = nil
        --    end
        --    self._timer = Timer.New(function()
        --        self:OnHeartBeat(true)
        --    end,1,-1)
        --    self._timer:Start()
        --    self:OnHeartBeat()
        --end
    end
    if self.buffRemainTime and self.buffRemainTime > 0 then
        if self._timer then
            self._timer:Stop()
            self._timer = nil
        end
        self._timer = Timer.New(function ()
            self.buffRemainTime = math.max(0, self.buffRemainTime - 1)
            self.left_time_txt.text = fun.format_time(self.buffRemainTime)
        end, 1, -1)
        self._timer:Start()
    end
end

function SuperMatchPosterView:GetRemainTime()
    quickTask, quickTaskActivity = ModelList.CompetitionModel:GetQuickTaskActive()
    local remainTime = math.max(0, quickTask.expireTime - os.time())
    self.leftTime = remainTime
    if quickTask.extraRewardContinue > 0 then
        local extra_leftTime = math.max(0, quickTask.extraRewardContinue - (os.time() - quickTask.createTime))
        self.extra_leftTime = extra_leftTime
    end
    self.doubleCollectTime = ModelList.CompetitionModel:GetDoubleCollectBuffTime()
end

function SuperMatchPosterView:SetProgress(num, targetNum)
    self.text_food_percent.text = string.format("<size=42>%s</size><color=#ecff93>/%s</color>", math.floor(num),
        targetNum)
    self.slid_food_progress.value = num / targetNum
end

function SuperMatchPosterView:on_btn_close_click()
    self:CloseSelf(self.CloseMethod.normal)
end

function SuperMatchPosterView:CloseSelf(closeMethod)
    --local task = function()
    --AnimatorPlayHelper.Play(self.anima, {"end", "SuperMatchPosterView_end"}, false, function()
    if closeMethod == self.CloseMethod.waitReward then
        local isFirst = (ModelList.ActivityModel:IsActivityFirstOpen(9) or not ModelList.GuideModel:IsGuideComplete(76)) and
            true or false
        if isFirst then
            local rewardIds = ModelList.SuperMatchModel:GetSuperMatchGuideData()
            if rewardIds and #rewardIds > 0 then
                Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show,
                    ClaimRewardViewType.CollectReward, rewardIds, function ()
                        --log.e("SuperMatchPosterView:on_btn_close_click111")
                        ModelList.GuideModel:TriggerSuperMatchGuide(565)
                        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide,
                            ClaimRewardViewType.CollectReward)
                        Event.Brocast(NotifyName.SuperMatch.PopupActivityPosterFinish,true,true)
                    end, nil, nil, true)
            else
               -- log.e("SuperMatchPosterView:on_btn_close_click222")
                ModelList.GuideModel:TriggerSuperMatchGuide(565)
                Event.Brocast(NotifyName.SuperMatch.PopupActivityPosterFinish,true,true)
            end
        end
        elseif closeMethod == self.CloseMethod.other then
        Event.Brocast(NotifyName.SuperMatch.PopupActivityPosterFinish,true,true)
    else
        Event.Brocast(NotifyName.SuperMatch.PopupActivityPosterFinish)
    end
    self:MutualTaskFinish()
    Facade.SendNotification(NotifyName.CloseUI, self)
    --end)
    --end

    --self:DoMutualTask(task)
    self:UnRegisterUIEvent()
end

function SuperMatchPosterView:on_btn_play_click()
    --- 第一次的时候，打开说明界面
    local isFirst = (ModelList.ActivityModel:IsActivityFirstOpen(9) or not ModelList.GuideModel:IsGuideComplete(76)) and
        true or false
    if isFirst and this.isFirst then
        this.isFirst = false
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SuperMatchExplainView)
    elseif not ModelList.GuideModel:IsGuideComplete(76) then
        local rewardIds = ModelList.SuperMatchModel:GetSuperMatchGuideData()
        if rewardIds and #rewardIds > 0 then
            --log.e("SuperMatchPosterView:on_btn_close_click333")
            ModelList.GuideModel:TriggerSuperMatchGuide(565)
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show,
                ClaimRewardViewType.CollectReward, rewardIds, function ()
                    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide,
                        ClaimRewardViewType.CollectReward)
                    if self then
                        --log.e("SuperMatchPosterView:on_btn_close_click555")
                        self:CloseSelf(self.CloseMethod.other)
                    end
                end, nil, nil, true)

            LuaTimer:SetDelayFunction(10, function ()
                Event.Brocast(NotifyName.SuperMatch.PopupActivityPosterFinish)
            end)
        else
            --log.e("SuperMatchPosterView:on_btn_close_click444")
            ModelList.GuideModel:TriggerSuperMatchGuide(565)
            self:CloseSelf(self.CloseMethod.normal)
        end
    else
        self:CloseSelf(self.CloseMethod.enterMain)
    end
end

function SuperMatchPosterView:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SuperMatchExplainView)
end

function SuperMatchPosterView:on_btn_foodcollect_click()
end

function SuperMatchPosterView:on_btn_extrareward_click()
end

function SuperMatchPosterView:CloseExplainView()
    local isFirst = (ModelList.ActivityModel:IsActivityFirstOpen(9) or not ModelList.GuideModel:IsGuideComplete(76)) and
        true or false
    if isFirst then
        --- 设置额外奖励
        Cache.load_sprite(AssetList["xianshiicon014"], "xianshiicon014", function (tex)
            if self and fun.is_not_null(self.extra_rewarditem) and fun.is_not_null(tex) then
                self.extra_rewarditem.texture = tex.texture
            end
        end)
        self.extra_rewardname.text = "1"
        self.SuperMatchPosterView:Play("enter2")
    end
end

function SuperMatchPosterView:RegisterUIEvent()
    Event.AddListener(EventName.Event_Super_Match_Close_Explain_View, self.CloseExplainView, self)
end

function SuperMatchPosterView:UnRegisterUIEvent()
    Event.RemoveListener(EventName.Event_Super_Match_Close_Explain_View, self.CloseExplainView, self)
end

return this
