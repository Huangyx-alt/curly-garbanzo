
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    AddLockCountOneStep(true)
    if ModelList.HallofFameModel:IsGetReward() then
        Event.AddListener(EventName.Event_popup_halloffame_reward,PopupOrder.Finish)
        Cache.Load_Atlas(AssetList["TournamentAtlas"],"TournamentAtlas",function()
            if ModelList.HallofFameModel:CheckIsTrueGoldUser() then
                Facade.SendNotification(NotifyName.ShowUI,ViewList.HallofFameGoldSettleView)
            else
                Facade.SendNotification(NotifyName.ShowUI,ViewList.HallofFameSettleView)
            end
        end)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    AddLockCountOneStep(false)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_halloffame_reward,PopupOrder.Finish)
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder