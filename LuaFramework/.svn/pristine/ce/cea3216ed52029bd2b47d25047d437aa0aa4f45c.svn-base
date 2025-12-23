local BaseOrder = require "PopupOrder/BaseOrder"
local PopupDiamondPromotionPosterOrder = Clazz(BaseOrder, "PopupDiamondPromotionPosterOrder")
local this = PopupDiamondPromotionPosterOrder
local TIMESTAMP = "PopupDiamondPromotionPosterTimestamp"

function PopupDiamondPromotionPosterOrder.Execute(arg, orderData)
    local isNeedPopup = PopupDiamondPromotionPosterOrder.IsNeedPopup(orderData)
    --isNeedPopup = false --for test wait delete
    if isNeedPopup then
        Event.AddListener(EventName.Event_Popup_DiamondPromotionPoster_Finish, this.Finish, this)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.DiamondPromotionPosterView)
        PopupDiamondPromotionPosterOrder.RecordPopTime(orderData)
    else
        this.Finish()
    end
end

function PopupDiamondPromotionPosterOrder.Finish()
    Event.RemoveListener(EventName.Event_Popup_DiamondPromotionPoster_Finish, this.Finish, this)
    log.g("brocast EventName.Event_Popup_DiamondPromotionPoster_Finish ")
    Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupDiamondPromotionPosterOrder.RecordPopTime(orderData)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    this.RefreshPopTime(TIMESTAMP .. playerInfo.uid,orderData)
end

function PopupDiamondPromotionPosterOrder.IsNeedPopup(orderData)
    local isValid = ModelList.GiftPackModel:IsPackAvailableByIcon("cEntdiamondsale")
    if not isValid then
        log.log("PopupDiamondPromotionPosterOrder.IsNeedPopup f1")
        return false
    end
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    return this.IsAllowPop(TIMESTAMP .. playerInfo.uid, orderData)

    --
    --recordDateStr = tonumber(recordDateStr) or 0
    --local popupCd = Csv.GetControlByName("cut_price_cd")[1][1] or 21600
    --if dateStr < recordDateStr + popupCd then
    --    log.log("PopupDiamondPromotionPosterOrder.IsNeedPopup f2")
    --    return false
    --end
    --
    --return true
end

return PopupDiamondPromotionPosterOrder