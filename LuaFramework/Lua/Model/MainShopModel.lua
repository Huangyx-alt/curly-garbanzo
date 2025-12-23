
local MainShopModel = BaseModel:New("MainShopModel")
local this = MainShopModel

local shopData = {}

local shopDataDic = {}
local ownPUData = {}

local free_coin_available = nil
local free_coin_remaintime = nil
local shop_data = nil

local cur_shopType = nil

local activityPayData = nil;

local groceryList = {}

local promoInfo = nil

function MainShopModel:InitData()
    self._timer = Timer.New(function()
        self:OnTimerCall()
    end,1,-1,true)
    self._timer:Start()
end

function MainShopModel:CancelInitData()
    Timer:Stop()
end

function MainShopModel:SetLoginData(data)
    for key, value in pairs(data.groceryInfo) do
        groceryList[value.id] = deep_copy(value)
    end
end

function MainShopModel:GetPayData()
    return activityPayData
end

function MainShopModel:SetLoginData(data)
    if PurchaseHelper ~= nil then
        PurchaseHelper.reLoginSetStackPurchase()
    end
end

function MainShopModel:CheckFreeRewardAvailable()
    free_coin_available = false
    free_coin_remaintime = nil
    if shop_data == nil then
        for key, value in pairs(Csv.shop) do
            if value.gift_type == ShopItemType.free2Ad then
                shop_data = value
                break
            end
        end
    end
    if shop_data then
        local ad_num = ModelList.AdModel.GetAdCount(AD_EVENTS.AD_EVENTS_SHOP_ITEM)
        if ad_num > 0 then 
            local shopItem = this:GetShopDataById(shop_data.id)
            if shopItem then
                if shopItem.canBuyCount > 0 or shopItem.canBuyCount == -1 then
                    free_coin_remaintime = math.max(0,(shopItem.nextUnix or 0) - os.time())
                    free_coin_available = (free_coin_remaintime == 0)
                end
            end
        end
    end 
    return free_coin_available and SDK.IsRewardedAdReady()
end

function MainShopModel:OnTimerCall(sub)
    if free_coin_remaintime and free_coin_remaintime > 0 then
        free_coin_remaintime = math.max(0,free_coin_remaintime - 1)
        if free_coin_remaintime <= 0 then
            free_coin_remaintime = nil
            self.C2S_RefreshShopInfo(SHOP_TYPE.SHOP_TYPE_ITEMS)
        end
    end
    ShopView.UpdateCountdown()
end

function MainShopModel:ClearShopData()
    --不能清空，红点需要用到数据
    --shopData = {}
    --shopDataDic = {}
end

function MainShopModel:GetShopDataById(id)
    if id then
        return shopDataDic[id]
    end
    return nil
end

--function MainShopModel:GetShopData(index)
--    local temData = {}
--    temData["top"] = {}
--    temData["main"] = {}
--    if shopData and shopData[index] then
--        --for key, value in pairs(shopData[index]["top"]) do
--        --    if shopDataDic[value] then
--        --        table.insert(temData["top"],shopDataDic[value])
--        --    end
--        --end
--        for key, value in pairs(shopData[index]["main"]) do
--            if shopDataDic[value] then
--                table.insert(temData["main"],shopDataDic[value])
--            end
--        end
--    end
--    return temData
--end

function MainShopModel:GetShopData(index)
    local temData = {}
    if shopData and shopData[index] then
        for key, value in pairs(shopData[index]) do
            if shopDataDic[value] then
                table.insert(temData,shopDataDic[value])
            end
        end
    end
    return temData
end

function MainShopModel:GetShopTypeData(shopType)
    if not shopData or not shopData[shopType] then
        log.r("错误 缺少商店数据 " , shopType)
        return nil
    end
    local dataList = {}
    for i = 1 , GetTableLength(shopData[shopType]) do
        local shopItemId = shopData[shopType][i]
        --local shopItemData = this:GetShopDataById(shopItemId)
        --if not shopItemData then
        --    log.r("错误 商店缺少指定id数据 " , shopItemId)
        --end
        local data = Csv.GetData("new_shop",shopItemId,nil)
        if data then
            table.insert(dataList, data)
        else
            log.log("缺少商店配置 " , shopItemId)
        end
    end
    return dataList
end

function MainShopModel.C2S_FetchShopInfo(shopType)
    cur_shopType = shopType
    --红点需要用到相关数据，所有没有清空数据，打开刷新吧
    --if shopData[shopType] then
        --Facade.SendNotification(NotifyName.ShopView.FetchShopDataResut)
    --else
    --end
    this.OnFetchShopResult_Notify = function()
        Event.Brocast(BingoBangEntry.mainShopViewEvent.ReqShopData)
    end
    this.SendMessage(MSG_ID.MSG_FETCH_SHOP,{index = shopType})
end

function MainShopModel.Login_C2S_FetchShopInfo(shopType)
    cur_shopType = shopType
    --红点需要用到相关数据，所有没有清空数据，打开刷新吧
    --if shopData[shopType] then
        --Facade.SendNotification(NotifyName.ShopView.FetchShopDataResut)
    --else
      --  this.C2S_RefreshShopInfo(shopType)
    --end
    this.OnFetchShopResult_Notify = function()
        Facade.SendNotification(NotifyName.ShopView.FetchShopDataResut)
    end
    
    return MSG_ID.MSG_FETCH_SHOP,Base64.encode(Proto.encode(MSG_ID.MSG_FETCH_SHOP,{index = shopType or cur_shopType}))
  --  this.SendMessage(MSG_ID.MSG_FETCH_SHOP,{index = shopType or cur_shopType})
end


function MainShopModel.C2S_RefreshShopInfo(shopType)
    this.OnFetchShopResult_Notify = function()
        --Facade.SendNotification(NotifyName.ShopView.FetchShopDataResut)
        Event.Brocast(BingoBangEntry.mainShopViewEvent.ReqShopData)
        --RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
    this.SendMessage(MSG_ID.MSG_FETCH_SHOP,{index = shopType or cur_shopType})
end

function MainShopModel.S2C_FetchShopResult(code,data)
    log.log("商店内容 协议3001 收到 " ,code , data)
    if code == RET.RET_SUCCESS and data then
        shopData[data.index] = {}
        shopData[data.index] = {}
        local main = deep_copy(data.main)
        local count = 0
        shopData[data.index] = {}
        for key, value in pairs(main) do
            shopDataDic[value.id] = value
            table.insert(shopData[data.index],value.id)
            count = count + 1
        end
        log.log("商店内容 重组购买项 shopDataDic " , shopDataDic)
        log.log("商店内容 重组购买项 shopData " , shopData)
        if count >= 2 then
            if this.OnFetchShopResult_Notify then
                this.OnFetchShopResult_Notify()
                this.OnFetchShopResult_Notify = nil
            end
        else
            UIUtil.show_common_popup(9025,true,nil)
        end
        this:CheckFreeRewardAvailable(true)
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function MainShopModel:UpdatePromotionInfo(index, data)
    if not index then
        log.log("MainShopModel:UpdatePromotionInfo index is nil")
        return
    end

    if not data then
        log.log("MainShopModel:UpdatePromotionInfo data is nil")
        return
    end

    shopData[data.index]["promoInfo"] = data.promoInfo

    promoInfo = data.promoInfo
end

function MainShopModel:IsPromotionValid(index)
    --[[undo test code wait delete
    if true then
        return true 
    end
    --]]

    if not promoInfo then
        return false
    end

    return self:GetPromotionRemainTime() > 0
end

function MainShopModel:GetPromotionRemainTime(index)
    if not promoInfo then
        return 0
    end

    if not promoInfo.endTime then
        return 0
    end

    return promoInfo.endTime - os.time()
end

function MainShopModel.C2S_RequestBuyItem(shopItemId)
    this.cacheShopItemId = shopItemId

    this.SendMessage(MSG_ID.MSG_BUY_ITEM,{shopItemId = shopItemId})
end

function MainShopModel.S2C_ResponeBuyItem(code,data)
    Event.Brocast(EventName.Event_ShopDataUpdata)
    --log.r("==========================>>S2C_ResponeBuyItem " .. code)
    if code == RET.RET_SUCCESS and data then
        local shopItem = Csv.GetData("shop",data.shopItemId)
        if shopItem == nil then
            return
        end
        local productId = shopItem.product_id --Csv.GetData("shop",data.shopItemId,"product_id")
        if 0 == productId then --免费商品不需要发消息
            if this.Purchasing_success then
               this.Purchasing_success()
            end
            return
        end
        if fun.is_null(data.pid) then
            UIUtil.show_common_popup(9025,true,nil)
            return
        end
        if productId > 0 then
            productId = Csv.GetData("appstorepurchaseconfig",productId,"product_id")
        end
        log.r("appstorepurchaseconfig"..productId)
        if PurchaseHelper.IsEditorPurchase() then
            --log.r("========================>>S2C_ResponeBuyItem1111")
            if not data.pid or tostring(data.pid) =="" then
                if this.Purchasing_success then 
                    this.Purchasing_success()
                end 
                
            else 
                this.C2S_NotifyServerIAPSuccess(nil,productId,data.pid,nil,nil,nil,this.Purchasing_success,this.Purchasing_failure)
            end
           
        else
            if not data.pid or tostring(data.pid) == "" then 
                if this.Purchasing_failure then 
                    this.Purchasing_failure()
                end 
            else
                local product_name = Csv.GetData("appstorepurchaseconfig",productId,"product_name")
                PurchaseHelper.PurchasingType(1,product_name)
                PurchaseHelper.DoPurchasing(deep_copy(data),shopItem,productId,data.pid,this.Purchasing_success,this.Purchasing_failure)
            end 
            
            --log.r("========================>>S2C_ResponeBuyItem2222")
            
        end
    else
        Facade.SendNotification(NotifyName.ShopView.BuyFailureReshone)
        if code == RET.RET_ORDER_CREATE_FAILED then
            UIUtil.show_common_popup(9025,true,nil)
        elseif code == RET.RET_SHOP_ITEM_EXPIRED then
            UIUtil.show_common_popup(9026,true,nil)   
        elseif code == RET.RET_ITEM_BUY_LIMITED then
            UIUtil.show_common_popup(9027,true,nil)   
        elseif code == RET.RET_ORDER_COMPLETED then
            UIUtil.show_common_popup(9028,true,nil)   
        elseif code == RET.RET_SHOP_BUY_IN_CD then
            UIUtil.show_common_popup(9029,true,nil)
        end
    end    
end

function MainShopModel.get_pay_channel()
    local platform = UnityEngine.Application.platform
    if PurchaseHelper.IsPayAType() then
        return PAY_CHANNEL.PAY_CHANNEL_SELF_STORE
    end
    if platform == UnityEngine.RuntimePlatform.Android then
        return PAY_CHANNEL.PAY_CHANNEL_GOOGLE_PLAY
    elseif platform == UnityEngine.RuntimePlatform.IPhonePlayer or platform == UnityEngine.RuntimePlatform.OSXPlayer then
        return PAY_CHANNEL.PAY_CHANNEL_APPLE_STORE    
    end
    return PAY_CHANNEL.PAY_CHANNEL_GOOGLE_PLAY
end

function MainShopModel.C2S_NotifyServerIAPSuccess(orderId,productId,payload,token,currency,receipt,success_callback,failure_callback,errorcode)
    --log.r("========================>>C2S_NotifyServerIAPSuccess")
    errorcode = errorcode or 0
    this._iap_success_callback = success_callback
    this._iap_failure_callback = failure_callback
    local platform = UnityEngine.Application.platform
    if PurchaseHelper.IsEditorPurchase() then
        local channel = this.get_pay_channel()
        this.SendMessage(MSG_ID.MSG_PAY_NOTIFY,{pid = payload,orderId = "0",payChannel = channel,payParams = ""})
    else
        local pid = payload
        local params = {
            productId = productId,
            currency = currency or "USD",
            city = ModelList.CityModel:GetCity(),
            errorcode = errorcode,
            receipt=receipt or 0,
            extradata = PurchaseHelper.extraData or ""
        }
        local channel = this.get_pay_channel()
        if channel == PAY_CHANNEL.PAY_CHANNEL_AMAZON_SOTRE then
            -- 亚马逊商店
        elseif channel == PAY_CHANNEL.PAY_CHANNEL_APPLE_STORE then
            -- 苹果AppStore
        elseif channel == PAY_CHANNEL.PAY_CHANNEL_GOOGLE_PLAY then
            --Google AppStore
            params.token = token
        end

        params = json.encode(params)
        this.SendMessage(MSG_ID.MSG_PAY_NOTIFY,{pid = pid,orderId = orderId,payChannel = channel,payParams = params},false,true)
    end
end

function MainShopModel.S2C_ResponeServerIAPSuccess(code,data)
    Event.Brocast(EventName.Event_New_Pay_Signature_Result,code,data)
    if code == RET.RET_SUCCESS then
        if this._iap_success_callback then
            this._iap_success_callback()
            this._iap_success_callback = nil
        end
    else
        if this._iap_failure_callback then
            this._iap_failure_callback(code)
            this._iap_failure_callback = nil
        end
        if PurchaseHelper.IsPayAType() then
            PurchaseHelper.on_purchase_failure(nil,nil,nil,code)
        end

    end



    local platform = UnityEngine.Application.platform
    if data ~= nil and type(data) =="table" and data.pid ~= nil and  platform ~= UnityEngine.RuntimePlatform.WindowsEditor and platform ~= UnityEngine.RuntimePlatform.OSXEditor then
        PurchaseHelper.cleanStackPayload(data.pid)
        PurchaseHelper.cleanNewStackPayload(data.pid)
    end
end

function MainShopModel.S2C_NotifyShopItemUpdata(code,data)
    --log.r("========================>>S2C_NotifyShopItemUpdata " .. code)
    if code == RET.RET_SUCCESS and data then
        for key, value in pairs(data.items) do
            if shopDataDic[value.id] then
                shopDataDic[value.id] = deep_copy(value)
            end
        end
        Event.Brocast(EventName.Event_ShopDataUpdata)
        this:CheckFreeRewardAvailable()
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function MainShopModel.Purchasing_success()
    if this.cacheShopItemId then
        Facade.SendNotification(NotifyName.ShopView.BuySucceedReshpone,this.cacheShopItemId)
        
        if fun.is_ios_platform()  then 
            local shopItem = Csv.GetData("shop",this.cacheShopItemId)
            local productId = shopItem.product_id 
            local productItem = Csv.GetData("appstorepurchaseconfig",productId,"product_id")
            if shopItem ~= nil and productItem ~= nil then 
                SDK.LogFbPurchase( productItem,shopItem.price,"US")
            end 
        end 
    end
end

function MainShopModel.Purchasing_failure()
    if this.cacheShopItemId then
        Facade.SendNotification(NotifyName.ShopView.BuyFailureReshone,this.cacheShopItemId)
        SDK.purchase_failed({itemType = this.cacheShopItemId})
    end
end

function MainShopModel.C2S_RequestActivityPay(activityId,activityName)
    this.SendMessage(MSG_ID.MSG_ACTIVITY_PAY,{itemId = activityId, activityName = activityName})
end

function MainShopModel.S2C_ResponeActivityPay(code,data)
    if code == RET.RET_SUCCESS and data then
        if data.code == 0 then
            activityPayData = deep_copy(data)
        end
    end
    Facade.SendNotification(NotifyName.ShopView.ActivityPayResult, (data and {data.code} or {-1})[1])
end

function MainShopModel.C2S_RequestGroceryNotify()
    this.SendMessage(MSG_ID.MSG_GROCERY_NOTIFY,{})
end

function MainShopModel.S2C_ResponeGroceryNotify(code,data)
    if code == RET.RET_SUCCESS and data then
        for _,v in pairs(data) do
            groceryList[v.id] = deep_copy(v) 
        end
    end
    Facade.SendNotification(NotifyName.Grocery.GroceryInfoUpdate, this.BuyId )
end

function MainShopModel.C2S_RequestBuyGrocery(id)
    this.SendMessage(MSG_ID.MSG_BUY_GROCERY,{id =id})
end

function MainShopModel.S2C_ResponeBuyGrocery(code,data)
    if code == RET.RET_SUCCESS and data then
        this.BuyId = data.id
        local grocery_item = Csv.GetData("grocery",data.id)
        if grocery_item == nil then
            return
        end
        local productId = grocery_item.product_id  --Csv.GetData("pop_up",giftId,"product_id")
        if 0 == productId then --免费商品不需要发消息
            return
        end
        productId = Csv.GetData("appstorepurchaseconfig",productId,"product_id")
        if productId then
            if PurchaseHelper.IsEditorPurchase() then
                if not data.pid or tostring(data.pid) =="" then
                    if this.Purchasing_Grocery_success then 
                        this.Purchasing_Grocery_success()
                    end 
                else 
                    this.C2S_NotifyServerIAPSuccess(nil,productId,data.pid,nil,nil,function()
                        this:Purchasing_Grocery_success()
                    end,function()
                        this:Purchasing_Grocery_failure()
                    end)
                end 
            else
                if not data.pid or tostring(data.pid) == "" then 
                    if this.Purchasing_Grocery_failure then 
                        this.Purchasing_Grocery_failure()
                    end 
                else
                    local product_name = Csv.GetData("appstorepurchaseconfig", productId, "product_name")
                    PurchaseHelper.PurchasingType(1,product_name)
                    PurchaseHelper.DoPurchasing(deep_copy(data),grocery_item,productId,data.pid,this.Purchasing_Grocery_success,this.Purchasing_Grocery_failure)
                end 
               
            end
        end
    else
        if code == RET.RET_ORDER_CREATE_FAILED then
            UIUtil.show_common_popup(9025,true,nil)
        elseif code == RET.RET_SHOP_ITEM_EXPIRED then
            UIUtil.show_common_popup(9026,true,nil)   
        elseif code == RET.RET_ITEM_BUY_LIMITED then
            UIUtil.show_common_popup(9027,true,nil)   
        elseif code == RET.RET_ORDER_COMPLETED then
            UIUtil.show_common_popup(9028,true,nil)   
        elseif code == RET.RET_SHOP_BUY_IN_CD then
            UIUtil.show_common_popup(9029,true,nil)
        end
    end
end

function MainShopModel.Purchasing_Grocery_success()
    log.r("购买礼包成功")

    ---发送需要表现出来
    Facade.SendNotification(NotifyName.Grocery.GroceryBuySuccess, this.BuyId )
end

function MainShopModel.Purchasing_Grocery_failure()
    log.r("购买礼包失败")
    Facade.SendNotification(NotifyName.Grocery.GroceryBuyFailure, this.BuyId )
end

function MainShopModel.GetGroceryInfo(id,params)
    if params and groceryList[id] then
        return groceryList[id][params]
    end
    return groceryList[id]
end

function MainShopModel.ResetNewPayCallBack(success_callback,failure_callback)
    this._iap_success_callback = success_callback
    this._iap_failure_callback = failure_callback
end


--- 音符兑换返回
function MainShopModel.C2S_VICTORY_BEATS_NOTE_EXCHANGE(itemId)
    this.SendMessage(MSG_ID.MSG_VICTORY_BEATS_NOTE_EXCHANGE,{itemId = itemId},false)
end

--- 音符兑换返回
function MainShopModel.S2C_Respone_VICTORY_BEATS_NOTE_EXCHANGE(code,data)
    if code == RET.RET_SUCCESS and data and data.reward then
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,data.reward,function()

            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
        end)
    elseif code == RET.RET_VICTORY_BEATS_NOTE_NOT_ENOUGH then
        UIUtil.show_common_popup(8044,true,nil)
    end
end

---------------------------new --------------------


function MainShopModel.Purchasing_failure_new()
    if this.cacheShopItemId then
        Facade.SendNotification(NotifyName.ShopView.BuyFailureReshone,this.cacheShopItemId)
        --SDK.purchase_failed({itemType = this.cacheShopItemId})
    end
end

----------------------------------------------------
function MainShopModel.CheckMainShopDataExist(shopType)
    if shopData and shopData[shopType] then
        return true
    end
    return false
end

function MainShopModel.S2C_FetchPU(code,data)
    log.log("pu数据检查 " , code , data)
    if code == RET.RET_SUCCESS and data then
        for k ,v in pairs(data.userPowerUps) do
            ownPUData[v.powerUpId] = v.num
        end
        Event.Brocast(BingoBangEntry.mainShopViewEvent.RefreshShopTypeView)
    else
        ownPUData = {}
    end
end

function MainShopModel.GetPUNum()
    local num = 0
    for k ,v in pairs(ownPUData) do
        num = num + v
    end
    return num
end

function MainShopModel.GetOwnPU()
    return ownPUData
end

function MainShopModel.C2S_FetchPU()
    this.SendMessage(MSG_ID.MSG_BINGO_GAME_GET_POWER_UP,{index = shopType})
end


this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_FETCH_SHOP,func = this.S2C_FetchShopResult},
    {msgid = MSG_ID.MSG_BUY_ITEM,func = this.S2C_ResponeBuyItem},
    {msgid = MSG_ID.MSG_PAY_NOTIFY,func = this.S2C_ResponeServerIAPSuccess},
    {msgid = MSG_ID.MSG_SHOP_ITEM_NOTIFY,func = this.S2C_NotifyShopItemUpdata},
    {msgid = MSG_ID.MSG_ACTIVITY_PAY,func = this.S2C_ResponeActivityPay},
    {msgid = MSG_ID.MSG_BUY_GROCERY,func = this.S2C_ResponeBuyGrocery},
    {msgid = MSG_ID.MSG_GROCERY_NOTIFY,func = this.S2C_ResponeGroceryNotify},
    {msgid = MSG_ID.MSG_VICTORY_BEATS_NOTE_EXCHANGE,func = this.S2C_Respone_VICTORY_BEATS_NOTE_EXCHANGE},
    {msgid = MSG_ID.MSG_BINGO_GAME_GET_POWER_UP,func = this.S2C_FetchPU},
    
}

return this