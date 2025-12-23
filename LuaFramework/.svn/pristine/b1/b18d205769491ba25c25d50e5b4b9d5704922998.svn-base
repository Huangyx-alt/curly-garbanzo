local BingoPassAwardItem = require "View/Bingopass/BingoPassAwardItem"
local BingoPassRecommendView = BaseDialogView:New('BingoPassRecommendView',"BingoPassPopupAtlas")
local this = BingoPassRecommendView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
--this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_buy",
    "item_template",
    "scroll_rect1",
    "scroll_rect2",
    "txt_count1",
    "txt_count2",
    "txt_exp",
    "txt_price",
    "anima",
}

this.CloseMethod = {
    normal = 1,
    payFail = 2,
    paySucceed = 3,
}

function BingoPassRecommendView:Awake()
    self.rewardItemCache1 = {}
    self.rewardItemCache2 = {}
    self.productIdParam = nil
    self.payType = nil
end

function BingoPassRecommendView:OnEnable()
    Facade.RegisterView(self)
    self:ClearMutualTask()
end

function BingoPassRecommendView:on_after_bind_ref()
    self:FillData()
    local task = function()
        UISound.play("bingopass_pay1")
        AnimatorPlayHelper.Play(self.anima, {"start", "BingoPassRecommendView_start"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
    local bg = fun.find_child(self.go, "img_background")
    if bg then
        local img = fun.get_component(bg, fun.IMAGE)
        img.raycastTarget = true
    end
end

function BingoPassRecommendView:FillData()
    local isPay499 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499)
    local payData = ModelList.BingopassModel:get_priceItem1()
    local price = ModelList.BingopassModel:get_price1()

    if isPay499 then
        payData = ModelList.BingopassModel:get_priceItem2()
        price = ModelList.BingopassModel:get_payDifference()
    else
        payData = ModelList.BingopassModel:get_priceItem2()
        price = ModelList.BingopassModel:get_price2()
    end
    self.txt_exp.text = type(payData) == "table" and tostring(payData[1][2]) or payData
    self.txt_price.text = string.format("$%s", price)

    --
    local rewardNow, rewardSoon = ModelList.BingopassModel:GetAllReward(BingoPassPayType.Pay999)
    self.txt_count1.text = fun.NumInsertComma(rewardNow[Resource.coin] or 0) --fun.format_number(rewardNow[Resource.coin] or 0)
    self.txt_count2.text = fun.NumInsertComma(rewardSoon[Resource.coin] or 0) --fun.format_number(rewardSoon[Resource.coin] or 0)
    rewardNow[Resource.coin] = nil
    rewardSoon[Resource.coin] = nil
    self:BuildRewardItem(self.rewardItemCache1, rewardNow, self.item_template, self.scroll_rect1)
    self:BuildRewardItem(self.rewardItemCache2, rewardSoon, self.item_template, self.scroll_rect2)
end

function BingoPassRecommendView:BuildRewardItem(itemCache, rewardData, itemGo, content)
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

function BingoPassRecommendView:OnDisable()
    Facade.RemoveView(self)
    self.rewardItemCache1 = {}
    self.rewardItemCache2 = {}
    self.productIdParam = nil
    self.payType = nil
end

function BingoPassRecommendView:CloseSelf(closeMethod)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "BingoPassRecommendView_end"}, false, function()
            if self.closeCallback then
                self.closeCallback(closeMethod)
            end
            self.closeCallback = nil
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end
    self:DoMutualTask(task)
end

function BingoPassRecommendView:SetCloseCallback(callback)
    self.closeCallback = callback
end

function BingoPassRecommendView:on_btn_close_click()
    self:CloseSelf(self.CloseMethod.normal)
end

function BingoPassRecommendView:on_btn_buy_click()
    local task = function()
        if not ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499) then
            self.productIdParam = ModelList.BingopassModel:get_productId2() --"product2_id"
            self.payType = BingoPassPayType.Pay999
            ModelList.BingopassModel:RequestActivateGoldenPass(BingoPassPayType.Pay999)
        elseif not ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay500) then
            self.productIdParam = ModelList.BingopassModel:get_productDifference() --"product_difference"
            self.payType = BingoPassPayType.Pay500
            ModelList.BingopassModel:RequestActivateGoldenPass(BingoPassPayType.Pay500)
        end
    end
    self:DoMutualTask(task)
end

function BingoPassRecommendView.OnActivateGoldenPassPayResult(code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        if PurchaseHelper.IsEditorPurchase() then
            --[[
            ModelList.MainShopModel.C2S_NotifyServerIAPSuccess(nil, this.productIdParam, payData.pid, nil, nil, nil,
                function()
                    this.Purchasing_success()
                end,
                function()
                end
            )
            --]]
            this.Purchasing_success()
        else
            if fun.is_null(payData.pid) then
                UIUtil.show_common_popup(9025, true, nil)
                return
            end
            local productId = Csv.GetData("appstorepurchaseconfig", this.productIdParam, "product_id")
            if not payData.pid or tostring(payData.pid) == "" then 
                if this.Purchasing_failure then 
                    this.Purchasing_failure()
                end 
            else
                local product_name = Csv.GetData("appstorepurchaseconfig",this.productIdParam,"product_name")
                PurchaseHelper.PurchasingType(3,product_name)
                PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, this.Purchasing_success, this.Purchasing_failure)
            end
        end
    else
        this.Purchasing_failure()
    end
end

function BingoPassRecommendView.Purchasing_success()
    this:MutualTaskFinish()
    ModelList.BingopassModel:SetPayInfo()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassReceivedView, nil, nil, this.payType)
    this:CloseSelf(this.CloseMethod.paySucceed)
end
 
function BingoPassRecommendView.Purchasing_failure()
    this:MutualTaskFinish()
end

this.NotifyList = {
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnActivateGoldenPassPayResult}
}

return this