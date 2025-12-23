
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute(arg)
    AddLockCountOneStep(true)
    if ModelList.TournamentModel:IsTournamentGetReward() then
        Event.AddListener(EventName.Event_popup_tournament_reward,PopupOrder.Finish)
        Cache.Load_Atlas(AssetList["TournamentAtlas"],"TournamentAtlas",function()
            if ModelList.TournamentModel:CheckIsBlackGoldUser() then
                Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentBlackGoldSettleTopPlayerView)
            else
                Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentSettleTopPlayerView)
            end
        end)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    AddLockCountOneStep(false)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.RemoveListener(EventName.Event_popup_tournament_reward,PopupOrder.Finish)
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

return PopupOrder