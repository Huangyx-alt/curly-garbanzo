local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute()

    Event.AddListener(EventName.Event_show_treasure_box_animafinish,PopupOrder.Finish)
    local foodBags = ModelList.CityModel:GetCityFoodBag() -- ModelList.CityModel:GetCityResourceNum(foodBagIds[city],city)
    local hasCount = false
    for i = 1, #foodBags do
        for k,v in pairs(foodBags) do
            if v.value > 0 then
                hasCount = true
                break
            end
        end
    end
    if #foodBags <= 0  or not hasCount then
        this.Finish()
    else
        --Facade.SendNotification(NotifyName.ShowUI, ViewList.FoodBagClaimView)
    end

    --this.Finish()
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_show_treasure_box_animafinish,PopupOrder.Finish)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder