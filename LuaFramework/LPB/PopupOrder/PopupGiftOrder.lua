local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    Event.AddListener(EventName.Event_Gift_Show_Over,this.OnGiftFinish)
    --Event.Brocast(Notes.LOGIN_ENTER_CITY)
    ModelList.GiftPackModel:ResetPopUpGiftCount()
    if arg == 3 then
        ModelList.GiftPackModel.EnterMain()
    else
        ModelList.GiftPackModel.EnterCity()
    end
    SDK.event_enter_lobby()
end

function PopupOrder.OnGiftFinish()--彈出禮包完成
    Event.RemoveListener(EventName.Event_Gift_Show_Over,this.OnGiftFinish)
    ModelList.GiftPackModel:ResetPopUpGiftCount()
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder