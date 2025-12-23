
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    PopupOrder.Finish()
    --
    --local rofyid = ModelList.RofyModel:GetRofyId()
    --local popUpType = nil
    --local isPopup = false
    --if ModelList.RofyModel:CanPopupRofy() then
    --    if rofyid then
    --        popUpType = Csv.GetData("reward_sky",rofyid,"application")
    --    end
    --    if CityHomeScene:IsNormalLobby() then
    --        if popUpType and popUpType ~= 2 then
    --            isPopup = true
    --        end
    --    elseif CityHomeScene:IsAutoLobby() then
    --        if popUpType and popUpType ~= 1 then
    --            isPopup = true
    --        end    
    --    end
    --end
    --if isPopup then
    --    Event.AddListener(EventName.Event_popup_rofy_finish,PopupOrder.Finish,this)
    --    Facade.SendNotification(NotifyName.ShowUI,ViewList.AdventureView)
    --else
    --    PopupOrder.Finish()
    --end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_popup_rofy_finish,PopupOrder.Finish,this)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder