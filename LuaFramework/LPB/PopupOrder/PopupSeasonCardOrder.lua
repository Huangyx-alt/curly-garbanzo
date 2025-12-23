
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupSeasonCardOrder = Clazz(BaseOrder, "PopupSeasonCardOrder")
local this = PopupSeasonCardOrder
local DATE_FORMAT_STR = "%Y%m%d"

function PopupSeasonCardOrder.Execute(args, orderData)
    local isNeedPopup = this.IsNeedPopup(orderData)
    --isNeedPopup = true --for test
    if isNeedPopup then
        Event.AddListener(NotifyName.SeasonCard.PopupActivityPosterFinish, this.Finish, this)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardPosterView)
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        --fun.save_value(ModelList.SeasonCardModel.Consts.TODAY_TIMESTAMP .. playerInfo.uid, os.date(DATE_FORMAT_STR))
        --fun.save_value(ModelList.SeasonCardModel.Consts.TODAY_TIMESTAMP .. playerInfo.uid, os.time())
        local seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
        this.RefreshPopTime(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP..seasonId .. playerInfo.uid, orderData)
    else
        this.Finish()
    end
end

function PopupSeasonCardOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish  PopupSeasonCardOrder")
    Event.RemoveListener(NotifyName.SeasonCard.PopupActivityPosterFinish, this.Finish, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupSeasonCardOrder.IsNeedPopup(orderData)
    local isValid = ModelList.SeasonCardModel:IsActivityValid()
    if not isValid then
        log.log("PopupSeasonCardOrder.IsNeedPopup f1")
        return false
    end

    if ModelList.SeasonCardModel:GetLeftTime() <= 0 then
        log.log("PopupSeasonCardOrder.IsNeedPopup f2")
        return false
    end
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    if not this.IsAllowPop(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP..seasonId .. playerInfo.uid,orderData) then
        return false
    end
    return true
end

return this