local BingoPassAwardItem = require "View/Bingopass/BingoPassAwardItem"
local BingoPassPurchaseView = BaseDialogView:New('BingoPassPurchaseView')
local this = BingoPassPurchaseView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "item_template1",
    "txt_level",
    "txt_unlock",
    "txt_value",
    "txt_exp1",
    "txt_exp2",
    "txt_price1",
    "txt_price2",
    "scroll_rect1",
    "scroll_rect2",
    "scroll_rect3",
    "scroll_rect4",
    "anima",
    "text_remainTime",
}

this.CloseMethod = {
    normal = 1,
    payFail = 2,
    paySucceed = 3,
}
local remainTimeCountDown = RemainTimeCountDown:New()

function BingoPassPurchaseView:Awake()
    this.rewardItemCache1 = {}
    this.rewardItemCache2 = {}
    this.rewardItemCache3 = {}
    this.rewardItemCache4 = {}
    this.productIdParam = nil
    this.payType = nil
end

function BingoPassPurchaseView:OnEnable()
    Facade.RegisterView(this)
    this:ClearMutualTask()
end

function BingoPassPurchaseView:on_after_bind_ref()
    this:SetPurchaseInfo()
    this:FillGoodsData()
    local task = function()
        UISound.play("bingopass_pay2")
        AnimatorPlayHelper.Play(this.anima, {"start", "BingoPassPurchaseView_start"}, false, function()
            this:MutualTaskFinish()
            this:UpdateBuyBtnState()
        end)
    end
    this:DoMutualTask(task)

    remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.BingopassModel:GetRemainTime(),this.text_remainTime,function()
        this:CloseSelf(this.CloseMethod.normal)
    end)
end

function BingoPassPurchaseView:FillGoodsData()
    -------------------------------------------14.9商品-------------------------------------------
    local rewardNow, rewardSoon = ModelList.BingopassModel:GetAllReward(BingoPassPayType.Pay999)
    local allReward = fun.merge_table_same_key_add(rewardNow, rewardSoon)
    this:BuildRewardUniversalItems(this.rewardItemCache1, rewardNow, this.item_template1, this.scroll_rect1)
    this:BuildRewardUniversalItems(this.rewardItemCache2, rewardSoon, this.item_template1, this.scroll_rect2)
    
    -------------------------------------------9.99商品-------------------------------------------
    rewardNow, rewardSoon = ModelList.BingopassModel:GetAllReward(BingoPassPayType.Pay499)
    allReward = fun.merge_table_same_key_add(rewardNow, rewardSoon)
    this:BuildRewardUniversalItems(this.rewardItemCache3, rewardNow, this.item_template1, this.scroll_rect3)
    this:BuildRewardUniversalItems(this.rewardItemCache4, rewardSoon, this.item_template1, this.scroll_rect4)
end

function BingoPassPurchaseView:SetPurchaseInfo()
    local isPay499 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499)
    local payData, price

    -------------------------------------------14.9商品-------------------------------------------
    if isPay499 then
        payData = ModelList.BingopassModel:get_priceItem2()
        price = ModelList.BingopassModel:get_payDifference()
    else
        payData = ModelList.BingopassModel:get_priceItem2()
        price = ModelList.BingopassModel:get_price2()
    end
    this.txt_exp1.text = type(payData) == "table" and tostring(payData[1][2]) or payData
    this.txt_price1.text = string.format("$%s", price)

    payData = ModelList.BingopassModel:get_description2()
    --this.txt_level.text = tostring(payData)  -- 30level

    -------------------------------------------9.99商品-------------------------------------------
    payData = ModelList.BingopassModel:get_priceItem1()
    price = ModelList.BingopassModel:get_price1()
    this.txt_exp2.text = payData[2]
    this.txt_price2.text = string.format("$%s", price)

    payData = ModelList.BingopassModel:get_priceItem1()
    this.txt_unlock.text = string.format("%s", #Csv.season_pass - 1) -- 100golden pass
    payData = ModelList.BingopassModel:get_description1()
    --this.txt_value.text = string.format("$%s", payData)--150$
end

function BingoPassPurchaseView:UpdateBuyBtnState()
    local isPay499 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499)
    local isPay999 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay999)
    local isPay500 = ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay500)

    if isPay499 then
        AnimatorPlayHelper.Play(self.anima, {"idlehui2", "BingoPassPurchaseView_idlehui2"}, false, function() end)
    end

    if isPay500 or isPay999 then
        AnimatorPlayHelper.Play(self.anima, {"idlehuiend", "BingoPassPurchaseView_idlehuiend"}, false, function() end)
    end

    local isMaxLevel = ModelList.BingopassModel:IsMaxLevel()
    Util.SetImageColorGray(self.btn_buy1, isPay500 or isPay999 or isMaxLevel)
    Util.SetImageColorGray(self.btn_buy2, isPay499)
end

function BingoPassPurchaseView:BuildRewardUniversalItems(itemCache, rewardData, itemGo, content)
    local keyIndex = 1
    local keyCount = #itemCache
    for key, value in pairs(rewardData) do
        local go
        if itemCache and itemCache[keyIndex] then
            itemCache[keyIndex]:SetInfo({key, value})
            go = itemCache[keyIndex].go
            fun.set_active(go, true)
        else
            go = fun.get_instance(itemGo, content)
            fun.set_active(go, true)
            local riv = BingoPassAwardItem:New({key, value, kbm = false})
            riv:SkipLoadShow(go)
            table.insert(itemCache, riv)
        end
        --[[强制把金币放在第一个位置
        if key == Resource.coin then
            fun.SetAsFirstSibling(go)
        end
        --]]
        keyIndex = keyIndex + 1
    end
    if keyIndex < keyCount then
        for i = keyIndex, keyCount do
            fun.set_active(itemCache[i].go, false)
        end
    end
end

function BingoPassPurchaseView.OnDisable()
    Facade.RemoveView(this)
    this.rewardItemCache1 = {}
    this.rewardItemCache2 = {}
    this.rewardItemCache3 = {}
    this.rewardItemCache4 = {}
    this.productIdParam = nil
    this.payType = nil
    remainTimeCountDown:StopCountDown()
end

function BingoPassPurchaseView:CloseSelf(closeMethod)
    local task = function()
            AnimatorPlayHelper.Play(this.anima, {"end", "BingoPassPurchaseView_end"}, false, function()
            if this.closeCallback then
                this.closeCallback(closeMethod)
            end
            this.closeCallback = nil


            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, this)
        end)
    end
    self:DoMutualTask(task)
end

function BingoPassPurchaseView:SetCloseCallback(callback)
    this.closeCallback = callback
end

function BingoPassPurchaseView:on_btn_close_click()
    this:CloseSelf(this.CloseMethod.normal)
end

function BingoPassPurchaseView:on_btn_buy1_click()
    if ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay999) then
        log.log("dghdgh007 BingoPassPurchaseView:on_btn_buy1_click 999已经购买")
        return
    end

    if ModelList.BingopassModel:IsMaxLevel() then
        log.log("BingoPassPurchaseView:on_btn_buy1_click 已满级")
        return
    end

    local task = function()
        if not ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499) then
            this.productIdParam = ModelList.BingopassModel:get_productId2() --"product2_id"
            this.payType = BingoPassPayType.Pay999
            ModelList.BingopassModel:RequestActivateGoldenPass(BingoPassPayType.Pay999)
        elseif not ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay500) then
            this.productIdParam = ModelList.BingopassModel:get_productDifference() --"product_difference"
            this.payType = BingoPassPayType.Pay500
            ModelList.BingopassModel:RequestActivateGoldenPass(BingoPassPayType.Pay500)
        end
    end

    self:DoMutualTask(task)
end



function BingoPassPurchaseView:on_btn_buy2_click()
    if ModelList.BingopassModel:IsCompletePay(BingoPassPayType.Pay499) then
        log.log("dghdgh007 BingoPassPurchaseView:on_btn_buy2_click 499已经购买")
        return
    end

    local task = function()
        this.productIdParam = ModelList.BingopassModel:get_productId1() --"product1_id"
        this.payType = BingoPassPayType.Pay499
        ModelList.BingopassModel:RequestActivateGoldenPass(BingoPassPayType.Pay499)
    end
    self:DoMutualTask(task)
end

function BingoPassPurchaseView.OnActivateGoldenPassPayResult(code)
    if code == RET.RET_SUCCESS then
        local payData = ModelList.MainShopModel:GetPayData()
        if PurchaseHelper.IsEditorPurchase() then
 
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
                local product_name = Csv.GetData("appstorepurchaseconfig", this.productIdParam, "product_name")
                PurchaseHelper.PurchasingType(3,product_name)
                PurchaseHelper.DoPurchasing(deep_copy(payData), nil, productId, payData.pid, this.Purchasing_success, this.Purchasing_failure)
            end
        end
    else
        this.Purchasing_failure()
    end
end

function BingoPassPurchaseView.Purchasing_success()
    this:MutualTaskFinish()
    ModelList.BingopassModel:SetPayInfo()
    this:SetPurchaseInfo()
    this:UpdateBuyBtnState()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassReceivedView, nil, nil, this.payType)
    this:CloseSelf(this.CloseMethod.paySucceed)
end
 
function BingoPassPurchaseView.Purchasing_failure()
    this:MutualTaskFinish()
end

this.NotifyList = {
    {notifyName = NotifyName.ShopView.ActivityPayResult, func = this.OnActivateGoldenPassPayResult}
}

return this