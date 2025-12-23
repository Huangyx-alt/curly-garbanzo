local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder, "")
local this = PopupOrder

local isAllPopOrderFinish = false
local private = {}

function PopupOrder.Execute(occasion, args)
    this.args = args or {}

    if private.CheckCanOpen() then
        private.OpenView()
    else
        --已经领取
        this.Finish()
    end
end

function PopupOrder.IsPreOrderFinish()
    return isAllPopOrderFinish
end

function PopupOrder.Finish(self, flag)
    isAllPopOrderFinish = flag
    Event.RemoveListener(EventName.Event_popup_FullGameplay_finish, this.Finish)
    Event.Brocast(EventName.Event_popup_order_finish, true)
end

-------------------------私有方法----------------------------------

---粉丝页奖励是否已经领取
function private.CheckCanOpen()
    local remainTime, ret = ModelList.CityModel:GetFullGameplayRemainTime()
    if remainTime > 0 then
        local lastOpenTime = fun.read_int_by_userid("PopupFullGameplayOrder", 0)
        if lastOpenTime == 0 then
            --没打开过
            fun.save_int_by_userid("PopupFullGameplayOrder", os.time())
            ret = true
        else
            local nowDate, openDate = os.date("%Y_%m_%d"), os.date("%Y_%m_%d", lastOpenTime)
            if nowDate ~= openDate then
                --不是同一日
                fun.save_int_by_userid("PopupFullGameplayOrder", os.time())
                ret = true
            end
        end
    end
    return ret
end

function private.OpenView()
    Event.AddListener(EventName.Event_popup_FullGameplay_finish, this.Finish)
    Facade.SendNotification(NotifyName.ShowDialog, ViewList.FullGameplayPosterView)
end

return this