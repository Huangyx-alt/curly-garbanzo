
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupHorseRacingPassPurchaseOrder = Clazz(BaseOrder, "PopupHorseRacingPassPurchaseOrder")
local this = PopupHorseRacingPassPurchaseOrder

function PopupHorseRacingPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupHorseRacingPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupHorseRacingPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupHorseRacingPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupHorseRacingPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupHorseRacingPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupHorseRacingPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupHorseRacingPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupHorseRacingPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end
    
    if extra.playType ~= 28 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupHorseRacingPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(28)
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
