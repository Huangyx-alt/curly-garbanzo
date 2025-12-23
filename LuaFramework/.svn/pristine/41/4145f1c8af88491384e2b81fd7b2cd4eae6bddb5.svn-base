
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupMoleMinerPassPurchaseOrder = Clazz(BaseOrder, "PopupMoleMinerPassPurchaseOrder")
local this = PopupMoleMinerPassPurchaseOrder

function PopupMoleMinerPassPurchaseOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        this.RefreshPopTime("PopupMoleMinerPassPurchaseOrder" .. playerInfo.uid, config)
        Event.AddListener(NotifyName.GamePlayShortPassView.PopupMoleMinerPassPurchaseOrderFinish, this.Finish, this)
        local params = {}
        params.isActiveByPopup = true
        Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView", params)
    else
        this.Finish()
    end
end

function PopupMoleMinerPassPurchaseOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupMoleMinerPassPurchaseOrderFinish")
    Event.RemoveListener(NotifyName.GamePlayShortPassView.PopupMoleMinerPassPurchaseOrderFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupMoleMinerPassPurchaseOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupMoleMinerPassPurchaseOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

function PopupMoleMinerPassPurchaseOrder.IsNeedPopup(config, occasion, extra)
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
    if not this.IsAllowPop("PopupMoleMinerPassPurchaseOrder" .. playerInfo.uid, config) then
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