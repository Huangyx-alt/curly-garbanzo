
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

local minOffsetLevel = 3 -- 相差等级小于等于3 显示一个进度条 大于3显示另外一个

function PopupOrder.Execute(arg)
    if not ModelList.TournamentModel:IsActivityAvailable() then
        PopupOrder.Finish()
        return
    end
    
    if this.CheckFinishTournament() and ModelList.TournamentModel:CheckIsBlackGoldUser() then
        Event.AddListener(EventName.Event_show_unlock_tournament_unlock_progress_view,PopupOrder.Finish)
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentBlackGoldUnlockProgressView)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    log.g("brocast  EventName.Event_show_unlock_avatar_or_frame_view ")
    Event.RemoveListener(EventName.Event_show_unlock_tournament_unlock_progress_view,PopupOrder.Finish)
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

function PopupOrder.CheckFinishTournament()
    local unlockLv =  ModelList.TournamentModel:GetUnlockTournamentLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    if myLevel >= unlockLv then
        return false
    else
        return true
    end
end

return PopupOrder