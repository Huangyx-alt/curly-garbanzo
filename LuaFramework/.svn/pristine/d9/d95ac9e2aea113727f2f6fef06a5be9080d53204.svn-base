
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

local isPopup = nil

function PopupOrder.Execute(arg)
    PopupOrder.Finish()
    --local first = ModelList.ActivityModel:IsFirstOpen(ActivityTypes.quickTask)
    --local isAvailable =  ModelList.ActivityModel:IsActivityAvailable(ActivityTypes.quickTask)
    --if isAvailable and first and not isPopup then
    --    --弹出限时任务第一次开启框
    --    isPopup = true
    --    Event.AddListener(EventName.Event_popup_activity_finish,PopupOrder.Finish,this)
    --    Facade.SendNotification(NotifyName.ShowUI,ViewList.QuickTaskPromotedView)
    --else
    --    PopupOrder.Finish()
    --end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_popup_activity_finish,PopupOrder.Finish,this)
  --  log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder