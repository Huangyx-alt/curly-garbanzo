local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute()
    if CityHomeScene:IsLobby() then
        local gameMode = ModelList.CityModel:GetEnterGameMode()
        if  gameMode == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
            Event.AddListener(EventName.Event_jackpoview_hide,PopupOrder.Finish,this)
            if ModelList.VolcanoMissionModel:IsStartActivity() then
                --火山优先级最高
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.VolcanoMissionJackpotEnableView)
            elseif ModelList.CarQuestModel:IsActivityAvailable() then
                --然后是赛车
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewQuest)
            elseif (ModelList.CompetitionModel:IsActivityAvailable()) then
                --最后是饼干
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewCookie)
            else
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableView)
            end
        else 
            PopupOrder.Finish()
        end
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_jackpoview_hide,PopupOrder.Finish,this)
    Event.Brocast(EventName.Event_popup_order_finish,true)

    log.g("brocast  EventName.Event_popup_order_finish  RegisterReward")
end

function PopupOrder.IsOrderFinish()
    return true
end

return PopupOrder