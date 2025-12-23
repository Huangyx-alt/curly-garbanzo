
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    if ModelList.PlayerInfoSysModel:CheckHasUnlockNew() then
        Event.AddListener(EventName.Event_show_unlock_avatar_or_frame_view,PopupOrder.Finish)
        Facade.SendNotification(NotifyName.ShowUI,ViewList.PlayerInfoSysNewIconView)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_show_unlock_avatar_or_frame_view ")
    Event.RemoveListener(EventName.Event_show_unlock_avatar_or_frame_view,PopupOrder.Finish)
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder