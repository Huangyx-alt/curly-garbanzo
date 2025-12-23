local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    local platform = ModelList.loginModel:GetLoginPlatform()
    local playInfo = ModelList.PlayerInfoModel:GetUserInfo()
    --local firstLogin = ProcedureManager:IsFirstLoginEnter()
    if --[[firstLogin and--]] platform == PLATFORM.PLATFORM_GUEST and playInfo.level >= 10 then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.FBRecommendView)
        Event.AddListener(EventName.Event_previous_enter_homescene,this.Finish)
    else
        this.Finish(false)
    end
end

function PopupOrder.Finish(succeed)
    Event.RemoveListener(EventName.Event_previous_enter_homescene,this.Finish)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,succeed or true)
end

return PopupOrder