local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder


function PopupOrder.Execute(arg)
  
    local data =  ModelList.CityModel.GetDownloadList()

    if #data >0 then 
        for id,v in pairs(data) do 
            if v == true then 
                Facade.SendNotification(NotifyName.ShowUI,ViewList.SpecialGameplayTip,nil,nil,id)
                break;
            end 
        end 
    end 

    PopupOrder.Finish()
end

function PopupOrder.Finish()
   -- Event.RemoveListener(EventName.Event_popup_BankAdvertising_finish,PopupOrder.Finish,this)
   log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder