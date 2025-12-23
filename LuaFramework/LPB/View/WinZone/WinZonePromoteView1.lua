local Const = require "View/WinZone/WinZoneConst"
local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"
local WinZoneAvatarItem2 = require "View/WinZone/WinZoneAvatarItem2"
local WinZonePromoteView1 = BaseView:New("WinZonePromoteView1", "WinZonePromote1Atlas")
local this = WinZonePromoteView1
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
    "anima",
    "imgTitle1",
    "imgTitle2",
    "curRound",
    "imgRoundBg",
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


local RoundBgImgs = {
    "WinzonTtRoundDi",      --1
    "WinzonTtRoundDi2",     --2
    "WinzonTtRoundDi3",     --3
    "WinzonTtRoundDi4",     --4
    "WinzonTtRoundDi4",     --5
    "WinzonTtRoundDi4",     --6
    "WinzonTtRoundDi5",     --7
    "WinzonTtRoundDi5",     --8
    "WinzonTtRoundDi5",     --9
}

function WinZonePromoteView1:Awake()
end

function WinZonePromoteView1:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    UISound.play("winzoneOut")
end

function WinZonePromoteView1:on_after_bind_ref()
    log.log("WinZonePromoteView1:on_after_bind_ref()")
    fun.set_active(self.prefabRoot, false)    
    fun.set_active(self.btn_help, false)    
    fun.set_active(self.btn_close, false)
    fun.set_active(self.imgTitle1, true)
    fun.set_active(self.imgTitle2, false)
    self:InitView()
    self.hasInit = true
    if fun.is_not_null(self.anima) then
        log.log("WinZonePromoteView1:on_after_bind_ref() play anima 1")
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZonePromoteView1start"}, false, function() 
                log.log("WinZonePromoteView1:on_after_bind_ref() play anima 2")
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
    end
end

function WinZonePromoteView1:InitView()
    log.log("WinZonePromoteView1:InitView()")
    self:InitPlayerDisuseState()
    self:InitRoundInfo()
end

function WinZonePromoteView1:OnDisable()
    log.log("WinZonePromoteView1:OnDisable()")
    Facade.RemoveViewEnhance(self)
    self.hasInit = nil
end

--设置整个活动所处的状态
function WinZonePromoteView1:SetGameState(state)
    self.curGameState = state
end

function WinZonePromoteView1:on_x_update()
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

function WinZonePromoteView1:SetData(data)
    self.data = DeepCopy(data)
end

function WinZonePromoteView1:InitRoundInfo()
    local data = ModelList.WinZoneModel:GetPlayReadyData()
    if not data then
        return
    end

    if fun.is_null(self.curRound) then
        return
    end
    
    --self.curRound.text = string.format("%s/%s", data.curRound, data.allRound)
    --self.curRound.text = string.format("ROUND %s", data.curRound)
    self.curRound.text = data.curRound
    local imgName = RoundBgImgs[data.curRound] or RoundBgImgs[1]
    self.imgRoundBg.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas", imgName)
end

function WinZonePromoteView1:InitPlayerDisuseState()
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

function WinZonePromoteView1:GetPlayerList()
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

function WinZonePromoteView1:GetRealPlayerCount()
    if self.data and self.data.roles then
        return #self.data.roles
    end

    return 0
end

function WinZonePromoteView1:CreatePlaceholderPlayer()
    return Const.PlaceholderPlayer
end

function WinZonePromoteView1:CreatePlayersAvatarV1(playerList)
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

function WinZonePromoteView1:CreatePlayersAvatarV2(playerList)
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

function WinZonePromoteView1:AvatarCreateFinish()
    log.log("WinZonePromoteView1:AvatarCreateFinish()")
    self:GenTaskList()
    self:SetState(States.ready)
    self:register_invoke(function()
        self:SetState(States.waitTask)
    end, Const.DisusePlayerDelay)
    self.curWaittingTaskIdx = 1
end

function WinZonePromoteView1:SetState(state)
    self.state = state
end

function WinZonePromoteView1:CreateAvatar(data)
    local item = WinZoneAvatarItem2:New()
    item:SetData(data)
    local itemGo = fun.get_instance(self.featurePrefab, self.featureRoot)
    fun.set_active(itemGo, true)
    item:SkipLoadShow(itemGo)

    return item
end

function WinZonePromoteView1:CloseSelf()
    log.log("WinZonePromoteView1:CloseSelf()")
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZonePromoteView1:CloseSelf() play anima 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZonePromoteView1end"}, false, function()
                self:MutualTaskFinish()
                log.log("WinZonePromoteView1:CloseSelf() play anima 3")
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        log.log("WinZonePromoteView1:CloseSelf() play anima 1")
        self:DoMutualTask(task)
    else
        log.log("WinZonePromoteView1:CloseSelf() no anima")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZonePromoteView1:on_btn_close_click()
    self:CloseSelf()
end

function WinZonePromoteView1:on_btn_help_click()
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

--获得每页的容量
function WinZonePromoteView1:GetPerPageCapacity()
    return Const.MinPerPageCapacity1
end

--生成任务列表
function WinZonePromoteView1:GenTaskList()
    log.log("WinZonePromoteView1:GenTaskList()")
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
    log.log("WinZonePromoteView1:GenTaskList() task is", taskList)
end

--开始滑动
function WinZonePromoteView1:StartScroll(from, to, isArriveTail)
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
function WinZonePromoteView1:GetScorllRectHeight()
    local size  = fun.get_rect_delta_size(self.scrollRect)
    return size.y
end

--获得一页的高度（小于等于Rect的高度）
function WinZonePromoteView1:GetPageHeight()
    return self:GetScorllRectHeight()
end

--获得Content的高度
function WinZonePromoteView1:GetScorllContentHeight()
    local size  = fun.get_rect_delta_size(self.featureRoot)
    return size.y
end

--处理一条任务
function WinZonePromoteView1:HandleTask()
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
function WinZonePromoteView1:DisusePlayer(idx)
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
function WinZonePromoteView1:FinishCurTask()
    self.curWaittingTaskIdx = self.curWaittingTaskIdx + 1
    if not self.taskList or self.curWaittingTaskIdx > #self.taskList then
        self:PlayerDisuseFinish()
    else
        self:SetState(States.waitTask)
    end
end

--完了了任务列表中的所有任务(完成了淘汰过程)
function WinZonePromoteView1:PlayerDisuseFinish()
    log.log("WinZonePromoteView1:PlayerDisuseFinish()")
    fun.set_active(self.imgTitle1, false)
    fun.set_active(self.imgTitle2, true)
    self.txtNumerator.text = ""
    self.txtDenominator.text = ""
    local realPlayerCount = self:GetRealPlayerCount()
    self.txtDivide.text = realPlayerCount - self.disusedNum
    self:SetState(States.finishAllTask)

    Facade.SendNotification(NotifyName.WinZone.CelebratePromote1)

    self:register_invoke(function()
        --下一步
        if ModelList.WinZoneModel:IsDisuse() then
            ViewList.WinZonePromoteTipView:SetShowType(Const.ShowPromoteTipTypes.fail)
        else
            ViewList.WinZonePromoteTipView:SetShowType(Const.ShowPromoteTipTypes.succ)
        end
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZonePromoteTipView)
    end, Const.CelebratePromoteAnimTime1)
end

function WinZonePromoteView1:UpdateDisuseProgress()
    local realPlayerCount = self:GetRealPlayerCount()
    self.txtNumerator.text = realPlayerCount - self.disusedNum
    self.txtDenominator.text = realPlayerCount
    --self.txtDesc1.text = "USERS JOINED"
end

function WinZonePromoteView1:OnPlayerDisuse(params)
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

--晋级淘汰提示窗关闭后
function WinZonePromoteView1:OnPromoteTipClose(showType)
    log.log("WinZonePromoteView1:OnPromoteTipClose(showType)", showType)
    if showType == Const.ShowPromoteTipTypes.fail then
        if ModelList.WinZoneModel:CanRelive() then
            ModelList.WinZoneModel:ShowReliveDialog()
            self:CloseSelf()
        elseif ModelList.WinZoneModel:HasReward() then
            if Const.DisableRecordView then
                ModelList.WinZoneModel:C2S_VictoryBeatsReward()
            else
                ViewList.WinZoneRecordView:SetConfirmCallback(function() ModelList.WinZoneModel:C2S_VictoryBeatsReward() end)
                ViewList.WinZoneRecordView:SetEnterMode(Const.EnterRecordMode.fromPromoteView1)
                Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRecordView)
            end
        else    --不可复活且无奖励 只能做退出操作了
            if Const.DisableRecordView then
                ModelList.WinZoneModel:C2S_VictoryBeatsExit()
            else
                ViewList.WinZoneRecordView:SetConfirmCallback(function() ModelList.WinZoneModel:C2S_VictoryBeatsExit() end)
                ViewList.WinZoneRecordView:SetEnterMode(Const.EnterRecordMode.fromPromoteView1)
                Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRecordView)
            end
            --self:CloseSelf()
        end
    else --无条件进入集结界面
        --超时处理
        if ModelList.WinZoneModel:GetCurServerTime() > ModelList.WinZoneModel:GetLastPlayTime() then
            local descId = 8045
            UIUtil.show_common_popup(descId, true, function()
                if Const.DisableRecordView then
                    if ModelList.WinZoneModel:HasReward() then
                        ModelList.WinZoneModel:C2S_VictoryBeatsReward()
                    else    --无奖励 只能做退出操作了
                        ModelList.WinZoneModel:C2S_VictoryBeatsExit()
                    end
                else
                    ViewList.WinZoneRecordView:SetConfirmCallback(function()
                        if ModelList.WinZoneModel:HasReward() then
                            ModelList.WinZoneModel:C2S_VictoryBeatsReward()
                        else    --无奖励 只能做退出操作了
                            ModelList.WinZoneModel:C2S_VictoryBeatsExit()
                        end
                    end)
                    ViewList.WinZoneRecordView:SetEnterMode(Const.EnterRecordMode.fromPromoteView1)
                    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRecordView)
                end
            end)
        else
            ModelList.WinZoneModel:WaitOtherRelive()
            self:CloseSelf()
        end
    end
end

function WinZonePromoteView1:OnClaimReward(params)
    log.log("WinZonePromoteView1:OnClaimReward(params)", params)
    self:CloseSelf()
	if params.code == RET.RET_SUCCESS then
        if fun.is_table_empty(params.reward) then
            log.log("WinZonePromoteView1:OnClaimReward 领奖成功，但数据有问题", params)
        else
            ModelList.WinZoneModel:DisplayReward(params.reward)
        end
    else
        log.log("WinZonePromoteView1:OnClaimReward 领奖失败", params)
    end
end

function WinZonePromoteView1:OnExitMatch(params)
    log.log("WinZonePromoteView1:OnExitMatch(params)", params)
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
    {notifyName = NotifyName.WinZone.ClosePromoteTip, func = this.OnPromoteTipClose},
    {notifyName = NotifyName.WinZone.ClaimReward, func = this.OnClaimReward},
    {notifyName = NotifyName.WinZone.Exit, func = this.OnExitMatch},
}

return this