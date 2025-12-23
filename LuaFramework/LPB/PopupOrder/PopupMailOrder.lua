
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(args)
    local mailRecordID = ModelList.MailModel.havePopMail()
    if mailRecordID > 0 then 
        Event.AddListener(EventName.Event_popup_MailPop_finish,this.Finish)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.MailMessagePopView,nil,nil,{RecordId =mailRecordID})
    else 
        this.Finish()
    end 
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_MailPop_finish,this.Finish)
    this.NotifyCurrentOrderFinish()
end

return this