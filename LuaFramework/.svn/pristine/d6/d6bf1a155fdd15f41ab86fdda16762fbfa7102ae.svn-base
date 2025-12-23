PurchaseHelper = {}
local this = PurchaseHelper
-- local _iap = IAPHelper.Instance
local _googleIAP = IAPManager_Google.Instance
local json = require "cjson"

this.timerTask = nil       --轮询的定时器
this.stackPurchase = {}
this.newStackPurchase = {} -- 新支付堆栈
this.PayType = 0           -- 支付类型

function PurchaseHelper.Initialize()
    PurchaseHelper.GoogleIAPInit()
end

-- function PurchaseHelper.IapInit()
--     _iap:RegisterProducts(this.get_products())
--     _iap:RegisterInitializeCallback(this.on_purchase_initial)
--     _iap:RegisterSuccessCallback(this.on_purchase_success)
--     _iap:RegisterFailCallback(this.on_purchase_failure)
--     _iap:RegisterPendingCallback(this.on_purchase_pending)
--     _iap:Initialize()
-- end
function PurchaseHelper.GoogleIAPInit()
    _googleIAP:RegisterInitializeCallback(this.on_purchase_initial)
    _googleIAP:RegisterSuccessCallback(this.on_purchase_success)
    _googleIAP:RegisterFailCallback(this.on_purchase_failure)
    _googleIAP:RegisterPendingCallback(this.on_purchase_pending)
    _googleIAP:Init()
    _googleIAP:RequestProducts(this.get_products())
end

function PurchaseHelper.get_products()
    --  local platform = UnityEngine.Application.platform
    -- if platform == UnityEngine.RuntimePlatform.Android then
    --     return this.get_products_by_platform("android")
    -- elseif platform == UnityEngine.RuntimePlatform.IPhonePlayer or platform == UnityEngine.RuntimePlatform.OSXPlayer then
    --     return this.get_products_by_platform("ios")
    -- end
    return this.get_products_by_platform()
end

function PurchaseHelper.get_products_by_platform()
    local data = Csv.appstorepurchaseconfig
    local ret = {}
    -- for _, v in pairs(data) do
    --     -- if(v.platform == platformStr)then
    --     ret[v.product_id] = v.type
    --     --  end
    -- end

    for _, v in pairs(data) do
        -- if(v.platform == platformStr)then
        table.insert(ret,v.product_id)
        --  end
    end

    return ret
end

function PurchaseHelper.on_purchase_initial()
    if this.not_finish_iap() then
        local orderId, productId, token, pid, currency = this.get_orderinfo()
        if orderId and productId and token and pid and currency then
            this.NotifyServerIAPSuccess(orderId, productId, pid, token, currency, nil, this.IAP_success_cb,
                this.IAP_failure_cb)
        end
    end
end

function PurchaseHelper.WebviewCallBack(msg)
    log.e("msg   = " .. msg)
    if string.find(msg, "{") then
        -- json字符串
        local data = JsonToTable(msg)
        if data.event then
            log.e("msg   = " .. data.event)
            if data.event == "WaitPay" then
                -- 弹出loading
                if ViewList.PayLoadingView and fun.is_not_null(ViewList.PayLoadingView.go) then
                    ViewList.PayLoadingView:ShowLoading()
                end
            elseif data.event == "PaymentSuccess" then
                --支付成功
                PurchaseHelper.payResult = 1
                PurchaseHelper.extraData = data.data
                Event.Brocast(EventName.Event_New_Pay_Result, true)
                this.on_purchase_success()
            elseif data.event == "close" then
                -- 点击关闭
                Event.Brocast(EventName.Event_Close_Web_View, true)
                Facade.SendNotification(NotifyName.ShopView.CloseLoadingView)
            elseif data.event == "StartedView" then
                -- 启动准备界面
                --Event.Brocast(EventName.Event_Show_Pay_Loading_View,true)
            end
        end
    elseif msg == "close" then
        Event.Brocast(EventName.Event_Close_Web_View, true)
        Facade.SendNotification(NotifyName.ShopView.CloseLoadingView)
        local g = GameObject.Find("WebViewObject")
        Destroy(g)
    end
end

function PurchaseHelper.ReSetData()
    PurchaseHelper.payResult = 0 -- 0 待支付  1 支付成功
end

function PurchaseHelper.DoPurchasing(data, shopItem, product_id, payload, suc_callback, fail_callback)
    if data and data.payExtra and data.payExtra ~= "" then
        --local hh = LuaFramework.GameManager
        this.suc_callback = suc_callback
        this.fail_callback = fail_callback
        this.save_product_id = product_id
        this.save_payload = payload
        this.save_data = data
        this.save_shopItem = shopItem
        UserData.set_nocache("IAP_PAYLOAD", payload)
        this.PayType = 1
        PurchaseHelper.ReSetData()
        this.newStackPurchase[payload] = { product_id = product_id, payload = payload }
        Facade.SendNotification(NotifyName.ShowUI, ViewList.PayLoadingView, nil, nil, {
            payExtra   = data.payExtra,
            product_id = product_id,
            data       = deep_copy(data)
        })
    else
        if data and product_id then
            this.suc_callback = suc_callback
            this.fail_callback = fail_callback
            this.save_product_id = product_id
            this.save_payload = payload
            this.save_data = data
            this.save_shopItem = shopItem

            UserData.set_nocache("IAP_PAYLOAD", payload)
            this.PayType = 0
            log.r("========================>>PurchaseHelper.DoPurchasing" .. product_id .. "   " .. payload)
            -- _iap:DoPurchasing(product_id, payload)
            _googleIAP:BuyProduct(product_id,true)
            log.r("发起支付 payload" .. payload)
            this.stackPurchase[payload] = { product_id = product_id, payload = payload }
        end
    end
end

function PurchaseHelper.on_purchase_success1(product_id, transaction_id, receipt, currency)
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView)

    if fun.is_ios_platform() then -- iOS平台
        local token = currency
        local orderId = transaction_id
        local productId = product_id
        this.payingFlag = false
        local pid = this.save_payload
        local payload = this.save_payload
        if StringUtil.is_empty(pid) then
            pid = UserData.read_nocache("IAP_PAYLOAD")
        end
        if StringUtil.is_empty(tostring(pid)) or StringUtil.is_empty(token) or StringUtil.is_empty(orderId) or StringUtil.is_empty(tostring(productId)) then
            SDK.purchase_exception({itemid = this.GetItemId() , payload = payload, token = token or payload, orderId = orderId or payload, productId =
            productId or payload })
            this.NotifyServerIAPSuccess(orderId or payload, productId or payload, pid, token or orderId, currency,
                    receipt, this.IAP_success_cb, this.IAP_failure_cb, 1)
            UIUtil.show_common_popup(9030, true, nil)
        else
            this.save_orderinfo(productId, orderId, token, currency, pid)
            this.NotifyServerIAPSuccess(orderId, productId, pid, token, currency, receipt, this.IAP_success_cb,
                    this.IAP_failure_cb)
        end

        if this.stackPurchase[pid] then
            this.stackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                token = token,
                orderId = orderId,
                receipt = receipt,
                payChannel = ModelList.MainShopModel.get_pay_channel()
            }
            fun.save_value("stackPurchase", this.stackPurchase)
        end
        if this.newStackPurchase[pid] then
            this.newStackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                token = token,
                orderId = orderId,
                receipt = receipt,
                payChannel = ModelList.MainShopModel.get_pay_channel()
            }
            fun.save_value("newStackPurchase", this.newStackPurchase)
        end
    else -- Android平台（Google Play Billing）
        local payload = this.save_payload
        log.r("支付回调成功 回给服务器 payload: " .. payload .. " json信息: " .. receipt)

        -- 直接解析receipt，因为Google Play Billing的receipt是直接的JSON字符串
        local success, tJson = pcall(json.decode, receipt)
        if not success then
            log.r("解析receipt失败: " .. tostring(tJson))
            -- 错误处理
            SDK.purchase_exception({itemid = this.GetItemId() , payload = payload, token = "", orderId = "", productId = product_id })
            this.NotifyServerIAPSuccess("", product_id, payload, "", currency, receipt, this.IAP_success_cb,
                    this.IAP_failure_cb, 1)
            UIUtil.show_common_popup(9030, true, nil)
            return
        end

        local token = tJson.purchaseToken
        local orderId = tJson.orderId
        local productId = product_id -- 使用参数中的product_id，也可以从tJson中获取: tJson.productId

        this.payingFlag = false
        local pid = payload
        if StringUtil.is_empty(pid) then
            pid = UserData.read_nocache("IAP_PAYLOAD")
        end

        if StringUtil.is_empty(tostring(pid)) or StringUtil.is_empty(token) or StringUtil.is_empty(orderId) or StringUtil.is_empty(tostring(productId)) then
            -- 致命错误
            SDK.purchase_exception({itemid = this.GetItemId() , payload = payload, token = token or payload, orderId = orderId or payload, productId =
            productId or payload })
            this.NotifyServerIAPSuccess(orderId or payload, productId or payload, pid, token or orderId, currency,
                    receipt, this.IAP_success_cb, this.IAP_failure_cb, 1)
            UIUtil.show_common_popup(9030, true, nil)
        else
            this.save_orderinfo(productId, orderId, token, currency, pid)
            this.NotifyServerIAPSuccess(orderId, productId, pid, token, currency, receipt, this.IAP_success_cb,
                    this.IAP_failure_cb)
            -- Facade.SendNotification(NotifyName.ShopView.BuySucceed, ViewList.MainShopView, productId)
        end

        -- 保存购买信息
        if this.stackPurchase[pid] then
            this.stackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                token = token,
                orderId = orderId,
                receipt = receipt,
                payChannel = ModelList.ShopModel.get_pay_channel()
            }
            fun.save_value("stackPurchase", this.stackPurchase)
        end
        if this.newStackPurchase[pid] then
            this.newStackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                token = token,
                orderId = orderId,
                receipt = receipt,
                payChannel = ModelList.ShopModel.get_pay_channel()
            }
            fun.save_value("newStackPurchase", this.newStackPurchase)
        end
    end

    --发起的时候
    if not this.timerTask then
        this.timerTask = LuaTimer:SetDelayFunction(10, function()
            if (this.stackPurchase == nil or #this.stackPurchase == 0)
                    and (this.newStackPurchase == nil or #this.newStackPurchase == 0) then
                LuaTimer:Remove(this.timerTask)
                this.timerTask = nil
                return;
            end

            local index = 0
            for _, v in pairs(this.stackPurchase) do
                if v == nil then
                    index = index + 1
                else
                    log.r(" 支付等待中的十秒轮询 payload" .. v.payload)
                    Http.PollPayState(v.payload, v.orderId, v.token, v.product_id, v.receipt, function()
                        log.r(" 支付等待中的十秒轮询 消息已回 payload" .. v.payload)
                        PurchaseHelper.cleanStackPayload(v.payload)
                    end, v.payChannel)
                end
            end

            if index == #this.stackPurchase then
                this.stackPurchase = {}
            end



            index = 0
            for _, v in pairs(this.newStackPurchase) do
                if v == nil then
                    index = index + 1
                else
                    log.r(" 支付等待中的十秒轮询 payload" .. v.payload)
                    Http.PollPayState(v.payload, v.orderId, v.token, v.product_id, v.receipt, function()
                        log.r(" 支付等待中的十秒轮询 消息已回 payload" .. v.payload)
                        PurchaseHelper.cleanNewStackPayload(v.payload)
                    end, v.payChannel)
                end
            end

            if index == #this.newStackPurchase then
                this.newStackPurchase = {}
            end
        end)
    end
end

function PurchaseHelper.on_purchase_success(product_id, transaction_id, receipt, currency)
    if this.PayType ~= 1 then
        this.on_purchase_success1(product_id, transaction_id, receipt, currency)
    else
        this.on_purchase_success2(product_id, transaction_id, receipt, currency)
    end
end

function PurchaseHelper.NotifyServerIAPSuccess(orderId, productId, pid, token, currency, receipt, success_cb, failure_cb,
                                               errorcode)
    ModelList.MainShopModel.C2S_NotifyServerIAPSuccess(orderId, productId, pid, token, currency, receipt, success_cb,
            failure_cb, errorcode)
end

function PurchaseHelper.on_purchase_failure(product_id, failureReason, failureCode)
    if this.save_shopItem then
        log.log("购买失败的道具 " , this.save_shopItem)
        local orderId, productId, token, pid, currency = this.get_orderinfo()
        Http.report_event("purchase_failed",
                {viplevel = vipLv ,
                 itempos = this.save_shopItem.cehuakan , 
                 price = this.save_shopItem.price,
                 purchasefailedreason = failureCode , 
                 itemid = this.save_shopItem.id,payload = pid, 
                 token = token or pid, 
                 orderId = orderId or pid,
                 productId = productId or pid})
    else
        log.r("错误的购买参数 ")
    end
    this.IAP_failure_cb()
    local vipLv = ModelList.PlayerInfoModel:GetVIP()
    local level = ModelList.PlayerInfoModel:GetLevel()
    if failureCode == -1 then

    elseif failureCode == 0 then
        -- IAP may be disabled in device settings
        UIUtil.show_common_popup(9036, true, nil)
    elseif failureCode == 1 then
        -- body
    elseif failureCode == 2 then
        UIUtil.show_common_popup(9035, true, nil)
    elseif failureCode == 3 then
        UIUtil.show_common_popup(9034, true, nil)
    elseif failureCode == 4 then
        UIUtil.show_common_popup(9033, true, nil)
        if this.save_shopItem then
            Http.report_event("purchase_cancel",{level = level, viplevel = vipLv ,itempos = this.save_shopItem.cehuakan , count = 1 , price = this.save_shopItem.price })
        end
    elseif failureCode == 5 then
        UIUtil.show_common_popup(9032, true, nil)
    elseif failureCode == 6 then
        UIUtil.show_common_popup(9031, true, nil)
    elseif failureCode == 7 then
        -- 未知错误
    end
end

function PurchaseHelper.IAP_success_cb()
    this.clean_orderinfo()
    if this.suc_callback then
        this.suc_callback()
    end
end

function PurchaseHelper.IAP_failure_cb()
    this.clean_orderinfo()
    if this.fail_callback then
        this.fail_callback()
    end

    local orderId, productId, token, pid, currency = this.get_orderinfo()
    SDK.purchase_exception({itemid = this.GetItemId() ,payload = pid, token = token or pid, orderId = orderId or pid,productId = productId or pid})
end

--重登的时候，发3003
function PurchaseHelper.reLoginSetStackPurchase()
    local tb = fun.read_value("stackPurchase", nil)

    if tb ~= nil then
        log.g("重登的时候，发3003" .. #tb)
        this.stackPurchase = tb;

        for _, v in pairs(this.stackPurchase) do
            if v ~= nil then
                log.r(" 支付等待中的十秒轮询 payload" .. v.payload)
                Http.PollPayState(v.payload, v.orderId, v.token, v.product_id, v.receipt, function()
                    log.r(" 支付等待中的十秒轮询 消息已回 payload" .. v.payload)
                    PurchaseHelper.cleanStackPayload(v.payload)
                end, v.payChannel)
            end
        end
    end

    tb = fun.read_value("newStackPurchase", nil)

    if tb ~= nil then
        log.g("重登的时候，发3003" .. #tb)
        this.newStackPurchase = tb;

        for _, v in pairs(this.newStackPurchase) do
            if v ~= nil then
                log.r(" 支付等待中的十秒轮询 payload" .. v.payload)
                Http.PollPayState(v.payload, v.orderId, v.token, v.product_id, v.receipt, function()
                    log.r(" 支付等待中的十秒轮询 消息已回 payload" .. v.payload)
                    PurchaseHelper.cleanNewStackPayload(v.payload)
                end, v.payChannel)
            end
        end
    end
end

--清除堆栈信息
function PurchaseHelper.cleanStackPayload(playload)
    if not playload or not this.stackPurchase then
        log.r("清除 playload 堆栈失败 not playload")
        return
    end

    if not this.stackPurchase[playload] then
        log.r("清除 playload 堆栈失败 not this.stackPurchase[playload]")
        return
    end
    log.r("清除 playload 堆栈成功" .. playload)
    this.stackPurchase[playload] = nil
    fun.save_value("stackPurchase", this.stackPurchase)
end

--清除堆栈信息
function PurchaseHelper.cleanNewStackPayload(playload)
    if not playload or not this.newStackPurchase then
        log.r("清除 playload 堆栈失败 not playload")
        return
    end

    if not this.newStackPurchase[playload] then
        log.r("清除 playload 堆栈失败 not this.newStackPurchase[playload]")
        return
    end
    log.r("清除 playload 堆栈成功" .. playload)
    this.newStackPurchase[playload] = nil
    fun.save_value("newStackPurchase", this.newStackPurchase)
end

function PurchaseHelper.on_purchase_pending(product_id, transaction_id, receipt, currency)
    UIUtil.show_common_popup(8012, true, function()
        this.on_purchase_success(product_id, transaction_id, receipt, currency,this.save_payload)
    end)
end

function PurchaseHelper.not_finish_iap()
    return UserData.read_nocache("IAP_WAITING") ~= nil
end

function PurchaseHelper.save_orderinfo(productId, orderId, token, currency, payload)
    UserData.set_nocache("IAP_WAITING", 1)
    UserData.set_nocache("IAP_ORDER_ID", orderId)
    UserData.set_nocache("IAP_PRODUCT_ID", productId)
    UserData.set_nocache("IAP_TOKEN", token)
    UserData.set_nocache("PID", tostring(payload)) --- pid应该是个字符串
    UserData.set_nocache("CURRENCY", currency)
end

function PurchaseHelper.get_orderinfo()
    local iap_waiting = UserData.read_nocache("IAP_WAITING")
    if iap_waiting then
        local waitting = UserData.read_nocache("IAP_WAITING")
        local orderId = UserData.read_nocache("IAP_ORDER_ID")
        local productId = UserData.read_nocache("IAP_PRODUCT_ID")
        local token = UserData.read_nocache("IAP_TOKEN")
        local pid = UserData.read_nocache("PID")
        local currency = UserData.read_nocache("CURRENCY")
        return orderId, productId, token, pid, currency
    end
    return nil
end

function PurchaseHelper.clean_orderinfo()
    local iap_waiting = UserData.read_nocache("IAP_WAITING")
    if iap_waiting then
        UserData.delete_nocache("IAP_WAITING")
        UserData.delete_nocache("IAP_ORDER_ID")
        UserData.delete_nocache("IAP_PRODUCT_ID")
        UserData.delete_nocache("IAP_TOKEN")
        UserData.delete_nocache("PID")
        UserData.delete_nocache("CURRENCY")
    end
end

--------------------------new --------------------------------

function PurchaseHelper.on_purchase_success2()
    Facade.SendNotification(NotifyName.HideUI, ViewList.NetLoadingView)
    local product_id = this.save_product_id
    local transaction_id = this.save_data.transactionId
    --local receipt,
    local currency = this.save_data.currency
    local payload = this.save_payload

    if fun.is_ios_platform() then --ios 平台下
        local token = currency
        local orderId = transaction_id
        local productId = product_id
        this.payingFlag = false
        local pid = payload
        if StringUtil.is_empty(pid) then
            pid = UserData.read_nocache("IAP_PAYLOAD")
        end
        --log.r("支付回调 payload"..pid)
        if StringUtil.is_empty(tostring(pid)) then
            --致命错误
            SDK.purchase_exception({itemid = this.GetItemId(),payload = payload, token = token or payload, orderId = orderId or payload,productId = productId or payload})
            this.NotifyServerIAPSuccess(orderId or payload, productId or payload, pid, token or orderId, currency,
                    receipt, this.IAP_success_cb, this.IAP_failure_cb, 1)
            UIUtil.show_common_popup(9030, true, nil)


            log.r("StringUtil.is_empty(tostring(pid))" .. tostring(StringUtil.is_empty(tostring(pid))))
            log.r(" StringUtil.is_empty(token) " .. tostring(StringUtil.is_empty(token)))
            log.r("StringUtil.is_empty(orderId) " .. tostring(StringUtil.is_empty(orderId)))
            log.r("StringUtil.is_empty(tostring(productId))" .. tostring(StringUtil.is_empty(tostring(productId))))
            if payload and receipt then
                log.r("支付回调失败 回给服务器 payload" .. payload .. "json 信息" .. receipt)
            end
        else
            this.save_orderinfo(productId, orderId, token, currency, pid)
        end
        if this.newStackPurchase[pid] then
            this.newStackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                token = token,
                orderId = orderId,
                receipt = receipt,
            }
            fun.save_value("newStackPurchase", this.newStackPurchase)
        end
    else --安卓平台下
        local productId = product_id
        this.payingFlag = false
        local pid = payload
        if StringUtil.is_empty(pid) then
            pid = UserData.read_nocache("IAP_PAYLOAD")
        end
        --log.r("支付回调 payload"..pid)
        if StringUtil.is_empty(tostring(pid)) or StringUtil.is_empty(tostring(productId)) then
            --致命错误
            SDK.purchase_exception({itemid = this.GetItemId() , payload = payload, token = token or payload, orderId = orderId or payload,productId = productId or payload})
            this.NotifyServerIAPSuccess(orderId or payload, productId or payload, pid, token or orderId, currency,
                    receipt, this.IAP_success_cb, this.IAP_failure_cb, 1)
            UIUtil.show_common_popup(9030, true, nil)


            log.r("StringUtil.is_empty(tostring(pid))" .. tostring(StringUtil.is_empty(tostring(pid))))
            log.r(" StringUtil.is_empty(token) " .. tostring(StringUtil.is_empty(token)))
            log.r("StringUtil.is_empty(orderId) " .. tostring(StringUtil.is_empty(orderId)))
            log.r("StringUtil.is_empty(tostring(productId))" .. tostring(StringUtil.is_empty(tostring(productId))))
            if payload and receipt then
                log.r("支付回调失败 回给服务器 payload" .. payload .. "json 信息" .. receipt)
            end
        else
            this.save_orderinfo(productId, orderId, token, currency, pid)
        end
        if this.newStackPurchase[pid] then
            this.newStackPurchase[pid] = {
                product_id = product_id,
                payload = pid,
                receipt = receipt
            }
            fun.save_value("newStackPurchase", this.newStackPurchase)
        end
    end
end

function PurchaseHelper.IsPayAType()
    return (this.PayType and this.PayType == 1) and true or false
end

---@param type any: 商店1 礼包2 通行证3 金令牌4 短令牌5 转盘6 火山复活7 winzone复活8
function PurchaseHelper.PurchasingType(type, product_name)
    this.purchaseType = type
    this.product_name = product_name
end

function PurchaseHelper.GetPurchasingInfo()
    return this.purchaseType or 1, this.product_name or 1
end

function PurchaseHelper.IsEditorPurchase()
    local platform = UnityEngine.Application.platform
    if this.PayType == 1 then
        return false
    end
    return (platform == UnityEngine.RuntimePlatform.WindowsEditor or platform == UnityEngine.RuntimePlatform.OSXEditor) and
    true or false
end

function PurchaseHelper.GetItemId()
    if this.save_shopItem then
        return this.save_shopItem.id
    end
    return ""
end
