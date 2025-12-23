
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupWinZonePosterOrder = Clazz(BaseOrder, "PopupWinZonePosterOrder")
local this = PopupWinZonePosterOrder
local DATE_FORMAT_STR = "%Y%m%d"
local useTodayCd = false

function PopupWinZonePosterOrder.Execute(args)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup()
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        Event.AddListener(NotifyName.WinZone.PopupActivityPosterFinish, this.Finish, this)
        Event.AddListener(NotifyName.WinZone.BreakPopupOrder, this.BreakPopupOrder, this)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZonePosterView)
        local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
        if useTodayCd then
            fun.save_value(Const.TODAY_TIMESTAMP .. playerInfo.uid, os.date(DATE_FORMAT_STR))
        else
            fun.save_value(Const.TODAY_TIMESTAMP .. playerInfo.uid, os.time())
        end
        Facade.SendNotification(NotifyName.WinZone.StartDownloadMachine)
    else
        this.Finish()
    end
end



function PopupWinZonePosterOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupWinZonePosterOrder")
    Event.RemoveListener(NotifyName.WinZone.PopupActivityPosterFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.WinZone.BreakPopupOrder, this.BreakPopupOrder, this)

    
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupWinZonePosterOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupWinZonePosterOrder.IsPreOrderFinish()
    if ModelList.GuideModel:IsGuiding() then
        return true
    end

    return this.needBreakPopupOrder
end

function PopupWinZonePosterOrder.IsNeedPopup()
    local isValid = ModelList.WinZoneModel:IsActivityValid()
    if not isValid then
        log.log("PopupWinZonePosterOrder.IsNeedPopup f1")
        return false
    end

    if useTodayCd then
        return this.IsCooldown2()
    else
        return this.IsCooldown1()
    end
end

function PopupWinZonePosterOrder.IsCooldown1()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value(Const.TODAY_NO_LONGER_POPUP .. playerInfo.uid, Const.PosterToggleDefault)

    if value == 0 then  --value = 1 --每日一次, 0 --每日不限次数
        return true
    end

    local dateStr = os.time()
    local recordDateStr = fun.read_value(Const.TODAY_TIMESTAMP .. playerInfo.uid, 0)
    recordDateStr = tonumber(recordDateStr) or 0
    local cfg = Csv.GetControlByName("winzone_pop_cd")
    local popupCd = cfg and cfg[1] and cfg[1][1] or 86400
    if dateStr < recordDateStr + popupCd then
        log.log("PopupWinZonePosterOrder.IsNeedPopup f2")
        return false
    end

    return true
end

function PopupWinZonePosterOrder.IsCooldown2()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value(Const.TODAY_NO_LONGER_POPUP .. playerInfo.uid, 1)
   
    if value == 0 then  --value = 1 --每日一次, 0 --每日不限次数
        return true
    end

    local dateStr = os.time()
    local dataFormatStr = os.date(DATE_FORMAT_STR, dateStr)
    local recordDateStr = fun.read_value(Const.TODAY_TIMESTAMP .. playerInfo.uid, 0)
    if dataFormatStr == recordDateStr then
        log.log("PopupWinZonePosterOrder.IsNeedPopup f3")
        return false
    end

    return true
end

return this