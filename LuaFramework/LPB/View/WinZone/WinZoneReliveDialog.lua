local Const = require "View/WinZone/WinZoneConst"
local WinZoneReliveDialog = BaseDialogView:New('WinZoneReliveDialog', "WinZonePromoteReliveAtlas")
local this = WinZoneReliveDialog
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
--this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "panel1",
    "panel2",
    "panel3",
    "Top",
    "Center",
    "lblItemCount",
    "desc1",
    "desc2",
    "desc3",
    "imgClock",
    "lblCountdown",
    "btn_confirm1",
    "btn_confirm2",
    "btn_confirm3",
    "btn_no",
    "btnDesc1",
    "btnDesc2",
    "btnDesc3",
    "btnDesc4",
    "lblCost1",
    "lblCost2",
    "anima",
    "lblBuyItemCount",
}

local descriptionIds = {
    8046, 8046, 8042
}

local btnDescriptionIds = {
    30110, 30111, 30111, 30111
}

local animaParams = {
    {"start1", "WinZoneReliveDialog_start1", "end1", "WinZoneReliveDialog_end1"},
    {"start2", "WinZoneReliveDialog_start2", "end2", "WinZoneReliveDialog_end2"},
    {"start3", "WinZoneReliveDialog_start3", "end3", "WinZoneReliveDialog_end3"},
}

local animaIdx = 1

function WinZoneReliveDialog:Awake()
end

function WinZoneReliveDialog:OnEnable()
    Facade.RegisterViewEnhance(self)
    Event.AddListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self:ClearMutualTask()
end

function WinZoneReliveDialog:ReportEvent()
    local needCoinCount
    if self.reliveCfg then
        needCoinCount = self.reliveCfg.revivalcoin_num
    end

    local needCashCount
    if self.coinCount and needCoinCount and needCoinCount > self.coinCount then
        needCashCount = self.reliveCfg.price
    end

    SDK.BI_Event_Tracker("victorybeats_reconnect_open",
        {
            totalround = ModelList.WinZoneModel:GetTotalRound(),
            currentround = ModelList.WinZoneModel:GetCurRound(),
            revivalcoin_need = needCoinCount,
            revivalcash_need = needCashCount,
        }
    )
end

function WinZoneReliveDialog:on_after_bind_ref()
    self:InitView()
end

function WinZoneReliveDialog:InitView()
    log.log("WinZoneReliveDialog:InitView")
    ---[[
    for i = 1, #descriptionIds do
        if descriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", descriptionIds[i], "description")
            self["desc" .. i].text = contentStr
        end
    end
    --]]

    --[[
    for i = 1, #btnDescriptionIds do
        if btnDescriptionIds[i] > 0 then
            local contentStr = Csv.GetData("description", btnDescriptionIds[i], "description")
            self["btnDesc" .. i].text = contentStr
        end
    end
    --]]

    fun.set_active(self.panel3, false)
    fun.set_active(self.btn_confirm3, false)
    fun.set_active(self.imgClock, true)
    fun.set_active(self.btn_no, true)
    self:EnableReliveBtn()
    
    self.lblItemCount.text = self.coinCount
    if self.reliveCfg then
        if self.reliveCfg.revivalcoin_num <= self.coinCount then
            fun.set_active(self.panel1, true)
            fun.set_active(self.panel2, false)
            fun.set_active(self.btn_confirm1, true)
            fun.set_active(self.btn_confirm2, false)
            animaIdx = 1
        else
            fun.set_active(self.panel1, false)
            fun.set_active(self.panel2, true)
            fun.set_active(self.btn_confirm1, false)
            fun.set_active(self.btn_confirm2, true)
            animaIdx = 2
        end
        self.lblCost1.text = "X" .. self.reliveCfg.revivalcoin_num
        self.lblCost2.text = "$" .. self.reliveCfg.price
    else

    end

    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZoneReliveDialog:InitView play anima 2")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][1], animaParams[animaIdx][2]}, false, function() 
                log.log("WinZoneReliveDialog:InitView play anima 3")
                self:MutualTaskFinish()
            end)
        end
        log.log("WinZoneReliveDialog:InitView play anima 1")
        self:DoMutualTask(task)
    end
    self:SetLeftTime()
    self:ReportEvent()
end

function WinZoneReliveDialog:SetLeftTime()
    self.startCoundownTime = ModelList.WinZoneModel:GetCurServerTime()
    self:ClearLoopTimer()
    local remainTime1 = self:GetRemainTime()
    if remainTime1 > 0 then
        self.lblCountdown.text = remainTime1 .. "S"
        self.loopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.lblCountdown then
                local remainTime2 = self:GetRemainTime()
                self.lblCountdown.text = remainTime2 .. "S"
                if remainTime2 <= 0 then
                    self:DisableReliveBtn()
                    self:ClearLoopTimer()
                end
                UISound.play("winzoneRevivalcountdown")
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    else
        self.lblCountdown.text = remainTime1 .. "0S"
        self:DisableReliveBtn()
    end
end

function WinZoneReliveDialog:DisableReliveBtn()
    log.log("WinZoneReliveDialog:DisableReliveBtn")
    --fun.enable_button_with_child(self.btn_confirm1, false)
    local btn = fun.get_component(self.btn_confirm1, fun.BUTTON)
	if btn then
		btn.interactable = false
	end
    Util.SetUIImageGray(self.btn_confirm1, true)

    --fun.enable_button_with_child(self.btn_confirm2, false)
    local btn = fun.get_component(self.btn_confirm2, fun.BUTTON)
	if btn then
		btn.interactable = false
	end
    Util.SetUIImageGray(self.btn_confirm2, true)
end

function WinZoneReliveDialog:EnableReliveBtn()
    log.log("WinZoneReliveDialog:EnableReliveBtn")
    local btn = fun.get_component(self.btn_confirm1, fun.BUTTON)
	if btn then
		btn.interactable = true
	end
    Util.SetUIImageGray(self.btn_confirm1, false)

    local btn = fun.get_component(self.btn_confirm2, fun.BUTTON)
	if btn then
		btn.interactable = true
	end
    Util.SetUIImageGray(self.btn_confirm2, false)
end

function WinZoneReliveDialog:GetRemainTime()
    local expireTime = ModelList.WinZoneModel:GetLastPlayTime()
    local currentTime = ModelList.WinZoneModel:GetCurServerTime()
    local cfgTime = self.reliveCfg and self.reliveCfg.revival_time or 30
    local startCoundownTime = self.startCoundownTime or currentTime
    local remain = expireTime - currentTime
    if remain > cfgTime + startCoundownTime - currentTime then
        remain = cfgTime + startCoundownTime - currentTime
    end

    if remain < 0 then
        remain = 0
    end

    return remain
end

function WinZoneReliveDialog:ClearLoopTimer()
    if self.loopTime  then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function WinZoneReliveDialog:OnDisable()
    log.log("WinZoneReliveDialog:OnDisable")
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener("MSG_NOT_RETURN", self.OnMsgNotReturn, self)
    self:ClearLoopTimer()
    self.isPurchaseSucc = nil
    self.data = nil
end

function WinZoneReliveDialog:SetData(data)
    log.log("WinZoneReliveDialog:SetData(data)", data)
    self.data = data
    self.coinCount = ModelList.WinZoneModel:GetReliveCoinCount()
    if data then
        self.reliveCfg = ModelList.WinZoneModel:GetReliveCfg(data.reliveTimes or 1, data.allRound)
    end
end

function WinZoneReliveDialog:CloseSelf()
    log.log("WinZoneReliveDialog:CloseSelf 000")
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZoneReliveDialog:CloseSelf 111")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][3], animaParams[animaIdx][4]}, false, function() 
                self:MutualTaskFinish()
                log.log("WinZoneReliveDialog:CloseSelf 222")
                Facade.SendNotification(NotifyName.HideDialog, self)
            end)
        end

        self:DoMutualTask(task)
    else
        log.log("WinZoneReliveDialog:CloseSelf 333")
        Facade.SendNotification(NotifyName.HideDialog, self)
    end
end

--处理用户放弃复活或复活失败后的流程
function WinZoneReliveDialog:HandleCancelRelive()
    log.log("WinZoneReliveDialog:HandleCancelRelive")
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
        ViewList.WinZoneRecordView:SetEnterMode(Const.EnterRecordMode.fromReliveDialog)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRecordView)
        self:CloseSelf()
    end
end

function WinZoneReliveDialog:ReqRelive()
    log.log("WinZoneReliveDialog:ReqRelive")
    local task = function()
        ModelList.WinZoneModel:C2S_VictoryBeatsRelive()
    end
    self:DoMutualTask(task)
end

function WinZoneReliveDialog:on_btn_confirm1_click()
    log.log("WinZoneReliveDialog:on_btn_confirm1_click")
    self:ReqRelive()
end

function WinZoneReliveDialog:on_btn_confirm2_click()
    log.log("WinZoneReliveDialog:on_btn_confirm2_click")
    local task = function()
        if self.reliveCfg and self.reliveCfg.id then
            ModelList.WinZoneModel:PurchaseReliveCoin(self.reliveCfg.id)
        else
            self:MutualTaskFinish()
        end
    end
    self:DoMutualTask(task)
end

function WinZoneReliveDialog:on_btn_confirm3_click()
    log.log("WinZoneReliveDialog:on_btn_confirm3_click")
    self.coinCount = ModelList.WinZoneModel:GetReliveCoinCount()
    self.lblItemCount.text = self.coinCount
    self:HandleCancelRelive()
end

function WinZoneReliveDialog:on_btn_no_click()
    log.log("WinZoneReliveDialog:on_btn_no_click")
    self:HandleCancelRelive()
end

function WinZoneReliveDialog.OnPurchaseSucc()
    log.log("WinZoneReliveDialog:OnPurchaseSucc")
    this:MutualTaskFinish()
    this.isPurchaseSucc = true
    this:ReqRelive()
end
 
function WinZoneReliveDialog.OnPurchaseFail()
    log.log("WinZoneReliveDialog:OnPurchaseFail")
    this:MutualTaskFinish()
end

function WinZoneReliveDialog:OnPurchaseReliveCoinResult(code)
    log.log("WinZoneReliveDialog:OnPurchaseReliveCoinResult", code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        local purchaseId = self.reliveCfg and self.reliveCfg.product_difference
        if PurchaseHelper.IsEditorPurchase() then
            if not payData.pid or tostring(payData.pid) == "" then
                self.OnPurchaseSucc()
            else
                local productId = Csv.GetData("appstorepurchaseconfig", purchaseId, "product_id")
                log.log("WinZoneReliveDialog:OnPurchaseReliveCoinResult Editor productId, purchaseId, payData.pid", productId, purchaseId, payData.pid)
                ModelList.MainShopModel.C2S_NotifyServerIAPSuccess(nil, productId, payData.pid, nil, nil, nil,
                function()
                    self.OnPurchaseSucc()
                end,
                function()
                    self.OnPurchaseFail()
                end
            )
            end
        else            
            if fun.is_null(payData.pid) or tostring(payData.pid) == "" then 
                log.log("WinZoneReliveDialog:OnPurchaseReliveCoinResult pid is nil", self.reliveCfg, payData)
                UIUtil.show_common_popup(9025, true, nil)
                self.OnPurchaseFail()
            else 
                if not purchaseId then
                    log.log("WinZoneReliveDialog:OnPurchaseReliveCoinResult purchaseId is nil", self.reliveCfg, payData)
                    self.OnPurchaseFail()
                else
                    local productId = Csv.GetData("appstorepurchaseconfig", purchaseId, "product_id")
                    local product_name = Csv.GetData("appstorepurchaseconfig", purchaseId, "product_name")
                    PurchaseHelper.PurchasingType(8,product_name)
                    PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, self.OnPurchaseSucc, self.OnPurchaseFail)
                end
            end
        end
    else
        self.OnPurchaseFail()
    end
end

--复活成功，无条件进集结界面等别的玩家复活
function WinZoneReliveDialog:OnReliveSucc()
    log.log("WinZoneReliveDialog:OnReliveSucc")
    self:MutualTaskFinish()
    ModelList.WinZoneModel:WaitOtherRelive()
    self:CloseSelf()
end

--复活失败，处理已知情况
function WinZoneReliveDialog:OnReliveFail(params)
    log.log("WinZoneReliveDialog:OnReliveFail", params)
    self:MutualTaskFinish()
    if self.isPurchaseSucc then
        self:HandelReliveFailAfterPurchase(params)
    else
        self:HandelReliveFailWithoutPurchase(params)
    end
end

--购买成功后复活失败，处理已知情况
function WinZoneReliveDialog:HandelReliveFailAfterPurchase(params)
    log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase", params)
    animaIdx = 3
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase play anima 2")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][1], animaParams[animaIdx][2]}, false, function() 
                log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase play anima 3")
                self:MutualTaskFinish()
            end)
        end
        log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase play anima 1")
        self:DoMutualTask(task)
    else
        fun.set_active(self.panel1, false)
        fun.set_active(self.panel2, false)
        fun.set_active(self.btn_confirm1, false)
        fun.set_active(self.btn_confirm2, false)
        fun.set_active(self.imgClock, false)
        fun.set_active(self.btn_no, false)

        fun.set_active(self.panel3, true)
        fun.set_active(self.btn_confirm3, true)
    end
    self:EnableReliveBtn()
    
    local buyCoinCount = ModelList.WinZoneModel:GetReliveCoinCount() - self.coinCount
    if buyCoinCount < 0 then
        buyCoinCount = 0
    end
    self.lblBuyItemCount.text = buyCoinCount

    local descId = 8042
    if params.errorCode == RET.RET_VICTORY_BEATS_CANNOT_RELIVE then   --7254 用户不处于淘汰状态，或者当前轮制不能复活，复活失败
        log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase some thing error 7254 用户不处于淘汰状态")
        descId = 8042
    elseif params.errorCode == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then   --7251 进入对战时间已过期、淘汰，走退出逻辑
        log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase some thing error 7251 进入对战时间已过期")
        descId = 8042
    elseif params.errorCode == RET.RET_VICTORY_BEATS_RELIVE_COIN_NOT_ENOUGH then   --7250 复活币不足
        log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase some thing error 7250 复活币不足")
        descId = 8042
    else
        log.log("WinZoneReliveDialog:HandelReliveFailAfterPurchase some thing error 未知错误！")
        descId = 8042
    end

    local contentStr = Csv.GetData("description", descId, "description")
    self.desc3.text = contentStr
end

--未做购买 复活失败，处理已知情况
function WinZoneReliveDialog:HandelReliveFailWithoutPurchase(params)
    log.log("WinZoneReliveDialog:HandelReliveFailWithoutPurchase", params)
    local descId = 8048
    if params.errorCode == RET.RET_VICTORY_BEATS_CANNOT_RELIVE then   --7254 用户不处于淘汰状态，或者当前轮制不能复活，复活失败
        log.log("WinZoneReliveDialog:HandelReliveFailWithoutPurchase some thing error 7254 用户不处于淘汰状态")
        descId = 8048
    elseif params.errorCode == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then   --7251 进入对战时间已过期、淘汰，走退出逻辑
        descId = 8048
        log.log("WinZoneReliveDialog:HandelReliveFailWithoutPurchase some thing error 7251 进入对战时间已过期")
    elseif params.errorCode == RET.RET_VICTORY_BEATS_RELIVE_COIN_NOT_ENOUGH then   --7250 复活币不足
        log.log("WinZoneReliveDialog:HandelReliveFailWithoutPurchase some thing error 7250 复活币不足")
        descId = 8048
    else
        log.log("WinZoneReliveDialog:HandelReliveFailWithoutPurchase some thing error 未知错误！")
        descId = 8048
    end

    UIUtil.show_common_popup(
        descId,
        true,
        function()
            self:HandleCancelRelive()
        end
    )
end

function WinZoneReliveDialog:OnClaimReward(params)
    log.log("WinZoneReliveDialog:OnClaimReward", params)
    self:CloseSelf()
	if params.code == RET.RET_SUCCESS then
        if fun.is_table_empty(params.reward) then
            log.log("WinZoneReliveDialog:OnClaimReward 领奖成功，但数据有问题", params)
        else
            ModelList.WinZoneModel:DisplayReward(params.reward)
        end
    else
        log.log("WinZoneReliveDialog:OnClaimReward 领奖失败", params)
    end
end

function WinZoneReliveDialog:OnExitMatch(params)
    log.log("WinZoneReliveDialog:OnExitMatch(params)", params)
    self:CloseSelf()
    if not fun.is_table_empty(params.reward) then
        ModelList.WinZoneModel:DisplayReward(params.reward)
    end
end

function WinZoneReliveDialog:OnMsgNotReturn(code)
    log.log("WinZoneReliveDialog:OnMsgNotReturn(code)", code)
    if code == MSG_ID.MSG_VICTORY_BEATS_RELIVE then
        --self:MutualTaskFinish()
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnPurchaseReliveCoinResult},
    {notifyName = NotifyName.WinZone.ReliveSucc, func = this.OnReliveSucc},
    {notifyName = NotifyName.WinZone.ReliveFail, func = this.OnReliveFail},
    {notifyName = NotifyName.WinZone.ClaimReward, func = this.OnClaimReward},
    {notifyName = NotifyName.WinZone.Exit, func = this.OnExitMatch},
}

return this