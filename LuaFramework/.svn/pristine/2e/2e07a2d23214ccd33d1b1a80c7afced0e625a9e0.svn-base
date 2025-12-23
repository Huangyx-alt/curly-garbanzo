
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupGemQueenPassPurchaseOrder = Clazz(BaseOrder, "PopupGemQueenPassPurchaseOrder")
local this = PopupGemQueenPassPurchaseOrder

function PopupGemQueenPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupGemQueenPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupGemQueenPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupGemQueenPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupGemQueenPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupGemQueenPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupGemQueenPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end

    if extra.playType ~= 13 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupGemQueenPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(12)
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