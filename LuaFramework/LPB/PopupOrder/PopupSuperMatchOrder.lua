local BaseOrder = require "PopupOrder/BaseOrder"
local PopupSuperMatchOrder = Clazz(BaseOrder, "PopupSuperMatchOrder")
local this = PopupSuperMatchOrder
local DATE_FORMAT_STR = "%Y%m%d"

function PopupSuperMatchOrder.Execute(args, orderData)
    local isNeedPopup = this.IsNeedPopup(orderData)
    if isNeedPopup then
        Event.AddListener(NotifyName.SuperMatch.PopupActivityPosterFinish, this.Finish, this)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SuperMatchPosterView)
    else
        this.Finish()
    end
end

function PopupSuperMatchOrder:Finish(isDelay,isDelay2)
    --print(" isdelay "..tostring(isDelay))
    --print(" isdelay2 "..tostring(isDelay2))
    if isDelay then
        LuaTimer:SetDelayFunction(1, function ()
            ModelList.ActivityModel:CutdownFirstPopup(9, ModelList.ActivityModel:GetActivityCreatTime(9))
            log.g("brocast  EventName.Event_popup_order_finish  PopupSuperMatchOrder")
            Event.RemoveListener(NotifyName.SuperMatch.PopupActivityPosterFinish, this.Finish, this)
            this.NotifyCurrentOrderFinish()
            ModelList.GuideModel:BreakGuideStep()
        end)
    else
        ModelList.ActivityModel:CutdownFirstPopup(9, ModelList.ActivityModel:GetActivityCreatTime(9))
        log.g("brocast  EventName.Event_popup_order_finish  PopupSuperMatchOrder")
        Event.RemoveListener(NotifyName.SuperMatch.PopupActivityPosterFinish, this.Finish, this)
        this.NotifyCurrentOrderFinish()
    end
end

function PopupSuperMatchOrder.IsNeedPopup(orderData)
    local expireTime = ModelList.ActivityModel:GetActivityExpireTime(9)
    if ModelList.ActivityModel:IsActivityExpire(expireTime) then
        log.log("PopupSuperMatchOrder.IsNeedPopup f2")
        return false
    end

    -- local isFirstOpen = ModelList.ActivityModel:IsFirstOpen(orderData.id)
    -- if not isFirstOpen then
    --     log.log("PopupSuperMatchOrder.IsNeedPopup f1")
    --     return false
    -- end

    if ModelList.GuideModel:IsGuideComplete(76) then
        return false
    end

    --if not ModelList.ActivityModel:IsActivityFirstOpen(9) then
    --    return false
    --end

    -- local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    -- local seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    -- if not this.IsAllowPop(ModelList.SeasonCardModel.Consts.TODAY_NO_LONGER_POPUP..seasonId .. playerInfo.uid,orderData) then
    --     return false
    -- end
    return true
end

return this
