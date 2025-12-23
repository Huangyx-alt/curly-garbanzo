local Const = require "View/WinZone/WinZoneConst"
--local VolcanoMissionRevivalView = BaseDialogView:New('VolcanoMissionRevivalView', "XXXXXXAtlas") --undo 如果需要加载图集
local VolcanoMissionRevivalView = BaseDialogView:New('VolcanoMissionRevivalView',"VolcanoMission_InHotModule_Texture_Mission_RevivalView_AutoAtlas")
local this = VolcanoMissionRevivalView
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
    "lblBuyItemCount",
    "anima",
}

--undo 
local descriptionIds = {
    8069, 8069, 8070
}

--undo
local btnDescriptionIds = {
    30110, 30111, 30111, 30111
}

local animaParams = {
    {"start1", "VolcanoMissionRevivalView_start1", "end1", "VolcanoMissionRevivalView_end1"},
    {"start2", "VolcanoMissionRevivalView_start2", "end2", "VolcanoMissionRevivalView_end2"},
    {"start3", "VolcanoMissionRevivalView_start3", "end3", "VolcanoMissionRevivalView_end3"},
}

local animaIdx = 1

function VolcanoMissionRevivalView:Awake()
end

function VolcanoMissionRevivalView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function VolcanoMissionRevivalView:ReportEvent()
    local needCoinCount
    if self.reliveCfg then
        needCoinCount = self.reliveCfg.revivalcoin_num
    end

    local needCashCount
    if self.coinCount and needCoinCount and needCoinCount > self.coinCount then
        needCashCount = self.reliveCfg.price
    end

    local params = {
        currentmap = ModelList.VolcanoMissionModel:GetMapId(),
        currentsteps = ModelList.VolcanoMissionModel:GetCurStepId(),
        totalsteps = 0,
        revivalcoin_need = needCoinCount,
        revivalcash_need = needCashCount,
    }
    SDK.BI_Event_Tracker("volcanomission_reconnect_open", params)
    log.log("VolcanoMissionRevivalView:ReportEvent params is ", params)
end

function VolcanoMissionRevivalView:on_after_bind_ref()
    self:InitData()
    self:InitView()
end

function VolcanoMissionRevivalView:InitView()
    log.log("VolcanoMissionRevivalView:InitView")
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
            log.log("VolcanoMissionRevivalView:InitView play anima 2")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][1], animaParams[animaIdx][2]}, false, function() 
                log.log("VolcanoMissionRevivalView:InitView play anima 3")
                self:MutualTaskFinish()
            end)
        end
        log.log("VolcanoMissionRevivalView:InitView play anima 1")
        self:DoMutualTask(task)
    end

    self:ReportEvent()
end

function VolcanoMissionRevivalView:DisableReliveBtn()
    log.log("VolcanoMissionRevivalView:DisableReliveBtn")
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

function VolcanoMissionRevivalView:EnableReliveBtn()
    log.log("VolcanoMissionRevivalView:EnableReliveBtn")
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

function VolcanoMissionRevivalView:OnDisable()
    log.log("VolcanoMissionRevivalView:OnDisable")
    Facade.RemoveViewEnhance(self)
    self.isPurchaseSucc = nil
    self.coinCount = 0
    self.reliveCfg = nil
end

function VolcanoMissionRevivalView:InitData()
    log.log("VolcanoMissionRevivalView:InitData()")
    --undo wait data

    self.coinCount = ModelList.VolcanoMissionModel:GetReliveCoinCount()
    self.reliveCfg = ModelList.VolcanoMissionModel:GetReliveCfg()
end

function VolcanoMissionRevivalView:CloseSelf()
    log.log("VolcanoMissionRevivalView:CloseSelf 000")
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("VolcanoMissionRevivalView:CloseSelf 111")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][3], animaParams[animaIdx][4]}, false, function() 
                self:MutualTaskFinish()
                log.log("VolcanoMissionRevivalView:CloseSelf 222")
                Facade.SendNotification(NotifyName.HideDialog, self)
            end)
        end

        self:DoMutualTask(task)
    else
        log.log("VolcanoMissionRevivalView:CloseSelf 333")
        Facade.SendNotification(NotifyName.HideDialog, self)
    end
end

--处理用户放弃复活或复活失败后的流程
function VolcanoMissionRevivalView:HandleCancelRelive()
    log.log("VolcanoMissionRevivalView:HandleCancelRelive")
    self:CloseSelf()
end

function VolcanoMissionRevivalView:ReqRelive()
    log.log("VolcanoMissionRevivalView:ReqRelive")
    local task = function()
        ModelList.VolcanoMissionModel:C2S_ReqVolcanoRevival()
    end
    self:DoMutualTask(task)
end

function VolcanoMissionRevivalView:on_btn_confirm1_click()
    log.log("VolcanoMissionRevivalView:on_btn_confirm1_click")
    self:ReqRelive()
end

function VolcanoMissionRevivalView:on_btn_confirm2_click()
    log.log("VolcanoMissionRevivalView:on_btn_confirm2_click")
    local task = function()
        if self.reliveCfg and self.reliveCfg.id then
            ModelList.VolcanoMissionModel:PurchaseReliveCoin(self.reliveCfg.id)
        else
            self:MutualTaskFinish()
        end
    end
    self:DoMutualTask(task)
end

function VolcanoMissionRevivalView:on_btn_confirm3_click()
    log.log("VolcanoMissionRevivalView:on_btn_confirm3_click")
    self.coinCount = ModelList.VolcanoMissionModel:GetReliveCoinCount()
    self.lblItemCount.text = self.coinCount
    self:HandleCancelRelive()
end

function VolcanoMissionRevivalView:on_btn_no_click()
    log.log("VolcanoMissionRevivalView:on_btn_no_click")
    self:HandleCancelRelive()
    Facade.SendNotification(NotifyName.VolcanoMission.GiveUp)
end

function VolcanoMissionRevivalView.OnPurchaseSucc()
    log.log("VolcanoMissionRevivalView:OnPurchaseSucc")
    this:MutualTaskFinish()
    this.isPurchaseSucc = true
    this:ReqRelive()
end
 
function VolcanoMissionRevivalView.OnPurchaseFail()
    log.log("VolcanoMissionRevivalView:OnPurchaseFail")
    this:MutualTaskFinish()
end

function VolcanoMissionRevivalView:OnPurchaseReliveCoinResult(code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        local purchaseId = self.reliveCfg and self.reliveCfg.product_difference
        if PurchaseHelper.IsEditorPurchase() then
            if not payData.pid or tostring(payData.pid) == ""  or tostring(payData.pid) == "0" then
                self.OnPurchaseSucc()
            else
                local productId = Csv.GetData("appstorepurchaseconfig", purchaseId, "product_id")
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
                UIUtil.show_common_popup(9025, true, nil)
                self.OnPurchaseFail()
            else 
                if not purchaseId then
                    self.OnPurchaseFail()
                else
                    local product_name = Csv.GetData("appstorepurchaseconfig",purchaseId,"product_name")
                    local productId = Csv.GetData("appstorepurchaseconfig", purchaseId, "product_id")

                    PurchaseHelper.PurchasingType(7,product_name)
                    PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, self.OnPurchaseSucc, self.OnPurchaseFail)
                end
            end
        end
    else
        self.OnPurchaseFail()
    end
end

--复活成功，无条件进集结界面等别的玩家复活
function VolcanoMissionRevivalView:OnReliveSucc()
    log.log("VolcanoMissionRevivalView:OnReliveSucc")
    self:MutualTaskFinish()
    --undo do something 成功复活要做些什么？ 
    Facade.SendNotification(NotifyName.VolcanoMission.ReviveSuccess)
    self:CloseSelf()
end

--复活失败，处理已知情况
function VolcanoMissionRevivalView:OnReliveFail(params)
    log.log("VolcanoMissionRevivalView:OnReliveFail", params)
    self:MutualTaskFinish()
    if self.isPurchaseSucc then
        self:HandelReliveFailAfterPurchase(params)
    else
        self:HandelReliveFailWithoutPurchase(params)
    end
end

--购买成功后复活失败，处理已知情况
function VolcanoMissionRevivalView:HandelReliveFailAfterPurchase(params)
    log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase", params)
    animaIdx = 3
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase play anima 2")
            AnimatorPlayHelper.Play(self.anima, {animaParams[animaIdx][1], animaParams[animaIdx][2]}, false, function() 
                log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase play anima 3")
                self:MutualTaskFinish()
            end)
        end
        log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase play anima 1")
        self:DoMutualTask(task)
    else
        fun.set_active(self.panel1, false)
        fun.set_active(self.panel2, false)
        fun.set_active(self.btn_confirm1, false)
        fun.set_active(self.btn_confirm2, false)
        
        fun.set_active(self.btn_no, false)

        fun.set_active(self.panel3, true)
        fun.set_active(self.btn_confirm3, true)
    end
    self:EnableReliveBtn()
    
    local buyCoinCount = ModelList.VolcanoMissionModel:GetReliveCoinCount() - self.coinCount
    if buyCoinCount < 0 then
        buyCoinCount = 0
    end
    self.lblBuyItemCount.text = buyCoinCount

    --[[undo 根据需求看这里要不要有类似的处理
    local descId = 8042
    if params.errorCode == RET.RET_VICTORY_BEATS_CANNOT_RELIVE then   --7254 用户不处于淘汰状态，或者当前轮制不能复活，复活失败
        log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase some thing error 7254 用户不处于淘汰状态")
        descId = 8042
    elseif params.errorCode == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then   --7251 进入对战时间已过期、淘汰，走退出逻辑
        log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase some thing error 7251 进入对战时间已过期")
        descId = 8042
    elseif params.errorCode == RET.RET_VICTORY_BEATS_RELIVE_COIN_NOT_ENOUGH then   --7250 复活币不足
        log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase some thing error 7250 复活币不足")
        descId = 8042
    else
        log.log("VolcanoMissionRevivalView:HandelReliveFailAfterPurchase some thing error 未知错误！")
        descId = 8042
    end

    local contentStr = Csv.GetData("description", descId, "description")
    self.desc3.text = contentStr
    --]]
end

--未做购买 复活失败，处理已知情况
function VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase(params)
    log.log("VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase", params)
    --[[undo 根据需求看这里要不要有类似的处理
    local descId = 8048
    if params.errorCode == RET.RET_VICTORY_BEATS_CANNOT_RELIVE then   --7254 用户不处于淘汰状态，或者当前轮制不能复活，复活失败
        log.log("VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase some thing error 7254 用户不处于淘汰状态")
        descId = 8048
    elseif params.errorCode == RET.RET_VICTORY_BEATS_PLAY_TIME_EXPIRED then   --7251 进入对战时间已过期、淘汰，走退出逻辑
        descId = 8048
        log.log("VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase some thing error 7251 进入对战时间已过期")
    elseif params.errorCode == RET.RET_VICTORY_BEATS_RELIVE_COIN_NOT_ENOUGH then   --7250 复活币不足
        log.log("VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase some thing error 7250 复活币不足")
        descId = 8048
    else
        log.log("VolcanoMissionRevivalView:HandelReliveFailWithoutPurchase some thing error 未知错误！")
        descId = 8048
    end

    UIUtil.show_common_popup(
        descId,
        true,
        function()
            self:HandleCancelRelive()
        end
    )
    --]]

end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnPurchaseReliveCoinResult},
    {notifyName = NotifyName.VolcanoMission.ReliveSucc, func = this.OnReliveSucc},
    {notifyName = NotifyName.VolcanoMission.ReliveFail, func = this.OnReliveFail},
}

return this