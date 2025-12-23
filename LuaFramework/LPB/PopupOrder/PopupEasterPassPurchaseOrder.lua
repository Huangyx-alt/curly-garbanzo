
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupEasterPassPurchaseOrder = Clazz(BaseOrder, "PopupEasterPassPurchaseOrder")
local this = PopupEasterPassPurchaseOrder

function PopupEasterPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupEasterPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupEasterPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupEasterPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupEasterPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupEasterPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupEasterPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end

    if extra.playType ~= 22 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupEasterPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(21)
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