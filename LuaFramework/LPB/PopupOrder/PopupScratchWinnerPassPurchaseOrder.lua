
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupScratchWinnerPassPurchaseOrder = Clazz(BaseOrder, "PopupScratchWinnerPassPurchaseOrder")
local this = PopupScratchWinnerPassPurchaseOrder

function PopupScratchWinnerPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupScratchWinnerPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupScratchWinnerPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupScratchWinnerPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupScratchWinnerPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupScratchWinnerPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupScratchWinnerPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupScratchWinnerPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupScratchWinnerPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end
    
    if extra.playType ~= 29 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupScratchWinnerPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(29)
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
