local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

local isFinish = false
local private = {}
local OneDayTime = 24 * 60 * 60

function PopupOrder.Execute(occasion, args)
    this.Finish()
    --this.args = args or {}
    --
    ----如果关闭游戏没领取奖励，下次登录领取
    --if ModelList.FBFansModel:CheckFollowReward() then
    --    private.OpenView()
    --else
    --    if not ModelList.FBFansModel:CheckFansPageUnlock() then
    --        --未解锁
    --        this.Finish()
    --    else
    --        if private.CheckAvailable() then
    --            private.OpenView()
    --        else
    --            --已经领取
    --            this.Finish()
    --        end
    --    end
    --end
end

function PopupOrder.Finish()
    isFinish = true
    Event.RemoveListener(EventName.Event_popup_fans_page_finish, this.Finish)

    if not this.args or not this.args.isQuiet then
        this.NotifyCurrentOrderFinish()
    end
end

-------------------------私有方法----------------------------------

---粉丝页奖励是否已经领取
function private.CheckAvailable()
    local ret = ModelList.FBFansModel:IsClaimedFbFollowReward()
    if ret then
        --已经领取了奖励
        return false
    end

    return this.IsAllowPop("last_open_fans_page_time", this.args)
    ------限制每隔一段时间就弹出一次
    --local lastOpenTime = ModelList.FBFansModel:GetFromPrefs("last_open_fans_page_time", 0)
    --if lastOpenTime == 0 then
    --    return true
    --else
    --    local cfg = Csv.GetData("control", 150, "content")
    --    local openInterval = (cfg and cfg [1]) and cfg[1][2] or OneDayTime
    --    local now = os.time()
    --    return now - lastOpenTime >= openInterval
    --end
end

function private.OpenView()
    Event.AddListener(EventName.Event_popup_fans_page_finish, this.Finish)
    this.RefreshPopTime("last_open_fans_page_time", this.args)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.FansPageView)
end

return this