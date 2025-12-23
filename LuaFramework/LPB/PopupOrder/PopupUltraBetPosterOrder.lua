local BaseOrder = require "PopupOrder/BaseOrder"
local PopupUltraBetPosterOrder = Clazz(BaseOrder, "PopupUltraBetPosterOrder")
local this = PopupUltraBetPosterOrder

function PopupUltraBetPosterOrder.Execute(arg)
    local isNeedPopup = ModelList.UltraBetModel:IsActivityNewlyOpen()
    --isNeedPopup = false --for test wait delete
    if isNeedPopup then
        Event.AddListener(EventName.Event_Popup_UltraBetPoster_Finish, this.Finish, this)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.UltraBetPosterView)
        ModelList.UltraBetModel:UpdatePopupPosterTimes()
    else
        this.Finish()
    end
end

function PopupUltraBetPosterOrder.Finish()
    Event.RemoveListener(EventName.Event_Popup_UltraBetPoster_Finish, this.Finish, this)
    log.g("brocast  EventName.Event_Popup_UltraBetPoster_Finish ")
    Event.Brocast(EventName.Event_popup_order_finish, true)
end

return PopupUltraBetPosterOrder