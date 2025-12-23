local BaseOrder = require "PopupOrder/BaseOrder"
local PopupShopPromotionOrder = Clazz(BaseOrder, "")
local this = PopupShopPromotionOrder

function PopupShopPromotionOrder.Execute(args, orderData)
    local isNeedPopup = this.IsNeedPopup(orderData)
    --isNeedPopup = true
    if isNeedPopup then
        Event.AddListener(EventName.Event_Popup_Shop_Promotion_Finish, this.Finish)
        local view = require("View/ShopView/ShopPromotionPosterView"):New()
        Facade.SendNotification(NotifyName.ShowUI, view)
    else
        this.Finish()
    end
end

function PopupShopPromotionOrder.Finish()
    log.g("brocast  EventName.Event_Popup_Shop_Promotion_Finish ")
    Event.RemoveListener(EventName.Event_Popup_Shop_Promotion_Finish, this.Finish)
    this.NotifyCurrentOrderFinish()
end

function PopupShopPromotionOrder.IsNeedPopup(orderData)
    local isValid = ModelList.MainShopModel:IsPromotionValid()
    if not isValid then
        log.log("PopupShopPromotionOrder.IsNeedPopup f1")
        return false
    end

    --[[
    if ModelList.MainShopModel:GetPromotionRemainTime() <= 0 then
        log.log("PopupShopPromotionOrder.IsNeedPopup f2")
        return false
    end
    --]]
    
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local today = os.date("%Y%m%d", os.time()) .. playerInfo.uid
    local lastData =  fun.read_value("ShopPromotionPosterView" , 0)
    if lastData == today then
        log.log("PopupShopPromotionOrder.IsNeedPopup f2 今日已经弹过")
        return false
    end

    return true
end

return this