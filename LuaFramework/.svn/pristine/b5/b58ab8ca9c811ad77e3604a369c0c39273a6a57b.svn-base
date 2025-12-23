local Const = require "View/WinZone/WinZoneConst"
local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"
local WinZoneAvatarItem2 = require "View/WinZone/WinZoneAvatarItem2"
local WinZonePromoteView2 = BaseView:New("WinZonePromoteView2", "WinZonePromote1Atlas")
local this = WinZonePromoteView2
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
--this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)
this.update_x_enabled = true --开启独立刷新

this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "prefabRoot",
    "featurePrefab",
    "featureRoot",
    "txtRoot",
    "txtNumerator",
    "txtDenominator",
    "txtDivide",
    "scrollRect",
    "topPlayer1",
    "topPlayer2",
    "topPlayer3",
    "podium1",
    "podium2",
    "podium3",
    "imgTitle1",
    "imgTitle2",
    "anima",
    "btn_continue",
    "topPlayerRoot",
    "screenTopPlayer1",
    "screenTopPlayer2",
    "screenTopPlayer3",    
}

--定义当前界面可能的状态
local States = {
    none = -1,
    ready = 0,
    waitTask = 1,
    doingTask = 2,
    finishAllTask = 3,
}

--定义当前界面要完成的任务类型
local TaskTypes = {
    disusePlayer = 1,   --淘汰一个玩家
    scrollContent = 2,  --滑动视图
}

local AheadEnableContinue = true

function WinZonePromoteView2:Awake()
end

function WinZonePromoteView2:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    --UISound.play("xxxx")
    UISound.play("winzoneFantastic")  
end

function WinZonePromoteView2:on_after_bind_ref()
    log.log("WinZonePromoteView2:on_after_bind_ref()")
    fun.set_active(self.prefabRoot, false)
    fun.set_active(self.btn_help, false)    
    fun.set_active(self.btn_close, false)
    fun.set_active(self.btn_continue, false)
    fun.enable_button(self.btn_continue, false)
    self:InitView()
    self.hasInit = true
    if fun.is_not_null(self.anima) then
        --[[
        log.log("WinZonePromoteView2:on_after_bind_ref() play anima 1")
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZonePromoteView2start"}, false, function() 
                log.log("WinZonePromoteView2:on_after_bind_ref() play anima 2")
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
        --]]

        ---[[
        log.log("WinZonePromoteView2:on_after_bind_ref() play anima 0")
        AnimatorPlayHelper.Play(self.anima, {"start", "WinZonePromoteView2start"}, false, function() end)
        --]]
    end                 
end

function WinZonePromoteView2:PlayVoiceList1()
    self:ClearAllVoiceTimer()
    local delay = 0
    delay = math.max(Const.ThirdDelay, 0)
    self.voiceTimer3 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneNum3")
    end)
    

    delay = math.max(delay + Const.SecondDelay + Const.ThirdTime, 0)
    self.voiceTimer2 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneNum2")
    end)

    delay = math.max(delay + Const.FirstDelay + Const.SecondTime, 0)
    self.voiceTimer1 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneNum1")
    end)
end

function WinZonePromoteView2:ClearAllVoiceTimer()
    if self.voiceTimer3 then
        LuaTimer:Remove(self.voiceTimer3)
        self.voiceTimer3 = nil
    end

    if self.voiceTimer2 then
        LuaTimer:Remove(self.voiceTimer2)
        self.voiceTimer2 = nil
    end

    if self.voiceTimer1 then
        LuaTimer:Remove(self.voiceTimer1)
        self.voiceTimer1 = nil
    end
end

function WinZonePromoteView2:InitView()
    log.log("WinZonePromoteView2:InitView()")
    fun.set_active(self.imgTitle1, true)
    fun.set_active(self.imgTitle2, false)
    self:SetTopPlayerAvatarInfo()
    self:InitPlayerDisuseState()
end

function WinZonePromoteView2:OnDisable()
    log.log("WinZonePromoteView2:OnDisable()")
    Facade.RemoveViewEnhance(self)
    self:ClearAllVoiceTimer()
    self.hasInit = nil
    self.closeCb = nil
end

--设置整个活动所处的状态
function WinZonePromoteView2:SetGameState(state)
    self.curGameState = state
end

function WinZonePromoteView2:on_x_update()
    if not self.hasInit then
        return
    end

    if not self.state then
        return
    end

    if self.state == States.ready then
        return
    end

    if self.state == States.waitTask then
        self:HandleTask()
        return
    end

    if self.state == States.doingTask then
        return
    end

    if self.state == States.finishAllTask then
        return
    end
end

function WinZonePromoteView2:SetData(data)
    self.data = DeepCopy(data)
end

function WinZonePromoteView2:SetAvatarInfo(gameObject, data)
    if fun.is_null(gameObject) then
        return
    end
    if not data then
        return
    end

    local ref = fun.get_component(gameObject, fun.REFER)
    local imgHead = ref:Get("imgHead")
    local txtName1 = ref:Get("txtName1")
    local txtName2 = ref:Get("txtName2")
    local flagTop = ref:Get("imgFlag1")
    local flagBuff = ref:Get("imgFlag2")
    local flagRelive = ref:Get("imgFlag3")
    local imgFrame1 = ref:Get("imgFrame1")
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)

    --头像图片
    --玩家名称
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
            avatar = fun.get_strNoEmpty(avatar, "xxl_head01")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
            local nickname = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "name"))
            txtName1.text = nickname
        end
    end

    imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi01")

    --明星标志
    if data.isTop then
        fun.set_active(flagTop, true)
        imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi02")
    else
        fun.set_active(flagTop, false)
    end

    --buff标志
    if data.gameProps and fun.is_include(Const.BuffId1, data.gameProps) then
        imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas","WinzonFramesDi03")
        fun.set_active(flagBuff, true)
    else
        fun.set_active(flagBuff, false)
    end

    --复活标志
    if data.status == Const.PlayerStates.relive then
        fun.set_active(flagRelive, true)
    else
        fun.set_active(flagRelive, false)
    end
end

function WinZonePromoteView2:SetTopPlayerAvatarInfo()
    if self.data and self.data.roles then
        for i, v in ipairs(self.data.roles) do
            if v.rank <= 3 then
                self:SetAvatarInfo(self["topPlayer" .. v.rank], v)
                self:SetAvatarInfo(self["screenTopPlayer" .. v.rank], v)
            end
        end
    end
end

function WinZonePromoteView2:InitPlayerDisuseState()
    fun.clear_all_child(self.featureRoot)
    self.disusedNum = 0
    self.waittingDisuseNum = 0
    local playerList = self:GetPlayerList()

    for i, v in ipairs(playerList) do
        if v.status == Const.PlayerStates.disuse or v.status == Const.PlayerStates.relive then
            self.waittingDisuseNum = self.waittingDisuseNum + 1
        end
    end

    self:UpdateDisuseProgress()
    self.playerAvatarList = {}
    if Const.UseFrameCreateAvatar then
        self:CreatePlayersAvatarV2(playerList)
    else
        self:CreatePlayersAvatarV1(playerList)
    end
    self.scrollRect.verticalNormalizedPosition =  1
end

function WinZonePromoteView2:GetPlayerList()
    local playerList = DeepCopy(self.data.roles)
    if Const.UsePlaceholderPlayer then
        if playerList and #playerList % Const.PlayerCountPerRow ~= 0 then
            local num = Const.PlayerCountPerRow - (#playerList % Const.PlayerCountPerRow)
            for i = 1, num do
                table.insert(playerList, self:CreatePlaceholderPlayer())
            end
        end
    end

    return playerList
end

function WinZonePromoteView2:GetRealPlayerCount()
    if self.data and self.data.roles then
        return #self.data.roles
    end

    return 0
end

function WinZonePromoteView2:CreatePlaceholderPlayer()
    return Const.PlaceholderPlayer
end

function WinZonePromoteView2:CreatePlayersAvatarV1(playerList)
    for i, v in ipairs(playerList) do
        local avatar = self:CreateAvatar(v)
        if v.status == Const.PlayerStates.placeholder then
            avatar:ShowEmpty()
        else
            avatar:ShowFull()
        end

        avatar:SetIndex(i)
        table.insert(self.playerAvatarList, avatar)
    end

    self:AvatarCreateFinish()
    if self.waittingDisuseNum == 0 then
        self:PlayerDisuseFinish()
    end
end

function WinZonePromoteView2:CreatePlayersAvatarV2(playerList)
    coroutine.start(function()
        for i, v in ipairs(playerList) do
            local avatar = self:CreateAvatar(v)
            if v.status == Const.PlayerStates.placeholder then
                avatar:ShowEmpty()
            else
                avatar:ShowFull()
            end

            avatar:SetIndex(i)
            table.insert(self.playerAvatarList, avatar)
            --WaitForSeconds(0.3)
            WaitForEndOfFrame()
        end

        self:AvatarCreateFinish()
        if self.waittingDisuseNum == 0 then
            self:PlayerDisuseFinish()
        end
    end)
end

function WinZonePromoteView2:AvatarCreateFinish()
    log.log("WinZonePromoteView2:AvatarCreateFinish()")
    self:GenTaskList()
    self:SetState(States.ready)
    self:register_invoke(function()
        self:SetState(States.waitTask)
    end, Const.DisusePlayerDelay)
    self.curWaittingTaskIdx = 1
end

function WinZonePromoteView2:SetState(state)
    self.state = state
end

function WinZonePromoteView2:CreateAvatar(data)
    local item = WinZoneAvatarItem2:New()
    item:SetData(data)
    local itemGo = fun.get_instance(self.featurePrefab, self.featureRoot)
    fun.set_active(itemGo, true)
    item:SkipLoadShow(itemGo)

    return item
end

--播放最后的上榜动画
function WinZonePromoteView2:PlayRankAnima(callback)
    --[[
    log.log("WinZonePromoteView2:PlayRankAnima() 1")
    local task = function()
        log.log("WinZonePromoteView2:PlayRankAnima() 2")
        AnimatorPlayHelper.Play(self.anima, {"act", "WinZonePromoteView2act"}, false, function()
            self:MutualTaskFinish()
            log.log("WinZonePromoteView2:PlayRankAnima() 3")
            if callback then
                callback()
            end
        end)
    end
    self:DoMutualTask(task)
    --]]

    ---[[
    log.log("WinZonePromoteView2:PlayRankAnima() 001")
    AnimatorPlayHelper.Play(self.anima, {"act", "WinZonePromoteView2act"}, false, function()
        log.log("WinZonePromoteView2:PlayRankAnima() 002")
        if callback then
            callback()
        end
    end)
    --]]
    self:PlayVoiceList1()
end

function WinZonePromoteView2:CloseSelf()
    log.log("WinZonePromoteView2:CloseSelf()")
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZonePromoteView2:CloseSelf() play anima 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZonePromoteView2end"}, false, function()
                self:MutualTaskFinish()
                log.log("WinZonePromoteView2:CloseSelf() play anima 3")
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        log.log("WinZonePromoteView2:CloseSelf() play anima 1")
        self:DoMutualTask(task)
    else
        log.log("WinZonePromoteView2:CloseSelf() no anima")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZonePromoteView2:on_btn_close_click()
    self:CloseSelf()
end

function WinZonePromoteView2:on_btn_help_click()
    -- local playid = ModelList.CityModel.GetPlayIdByCity()
    -- local playType = Csv.GetData("city_play", playid, "play_type")
    local assetviewName = "WinZoneHelperView"
    local altasViewName = "WinZoneHelperView"
    Cache.load_prefabs(AssetList[assetviewName], altasViewName, function(obj)
        local root = HallExplainHelpView:GetRootView()
        local gameObject = fun.get_instance(obj, root)
        HallExplainHelperView:SkipLoadShow(gameObject)
    end)
end

function WinZonePromoteView2:on_btn_continue_click()
    if Const.DisableRecordView then
        if self.closeCb then
            self.closeCb()
        end
    else
        ViewList.WinZoneRecordView:SetConfirmCallback(function()
            if ModelList.WinZoneModel:HasReward() then
                ModelList.WinZoneModel:C2S_VictoryBeatsReward()
            else    --不可复活且无奖励 只能做退出操作了
                ModelList.WinZoneModel:C2S_VictoryBeatsExit()
            end
        end)
        ViewList.WinZoneRecordView:SetEnterMode(Const.EnterRecordMode.fromPromoteView2)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRecordView)
    end
    self:CloseSelf()
end

--获得每页的容量
function WinZonePromoteView2:GetPerPageCapacity()
    return Const.MinPerPageCapacity2
end

--生成任务列表
function WinZonePromoteView2:GenTaskList()
    log.log("WinZonePromoteView2:GenTaskList()")
    local roles = self:GetPlayerList()
    local disuseIndexList = {}
    for i, v in ipairs(roles) do
        if v.status == Const.PlayerStates.disuse or v.status == Const.PlayerStates.relive then
            table.insert(disuseIndexList, i)
        end
    end
    local totalPageCount = math.ceil(#roles / self:GetPerPageCapacity())

    local taskList = {}
    local curPageIdx = 1
    for i, v in ipairs(disuseIndexList) do
        local task = {}
        local newPageIdx = math.ceil(v / self:GetPerPageCapacity())
        if newPageIdx > curPageIdx then
            local task1 = {}
            task1.type = TaskTypes.scrollContent
            task1.from = curPageIdx
            task1.to = newPageIdx
            task1.isArriveTail = newPageIdx == totalPageCount
            table.insert(taskList, task1)

            curPageIdx = newPageIdx
        end
        task.type = TaskTypes.disusePlayer
        task.index = v
        table.insert(taskList, task)
    end

    self.taskList = taskList
    log.log("WinZonePromoteView2:GenTaskList() task is ", taskList)
end

--开始滑动
function WinZonePromoteView2:StartScroll(from, to, isArriveTail)
    local scrollTime = Const.AutoScrollTime
    local startPosY = fun.get_rect_anchored_position(self.featureRoot).y
    local endPosY = startPosY
    if isArriveTail then
        endPosY = self:GetScorllContentHeight() - self:GetScorllRectHeight()
    else
        endPosY = startPosY + self:GetPageHeight() * (to - from)
    end

    Anim.do_smooth_float_update(startPosY, endPosY, scrollTime, function(num)
            fun.set_rect_anchored_position(self.featureRoot, 0, num)
        end,
        function()
            fun.set_rect_anchored_position(self.featureRoot, 0, endPosY)
            self:FinishCurTask()
        end
    )
end

--获得Rect的高度
function WinZonePromoteView2:GetScorllRectHeight()
    local size  = fun.get_rect_delta_size(self.scrollRect)
    return size.y
end

--获得一页的高度（小于等于Rect的高度）
function WinZonePromoteView2:GetPageHeight()
    return self:GetScorllRectHeight()
end

--获得Content的高度
function WinZonePromoteView2:GetScorllContentHeight()
    local size  = fun.get_rect_delta_size(self.featureRoot)
    return size.y
end

--处理一条任务
function WinZonePromoteView2:HandleTask()
    if not self.taskList or self.curWaittingTaskIdx > #self.taskList then
        self:PlayerDisuseFinish()
    else
        local task = self.taskList[self.curWaittingTaskIdx]
        self:SetState(States.doingTask)
        if task.type == TaskTypes.scrollContent then
            self:StartScroll(task.from, task.to, task.isArriveTail)
        else
            self:DisusePlayer(task.index)
        end
    end
end

--淘汰指定位置的玩家
function WinZonePromoteView2:DisusePlayer(idx)
    local avatar = self.playerAvatarList[idx]
    if avatar then
        avatar:Disuse()
    end
    self.disusedNum = self.disusedNum + 1
    self.waittingDisuseNum = self.waittingDisuseNum - 1
    self:UpdateDisuseProgress()
    self:register_invoke(function()
        self:FinishCurTask()
    end, Const.DisusePlayerInterval)
    UISound.play("winzonePlayerout")
end

--完了当前任务
function WinZonePromoteView2:FinishCurTask()
    self.curWaittingTaskIdx = self.curWaittingTaskIdx + 1
    if not self.taskList or self.curWaittingTaskIdx > #self.taskList then
        self:PlayerDisuseFinish()
    else
        self:SetState(States.waitTask)
    end
end

--完了了任务列表中的所有任务(完成了淘汰过程)
function WinZonePromoteView2:PlayerDisuseFinish()
    log.log("WinZonePromoteView2:PlayerDisuseFinish()")
    self:SetState(States.finishAllTask)
    fun.set_active(self.imgTitle1, false)
    fun.set_active(self.imgTitle2, true)
    self.txtNumerator.text = ""
    self.txtDenominator.text = ""
    self.txtDivide.text = "3"

    Facade.SendNotification(NotifyName.WinZone.CelebratePromote2)

    local nextTask = function()
        if Const.DisableRecordView then
            if ModelList.WinZoneModel:HasReward() then
                ModelList.WinZoneModel:C2S_VictoryBeatsReward()
            else    --不可复活且无奖励 只能做退出操作了
                ModelList.WinZoneModel:C2S_VictoryBeatsExit()
                --self:CloseSelf()
            end
        else
            fun.set_active(self.btn_continue, true)
            fun.enable_button(self.btn_continue, true)
        end
    end
    self:register_invoke(function()
        if AheadEnableContinue then
            self:PlayRankAnima()
            self:register_invoke(nextTask, Const.DelayShowContinueBtnTime)
        else
            self:PlayRankAnima(nextTask)
        end
        
        UISound.play("winzoneFinalwin")
    end, Const.CelebratePromoteAnimTime2)
end

function WinZonePromoteView2:UpdateDisuseProgress()
    local realPlayerCount = self:GetRealPlayerCount()
    self.txtNumerator.text = realPlayerCount - self.disusedNum
    self.txtDenominator.text = realPlayerCount
    --self.txtDesc1.text = "USERS JOINED"
end

function WinZonePromoteView2:OnPlayerDisuse(params)
    --params.index
    self.disusedNum = self.disusedNum + 1
    self.waittingDisuseNum = self.waittingDisuseNum - 1
    self:UpdateDisuseProgress()
    if params.isTop then
        
    end

    if self.waittingDisuseNum == 0 then
    --if params.isLast then
        self:PlayerDisuseFinish()
    end
end

function WinZonePromoteView2:OnClaimReward(params)
    log.log("WinZonePromoteView2:OnClaimReward(params)", params)
    local isTopOne = ModelList.WinZoneModel:GetSelfRank() == 1
    isTopOne = isTopOne and ModelList.WinZoneModel:GetCurRound() > 0 
    isTopOne = isTopOne and  ModelList.WinZoneModel:GetCurRound() ==  ModelList.WinZoneModel:GetTotalRound()
    self.closeCb = function()
        if params.code == RET.RET_SUCCESS then
            if fun.is_table_empty(params.reward) then
                log.log("WinZonePromoteView2:OnClaimReward 领奖成功，但数据有问题", params)
            else
                ModelList.WinZoneModel:DisplayReward(params.reward, nil, isTopOne)
            end
        else
            log.log("WinZonePromoteView2:OnClaimReward 领奖失败", params)
        end
    end
    fun.set_active(self.btn_continue, true)
    fun.enable_button(self.btn_continue, true)
end

function WinZonePromoteView2:OnExitMatch(params)
    log.log("WinZonePromoteView2:OnExitMatch(params)", params)
    if fun.is_table_empty(params.reward) then
        self:CloseSelf()
    else
        ModelList.WinZoneModel:DisplayReward(params.reward, function() self:CloseSelf() end)
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.PlayerDisuse, func = this.OnPlayerDisuse},
    {notifyName = NotifyName.WinZone.ClaimReward, func = this.OnClaimReward},
    {notifyName = NotifyName.WinZone.Exit, func = this.OnExitMatch},
}

return this