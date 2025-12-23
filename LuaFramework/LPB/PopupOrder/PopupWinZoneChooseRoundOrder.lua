
local Const = require "View/WinZone/WinZoneConst"
local BaseOrder = require "PopupOrder/BaseOrder"
local PopupWinZoneChooseRoundOrder = Clazz(BaseOrder, "PopupWinZoneChooseRoundOrder")
local this = PopupWinZoneChooseRoundOrder

function PopupWinZoneChooseRoundOrder.Execute(occasion, config, extra)
    this.needBreakPopupOrder = false
    local isNeedPopup = this.IsNeedPopup(occasion, extra)
    --undo for test wait delete
    --isNeedPopup = true
    if isNeedPopup then
        Event.AddListener(NotifyName.WinZone.PopupChooseRoundFinish, this.Finish, this)
        Event.AddListener(NotifyName.WinZone.BreakPopupChooseRoundOrder, this.BreakPopupOrder, this)
        ModelList.BattleModel.RequireModuleLua("WinZone")
        if this.IsUnlockNewRoundType() then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneChooseRoundView)
        else
            ViewList.WinZoneRestartDialog:SetLastRoundType()
            local finalRank = ModelList.WinZoneModel:GetFinalRankRecord()
            if finalRank > 0 and finalRank <= 3 then
                ViewList.WinZoneRestartDialog:SetShowType(Const.ShowRestartDialogMode.win)
            else
                ViewList.WinZoneRestartDialog:SetShowType(Const.ShowRestartDialogMode.lose)
            end
            Facade.SendNotification(NotifyName.ShowUI, ViewList.WinZoneRestartDialog)
        end
    else
        this.Finish()
    end
end

function PopupWinZoneChooseRoundOrder.Finish()
    log.g("brocast EventName.Event_popup_order_finish PopupWinZoneChooseRoundOrder")
    Event.RemoveListener(NotifyName.WinZone.PopupChooseRoundFinish, this.Finish, this)
    Event.RemoveListener(NotifyName.WinZone.BreakPopupChooseRoundOrder, this.BreakPopupOrder, this)
    this.NotifyCurrentOrderFinish()
    --Event.Brocast(EventName.Event_popup_order_finish, true)
end

function PopupWinZoneChooseRoundOrder.BreakPopupOrder()
    this.needBreakPopupOrder = true
end

function PopupWinZoneChooseRoundOrder.IsPreOrderFinish()
    return this.needBreakPopupOrder
end

-- function PopupWinZoneChooseRoundOrder.IsNeedPopup(occasion, extra)
--     return occasion == PopupOrderOccasion.enterMainCity and extra and extra.lastPlayId == Const.PlayId
-- end

function PopupWinZoneChooseRoundOrder.IsNeedPopup(occasion, extra)
    if occasion ~= PopupOrderOccasion.enterMainCity then
        return false
    end

    if not extra then
        return false
    end

    if extra.lastPlayId ~= Const.PlayId then
        return false
    end

    if not ModelList.WinZoneModel:GetSelectRoundRecord() then
        return false
    end

    if ModelList.WinZoneModel:GetManualExitRecord() then
        return false
    end

    return true
end

function PopupWinZoneChooseRoundOrder.IsUnlockNewRoundType()
    local data = ModelList.WinZoneModel:GetActivityInfo()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local unlockRecord = fun.read_value(Const.ROUND_UNLOCK_RECORD .. playerInfo.uid, {})
    if data and data.rounds then
        for i, v in ipairs(data.rounds) do
            if unlockRecord[i] == false and v.isUnlock then
                return true
            end
        end
    end

    return false
end

return this