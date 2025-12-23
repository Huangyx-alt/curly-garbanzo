local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(occasion)
    PopupOrder.Finish()
    --if occasion ~= PopupOrderOccasion.changeCity and
    --ModelList.CompetitionModel:IsActivityAvailable(ActivityTypes.quickTask) then
    --    Event.AddListener(EventName.Event_topquicktask_animafinish,PopupOrder.Finish)
    --    Event.Brocast(EventName.Event_show_topquick_task)
    --else
    --    PopupOrder.Finish()
    --end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_topquicktask_animafinish,PopupOrder.Finish)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder