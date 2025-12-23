
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupVolcanoPassPurchaseOrder = Clazz(BaseOrder, "PopupVolcanoPassPurchaseOrder")
local this = PopupVolcanoPassPurchaseOrder

function PopupVolcanoPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupVolcanoPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupVolcanoPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupVolcanoPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupVolcanoPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupVolcanoPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupVolcanoPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupVolcanoPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupVolcanoPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end

    if extra.playType ~= 23 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupVolcanoPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(22)
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