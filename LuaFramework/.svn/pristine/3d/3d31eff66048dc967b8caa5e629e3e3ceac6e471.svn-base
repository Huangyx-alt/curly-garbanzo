
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupPirateShipPassPurchaseOrder = Clazz(BaseOrder, "PopupPirateShipPassPurchaseOrder")
local this = PopupPirateShipPassPurchaseOrder

function PopupPirateShipPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupPirateShipPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupPirateShipPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupPirateShipPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupPirateShipPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupPirateShipPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupPirateShipPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupPirateShipPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupPirateShipPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end
    
    if extra.playType ~= 24 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupPirateShipPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(23)
    if not model then
        return false
    end

    local isPay = model:IsAnyPayment()
    if isPay then
        return false
    end

    return true
end

return this