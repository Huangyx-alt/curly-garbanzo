local BingoPassAwardItem = require "View/Bingopass/BingoPassAwardItem"
--local PassPurchaseView = BaseDialogView:New('PassPurchaseView', "BingoPassPopupAtlas")
local PassPurchaseView = class("PassPurchaseView", BaseViewEx)
local this = PassPurchaseView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
--this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_buy",
    "item_template",
    "scroll_rect1",
    "txt_count1",
    "txt_exp",
    "txt_price",
    "anima",
    "txt_level",
    "txt_more",
}

this.CloseMethod = {
    normal = 1,
    payFail = 2,
    paySucceed = 3,
}


function PassPurchaseView:ctor(id)
    self.id = id 
end

function PassPurchaseView:GetModel()
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(self.id)
    return model 
end

function PassPurchaseView:Awake()
    self.rewardItemCache1 = {}
    self.rewardItemCache2 = {}
    self.productIdParam = nil
    self.payType = nil
    self.isExpired = nil
end

function PassPurchaseView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()

    self:register_invoke(function()
        self:OnExpired()
    end,
    self:GetModel():GetRemainTime()
)
end

function PassPurchaseView:on_after_bind_ref()
    self:FillData()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"start", "PassPurchaseView_start"}, false, function() 
                self:MutualTaskFinish()
            end)
        end
        self:DoMutualTask(task)
    end
end

function PassPurchaseView:FillData()
    --local isPay499 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499)
    local payData = self:GetModel():get_priceItem()
    local price = self:GetModel():get_price()

    -- if isPay499 then
    --     payData = ModelList.BingopassModel:get_priceItem2()
    --     price = ModelList.BingopassModel:get_payDifference()
    -- else
    --     payData = ModelList.BingopassModel:get_priceItem2()
    --     price = ModelList.BingopassModel:get_price2()
    -- end
    --self.txt_exp.text = type(payData) == "table" and tostring(payData[1][2]) or payData
    self.txt_exp.text = type(payData) == "table" and tostring(payData[2]) or payData
    self.txt_price.text = string.format("$%s", price)

    local upgradeLevel = self:GetModel():GetPayUpgradeLevel()
    self.txt_level.text = upgradeLevel
    --undo
    local payID = self:GetModel():get_productId()
    self.txt_more.text = self:GetModel():GetMoreExtraNum(payID) .. "%"


    --
    local rewardNow, rewardSoon = self:GetModel():GetAllReward(BingoPassPayType.Pay999)
    self.txt_count1.text = fun.NumInsertComma(rewardNow[Resource.coin] or 0) --fun.format_number(rewardNow[Resource.coin] or 0)
    --self.txt_count2.text = fun.NumInsertComma(rewardSoon[Resource.coin] or 0) --fun.format_number(rewardSoon[Resource.coin] or 0)
    rewardNow[Resource.coin] = nil
    --rewardSoon[Resource.coin] = nil
    self:BuildRewardItem(self.rewardItemCache1, rewardNow, self.item_template, self.scroll_rect1)
    --self:BuildRewardItem(self.rewardItemCache2, rewardSoon, self.item_template, self.scroll_rect2)
end

function PassPurchaseView:BuildRewardItem(itemCache, rewardData, itemGo, content)
    local keyIndex = 1
    local keyCount = #itemCache
    for key, value in pairs(rewardData) do
        if itemCache and itemCache[keyIndex] then
            itemCache[keyIndex]:SetInfo({key, value})
            fun.set_active(itemCache[keyIndex].go, true)
        else
            local go = fun.get_instance(itemGo, content)
            fun.set_active(go, true)
            local riv = BingoPassAwardItem:New({key, value, kbm = false})
            riv:SkipLoadShow(go)
            table.insert(itemCache, riv)
        end
        keyIndex = keyIndex + 1
    end
    if keyIndex < keyCount then
        for i = keyIndex, keyCount do
            fun.set_active(itemCache[i].go, false)
        end
    end
end

function PassPurchaseView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self.rewardItemCache1 = {}
    self.rewardItemCache2 = {}
    self.productIdParam = nil
    self.payType = nil
    self.isExpired = nil
    self.isActiveByPopup = nil
end

function PassPurchaseView:CloseSelf(closeMethod)
    if closeMethod == self.CloseMethod.normal and self.isActiveByPopup then
        log.log("Facade.SendNotification(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish) 1")
        Event.Brocast(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish)  
    end

    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "PassPurchaseView_end"}, false, function()
                if self.closeCallback then
                    self.closeCallback(closeMethod)
                end
                self.closeCallback = nil
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        self:DoMutualTask(task)
    else
        if self.closeCallback then
            self.closeCallback(closeMethod)
        end
        self.closeCallback = nil
        self:MutualTaskFinish()
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function PassPurchaseView:SetCloseCallback(callback)
    self.closeCallback = callback
end

function PassPurchaseView:on_btn_close_click()
    self:CloseSelf(self.CloseMethod.normal)
end

function PassPurchaseView:on_btn_buy_click()
    if self.isExpired then
        UIUtil.show_common_popup(984, true, function()
                self:CloseSelf(self.CloseMethod.normal)
            end, function()
            end, nil, nil
        )
    else
        local task = function()
            local payItem =self:GetModel():GetPayItemId()
            if payItem then 
                self:GetModel():RequestActivateGoldenPass(payItem)
            else
                self:MutualTaskFinish()
            end
        end
        self:DoMutualTask(task)
    end
end

function PassPurchaseView:OnExpired()    
    self.isExpired = true
end

function PassPurchaseView:OnActivateGoldenPassPayResult(code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        if PurchaseHelper.IsEditorPurchase() then
            if not payData.pid or tostring(payData.pid) == "" or tostring(payData.pid) == "0" then
                self:Purchasing_success()
            else
                local productId = Csv.GetData("appstorepurchaseconfig", self:GetModel():get_productId(), "product_id")
                ModelList.MainShopModel.C2S_NotifyServerIAPSuccess(nil, productId, payData.pid, nil, nil, nil,
                function()
                    self:Purchasing_success()
                end,
                function()
                    self:Purchasing_failure()
                end
            )
            end
            --]]
        else
            if fun.is_null(payData.pid) then
                UIUtil.show_common_popup(9025, true, nil)
                return
            end
            local productId = Csv.GetData("appstorepurchaseconfig",self:GetModel():get_productId(), "product_id")
            if not payData.pid or tostring(payData.pid) == "" then 
                if self.Purchasing_failure then 
                    self:Purchasing_failure()
                end 
            else
                local product_name = Csv.GetData("appstorepurchaseconfig",self:GetModel():get_productId(),"product_name")
                PurchaseHelper.PurchasingType(5,product_name)
                PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, function()
                    self:Purchasing_success()
                end, function()
                    self:Purchasing_failure()
                end)
            end
        end
    else
        self:Purchasing_failure()
    end
end

function PassPurchaseView:Purchasing_success()
    log.log("PassPurchaseView:Purchasing_success")
    self:MutualTaskFinish()
    self:GetModel():SetPayInfo()
    local params = {}
    if self.isActiveByPopup then
        params.onCloseCallback = function()
            log.log("Facade.SendNotification(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish) 2")
            Event.Brocast(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish)    
        end
    end

    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassReceivedView", params)
    Facade.SendNotification(NotifyName.GamePlayShortPassView.PurchasingPassSuccess)
    --self:InitGoldPassInfo()
    self:CloseSelf(self.CloseMethod.paySucceed)
end
 
function PassPurchaseView:Purchasing_failure()
    log.log("PassPurchaseView:Purchasing_failure")
    self:MutualTaskFinish()
end

function PassPurchaseView:SetParam(param)
    if param then
        self.isActiveByPopup = param.isActiveByPopup
    end
end

this.NotifyEnhanceList = {
    {notifyName = NotifyName.GamePlayShortPassView.Expired, func = this.OnExpired},
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnActivateGoldenPassPayResult},
}

return this