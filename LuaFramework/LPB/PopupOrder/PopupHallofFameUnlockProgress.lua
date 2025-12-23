local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder, "")
local this = PopupOrder

function PopupOrder.Execute(arg)
    local isActivityAvailable = ModelList.HallofFameModel:IsActivityAvailable()
    if not isActivityAvailable then
        PopupOrder.Finish()
        return
    end

    if this.CheckFinish() and ModelList.HallofFameModel:CheckIsTrueGoldUser() then
        Event.AddListener(EventName.Event_show_halloffame_unlock_progress_view, PopupOrder.Finish)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldUnlockProgressView)
    else
        PopupOrder.Finish()
    end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_show_halloffame_unlock_progress_view, PopupOrder.Finish)
    Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupOrder.CheckFinish()
    local unlockLv = ModelList.HallofFameModel:GetUnlockLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    if myLevel >= unlockLv then
        return false
    else
        return true
    end
end

return PopupOrder