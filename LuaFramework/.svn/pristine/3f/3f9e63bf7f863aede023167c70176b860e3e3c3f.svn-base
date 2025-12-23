local BaseOrder = require "PopupOrder/BaseOrder"
local PopupPassPurchaseOrder = Clazz(BaseOrder, "PopupPassPurchaseOrder")
local this = PopupPassPurchaseOrder

function PopupPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    if isNeedPopup then
        local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupPassPurchaseOrder" .. playerInfo.uid .. extra.playType, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupPassPurchaseOrderFinish, this.Finish, this)
        this.AddOtherPopPass()
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupPassPurchaseOrderFinish, this.Finish, this)
    this.RemoveOtherPopPass()
    this.NotifyCurrentOrderFinish()
end

function PopupPassPurchaseOrder.AddOtherPopPass()
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupVolcanoPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupPirateShipPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupBisonPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupHorseRacingPassPurchaseOrderFinish, this.Finish, this)
    Event.AddListener(NotifyName.GamePlayShortPassView.PopupScratchWinnerPassPurchaseOrderFinish, this.Finish, this)
end

function PopupPassPurchaseOrder.RemoveOtherPopPass()
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupVolcanoPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupEasterPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupGemQueenPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupPirateShipPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupBisonPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupHorseRacingPassPurchaseOrderFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupScratchWinnerPassPurchaseOrderFinish, this.Finish, this)
end


function PopupPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end
    --if occasion ~= PopupOrderOccasion.enterHallFromBattle then
    --    return false
    --end

    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if not playerInfo or not extra or not extra.playType then
        return false
    end
    if not this.IsAllowPop("PopupPassPurchaseOrder" .. playerInfo.uid .. extra.playType, config) then
        return false
    end
    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(extra.playType)
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
