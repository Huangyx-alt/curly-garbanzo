local Const = require "View/WinZone/WinZoneConst"
local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"
local WinZoneAvatarItem1 = require "View/WinZone/WinZoneAvatarItem1"
local WinZoneLobbyView = BaseView:New("WinZoneLobbyView", "WinZoneLobbyAtlas")
local this = WinZoneLobbyView
this.isCleanRes = true
--this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
this.update_x_enabled = true --开启独立刷新

this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "prefabRoot",
    "featurePrefab",
    "rect1",
    "rect2",
    "rect3",
    "txtNumerator",
    "txtDenominator",
    "txtDesc1",
    "featureRoot",
    "topFeature",
    "rect4",
    "txtReadCountdown",
    "anima",
    "animaScreen1",
    "animaScreen2",
    "img_countdown",
}

function WinZoneLobbyView:Awake()
end

function WinZoneLobbyView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    UISound.play_bgm("winzonebgm")
    --UISound.play("xxxx")
end

function WinZoneLobbyView:on_after_bind_ref()
    --log.log("WinZoneLobbyView:on_after_bind_ref()")
    fun.set_active(self.prefabRoot, false)
    fun.set_active(self.btn_close, false)
    fun.set_active(self.txtReadCountdown, false)

    self:InitView()
    self.hasInit = true
    if fun.is_not_null(self.anima) then
        --[[
        local task = function()
            log.log("WinZoneLobbyView:on_after_bind_ref() play anima 2")
            local animStateName = "start"
            local animClipName = "WinZoneLobbyViewstart"
            if self.curGameState == Const.GameStates.joinRoom then
                animStateName = "start2"
                animClipName = "WinZoneLobbyViewstart2"
            end
            AnimatorPlayHelper.Play(self.anima, {animStateName, animClipName}, false, function() 
                self:MutualTaskFinish()
                log.log("WinZoneLobbyView:on_after_bind_ref() play anima 3")
            end)
        end
        log.log("WinZoneLobbyView:on_after_bind_ref() play anima 1")
        self:DoMutualTask(task)
        --]]

        ---[[
        --log.log("WinZoneLobbyView:on_after_bind_ref() play anima 001")
        local animStateName = "start"
        local animClipName = "WinZoneLobbyViewstart"
        if self.curGameState == Const.GameStates.joinRoom then
            animStateName = "start2"
            animClipName = "WinZoneLobbyViewstart2"
            self:register_invoke(function()
                UISound.play("winzoneWelcome")
            end, Const.Welcome0Delay)
        end
        AnimatorPlayHelper.Play(self.anima, {animStateName, animClipName}, false, function() 
            --log.log("WinZoneLobbyView:on_after_bind_ref() play anima 002")
            if self.curGameState == Const.GameStates.joinRoom then
                --undo wait add
                self:PlayVoiceList1()
            end
        end)
        --]]
    end

    UISound.play("winzoneConcentratetransition")
end

function WinZoneLobbyView:PlayVoiceList1()
    self:ClearAllVoiceTimer()
    local delay = 0
    delay = math.max(Const.Welcome1Delay, 0)
    self.voiceTimer1 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneChosen")
    end)
    
    delay = math.max(delay + Const.Welcome2Delay + Const.Welcome1Time, 0)
    self.voiceTimer2 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneReadystart")
    end)

    delay = math.max(delay + Const.Welcome3Delay + Const.Welcome2Time, 0)
    self.voiceTimer3 = LuaTimer:SetDelayFunction(delay, function()
        UISound.play("winzoneGoodluck")
    end)
end

function WinZoneLobbyView:ClearAllVoiceTimer()
    if self.voiceTimer1 then
        LuaTimer:Remove(self.voiceTimer1)
        self.voiceTimer1 = nil
    end

    if self.voiceTimer2 then
        LuaTimer:Remove(self.voiceTimer2)
        self.voiceTimer2 = nil
    end

    if self.voiceTimer3 then
        LuaTimer:Remove(self.voiceTimer3)
        self.voiceTimer3 = nil
    end
end

function WinZoneLobbyView:InitView()
    --log.log("WinZoneLobbyView:InitView()")
    if self.curGameState == Const.GameStates.joinRoom then
        self:InitPlayerJoinState()
    elseif self.curGameState == Const.GameStates.ready then
        self:InitPlayerReadyState()
    elseif self.curGameState == Const.GameStates.waitOtherRelive then
        self:InitReliveState()
    end
end

function WinZoneLobbyView:OnDisable()
    --log.log("WinZoneLobbyView:OnDisable()")
    Facade.RemoveViewEnhance(self)
    self:ClearReadyTimer()
    self:ClearAllVoiceTimer()
    self.hasInit = nil
    self.hasPlayedStartSound = false
    self.topPlayerRemainingTime = nil
end

function WinZoneLobbyView:ShowScreen(contentType)
    --log.log("WinZoneLobbyView:ShowScreen()", contentType)
    --[[
    fun.set_active(self.rect1, false)
    fun.set_active(self.rect2, false)
    fun.set_active(self.rect3, false)
    fun.set_active(self.rect4, false)

    if contentType == Const.LargeScreenContentType.joinProgress then
        fun.set_active(self.rect1, true)
    elseif contentType == Const.LargeScreenContentType.topPlayerInfo then
        fun.set_active(self.rect2, true)
    elseif contentType == Const.LargeScreenContentType.readyCountdown then
        fun.set_active(self.rect3, true)
    elseif contentType == Const.LargeScreenContentType.waitOtherRelive then
        fun.set_active(self.rect4, true)
    else
        log.log("WinZoneLobbyView:ShowScreen() contentType unknown ", contentType)
    end
    --]]
    if contentType == Const.LargeScreenContentType.joinProgress then
        AnimatorPlayHelper.Play(self.animaScreen1, {"TV1", "WinZone_imgTV1"}, false, function() end)
    elseif contentType == Const.LargeScreenContentType.topPlayerInfo then
        AnimatorPlayHelper.Play(self.animaScreen1, {"TV2", "WinZone_imgTV2"}, false, function() end)
    elseif contentType == Const.LargeScreenContentType.readyCountdown then
        AnimatorPlayHelper.Play(self.animaScreen1, {"TV3", "WinZone_imgTV3"}, false, function() end)
    elseif contentType == Const.LargeScreenContentType.waitOtherRelive then
        AnimatorPlayHelper.Play(self.animaScreen1, {"TV4", "WinZone_imgTV4"}, false, function() end)
    else
        log.log("WinZoneLobbyView:ShowScreen() contentType unknown ", contentType)
    end
    AnimatorPlayHelper.Play(self.animaScreen2, {"start", "TVChangestart"}, false, function() end)
end

function WinZoneLobbyView:SetGameState(state)
    --log.log("WinZoneLobbyView:SetGameState(state)", state)
    self.curGameState = state
end

function WinZoneLobbyView:on_x_update()
    if not self.hasInit then
        return
    end

    if self.curGameState == Const.GameStates.joinRoom then
        self:OnUpdateJoinState(Time.deltaTime)
    end
end

function WinZoneLobbyView:SetData(data)
    --log.log("WinZoneLobbyView:SetData(data)", data)
    self.data = data 
end

--初始玩家join room的状态，进度
function WinZoneLobbyView:InitPlayerJoinState()
    --log.log("WinZoneLobbyView:InitPlayerJoinState()")
    fun.clear_all_child(self.featureRoot)
    self.joinedNum = 0
    self.waittingJoinNum = 0
    local currTime = ModelList.PlayerInfoModel.get_cur_server_time()
    local joinPlayers = DeepCopy(ModelList.WinZoneModel:GetJoinPlayers())

    for i, v in ipairs(joinPlayers) do
        if v.joinTime > currTime then
            self.waittingJoinNum = self.waittingJoinNum + 1
        else
            self.joinedNum = self.joinedNum + 1
        end
    end

    self:ShowScreen(Const.LargeScreenContentType.joinProgress)
    self:UpdateJoinProgress()

    joinPlayers = self:FillSomePlaceHolderPlayerJoin(joinPlayers)
    if Const.UseFrameCreateAvatar then
        self:CreatePlayersAvatarJoinV2(joinPlayers, currTime)
    else
        self:CreatePlayersAvatarJoinV1(joinPlayers, currTime)
    end
end

function WinZoneLobbyView:FillSomePlaceHolderPlayerJoin(joinPlayers)
    if Const.UsePlaceholderPlayer then
        if joinPlayers and #joinPlayers % Const.PlayerCountPerRow ~= 0 then
            local num = Const.PlayerCountPerRow - (#joinPlayers % Const.PlayerCountPerRow)
            for i = 1, num do
                local item = {}
                item.role = self:CreatePlaceholderPlayer()
                item.joinTime = 0
                table.insert(joinPlayers, item)
            end
        end
    end

    return joinPlayers
end

function WinZoneLobbyView:CreatePlaceholderPlayer()
    return Const.PlaceholderPlayer
end

function WinZoneLobbyView:CreatePlayersAvatarJoinV1(joinPlayers, currTime)
    for i, v in ipairs(joinPlayers) do
        local avatar = self:CreateAvatar(v.role)
        if v.role.status == Const.PlayerStates.placeholder then
            avatar:ShowEmpty()
        else
            if v.joinTime > currTime then
                avatar:ShowEmpty()
                avatar:WaittingJoin(v.joinTime - currTime)
            else
                avatar:ShowFull()
            end
    
            avatar:SetIndex(i)
        end
    end

    if self.waittingJoinNum == 0 then
        self:AllPlayerJoinRoomFinish()
    end
end

function WinZoneLobbyView:CreatePlayersAvatarJoinV2(joinPlayers, currTime)
    coroutine.start(function()
        for i, v in ipairs(joinPlayers) do
            local avatar = self:CreateAvatar(v.role)
            if v.role.status == Const.PlayerStates.placeholder then
                avatar:ShowEmpty()
            else
                if v.joinTime > currTime then
                    avatar:ShowEmpty()
                    avatar:SetJoinDelay(v.joinTime - currTime)
                else
                    avatar:ShowFull()
                end
    
                avatar:SetIndex(i) --有序为前提
            end
            --WaitForSeconds(0.3)
            WaitForEndOfFrame()
        end

        Facade.SendNotification(NotifyName.WinZone.AllAvatarCreateFinish)
        if self.waittingJoinNum == 0 then
            self:AllPlayerJoinRoomFinish()
        end
    end)
end

--初始玩家ready的状态（倒计时5s）
function WinZoneLobbyView:InitPlayerReadyState()
    --log.log("WinZoneLobbyView:InitPlayerReadyState()")
    fun.clear_all_child(self.featureRoot)
    local playerList = DeepCopy(ModelList.WinZoneModel:GetPlayerList())
    playerList = self:FillSomePlaceHolderPlayerReady(playerList)
    if Const.UseFrameCreateAvatar then
        coroutine.start(function()
            --剔除已经淘汰的玩家
            for i, v in ipairs(playerList) do
                if v.status == Const.PlayerStates.ready or v.status == Const.PlayerStates.promote or v.status == Const.PlayerStates.relive then
                    local avatar = self:CreateAvatar(v)
                    avatar:ShowFull()
                    --WaitForSeconds(0.3)
                    WaitForEndOfFrame()
                elseif v.status == Const.PlayerStates.placeholder then
                    local avatar = self:CreateAvatar(v)
                    avatar:ShowEmpty()
                    WaitForEndOfFrame()
                end
            end

            self:StartCountdown()
        end)
    else
        --剔除已经淘汰的玩家
        for i, v in ipairs(playerList) do
            if v.status == Const.PlayerStates.ready or v.status == Const.PlayerStates.promote or v.status == Const.PlayerStates.relive then
                local avatar = self:CreateAvatar(v)
                avatar:ShowFull()
            elseif v.status == Const.PlayerStates.placeholder then
                local avatar = self:CreateAvatar(v)
                avatar:ShowEmpty()
            end
        end

        self:StartCountdown()
    end
end

function WinZoneLobbyView:FillSomePlaceHolderPlayerReady(playerList)
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

function WinZoneLobbyView:InitReliveState()
    fun.clear_all_child(self.featureRoot)
    self:ShowScreen(Const.LargeScreenContentType.waitOtherRelive)
    self.relivedNum = 0
    self.waittingReliveNum = 0
    local playerList, waitReliveCount = ModelList.WinZoneModel:GetPlayerPromoteList()
    local reliveTimeLimit = self:GetReliveTimeLimit()
    local finalReliveIndex = 0
    for i, v in ipairs(playerList) do
        if v.reliveTime then
            if v.reliveTime > reliveTimeLimit then
                self.waittingReliveNum = self.waittingReliveNum + 1
                finalReliveIndex = i
            else
                self.relivedNum = self.relivedNum + 1
            end
        end
    end

    playerList = self:FillSomePlaceHolderPlayerRelive(DeepCopy(playerList))
    if Const.UseFrameCreateAvatar then
        self:CreatePlayersAvatarReliveV2(playerList, reliveTimeLimit, finalReliveIndex)
    else
        self:CreatePlayersAvatarReliveV1(playerList, reliveTimeLimit, finalReliveIndex)
    end
end

function WinZoneLobbyView:FillSomePlaceHolderPlayerRelive(playerList)
    if Const.UsePlaceholderPlayer then
        if playerList and #playerList % Const.PlayerCountPerRow ~= 0 then
            local num = Const.PlayerCountPerRow - (#playerList % Const.PlayerCountPerRow)
            for i = 1, num do
                local item = {}
                item.role = self:CreatePlaceholderPlayer()
                table.insert(playerList, item)
            end
        end
    end

    return playerList
end

function WinZoneLobbyView:CreatePlayersAvatarReliveV1(playerList, reliveTimeLimit, finalReliveIndex)
    for i, v in ipairs(playerList) do
        local avatar = self:CreateAvatar(v.role)
        if v.reliveTime then
            if v.reliveTime > reliveTimeLimit then
                avatar:ShowEmpty()
                avatar:WaittingRelive(v.reliveTime - reliveTimeLimit)
                avatar:SetIndex(i, i == finalReliveIndex)
            else
                avatar:ShowFull()
                avatar:SetIndex(i)
            end
        else
            if v.role.status == Const.PlayerStates.placeholder then
                avatar:ShowEmpty()
            else
                avatar:ShowFull()
            end
            avatar:SetIndex(i)
        end
    end

    if self.waittingReliveNum == 0 then
        self:PlayerReliveFinish()
    end
end

function WinZoneLobbyView:CreatePlayersAvatarReliveV2(playerList, reliveTimeLimit, finalReliveIndex)
    coroutine.start(function()
        for i, v in ipairs(playerList) do
            local avatar = self:CreateAvatar(v.role)
            if v.reliveTime then
                if v.reliveTime > reliveTimeLimit then
                    avatar:ShowEmpty()
                    avatar:SetReliveDelay(v.reliveTime - reliveTimeLimit)
                    avatar:SetIndex(i, i == finalReliveIndex)
                else
                    avatar:ShowFull()
                    avatar:SetIndex(i)
                end
            else
                if v.role.status == Const.PlayerStates.placeholder then
                    avatar:ShowEmpty()
                else
                    avatar:ShowFull()
                end
                avatar:SetIndex(i)
            end
            --WaitForSeconds(2)
            WaitForEndOfFrame()
        end

        Facade.SendNotification(NotifyName.WinZone.AllAvatarCreateFinish)
        if self.waittingReliveNum == 0 then
            self:PlayerReliveFinish()
        end
    end)
end

function WinZoneLobbyView:GetReliveTimeLimit()
    return Const.ReliveTimeLimit
end

--启动ready定时器
function WinZoneLobbyView:StartCountdown(leftTime)
    self:ClearAllVoiceTimer()
    self:ShowScreen(Const.LargeScreenContentType.readyCountdown)
    self.readyEndTime = leftTime or Const.ReadCountDownTime
    self:ClearReadyTimer()
    if self.readyEndTime > 0 then
        UISound.play("winzoneAboutBegin")
        self.readyLoopTimer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.img_countdown and self.readyEndTime then
                self.readyEndTime = self.readyEndTime - 1
                if self.readyEndTime <= 1 and not self.hasPlayedStartSound then
                    UISound.play("winzoneCompetitionstart")
                    self.hasPlayedStartSound = true
                end        

                if self.readyEndTime <= 0 then
                    self.img_countdown.text = 0
                    self:ReadyCountdownFinish()
                    --UISound.play("winzoneCompetitionstart")
                else
                    UISound.play("winzoneCountdown")
                    self.img_countdown.text = self.readyEndTime
                end
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    else
        self.img_countdown.text = 0
        self:ReadyCountdownFinish()
    end
end

--clear ready定时器
function WinZoneLobbyView:ClearReadyTimer()
    --log.log("WinZoneLobbyView:ClearReadyTimer()")
    if self.readyLoopTimer then
        LuaTimer:Remove(self.readyLoopTimer)
        self.readyLoopTimer = nil
    end 
end

--结束ready状态（倒计时5s）
function WinZoneLobbyView:ReadyCountdownFinish()
    --log.log("WinZoneLobbyView:ReadyCountdownFinish()")
    self:ClearReadyTimer()
    self.readyEndTime = nil

    ModelList.WinZoneModel:C2S_VictoryBeatsPlay()
end

--从其他状态切换到ready状态（join,复活）
function WinZoneLobbyView:SwitchToReadyState()
    --log.log("WinZoneLobbyView:SwitchToReadyState()")
    if self.curGameState == Const.GameStates.joinRoom then
        --log.log("inZoneLobbyView:SwitchToReadyState 进入房间完成")
    elseif self.curGameState == Const.GameStates.waitOtherRelive then
        --log.log("inZoneLobbyView:SwitchToReadyState 玩家复活完成")
    end
    self.curGameState = Const.GameStates.ready
    self:StartCountdown()
end

function WinZoneLobbyView:CreateAvatar(data)
    local item = WinZoneAvatarItem1:New()
    item:SetData(data)
    local itemGo = fun.get_instance(self.featurePrefab, self.featureRoot)
    fun.set_active(itemGo, true)
    item:SkipLoadShow(itemGo)

    return item
end

function WinZoneLobbyView:SetAvatarInfo(gameObject, data)
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

    imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi01")

    --明星标志
    if data.isTop then
        fun.set_active(flagTop, true)
        imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi02")
    else
        fun.set_active(flagTop, false)
    end

    --buff标志
    if data.gameProps and fun.is_include(Const.BuffId1, data.gameProps) then
        imgFrame1.sprite = AtlasManager:GetSpriteByName("WinZoneLobbyAtlas","WinzonFramesDi03")
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

function WinZoneLobbyView:SetTopPlayerAvatarInfo(gameObject, data)
    self:SetAvatarInfo(gameObject, data)
    local ref = fun.get_component(gameObject, fun.REFER)
    local flagTop = ref:Get("imgFlag1")
    fun.set_active(flagTop, false)
end

function WinZoneLobbyView:CloseSelf()
    --log.log("WinZoneLobbyView:CloseSelf()")
    Facade.SendNotification(NotifyName.WinZone.CloseLobbyView)
    if fun.is_not_null(self.anima) then
        local task = function()
            --log.log("WinZoneLobbyView:CloseSelf() 1 play anima 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneLobbyViewend"}, false, function()
                --log.log("WinZoneLobbyView:CloseSelf() 1 play anima 3")
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        --log.log("WinZoneLobbyView:CloseSelf() 1 play anima 1")
        self:DoMutualTask(task)
    else
        --log.log("WinZoneLobbyView:CloseSelf() 0 no anima")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZoneLobbyView:on_btn_close_click()
    --log.log("WinZoneLobbyView:on_btn_close_click()")
    self:CloseSelf()
end

function WinZoneLobbyView:on_btn_help_click()
    --log.log("WinZoneLobbyView:on_btn_help_click()")
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneExplainView)
end

--所有玩家都已加入房间了
function WinZoneLobbyView:AllPlayerJoinRoomFinish()
    --log.log("WinZoneLobbyView:AllPlayerJoinRoomFinish()")
    if self.topPlayerRemainingTime and self.topPlayerRemainingTime > 0 then
        self:register_invoke(function()
                self:SwitchToReadyState()
            end,
            self.topPlayerRemainingTime + 0.5
        )
    else
        self:SwitchToReadyState()
    end
end

--复活环节已经完成
function WinZoneLobbyView:PlayerReliveFinish()
    --log.log("WinZoneLobbyView:PlayerReliveFinish()")
    self:SwitchToReadyState()
end

function WinZoneLobbyView:UpdateJoinProgress()
    self.txtNumerator.text = self.joinedNum
    self.txtDenominator.text = self.joinedNum + self.waittingJoinNum
    --self.txtDesc1.text = "USERS JOINED"
end

function WinZoneLobbyView:PlayNormalPlayerJoin()
    
end

function WinZoneLobbyView:OnUpdateJoinState(deltaTime)
    if self.topPlayerRemainingTime then
        self.topPlayerRemainingTime = self.topPlayerRemainingTime - deltaTime 
        if self.topPlayerRemainingTime <= 0 then
            --明星头像面板可以消失了
            self:ShowScreen(Const.LargeScreenContentType.joinProgress)
            self.topPlayerRemainingTime = nil
        end
    end
end

function WinZoneLobbyView:PlayTopPlayerJoin(detail)
    self:SetTopPlayerAvatarInfo(self.topFeature, detail)
    if self.topPlayerRemainingTime then
        --self.topPlayerRemainingTime = self.topPlayerRemainingTime + Const.TopPlayerDisplayTime
        self.topPlayerRemainingTime = Const.TopPlayerDisplayTime
    else
        self.topPlayerRemainingTime = Const.TopPlayerDisplayTime
        fun.set_active(self.rect2, true)
        self:ShowScreen(Const.LargeScreenContentType.topPlayerInfo)
    end
end

function WinZoneLobbyView:OnPlayerJoinRoom(params)
    UISound.play("winzonePlayerjoin")
    --params.index
    self.joinedNum = self.joinedNum + 1
    self.waittingJoinNum = self.waittingJoinNum - 1
    self:UpdateJoinProgress()
    if params.isTop then
        self:PlayTopPlayerJoin(params.detail)
    else
        self:PlayNormalPlayerJoin()
    end

    if self.waittingJoinNum == 0 then
    --if params.isLast then
        self:AllPlayerJoinRoomFinish()
    end
end

function WinZoneLobbyView:OnReadyPlaySucc()
    --log.log("WinZoneLobbyView:OnReadyPlaySucc()")
    ModelList.WinZoneModel:EnterGameHall()
    self:CloseSelf()
end

--处理已知失败的情况
function WinZoneLobbyView:OnReadyPlayFail(params)
    --log.log("WinZoneLobbyView:OnReadyPlayFail some thing error ", params)
    if params.errorCode == RET.RET_VICTORY_BEATS_NO_GAME_INFO then --7252 没有正在进行的游戏
        --log.log("WinZoneLobbyView:OnReadyPlayFail errorCode 7252 没有正在进行的游戏")
        self:CloseSelf()
    elseif params.errorCode == RET.RET_VICTORY_BEATS_WRONG_USER_TIMELINE then --7253 时间线错误，用户完成了Join或者对局结束才能进行Play操作，否则返回该错误
        --log.log("WinZoneLobbyView:OnReadyPlayFail errorCode 7253 时间线错误")
        self:CloseSelf()
    elseif params.errorCode == RET.RET_VICTORY_BEATS_DISUSED then --7255 用户已经被淘汰，不能进行Play
        --log.log("WinZoneLobbyView:OnReadyPlayFail errorCode 7255 用户已经被淘汰")
        --self:CloseSelf()
        ModelList.WinZoneModel:C2S_VictoryBeatsExit()
    elseif params.errorCode == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then --7251 进入对战时间已过期、淘汰，走退出逻辑
        local descId = 8045
        UIUtil.show_common_popup(descId, true, function()
            --[[
            if ModelList.WinZoneModel:HasReward() then
                ModelList.WinZoneModel:C2S_VictoryBeatsReward()
            else    --无奖励 只能做退出操作了
                ModelList.WinZoneModel:C2S_VictoryBeatsExit()
            end
            --]]

            --有奖无奖可统一这么调
            ModelList.WinZoneModel:C2S_VictoryBeatsExit()
        end)
    else
        --log.log("WinZoneLobbyView:OnReadyPlayFail errorCode 未知", params)
        self:CloseSelf()
    end
end

function WinZoneLobbyView:OnPlayerRelive(params)
    UISound.play("winzonePlayerjoin")
    --params.index
    self.relivedNum = self.relivedNum + 1
    self.waittingReliveNum = self.waittingReliveNum - 1

    if self.waittingReliveNum == 0 then
    --if params.isLast then
        self:PlayerReliveFinish()
    end
end

function WinZoneLobbyView:OnExitMatch(params)
    --log.log("WinZoneLobbyView:OnExitMatch(params)", params)
    if fun.is_table_empty(params.reward) then
        self:CloseSelf()
    else
        ModelList.WinZoneModel:DisplayReward(params.reward, function() self:CloseSelf() end)
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.PlayerJoinRoom, func = this.OnPlayerJoinRoom},
    {notifyName = NotifyName.WinZone.ReadyPlaySucc, func = this.OnReadyPlaySucc},
    {notifyName = NotifyName.WinZone.ReadyPlayFail, func = this.OnReadyPlayFail},
    {notifyName = NotifyName.WinZone.PlayerRelive, func = this.OnPlayerRelive},
    {notifyName = NotifyName.WinZone.Exit, func = this.OnExitMatch},
}

return this