local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder


function PopupOrder.Execute(arg)
    --判断条件
    -- if false then 
    --     PopupOrder.Finish()
    -- else 

    --     PopupOrder.Finish()
    -- end 
    PopupOrder.Finish()
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_popup_BankAdvertising_finish,PopupOrder.Finish,this)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder