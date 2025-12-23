
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    local main_reddot = ModelList.TaskModel.GetRewardInfo(TaskToggle.main)
    if main_reddot.canGetReward then
        Event.AddListener(EventName.Event_popup_levelup_finish,PopupOrder.Finish,this)
        Facade.SendNotification(NotifyName.ShowUI,ViewList.MainTaskLevelUpView)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_popup_levelup_finish,PopupOrder.Finish,this)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder