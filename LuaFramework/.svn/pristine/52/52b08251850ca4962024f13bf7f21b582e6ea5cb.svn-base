local CarQuestTest = require "View/CarQuest/CarQuestTest"

local Const = require "View/CarQuest/CarQuestConst"
local CarQuestRoadMgr = require "View/CarQuest/CarQuestRoadMgr"
local CarQuestRoadUnit = require "View/CarQuest/CarQuestRoadUnit"
local CarQuestCarMgr = require "View/CarQuest/CarQuestCarMgr"
local CarQuestSectionMgr = require "View/CarQuest/CarQuestSectionMgr"
local CarQuestProgressMgr = require "View/CarQuest/CarQuestProgressMgr"
local CarQuestPropMgr = require "View/CarQuest/CarQuestPropMgr"

local CarQuestMainView = BaseDialogView:New('CarQuestMainView', "CarQuestMainAtlas")
local this = CarQuestMainView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
this.update_x_enabled = true --开启独立刷新

local RankImgList = {
    "CarHead1st", "CarHead2nd", "CarHead3rd", "CarHead4th", "CarHead5th"
}

local BubbleShowPosList = {
    { 0,    218 },
    { -213, 189 },
    { 213,  189 },
}

local lastBgmName

this.auto_bind_ui_items = {
    "background",
    "roadRoot",
    "carRoot",
    "uiRoot",
    "prefabRoot",
    "btn_close",
    "roadUnit",
    "testRoot",
    "car1",
    "car2",
    "startPos",
    "roadUIRoot",
    "startPos1",
    "imgProgressBg",
    "btn_reward_bubble",
    "btn_help",
    "btn_gift",
    "bottomPanel",
    "topPanel",
    "leftPanel",
    "rightPanel",
    "rewardBubble",
    "bubbleItem",
    "bubblePanel",
    "btn_box1",
    "btn_box2",
    "btn_box3",
    "CarReadyFlag",
    "CarReadyloading",
    "animaLoading",
    "animaReady",
    "stageRewardPanel",
    "bigBg",
    "smallBg",
    "textFuelNum",
    "stageRewardItem",
    "firstRewardItem",
    "animaStageRewardPanel",
    "btn_unfold",
    "btn_reward_mask",
    "firstRewardItem2",
    "stageRewardItem2",
    "extraRewardItem",
    "btn_close_reward_panel",
    "txtGroup1",
    "txtGroup2",
    "btn_go",
    "roadPropRoot",
    "baojinbi",
    "baoxiaohuojian",
    "baozuanshi",
    "propEffectRoot",
    "baozoom",
    "baocard",
}

function CarQuestMainView:Awake()
    self.hasInit = false
end

function CarQuestMainView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function CarQuestMainView:SetEnterMode(enterMode)
    self.enterMode = enterMode
    --undo wait delete for test
    -- self.enterMode = Const.EnterMode.afterBattle
    -- self.enterMode = Const.EnterMode.manualClick
    -- self.enterMode = Const.EnterMode.afterAlternative
    -- self.enterMode = Const.EnterMode.beforeRewardResend
end

function CarQuestMainView:SetFinishCb(cb)
    self.finishCb = cb
end

function CarQuestMainView:on_after_bind_ref()
    --[[
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"start", "SeasonCardHelpViewstart"}, false, function()
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    --]]
    lastBgmName = UISound.get_playing_bgm() or "city"
    UISound.play_bgm("racingbgm")

    fun.set_active(self.CarReadyloading, false)
    fun.set_active(self.CarReadyFlag, false)
    fun.set_active(self.topPanel, false)
    fun.set_active(self.prefabRoot, false)
    self:InitData()
    self:InitView()
end

function CarQuestMainView:GetRankData()
    return self.showRankList
end

function CarQuestMainView:InitData()
    self.data = DeepCopy(ModelList.CarQuestModel:GetRacingData())
    self.groupId = self.data.groupId
    self.showRankList = self.data.showRankList
    self.stepRewards = self.data.stepRewards
    self.extraRewards = self.data.extraRewards
    self.isOver = self.data.isOver
    self.cfg = ModelList.CarQuestModel:GetRacingConfig(self.groupId)
    log.log("CarQuestMainView:InitData groupId is ", self.groupId, self.data, self.cfg)
    self.finishRaceNeedScore = 0
    self.raceConfig = nil
    self.selfHasExtraBuff = self:SelfHasExtraBuff()
    local cfg = self:GetRaceConfig()
    if cfg and #cfg > 0 then
        self.finishRaceNeedScore = cfg[#cfg][3]
    end
    self:SortRankData()
end

function CarQuestMainView:SortRankData()
    log.log("CarQuestMainView:SortRankData before sort", self.showRankList)
    table.sort(self.showRankList, function (a, b)
        if a.robot > b.robot then
            return true
        elseif a.robot == b.robot then
            return a.uid < b.uid
        else
            return false
        end
    end)

    table.insert(self.showRankList, 3, self.showRankList[5])
    self.showRankList[6] = nil
    log.log("CarQuestMainView:SortRankData after sort", self.showRankList)
end

function CarQuestMainView:InitView()
    self.hasInit = true
    self.clickable = false
    self.stageRewardPanelIsUnfold = false
    fun.set_active(self.testRoot, false)
    fun.set_active(self.btn_go, false)
    fun.set_active(self.btn_reward_mask, false)
    fun.set_active(self.btn_close_reward_panel, false)
    AnimatorPlayHelper.Play(self.animaStageRewardPanel, { "no", "stageRewardPanelno" }, false, function () end)

    CarQuestRoadMgr:Init(self, self:GetRankData())
    CarQuestCarMgr:Init(self, self:GetRankData())
    CarQuestSectionMgr:Init(self, self.roadUIRoot, self:GetRankData())
    CarQuestPropMgr:Init(self, self.roadPropRoot, self:GetRankData(), self.extraRewards)
    CarQuestProgressMgr:Init(self, self.imgProgressBg, self:GetRankData())

    CarQuestRoadMgr:CreateRoad(self.roadUnit, self.roadRoot)
    CarQuestCarMgr:CreateAllCars(self.car1, self.car2, self.carRoot)

    CarQuestPropMgr:SetTraveledDistance(self:GetSectionTraveledDistance())
    CarQuestPropMgr:SetTargetMoveDistance(self:GetSectionTargetMoveDistance())

    self.txtGroup1.text = "S" .. self.groupId
    self.txtGroup2.text = "S" .. self.groupId
    self:HideBubble()
    self:InitPlayerFeatures()
    self:HideFeatureRanks()
    self:InitBuffs()
    self:SetActivityLeftTime()
    self:InitGiftPackIcon()
    self:InitTopPlayerFeatures()

    log.log("CarQuestMainView:InitView", self.enterMode)
    local stageIdx = CarQuestSectionMgr:GetStartStageIdx()
    if self.enterMode == Const.EnterMode.afterAlternative then
        CarQuestProgressMgr:ShowEndProgress()
        CarQuestCarMgr:SetAllCarsInStartPoint()
        CarQuestRoadMgr:ShowStartLine()

        CarQuestPropMgr:ShowInFinalPos()
        CarQuestPropMgr:CreatePropsAtEndPoint()
        stageIdx = CarQuestSectionMgr:GetEndStageIdx()
    elseif self.enterMode == Const.EnterMode.afterBattle then
        CarQuestRoadMgr:StartMove()
        local carMovingTime = CarQuestCarMgr:GetCarMovingTime()
        CarQuestProgressMgr:ShowStartProgress()
        CarQuestProgressMgr:SetCarMovingTime(carMovingTime)
        CarQuestSectionMgr:SetCarMovingTime(carMovingTime)

        CarQuestCarMgr:CalculateSpeed()
        CarQuestCarMgr:ShowStartFuel()
        CarQuestSectionMgr:CalculateSpeed()

        CarQuestPropMgr:ShowInStartPos()
        CarQuestPropMgr:CreatePropsAtStartPoint()
        CarQuestPropMgr:SetCarMovingTime(carMovingTime)
        CarQuestPropMgr:CalculateSpeed()
    elseif self.enterMode == Const.EnterMode.beforeRewardResend then
        CarQuestRoadMgr:StartMove()
        local carMovingTime = CarQuestCarMgr:GetCarMovingTime()
        CarQuestProgressMgr:ShowStartProgress()
        CarQuestProgressMgr:SetCarMovingTime(carMovingTime)
        CarQuestSectionMgr:SetCarMovingTime(carMovingTime)
        CarQuestCarMgr:CalculateSpeed()
        CarQuestSectionMgr:CalculateSpeed()

        CarQuestPropMgr:ShowInStartPos()
        CarQuestPropMgr:CreatePropsAtStartPoint()
        CarQuestPropMgr:SetCarMovingTime(carMovingTime)
        CarQuestPropMgr:CalculateSpeed()
    elseif self.enterMode == Const.EnterMode.manualClick then
        CarQuestRoadMgr:StartMove()
        CarQuestProgressMgr:ShowEndProgress()
        CarQuestSectionMgr:ShowInFinalPos()
        CarQuestCarMgr:AllCarPlayIdle()
        CarQuestCarMgr:ShowAllCarInEndPos()

        CarQuestPropMgr:ShowInFinalPos()
        CarQuestPropMgr:CreatePropsAtEndPoint()
        stageIdx = CarQuestSectionMgr:GetEndStageIdx()
    end
    self:InitTargetFuelNum(stageIdx)
    self:InitStageRewardItem(stageIdx)
    self:InitFirstRewardItem(stageIdx)
    self:InitExtraRewardItem(stageIdx)

    if self.selfHasExtraBuff then
        CarQuestRoadMgr:ShowUpgradeFlag()
    else
        CarQuestRoadMgr:HideUpgradeFlag()
    end
    if self.isNeedReady then
        self:PlayStartLoading()
    else
        self:AfterLoadingAnima()
    end
end

function CarQuestMainView:PlayStartLoading()
    log.log("CarQuestMainView:PlayStartLoading")
    fun.set_active(self.CarReadyloading, true)
    AnimatorPlayHelper.Play(self.animaLoading, { "start", "CarReadyloading_start" }, false, function ()
        self:PlayLoadingIdle()
    end)
end

function CarQuestMainView:PlayLoadingIdle()
    log.log("CarQuestMainView:PlayLoadingIdle")
    AnimatorPlayHelper.Play(self.animaLoading, { "idle", "CarReadyloading_idle" }, false, function ()
        self:PlayEndLoading()
    end)
end

function CarQuestMainView:PlayEndLoading()
    log.log("CarQuestMainView:PlayEndLoading")
    AnimatorPlayHelper.Play(self.animaLoading, { "end", "CarReadyloading_end" }, false, function ()
        self:AfterLoadingAnima()
    end)
end

function CarQuestMainView:AfterLoadingAnima()
    log.log("CarQuestMainView:AfterLoadingAnima", self.enterMode)
    fun.set_active(self.CarReadyloading, false)
    if self.enterMode == Const.EnterMode.afterAlternative then
        fun.set_active(self.CarReadyFlag, true)
        UISound.play("racingbegin")
        AnimatorPlayHelper.Play(self.animaReady, { "start", "CarReadyFlag_start" }, false, function ()
            self:AfterReadyAnima()
        end)
    elseif self.enterMode == Const.EnterMode.afterBattle then
        self:StartFuelUp()
        self:UnfoldStageRewardPanel()
    elseif self.enterMode == Const.EnterMode.beforeRewardResend then
        self:UnfoldStageRewardPanel()
        self:OnFuelUpFinish()
    else
        self:ShowTopPanel()
        self:ShowFeatureRanks()
    end
end

function CarQuestMainView:AfterReadyAnima()
    log.log("CarQuestMainView:AfterReadyAnima")
    fun.set_active(self.CarReadyFlag, false)
    CarQuestRoadMgr:StartMove()
    CarQuestCarMgr:StartingAllCars()
    CarQuestCarMgr:HideFuleBubble()
end

function CarQuestMainView:StartFuelUp()
    CarQuestCarMgr:StartFuelUp()
end

function CarQuestMainView:ShowTopPanel()
    log.log("CarQuestMainView:ShowTopPanel")
    fun.set_rect_anchored_position(self.topPanel, 0, 600)
    fun.set_active(self.topPanel, true)
    Anim.do_smooth_float_update(600, 0, 1,
        function (num)
            fun.set_rect_anchored_position(self.topPanel, 0, num)
        end,

        function ()
            self:ShowTopPanelFinish()
        end
    )

    if self.stageRewardPanelIsUnfold then
        self:FoldStageRewardPanel()
    end

    fun.set_active(self.btn_go, true)
end

function CarQuestMainView:ShowTopPanelFinish()
    fun.set_rect_anchored_position(self.topPanel, 0, 0)
    if self.enterMode == Const.EnterMode.afterBattle or self.enterMode == Const.EnterMode.beforeRewardResend then
        if self.data.roundReward and #self.data.roundReward > 0 then
            self:register_invoke(function ()
                self.clickable = true
            end, 1)

            local poptype = 1
            Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestOpenBoxView, nil, nil, poptype)
        else
            self.clickable = true
            if self.isOver == 1 then
                self:CloseSelf()
            end
        end
    else
        self.clickable = true
    end
end

function CarQuestMainView:GetRaceConfig()
    if not self.raceConfig then
        self.raceConfig = {}
        local cfg = self.cfg or {}
        for i, v in ipairs(cfg) do
            local item = {}
            item[1] = v.racing_step
            item[2] = v.racing_step_long
            item[3] = v.finish_need
            item[4] = v.reward
            item[5] = v.reward_first
            item[6] = v.extra_number
            item[7] = v.reward_extra
            item[8] = v.reward_extra_step
            table.insert(self.raceConfig, item)
        end
        log.log("CarQuestMainView:GetRaceConfig", self.cfg, self.raceConfig)
    end

    return self.raceConfig
end

function CarQuestMainView:GetFinishRaceNeedScore()
    return self.finishRaceNeedScore
end

function CarQuestMainView:GetScreenHeight()
    if not self.screenHeight then
        local ref = fun.get_component(self.roadUIRoot, fun.REFER)
        local topPoint = ref:Get("topPoint")
        local pos = fun.get_gameobject_pos(topPoint, true)
        local screenHeight = pos.y * 2
        self.screenHeight = screenHeight
    end

    return self.screenHeight
end

function CarQuestMainView:GetPlayerCarMovingPos()
    --return self:GetScreenHeight() / 2
    return Const.PlayerCarPosInScreen
end

function CarQuestMainView:GetPlayerCarStartPos()
    return 0
end

function CarQuestMainView:GetPlayerCarEndPos()
    return self:GetScreenHeight()
end

function CarQuestMainView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.curShowBoxIdx = nil
    self.hasInit = false
    self:CleanBuffLeftTime()
    self:CleanActivityLeftTime()
    self:CleanGiftPackLeftTime()

    if self.finishCb then
        self.finishCb()
        self.finishCb = nil
    else
        self:AfterViewClose()
    end
    this.anniversaryBuffObj = nil
    self.isNeedReady = nil
end

function CarQuestMainView:on_x_update()
    if not self.hasInit then
        return
    end

    local deltaTime = Time.deltaTime
    if deltaTime > 0.3 then
        deltaTime = 0.3
    end
    CarQuestRoadMgr:Update(deltaTime)
    CarQuestSectionMgr:Update(deltaTime)
    CarQuestPropMgr:Update(deltaTime)
    CarQuestCarMgr:Update(deltaTime)
    --略晚的刷新
    CarQuestPropMgr:UpdateLater(deltaTime)
end

function CarQuestMainView:CloseSelf()
    --[[
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardHelpViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end

    self:DoMutualTask(task)
    --]]
    log.y("CarQuestMainView:CloseSelf")
    UISound.stop_bgm()
    UISound.play_bgm(lastBgmName)
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function CarQuestMainView:on_btn_close_click()
    if not self.clickable then
        return
    end
    self:CloseSelf()
end

function CarQuestMainView:on_btn_go_click()
    if not self.clickable then
        return
    end
    self:CloseSelf()
end

function CarQuestMainView:on_btn_help_click()
    if not self.clickable then
        return
    end
    Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestHelpView)
end

function CarQuestMainView:on_btn_gift_click()
    if not self.clickable then
        return
    end
    ModelList.GiftPackModel:ShowQuestPack()
end

function CarQuestMainView:on_btn_box1_click()
    if not self.clickable then
        return
    end
    self:HandleBtnBoxClick(1)
end

function CarQuestMainView:on_btn_box2_click()
    if not self.clickable then
        return
    end
    self:HandleBtnBoxClick(2)
end

function CarQuestMainView:on_btn_box3_click()
    if not self.clickable then
        return
    end
    self:HandleBtnBoxClick(3)
end

function CarQuestMainView:on_btn_unfold_click()
    if not self.clickable then
        return
    end
    self:UnfoldStageRewardPanel()
end

function CarQuestMainView:on_btn_close_reward_panel_click()
    if not self.clickable then
        return
    end
    self:FoldStageRewardPanel()
end

function CarQuestMainView:on_btn_reward_mask_click()
    if not self.clickable then
        return
    end
    self:FoldStageRewardPanel()
end

function CarQuestMainView:HandleBtnBoxClick(index)
    if index == self.curShowBoxIdx then
        self:HideBubble()
    else
        local params = {}
        params.posX = BubbleShowPosList[index][1]
        params.posY = BubbleShowPosList[index][2]
        local rewardStr = Csv.GetData("competition_racing", self.groupId, "reward")
        local rewards = Const.ParseRankReward(rewardStr)
        params.rewards = rewards[index]
        log.log("CarQuestMainView:HandleBtnBoxClick show params", params)
        self:ShowBubble(params)
        self.curShowBoxIdx = index
    end
end

function CarQuestMainView:on_btn_reward_bubble_click()
    self:HideBubble()
end

function CarQuestMainView:InitPlayerFeatures()
    local ref = fun.get_component(self.bottomPanel, fun.REFER)
    local data = self:GetRankData()
    for i = 1, Const.CarCount do
        local featureGo = ref:Get("feature" .. i)
        self:SetOneFeature(featureGo, data[i])
    end
end

function CarQuestMainView:SetOneFeature(gameObject, data)
    local ref = fun.get_component(gameObject, fun.REFER)
    local imgHead = ref:Get("imgHead")
    local txtName1 = ref:Get("txtName1")
    local txtName2 = ref:Get("txtName2")
    local imgRank = ref:Get("imgRank")
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)

    fun.set_active(imgRank, false)
    if fun.is_not_null(imgHead) then
        if data.robot == 0 and isSelf then
            fun.set_active(txtName1, false)
            fun.set_active(txtName2, true)
            txtName2.text = "You" --data.nickname
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
        else
            fun.set_active(txtName2, false)
            fun.set_active(txtName1, true)
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
            local nickname = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "name"))
            txtName1.text = nickname
        end
    end
end

function CarQuestMainView:InitTopPlayerFeatures()
    local ref = fun.get_component(self.topPanel, fun.REFER)
    local data = self:GetRankData()
    for i = 1, 3 do
        local featureGo = ref:Get("Person" .. i)
        fun.set_active(featureGo, false)
    end

    for i, v in ipairs(data) do
        if v.order and v.order >= 1 and v.order <= 3 then
            local featureGo = ref:Get("Person" .. v.order)
            fun.set_active(featureGo, true)
            self:SetOneTopFeature(featureGo, data[i])
        end
    end
end

function CarQuestMainView:SetOneTopFeature(gameObject, data)
    local ref = fun.get_component(gameObject, fun.REFER)
    local imgHead = ref:Get("imgHead")
    local txtName1 = ref:Get("txtName1")
    local txtName2 = ref:Get("txtName2")
    local imgRank = ref:Get("imgRank")
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)

    fun.set_active(imgRank, false)
    fun.set_active(txtName1, false)
    fun.set_active(txtName2, false)
    if fun.is_not_null(imgHead) then
        if data.robot == 0 and isSelf then
            txtName2.text = "You" --data.nickname
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
        else
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
            local nickname = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "name"))
            txtName1.text = nickname
        end
    end
end

function CarQuestMainView:HideFeatureRanks()
    local ref1 = fun.get_component(self.bottomPanel, fun.REFER)
    for i = 1, Const.CarCount do
        local featureGo = ref1:Get("feature" .. i)
        local ref2 = fun.get_component(featureGo, fun.REFER)
        local imgRank = ref2:Get("imgRank")
        fun.set_active(imgRank, false)
    end
end

function CarQuestMainView:ShowFeatureRanks()
    local ref = fun.get_component(self.bottomPanel, fun.REFER)
    for i = 1, Const.CarCount do
        local featureGo = ref:Get("feature" .. i)
        local rank = self.showRankList[i].rank
        self:SetFeatureRank(rank, featureGo)
    end
end

function CarQuestMainView:SetFeatureRank(rank, featureGo)
    if not rank then
        return
    end

    if rank < 1 then
        return
    end

    if rank > 5 then
        return
    end

    local ref = fun.get_component(featureGo, fun.REFER)
    local imgRank = ref:Get("imgRank")
    fun.set_active(imgRank, true)
    imgRank.sprite = AtlasManager:GetSpriteByName("CarQuestMainAtlas", RankImgList[rank])
end

function CarQuestMainView:InitBuffs()
    local ref = fun.get_component(self.topPanel, fun.REFER)
    local buff1 = ref:Get("extraBuff")
    fun.set_active(buff1, false)
    local buff2 = ref:Get("carBuff")
    fun.set_active(buff2, false)
    self.buffList = self.buffList or {}
    local data1 = { id = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF, value = ModelList.CarQuestModel
    :GetMoreItemBuffTime() }
    local data2 = { id = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF, value = ModelList.CarQuestModel
    :GetMoreRewardBuffTime() }
    if ModelList.FixedActivityModel:IsAnniversary() then
        self:SetAnniversaryBuffData(buff1, data1)
    else
        self:SetBuffData(buff1, data1)
    end
    self.buffList[1] = { go = buff1, value = data1.value }
    self:SetBuffData(buff2, data2)
    self.buffList[2] = { go = buff2, value = data2.value }
    self:SetBuffLeftTime()
end

function CarQuestMainView:SetBuffLeftTime()
    self:CleanBuffLeftTime()
    self.buffCountDown = LuaTimer:SetDelayLoopFunction(0, 1, -1, function ()
        for i, v in ipairs(self.buffList) do
            if v.go and v.value and v.value > 0 then
                v.value = v.value - 1
                local refer = fun.get_component(v.go, fun.REFER)
                local Text = refer:Get("Text")
                Text.text = fun.SecondToStrFormat2(v.value)
            end
        end
    end, nil)
end

function CarQuestMainView:CleanBuffLeftTime()
    if self.buffCountDown then
        LuaTimer:Remove(self.buffCountDown)
        self.buffCountDown = nil
    end
end

function CarQuestMainView:SetActivityLeftTime()
    self:CleanActivityLeftTime()
    self.activityLeftTime = ModelList.CarQuestModel:GetActivityRemainTime()
    if self.activityLeftTime < 0 then
        self.activityLeftTime = 0
    end
    local refer = fun.get_component(self.topPanel, fun.REFER)
    local Text = refer:Get("text_countdown")
    Text.text = fun.SecondToStrFormat(self.activityLeftTime)
    self.activityCountDown = LuaTimer:SetDelayLoopFunction(0, 1, -1, function ()
        self.activityLeftTime = self.activityLeftTime - 1
        if self.activityLeftTime >= 0 then
            Text.text = fun.SecondToStrFormat(self.activityLeftTime)
        else

        end
    end, nil)
end

function CarQuestMainView:CleanActivityLeftTime()
    if self.activityCountDown then
        LuaTimer:Remove(self.activityCountDown)
        self.activityCountDown = nil
    end
end

function CarQuestMainView:SetBuffData(buffGo, data)
    if data.value and data.value > 0 then
        fun.set_active(buffGo, true)
        local refer = fun.get_component(buffGo, fun.REFER)
        local item = Csv.GetItemOrResource(data.id)
        --local iconImg = refer:Get("icon")
        local Text = refer:Get("Text")
        --Cache.SetImageSprite("ItemAtlas", item.icon, iconImg)
        Text.text = fun.SecondToStrFormat2(data.value)
    end
end

function CarQuestMainView:SetAnniversaryBuffData(buffGo, data)
    if not this.anniversaryBuffObj then
        local anniversaryBuff = require("View.Anniversary.AnniversaryBuff")
        this.anniversaryBuffObj = anniversaryBuff:CheckDuringBuff(buffGo.transform.parent, fun.find_child(buffGo, "icon"),
            -80, 45.9, 2)
    end
end

function CarQuestMainView:InitGiftPackIcon()
    local info = ModelList.CarQuestModel:GetGiftPackInfo()
    if info and info.leftTime > 0 and info.canBuy then
        fun.set_active(self.btn_gift, true)
        self:SetGiftPackLeftTime(info.leftTime)
    else
        fun.set_active(self.btn_gift, false)
    end
end

function CarQuestMainView:InitTargetFuelNum(curStageIdx)
    curStageIdx = curStageIdx or CarQuestSectionMgr:GetStartStageIdx()
    if curStageIdx > self:GetMaxStageIdx() then
        return
    end

    local needScore = 0
    local cfg = self:GetRaceConfig()
    if cfg and cfg[curStageIdx] then
        needScore = cfg[curStageIdx][3]
    end
    self.textFuelNum.text = needScore
end

function CarQuestMainView:InitFirstRewardItem(curStageIdx)
    curStageIdx = curStageIdx or CarQuestSectionMgr:GetStartStageIdx()
    if curStageIdx > self:GetMaxStageIdx() then
        return
    end

    local reward
    local cfg = self:GetRaceConfig()
    if cfg and cfg[curStageIdx] then
        reward = cfg[curStageIdx][5]
    end
    local firstRewardItem = self.firstRewardItem
    if self.selfHasExtraBuff then
        firstRewardItem = self.firstRewardItem2
    end
    if reward then
        fun.set_active(firstRewardItem, true)
        local ref = fun.get_component(firstRewardItem, fun.REFER)
        local icon = ref:Get("icon")
        local value = ref:Get("value")
        local rewardRoot = ref:Get("rewardRoot")
        local featureRoot = ref:Get("featureRoot")
        local feature = ref:Get("feature")
        local rankRoot = ref:Get("rankRoot")
        local iconName = Csv.GetItemOrResource(reward[1], "more_icon")
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
        value.text = reward[2]
        fun.set_active(featureRoot, false)
        fun.set_active(rankRoot, true)
    else
        fun.set_active(firstRewardItem, false)
    end
end

function CarQuestMainView:InitStageRewardItem(curStageIdx)
    curStageIdx = curStageIdx or CarQuestSectionMgr:GetStartStageIdx()
    if curStageIdx > self:GetMaxStageIdx() then
        return
    end

    local reward
    if self.stepRewards and self.stepRewards[curStageIdx] then
        reward = self.stepRewards[curStageIdx].reward
    end

    local stageRewardItem = self.stageRewardItem
    if self.selfHasExtraBuff then
        stageRewardItem = self.stageRewardItem2
    end
    if reward then
        fun.set_active(stageRewardItem, true)
        local ref = fun.get_component(stageRewardItem, fun.REFER)
        local icon = ref:Get("icon")
        local value = ref:Get("value")
        local rewardRoot = ref:Get("rewardRoot")
        local featureRoot = ref:Get("featureRoot")
        local feature = ref:Get("feature")
        local rankRoot = ref:Get("rankRoot")
        local iconName = Csv.GetItemOrResource(reward.id, "more_icon")
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
        value.text = reward.value
        fun.set_active(featureRoot, false)
        fun.set_active(rankRoot, false)
    else
        fun.set_active(stageRewardItem, false)
    end
end

function CarQuestMainView:SelfHasExtraBuff()
    local selfRankInfo = ModelList.CarQuestModel:GetSelfRacingRankInfo()

    local props = selfRankInfo and selfRankInfo.gameProps
    if props and #props > 0 then
        for i, v in ipairs(props) do
            local name = Csv.GetData("resources", v, "name")
            if name == "racingreward" then
                return true
            end
        end
    end

    return false
end

function CarQuestMainView:SelfHasDisplacement()
    local selfRankInfo = ModelList.CarQuestModel:GetSelfRacingRankInfo()
    if selfRankInfo and selfRankInfo.lastScore and selfRankInfo.score then
        return selfRankInfo.lastScore < selfRankInfo.score
    end
    return false
end

function CarQuestMainView:InitExtraRewardItem(curStageIdx)
    curStageIdx = curStageIdx or CarQuestSectionMgr:GetStartStageIdx()
    if curStageIdx > self:GetMaxStageIdx() then
        return
    end

    local reward
    local cfg = self:GetRaceConfig()
    if cfg and cfg[curStageIdx] then
        reward = cfg[curStageIdx][8]
    end
    local extraRewardItem = self.extraRewardItem

    if reward then
        fun.set_active(extraRewardItem, true)
        local ref = fun.get_component(extraRewardItem, fun.REFER)
        local icon = ref:Get("icon")
        local value = ref:Get("value")
        local rewardRoot = ref:Get("rewardRoot")
        local featureRoot = ref:Get("featureRoot")
        local feature = ref:Get("feature")
        local rankRoot = ref:Get("rankRoot")
        local iconName = Csv.GetItemOrResource(reward[1], "more_icon")
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
        value.text = reward[2]
        fun.set_active(featureRoot, false)
        fun.set_active(rankRoot, false)
    else
        fun.set_active(extraRewardItem, false)
    end
end

function CarQuestMainView:SetGiftPackLeftTime(leftTime)
    self:CleanGiftPackLeftTime()
    self.giftPackLeftTime = leftTime

    if self.giftPackLeftTime < 0 then
        self.giftPackLeftTime = 0
    end
    local refer = fun.get_component(self.topPanel, fun.REFER)
    local Text = refer:Get("gift_countdown")
    Text.text = fun.SecondToStrFormat(self.giftPackLeftTime)
    self.giftPackCountDown = LuaTimer:SetDelayLoopFunction(0, 1, -1, function ()
        self.giftPackLeftTime = self.giftPackLeftTime - 1
        if self.giftPackLeftTime >= 0 then
            Text.text = fun.SecondToStrFormat(self.giftPackLeftTime)
        else

        end
    end, nil)
end

function CarQuestMainView:CleanGiftPackLeftTime()
    if self.giftPackCountDown then
        LuaTimer:Remove(self.giftPackCountDown)
        self.giftPackCountDown = nil
    end
end

function CarQuestMainView:HideBubble()
    fun.set_active(self.rewardBubble, false)
    self.curShowBoxIdx = nil
end

function CarQuestMainView:CreateBubbleItem(reward)
    local itemGo = fun.get_instance(self.bubbleItem)
    fun.set_parent(itemGo, self.bubblePanel, true)
    fun.set_active(itemGo, true)

    local ref = fun.get_component(itemGo, fun.REFER)
    local lbl = ref:Get("value")
    local icon = ref:Get("icon")
    local iconName = Csv.GetItemOrResource(reward.id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)

    lbl.text = fun.format_number(reward.value, true)
    return itemGo
end

function CarQuestMainView:ShowBubble(params)
    fun.set_active(self.rewardBubble, true)
    fun.clear_all_child(self.bubblePanel)
    local rewards = params.rewards
    for i, v in ipairs(rewards) do
        self:CreateBubbleItem(v)
    end

    fun.set_gameobject_pos(self.rewardBubble, params.posX, params.posY, 0, true)
    --fun.set_rect_anchored_position(self.bubbleBg, 0, params.pos.y)
end

function CarQuestMainView:SetLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetActivityExpireTime()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.endTime = expireTime - currentTime
    if self.endTime > 0 then
        if self.loopTime then
            LuaTimer:Remove(self.loopTime)
            self.loopTime = nil
        end
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function ()
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime <= 0 then
                    self:on_btn_close_click()
                end
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    end
end

function CarQuestMainView:GetPlayerCarTransform()
    if self.hasInit then
        local go = CarQuestCarMgr:GetPlayerCar()
        local rectTransform = fun.get_component(go, fun.RECT)
        return rectTransform
    end
end

function CarQuestMainView:GetCarBuffTransform()
    if self.hasInit then
        local ref = fun.get_component(self.topPanel, fun.REFER)
        local buff = ref:Get("carBuff")
        local rectTransform = fun.get_component(buff, fun.RECT)
        return rectTransform
    end
end

function CarQuestMainView:GetRewardBuffTransform()
    if self.hasInit then
        local ref = fun.get_component(self.topPanel, fun.REFER)
        local buff = ref:Get("extraBuff")
        local rectTransform = fun.get_component(buff, fun.RECT)
        return rectTransform
    end
end

function CarQuestMainView:DoGetBuffEffect(buffType)
    if self.hasInit then
        if RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF == buffType then
            log.log("CarQuestMainView:DoGetBuffEffect 购买了更多投放buff", ModelList.CarQuestModel:GetMoreItemBuffTime())
        elseif RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF == buffType then
            log.log("CarQuestMainView:DoGetBuffEffect 购买了升级车辆buff", ModelList.CarQuestModel:GetMoreRewardBuffTime())
            CarQuestCarMgr:UpgradePlayerCar()
            CarQuestRoadMgr:ShowUpgradeFlag()
            CarQuestPropMgr:ForeshowPropItems()
            UISound.play("racinglevelup")
        end
        self:InitBuffs()
    end
end

function CarQuestMainView:GetZebraStripesPos()
    return CarQuestSectionMgr:GetCurPosInScreen()
end

function CarQuestMainView:GetCurStageIdx()
    if self.curStageIdx then
        return self.curStageIdx
    else
        return CarQuestSectionMgr:GetCurStageIdx()
    end
end

function CarQuestMainView:GetMaxStageIdx()
    local cfg = self:GetRaceConfig()
    if cfg and #cfg > 0 then
        return #cfg
    end
    log.log("CarQuestMainView:GetMaxStageIdx() 数据有问题")
    return 10
end

function CarQuestMainView:GetFirstRewardGetter(stageIdx)
    if self.data and self.data.firstReward then
        for i, v in ipairs(self.data.firstReward) do
            if stageIdx == v.step then
                for ii, vv in ipairs(self.showRankList) do
                    if v.uid == vv.uid then
                        return vv
                    end
                end
            end
        end
    end
end

function CarQuestMainView:UnfoldStageRewardPanel()
    if self.stageRewardPanelIsUnfold then
        return
    end
    if self.selfHasExtraBuff then
        AnimatorPlayHelper.Play(self.animaStageRewardPanel, { "enter3", "stageRewardPanelenter3" }, false, function ()
            fun.set_active(self.btn_close_reward_panel, true)
        end)
    else
        AnimatorPlayHelper.Play(self.animaStageRewardPanel, { "enter", "stageRewardPanelenter" }, false, function ()
            fun.set_active(self.btn_close_reward_panel, true)
        end)
    end
    self.stageRewardPanelIsUnfold = true
end

function CarQuestMainView:FoldStageRewardPanel()
    if self.stageRewardPanelIsUnfold == false then
        return
    end
    self.stageRewardPanelIsUnfold = false
    fun.set_active(self.btn_close_reward_panel, false)
    if self.selfHasExtraBuff then
        AnimatorPlayHelper.Play(self.animaStageRewardPanel, { "end3", "stageRewardPanelend3" }, false, function () end)
    else
        AnimatorPlayHelper.Play(self.animaStageRewardPanel, { "end", "stageRewardPanelend" }, false, function () end)
    end
end

function CarQuestMainView:PlayGetStageRewardAnima()
    local stageRewardItem = self.stageRewardItem
    if self.selfHasExtraBuff then
        stageRewardItem = self.stageRewardItem2
    end
    local ref = fun.get_component(stageRewardItem, fun.REFER)
    local bao = ref:Get("bao")
    fun.set_active(bao, false)
    fun.set_active(bao, true)
end

function CarQuestMainView:PlayGetStageFirstRewardAnima()
    local firstRewardItem = self.firstRewardItem
    if self.selfHasExtraBuff then
        firstRewardItem = self.firstRewardItem2
    end
    local ref = fun.get_component(self.firstRewardItem, fun.REFER)
    local bao = ref:Get("bao")
    fun.set_active(bao, false)
    fun.set_active(bao, true)
end

function CarQuestMainView:PlayGetStageExtraRewardAnima()
    local ref = fun.get_component(self.extraRewardItem, fun.REFER)
    local bao = ref:Get("bao")
    fun.set_active(bao, false)
    fun.set_active(bao, true)
end

function CarQuestMainView:GetSectionTraveledDistance()
    return CarQuestSectionMgr:GetTraveledDistance()
end

function CarQuestMainView:GetSectionTargetMoveDistance()
    return CarQuestSectionMgr:GetTargetMoveDistance()
end

function CarQuestMainView:GetCarCurPosInScreen(col)
    return CarQuestCarMgr:GetCarCurPosInScreen(col)
end

function CarQuestMainView:AfterViewClose()
    if self.isOver == 1 then
        if self.data.rankReward and #self.data.rankReward then
            local poptype = 2
            Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestOpenBoxView, nil, nil, poptype)
        else
            local flag = ModelList.CarQuestModel:GetIsRacingRankTop()
            --直接弹出
            if flag then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestRankView)
            else
                Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionQuestRank2View)
            end
        end
    end
end

function CarQuestMainView:OnFuelUpFinish()
    log.log("CarQuestMainView:OnFuelUpFinish")
    CarQuestCarMgr:StartMoveAllCars()
    CarQuestSectionMgr:CreateZebraStripes()
    CarQuestProgressMgr:StartIncrease()
    CarQuestSectionMgr:StartMove()
    CarQuestPropMgr:StartMove()
    CarQuestCarMgr:ShowEndFuel()
    CarQuestCarMgr:HideFuleBubble()
    if self:SelfHasDisplacement() then
        CarQuestRoadMgr:MoveFast()
    end
    UISound.play("racingspeed")
end

function CarQuestMainView:OnCarStartingFinish(params)
    if params.playerType == Const.EnmuPlayerType.myself then
        log.log("CarQuestMainView:OnCarStartingFinish(params)", params)
        self:ShowTopPanel()
        CarQuestCarMgr:ShowFuleBubble()
    end
end

function CarQuestMainView:OnCarMovingFinish(params)
    log.log("CarQuestMainView:OnCarMovingFinish(params)", params)
    if params.playerType == Const.EnmuPlayerType.myself then
        CarQuestRoadMgr:MoveSlow()
        if params.score >= self.finishRaceNeedScore then
            CarQuestCarMgr:StartFinialSprint(params.index)
        else
            self:ShowTopPanel()
            self:ShowFeatureRanks()
            CarQuestCarMgr:ShowFuleBubble()
            CarQuestCarMgr:StopMove(params.index)
        end
    else
        if params.score >= self.finishRaceNeedScore then
            CarQuestCarMgr:StartFinialSprint(params.index)
        else
            CarQuestCarMgr:StopMove(params.index)
        end
    end
end

function CarQuestMainView:OnCarSprintFinish(params)
    log.log("CarQuestMainView:OnCarSprintFinish(params)", params)
    if params.playerType == Const.EnmuPlayerType.myself then
        self:ShowTopPanel()
        self:ShowFeatureRanks()
    end
end

function CarQuestMainView:OnFinishOneStage(params)
    log.log("CarQuestMainView:OnFinishOneStage(params)", params)
    if params.playerType == Const.EnmuPlayerType.myself then
        self:PlayGetStageRewardAnima()
        UISound.play("coinfly")
        if params.isFirst then
            self:PlayGetStageFirstRewardAnima()
        end
        if self.selfHasExtraBuff then
            self:PlayGetStageExtraRewardAnima()
        end
        self:InitTargetFuelNum(params.curStageIdx + 1)
        self:InitStageRewardItem(params.curStageIdx + 1)
        self:InitFirstRewardItem(params.curStageIdx + 1)
        self:InitExtraRewardItem(params.curStageIdx + 1)
    else

    end
end

function CarQuestMainView:OnReceiveStageRewardFinish(params)
    log.log("CarQuestMainView:OnReceiveStageRewardFinish")
    if self.enterMode == Const.EnterMode.afterBattle or self.enterMode == Const.EnterMode.beforeRewardResend then
        if self.isOver == 1 then
            self:CloseSelf()
        end
    end
end

function CarQuestMainView:OnNotifyFinishRaceBefore(params)
    log.log("CarQuestMainView:OnNotifyFinishRaceBefore", params)
    if params.playerType == Const.EnmuPlayerType.myself then
        self:ShowTopPanel()
        self:ShowFeatureRanks()
    end
end

--just for test
function CarQuestMainView:OpenTestView()
    local itemGo = self.testRoot
    CarQuestTest:SkipLoadShow(itemGo)
    fun.set_active(itemGo, true)
end

function CarQuestMainView:SetReadyState(isNeedReady)
    self.isNeedReady = isNeedReady
end

--设置消息通知
this.NotifyEnhanceList =
{
    { notifyName = NotifyName.CarQuest.FuelUpFinish,             func = this.OnFuelUpFinish },
    { notifyName = NotifyName.CarQuest.CarStartingFinish,        func = this.OnCarStartingFinish },
    { notifyName = NotifyName.CarQuest.CarMovingFinish,          func = this.OnCarMovingFinish },
    { notifyName = NotifyName.CarQuest.CarSprintFinish,          func = this.OnCarSprintFinish },
    { notifyName = NotifyName.CarQuest.FinishOneStage,           func = this.OnFinishOneStage },
    { notifyName = NotifyName.CarQuest.ReceiveStageRewardFinish, func = this.OnReceiveStageRewardFinish },
    { notifyName = NotifyName.CarQuest.NotifyFinishRaceBefore,   func = this.OnNotifyFinishRaceBefore },
}

return this
