---@名人堂宣传弹窗

local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder, "")
local this = PopupOrder

function PopupOrder.Execute(occasion, orderData)
    this:RegisterEvent()
    
    local isActivityAvailable = ModelList.HallofFameModel:IsActivityAvailable()
    if not isActivityAvailable then
        this.Finish()
        return
    end
    
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    
    --检查开启间隔
    --使用活动开启时间做key,新一轮活动时刷新弹窗次数
    local openTime = ModelList.HallofFameModel.openTime or 1
    local popKey = "PopupHallofFameOpenOrder" .. openTime .. userID
    if not this.IsAllowPop(popKey, orderData) then
        this.Finish()
        return
    end

    local isTrueGoldUser = ModelList.HallofFameModel:CheckIsTrueGoldUser()
    local checkOpenLv = ModelList.HallofFameModel:CheckLvOpen()
    --是否打开过更新宣传界面
    local key = string.format("%s-%s", "HaveShowUpdatePosterView", userID)
    local ret = fun.get_int(key, 0)
    local checkHaveOpenUpdateView = ret == 1
    
    if checkOpenLv then
        if not checkHaveOpenUpdateView then
            if isTrueGoldUser then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldUpdatedPosterView)
            else
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameUpdatedPosterView)
            end
            fun.save_int(key, 1)
        else
            if isTrueGoldUser then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldPosterView)
            else
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFamePosterView)
            end
        end
        this.RefreshPopTime(popKey, orderData, 1)
    else
        this.Finish()
    end
end

function PopupOrder.RegisterEvent()
    Event.AddListener(EventName.Event_HallofFame_PopEnd, this.OnPopupEnd, this)
end

function PopupOrder:OnPopupEnd(code, data)
    this.Finish()
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_HallofFame_PopEnd, this.OnPopupEnd, this)
    Event.Brocast(EventName.Event_popup_order_finish, true)
end

return PopupOrder