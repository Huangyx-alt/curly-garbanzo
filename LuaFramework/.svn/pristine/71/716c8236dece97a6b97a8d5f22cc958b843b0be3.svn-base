local Const = require "View/WinZone/WinZoneConst"
local WinZoneRecordView = BaseDialogView:New('WinZoneRecordView', "WinZoneRecordAtlas")
local this = WinZoneRecordView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "prefabRoot",
    "scrollContent",
    "roundItem",
    "anima",
    "scrollRect",
    "btn_ok",
    "txtHeader1",
    "txtHeader2",
    "txtHeader3",
}

local RoundBgImgs = {
    "WinzoneZJbgDi01", --round1
    "WinzoneZJbgDi02", --round2
    "WinzoneZJbgDi03", --round3
    "WinzoneZJbgDi04", --round4
    "WinzoneZJbgDi05", --round5
    "WinzoneZJbgDi06", --round6
    "WinzoneZJbgDi07", --round7
    "WinzoneZJbgDi08", --round8
    "WinzoneZJbgDi09", --round9
}

function WinZoneRecordView:SetConfirmCallback(cb)
    log.log("WinZoneRecordView:SetConfirmCallback ", self.confirmCb == nil)
    self.confirmCb = cb
end

function WinZoneRecordView:SetEnterMode(enterMode)
    log.log("WinZoneRecordView:SetEnterMode ", enterMode, self.enterMode == nil)
    self.enterMode = enterMode
end

function WinZoneRecordView:Awake()
end

function WinZoneRecordView:OnEnable()
    Facade.RegisterViewEnhance(self)
    Event.AddListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self:ClearMutualTask()
end

function WinZoneRecordView:on_after_bind_ref()
    self:InitView()
end

function WinZoneRecordView:InitView()
    log.log("WinZoneRecordView:InitView")
    fun.set_active(self.prefabRoot, false)
    fun.clear_all_child(self.scrollContent)
    self.scrollRect.horizontal = false
    local records = ModelList.WinZoneModel:GetRecord()
    --[[
    local FakeData = require "View/WinZone/WinZoneFakeData"
    local records = FakeData.dataSettle_4.roundResult
    --]]
    if records then
        for i, v in ipairs(records) do
            self:CreateRoundItem(i, v)
        end
        self.scrollRect.vertical = #records > 9
    end

    if fun.is_not_null(self.anima) then
        --[[
        log.log("WinZoneRecordView:InitView play anima 0")
        local task = function()
            log.log("WinZoneRecordView:InitView play anima 1")
            AnimatorPlayHelper.Play(self.anima, {"enter", "WinZoneRecordViewenter"}, false, function()
                self:MutualTaskFinish()
                log.log("WinZoneRecordView:InitView play anima 2")
            end)
        end

        self:DoMutualTask(task)
        --]]
        log.log("WinZoneRecordView:InitView play anima 001")
        AnimatorPlayHelper.Play(self.anima, {"enter", "WinZoneRecordViewenter"}, false, function()
            log.log("WinZoneRecordView:InitView play anima 002")
        end)
    end

    UISound.play("winzoneDetails")
end

function WinZoneRecordView:OnDisable()
    log.log("WinZoneRecordView:OnDisable")
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self.confirmCb = nil
    self.enterMode = nil
end

function WinZoneRecordView:CloseSelf()
    log.log("WinZoneRecordView:CloseSelf 0")
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZoneRecordView:CloseSelf 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "WinZoneRecordViewend"}, false, function()
                self:MutualTaskFinish()
                log.log("WinZoneRecordView:CloseSelf 3")
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        log.log("WinZoneRecordView:CloseSelf 1")
        self:DoMutualTask(task)
    else
        log.log("WinZoneRecordView:CloseSelf 5")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZoneRecordView:CreateRoundItem(index, data)
    log.log("WinZoneRecordView:CreateRoundItem", index, data)
    if not data or fun.is_table_empty(data) then
        log.log("WinZoneRecordView:CreateRoundItem 数据有错", index, data)
        return
    end
    local itemGo = fun.get_instance(self.roundItem, self.scrollContent)
    local ref = fun.get_component(itemGo, fun.REFER)
    local imgItemBg1 = ref:Get("imgItemBg1")
    local txtRound = ref:Get("txtRound")
    local stateRoot = ref:Get("stateRoot")
    local txtRank = ref:Get("txtRank")
    local imgState1 = ref:Get("imgState1")
    local imgState2 = ref:Get("imgState2")
    local imgNote = ref:Get("imgNote")
    local txtNote = ref:Get("txtNote")

    imgItemBg1.sprite = AtlasManager:GetSpriteByName("WinZoneRecordAtlas", RoundBgImgs[data.round] or RoundBgImgs[1])
    txtRound.text = "ROUND" .. data.round
    txtRank.text = data.rank
    txtNote.text = data.noteNum
    if data.status == Const.PlayerStates.promote then
        fun.set_active(txtRank, true)
        fun.set_active(imgState1, false)
        fun.set_active(imgState2, false)
    elseif data.status == Const.PlayerStates.disuse then
        fun.set_active(txtRank, false)
        fun.set_active(imgState1, true)
        fun.set_active(imgState2, false)
    elseif data.status == Const.PlayerStates.relive then
        fun.set_active(txtRank, false)
        fun.set_active(imgState1, false)
        fun.set_active(imgState2, true)
    else
        fun.set_active(txtRank, false)
        fun.set_active(imgState1, true)
        fun.set_active(imgState2, false)
    end

    fun.set_active(itemGo, true)
end

function WinZoneRecordView:on_btn_close_click()
    log.log("WinZoneRecordView:on_btn_close_click")
    self:CloseSelf()
end

function WinZoneRecordView:on_btn_ok_click()
    log.log("WinZoneRecordView:on_btn_ok_click")
    if self.confirmCb then
        self.confirmCb()
        self.confirmCb = nil
    else
        log.log("WinZoneRecordView:on_btn_ok_click nothing to do")
    end
end

function WinZoneRecordView:OnClaimReward(params)
    log.log("WinZoneRecordView:OnClaimReward", params, self.enterMode)
    self:CloseSelf()
    if self.enterMode == Const.EnterRecordMode.fromReliveDialog then
        if params.code == RET.RET_SUCCESS then
            if fun.is_table_empty(params.reward) then
                log.log("WinZoneRecordView:OnClaimReward 领奖成功，但数据有问题", params)
            else
                ModelList.WinZoneModel:DisplayReward(params.reward)
            end
        else
            log.log("WinZoneRecordView:OnClaimReward 领奖失败", params)
        end
    elseif self.enterMode == Const.EnterRecordMode.fromPromoteView2 then
        local isTopOne = ModelList.WinZoneModel:GetSelfRank() == 1
        isTopOne = isTopOne and ModelList.WinZoneModel:GetCurRound() > 0 
        isTopOne = isTopOne and  ModelList.WinZoneModel:GetCurRound() ==  ModelList.WinZoneModel:GetTotalRound()
        if params.code == RET.RET_SUCCESS then
            if fun.is_table_empty(params.reward) then
                log.log("WinZonePromoteView2:OnClaimReward 领奖成功，但数据有问题", params)
            else
                ModelList.WinZoneModel:DisplayReward(params.reward, nil, isTopOne)
            end
        else
            log.log("WinZonePromoteView2:OnClaimReward 领奖失败", params)
        end
        fun.set_active(self.btn_continue, true)
    end
end

function WinZoneRecordView:OnExitMatch(params)
    log.log("WinZoneRecordView:OnExitMatch(params)", params, self.enterMode)
    self:CloseSelf()
    if self.enterMode == Const.EnterRecordMode.fromReliveDialog then
        if not fun.is_table_empty(params.reward) then
            ModelList.WinZoneModel:DisplayReward(params.reward)
        end
    end
end

function WinZoneRecordView:OnMsgNotReturn(code)
    log.log("WinZoneRecordView:OnMsgNotReturn(code)", code)
    if code == MSG_ID.MSG_VICTORY_BEATS_RELIVE then
        --self:MutualTaskFinish()
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.ClaimReward, func = this.OnClaimReward},
    {notifyName = NotifyName.WinZone.Exit, func = this.OnExitMatch},
}

return this