
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute()
    if ModelList.FixedActivityModel:HaveSevenDayReward() then
        Event.AddListener(EventName.Event_popup_seven_day_login_finish,PopupOrder.Finish,this)
        Cache.Load_Atlas(AssetList["SevenDayLoginAtlas2"], "SevenDayLoginAtlas2", function()
            --- 修复一个7日登录白图的问题
            local delayTime  = 1
            if fun.is_ios_platform() then
                delayTime = 3
            end
            LuaTimer:SetDelayFunction(delayTime,function()
                Facade.SendNotification(NotifyName.ShowUI,ViewList.SevenDayLoginView)
            end)
        end)

        --PopupOrder.Finish()
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_popup_seven_day_login_finish,PopupOrder.Finish)
    log.g("brocast  EventName.Event_popup_order_finish Event_popup_seven_day_login_finish")
    this.NotifyCurrentOrderFinish()
end

return PopupOrder
