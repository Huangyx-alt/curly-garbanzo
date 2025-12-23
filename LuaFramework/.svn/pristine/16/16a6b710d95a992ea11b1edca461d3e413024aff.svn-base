
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupGoldenTrainPassPurchaseOrder = Clazz(BaseOrder, "PopupGoldenTrainPassPurchaseOrder")
local this = PopupGoldenTrainPassPurchaseOrder

function PopupGoldenTrainPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupGoldenTrainPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupGoldenTrainPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupGoldenTrainPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupGoldenTrainPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupGoldenTrainPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupGoldenTrainPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupGoldenTrainPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupGoldenTrainPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
    if not extra then
        return false
    end
    
    if extra.playType ~= 26 then
        return false
    end

    if occasion ~= PopupOrderOccasion.enterHallFromBattle then
        return false
    end

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if not this.IsAllowPop("PopupGoldenTrainPassPurchaseOrder" .. playerInfo.uid, config) then
        return false
    end

    local model = ModelList.GameActivityPassModel.GetPassDataComponentById(26)
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