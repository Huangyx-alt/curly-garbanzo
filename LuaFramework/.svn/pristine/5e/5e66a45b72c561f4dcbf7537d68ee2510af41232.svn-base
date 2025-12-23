local Const = require "View/WinZone/WinZoneConst"
local WinZoneChooseRoundView = BaseDialogView:New('WinZoneChooseRoundView', "WinZoneChooseRoundAtlas")
local this = WinZoneChooseRoundView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "prefabRoot",
    "scrollContent",
    "selectItem",
    "rewardItem",
    "anima",
    "scrollRect",
}

local RoundImgs = {
    "winzonebet05", --1, 3round
    "winzonebet06", --2, 6round
    "winzonebet07", --3, 9round
}

function WinZoneChooseRoundView:Awake()
end

function WinZoneChooseRoundView:OnEnable()
    Facade.RegisterViewEnhance(self)
    Event.AddListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self:ClearMutualTask()
    self.joinBtnList = nil
    self.allowClick = false
    self.isShowRestartDialog = false
    ModelList.WinZoneModel:ClearFinalRankRecord()
end

function WinZoneChooseRoundView:on_after_bind_ref()
    self:InitView()
end

function WinZoneChooseRoundView:InitView()
    --log.log("WinZoneChooseRoundView:InitView")
    fun.set_active(self.prefabRoot, false)
    fun.clear_all_child(self.scrollContent)
    self.scrollRect.horizontal = false
    local data = ModelList.WinZoneModel:GetActivityInfo()
    --[[
    local FakeData = require "View/WinZone/WinZoneFakeData"
    local data = FakeData.dataFetch_1
    --]]
    self.joinBtnList = {}
    self.totalUnlockNum = 0
    self.unlockCount = 0
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local unlockRecord = fun.read_value(Const.ROUND_UNLOCK_RECORD .. playerInfo.uid, {})
    if data and data.rounds then
        for i, v in ipairs(data.rounds) do
            if unlockRecord[i] == false and v.isUnlock then
                self.totalUnlockNum = self.totalUnlockNum + 1
            end
        end

        for i, v in ipairs(data.rounds) do
            self:CreateSelectItem(i, v, unlockRecord[i] == false and v.isUnlock)
        end
        self.scrollRect.vertical = #data.rounds > 3
        self:UpdateUnlockRecord(data.rounds)
    end

    self.allowClick = self.totalUnlockNum == 0

    if fun.is_not_null(self.anima) then
        --log.log("WinZoneChooseRoundView:InitView play anima 0")
        local task = function()
            --log.log("WinZoneChooseRoundView:InitView play anima 1")
            AnimatorPlayHelper.Play(self.anima, {"start", "WinZoneChooseRoundView_start"}, false, function()
                self:MutualTaskFinish()
                --log.log("WinZoneChooseRoundView:InitView play anima 2")
            end)
        end

        self:DoMutualTask(task)
    end
end

function WinZoneChooseRoundView:OnDisable()
    --log.log("WinZoneChooseRoundView:OnDisable")
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    Event.Brocast(NotifyName.WinZone.PopupChooseRoundFinish)

    if self.joinBtnList then
        for i, v in ipairs(self.joinBtnList) do
            if fun.is_not_null(v) then
                self.luabehaviour:RemoveClick(v)
            end
        end
    end
    self.joinBtnList = nil
    self.selectRoundType = nil
    self.allowClick = false
    self.isShowRestartDialog = false
    self.totalUnlockNum = 0
    self.unlockCount = 0
end

function WinZoneChooseRoundView:CloseSelf()
    --log.log("WinZoneChooseRoundView:CloseSelf 0")
    if fun.is_not_null(self.anima) then
        local task = function()
            --log.log("WinZoneChooseRoundView:CloseSelf 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneChooseRoundView_end"}, false, function()
                self:MutualTaskFinish()
                --log.log("WinZoneChooseRoundView:CloseSelf 3")
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        --log.log("WinZoneChooseRoundView:CloseSelf 1")
        self:DoMutualTask(task)
    else
        --log.log("WinZoneChooseRoundView:CloseSelf 5")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZoneChooseRoundView:CreateSelectItem(index, data, isPlayUnlockAnima)
    --log.log("WinZoneChooseRoundView:CreateSelectItem", index, data)
    local itemGo = fun.get_instance(self.selectItem, self.scrollContent)
    local ref = fun.get_component(itemGo, fun.REFER)
    local imgDesc = ref:Get("imgDesc")
    local imgRound = ref:Get("imgRound")
    local btnJoin = ref:Get("btn_join")
    local imgMask = ref:Get("imgMask")
    local rewardPanel = ref:Get("rewardPanel")
    local anima = ref:Get("anima")
    if data.isUnlock then
        if fun.is_null(anima) then
            fun.set_active(imgMask, false)
        else
            if isPlayUnlockAnima then
                --[[此方式得保证一次只能解锁一档
                local task = function()
                    log.log("WinZoneChooseRoundView:CreateSelectItem play unlock anima 2")
                    AnimatorPlayHelper.Play(anima, {"lockact", "WinZoneChooseRoundViewselectltemlockact"}, false, function()
                        self:MutualTaskFinish()
                        log.log("WinZoneChooseRoundView:CreateSelectItem play unlock anima 3")
                    end)
                end
                log.log("WinZoneChooseRoundView:CreateSelectItem play unlock anima 1")
                self:DoMutualTask(task)
                --]]
                self.unlockCount = self.unlockCount + 1
                self:register_invoke(function()
                    UISound.play("winzoneUnlock")
                end, 1)
                AnimatorPlayHelper.Play(anima, {"lockact", "WinZoneChooseRoundViewselectltemlockact"}, false, function() 
                    if self.unlockCount == self.totalUnlockNum then
                        self.allowClick = true
                        self.isShowRestartDialog = true
                        ViewList.WinZoneRestartDialog:SetLastRoundType(data.roundType)
                        ViewList.WinZoneRestartDialog:SetShowType(Const.ShowRestartDialogMode.upgrade)
                        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRestartDialog)
                    end
                end)
            else
                AnimatorPlayHelper.Play(anima, {"unlock", "WinZoneChooseRoundViewselectltemunlock"}, false, function() end)
            end
        end
    else
        if fun.is_null(anima) then
            fun.set_active(imgMask, true)
        else
            AnimatorPlayHelper.Play(anima, {"lock", "WinZoneChooseRoundViewselectltemlock"}, false, function() end)
        end
    end

    self.luabehaviour:AddClick(btnJoin, function()
        self:PlayBtnClickSound()
        self:OnBtnJoinClick(index, data)
    end)
    imgRound.sprite = AtlasManager:GetSpriteByName("WinZoneChooseRoundAtlas", RoundImgs[data.roundType] or "winzonebet05")

    table.insert(self.joinBtnList, btnJoin)
    fun.clear_all_child(rewardPanel)
    if data.reward then
        for i, v in ipairs(data.reward) do
            self:CreateRewardItem(i, v, rewardPanel)
        end
    end
    fun.set_active(itemGo, true)
end

function WinZoneChooseRoundView:UpdateUnlockRecord(rounds)
    if not rounds then
        return
    end

    local records = {}
    for i, v in ipairs(rounds) do
        records[i] = v.isUnlock
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    fun.save_value(Const.ROUND_UNLOCK_RECORD .. playerInfo.uid, records)
end

function WinZoneChooseRoundView:CreateRewardItem(index, data, parent)
    --log.log("WinZoneChooseRoundView:CreateRewardItem", index, data)
    local itemGo = fun.get_instance(self.rewardItem, parent)
    local ref = fun.get_component(itemGo, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local rewardRoot = ref:Get("rewardRoot")

    local iconName = Csv.GetItemOrResource(data.id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = data.value
    value.text = fun.format_money_reward(data)
    fun.set_active(itemGo, true)
end

function WinZoneChooseRoundView:OnBtnJoinClick(index, data)
    --log.log("WinZoneChooseRoundView:OnBtnJoinClick(index, data) 0", index, data)
    if not self.allowClick then
        return
    end
    --log.log("WinZoneChooseRoundView:OnBtnJoinClick(index, data) 1", index, data)
    local task = function()
        --log.log("WinZoneChooseRoundView:OnBtnJoinClick(index, data) 2", index, data)
        local roundType = data.roundType
        ModelList.WinZoneModel:C2S_VictoryBeatsJoin(roundType)
        self.selectRoundType = roundType
    end
    self:DoMutualTask(task)
end

function WinZoneChooseRoundView:on_btn_close_click()
    --log.log("WinZoneChooseRoundView:on_btn_close_click 0")
    if not self.allowClick then
        return
    end
    --log.log("WinZoneChooseRoundView:on_btn_close_click 1")
    self:CloseSelf()
end

function WinZoneChooseRoundView:on_btn_help_click()
    --log.log("WinZoneChooseRoundView:on_btn_help_click 0")
    if not self.allowClick then
        return
    end
    --log.log("WinZoneChooseRoundView:on_btn_help_click 1")
    Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneExplainView)
end

function WinZoneChooseRoundView:OnSelectRoundSucc(params)
    --log.log("WinZoneChooseRoundView:OnSelectRoundSucc", params)
    Event.Brocast(NotifyName.WinZone.BreakPopupChooseRoundOrder)
    self:MutualTaskFinish()
    self:CloseSelf()

    if self.selectRoundType then
        ModelList.WinZoneModel:RecordSelectRound(self.selectRoundType)
    end

    if not self.isShowRestartDialog then
        ViewList.WinZoneLobbyView:SetGameState(params.nextState)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneLobbyView)
    end
end

function WinZoneChooseRoundView:OnSelectRoundFail(params)
    --log.log("WinZoneChooseRoundView:OnSelectRoundFail some thing error ", params)
    self:MutualTaskFinish()
    if params.errorCode == 16 then --参数错误，没有达到用户等级、vip等级、加入没有解锁的轮制
        self:CloseSelf()
    elseif params.errorCode == RET.RET_ACTIVITY_NOT_ALLOWED then --7001 未完成上一次游戏，不能重复游戏 (有奖励未领取，上一次游戏还在进行中)
        self:CloseSelf()
    end
end

function WinZoneChooseRoundView:OnMsgNotReturn(code)
    --log.log("WinZoneChooseRoundView:OnMsgNotReturn(code)", code)
    if code == MSG_ID.MSG_VICTORY_BEATS_JOIN then
        self:MutualTaskFinish()
    end
end

function WinZoneChooseRoundView:OnRestartDialogClose(params)
    --log.log("WinZoneChooseRoundView:OnRestartDialogClose ", params)
    self.isShowRestartDialog = false
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.SelectRoundSucc, func = this.OnSelectRoundSucc},
    {notifyName = NotifyName.WinZone.SelectRoundFail, func = this.OnSelectRoundFail},
    {notifyName = NotifyName.WinZone.RestartDialogClose, func = this.OnRestartDialogClose},
}

return this