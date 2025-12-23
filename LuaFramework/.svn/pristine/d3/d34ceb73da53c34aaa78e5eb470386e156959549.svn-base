local VolcanoMissionMatchView = BaseDialogView:New('VolcanoMissionMatchView', "VolcanoMissionPosterAtlasInMain")
local this = VolcanoMissionMatchView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "Description",
    "PlayersRoot",
    "SelfPlayerCtrl",
    "PlayerCount",
    "btn_continue",
    "anima",
    "RewardItem",
    "CompleteEffect",
    "RemainTime"
}

function VolcanoMissionMatchView:Awake(obj)
    self:on_init()
end

function VolcanoMissionMatchView:on_after_bind_ref()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "VolcanoMissionMatchView_start"}, false, function()
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
    end
    fun.set_active(self.btn_continue, false)
end

function VolcanoMissionMatchView:OnEnable()
    self.Description.text = Csv.GetData("description", 8063, "description")
    self.PlayerCount.text = string.format("%s/%s", 0, 0)
    fun.set_active(self.CompleteEffect, false)
    fun.set_active(self.btn_continue, false)
    fun.set_active(self.PlayersRoot, false)

    self:StartRemainTime()
    self:StartPlayerGather()
    self:ShowFinalReward()
    self:ClearMutualTask()
    ModelList.VolcanoMissionModel:ResetLevelData()
end

function VolcanoMissionMatchView:CloseSelf(cb)
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "VolcanoMissionMatchView_end"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.HideDialog, self)
                if cb then cb() end
            end)
        end
        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.HideDialog, self)
        if cb then cb() end
    end
end

function VolcanoMissionMatchView:OnDisable()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function VolcanoMissionMatchView:StartRemainTime()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
    else
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end

    local remainTime = ModelList.VolcanoMissionModel:GetRemainTime() + 1
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt7, remainTime, self.RemainTime, function()
        local isAvailable = ModelList.VolcanoMissionModel:IsOpenActivity()
        if not isAvailable then
            self:CloseSelf()
        end
    end)
end

--开始玩家集合动画
function VolcanoMissionMatchView:StartPlayerGather()
    self.gatherComplete = false
    self:ShowSelfPlayerCtrl()
    
    local players = ModelList.VolcanoMissionModel:GetMapMembers()
    players = table.values(players) --只需要value,不需要key
    local playerCount = GetTableLength(players)
    if playerCount > 0 then
        local poolSize = fun.get_child_count(self.PlayersRoot)
        for i = 1, playerCount do
            local playerCtrl
            if i <= poolSize then
                playerCtrl = fun.get_child(self.PlayersRoot, i - 1)
            end
            if fun.is_not_null(playerCtrl) then
                self:SetPlayerInfo(players[i], playerCtrl)
            end
        end
        
        local totalCount = playerCount + 1
        self.PlayerCount.text = string.format("%s/%s", 0, totalCount)
        
        coroutine.start(function()
            coroutine.wait(0.2)
            
            local tween = Anim.do_smooth_float_update(0, totalCount, 1.5, function(cur)
                cur = math.floor(cur)
                self.PlayerCount.text = string.format("%s/%s", cur, totalCount)
            end)
            tween:SetEase(DG.Tweening.Ease.InQuad)
            
            fun.set_active(self.PlayersRoot, true)
            UISound.play("missionmatch")
            
            coroutine.wait(1.4)
            UISound.play("missionnumbercomplete")
            fun.set_active(self.CompleteEffect, true)
        end)
        
        AnimatorPlayHelper.Play(self.anima, {"match", "VolcanoMissionMatchView_match"}, false, function()
            fun.set_active(self.btn_continue, true)
            self.gatherComplete = true
        end)
    else
        self.gatherComplete = true
    end
end

function VolcanoMissionMatchView:ShowSelfPlayerCtrl()
    local refer = fun.get_component(self.SelfPlayerCtrl, fun.REFER)
    
    local usingHeadIconId = ModelList.PlayerInfoSysModel.GetUsingHeadIconID()
    local headIconCtrl = refer:Get("HeadIcon")
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(usingHeadIconId, headIconCtrl)
    
    local usingFrameIconId = ModelList.PlayerInfoSysModel.GetUsingFrameIconID()
    local HeadFrameCtrl = refer:Get("HeadFrame")
    Cache.SetImageSprite("HeadIconFrameAtlas", usingFrameIconId, HeadFrameCtrl, true)
    
    fun.set_active(self.SelfPlayerCtrl, true)
    Anim.scale_to_xy(self.SelfPlayerCtrl, 0.85, 0.85, 0.2)
end

function VolcanoMissionMatchView:SetPlayerInfo(playerData, playerCtrl)
    if not playerData then
        return
    end
    
    local refer = fun.get_component(playerCtrl, fun.REFER)
    
    local cfg = Csv.GetData("robot_name", playerData.uid)
    if cfg then
        playerData.avatar = playerData.avatar or cfg.icon
        playerData.frame = cfg.edge
    end

    if tonumber(playerData.avatar) ~= nil then
        --玩家的数据存储的时avatarID
        playerData.avatar = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(playerData.avatar)
    end
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(playerData.avatar, refer:Get("HeadIcon"))
    
    if tonumber(playerData.frame) ~= nil then
        --玩家的数据存储的时FrameID
        playerData.frame = ModelList.PlayerInfoSysModel:GetConfigFrameIconName(playerData.frame)
    end
    Cache.SetImageSprite("HeadIconFrameAtlas", playerData.frame, refer:Get("HeadFrame"), true)
    
    fun.set_active(playerCtrl, true)
end

function VolcanoMissionMatchView:ShowFinalReward()
    local curMapID = ModelList.VolcanoMissionModel:GetMapId()
    
    local finalReward
    table.each(Csv["volcano_round"], function(cfg)
        if cfg.map == curMapID then
            if cfg.reward_final[1][1] ~= 0 then
                finalReward = cfg.reward_final
            end
        end
    end)

    fun.eachChild(self.RewardItem.parent, function(child)
        fun.set_active(child, false)
    end)

    table.each(finalReward, function(reward)
        local itemCtrl = fun.get_instance(self.RewardItem, self.RewardItem.parent)
        fun.set_active(itemCtrl, true)
        
        local refer = fun.get_component(itemCtrl, fun.REFER)
        local icon, count = refer:Get("Icon"), refer:Get("Count")

        local itemIcon = Csv.GetItemOrResource(reward[1], "big_icon")
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIcon)
        count.text = fun.format_number(reward[2])
    end)
end

function VolcanoMissionMatchView:on_btn_continue_click()
    if not self.gatherComplete then
        return
    end

    self:CloseSelf(function()

        ---判断是否当日首次
        local isDayFirst = false
        local popDay = fun.read_value("volcanomission_popday","")
        local currentDate = os.date("%Y-%m-%d")
        if (popDay == "" or popDay ~= currentDate) then
            isDayFirst = true
        end

        --进入活动主界面
        if isDayFirst then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionMainView)
        else
            Event.Brocast(EventName.Event_VolcanoMission_PopuEnd)
        end
    end)
end

this.NotifyEnhanceList = {
     {notifyName = NotifyName.GamePlayShortPassView.UpdateExpInfo, func = this.SetProgress},
}

return this







