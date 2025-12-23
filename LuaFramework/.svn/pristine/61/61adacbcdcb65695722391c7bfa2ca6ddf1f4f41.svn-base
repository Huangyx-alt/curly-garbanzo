local BaseOrder = require "PopupOrder/BaseOrder"
local PopupSmallGameDescripe = Clazz(BaseOrder, "PopupSmallGameDescripe")
local this = PopupSmallGameDescripe

function PopupSmallGameDescripe.Execute(occasion, config, extra)
    local isNeedPopup = this.IsNeedPopup(config, occasion, extra)
    if isNeedPopup then
        local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
        local currSmallGameId = ModelList.SmallGameModel.GetCurrentGameId()
        fun.save_value("PopupSmallGameDescripe" .. playerInfo.uid .. currSmallGameId,1)
        Event.AddListener(EventName.Event_Popup_SmallGame_Finish, this.Finish, this)

        this.RefreshPopTime("PopupSmallGameDescripe" .. playerInfo.uid , config)

        local viewName = ModelList.SmallGameModel.GetCurrentGameHelperInfo()
        ViewList[viewName] = require("View.HallCity.SmallGame."..viewName)
        Facade.SendNotification(NotifyName.ShowUI, ViewList[viewName])


    else
        this.Finish()
    end
end

function PopupSmallGameDescripe.Finish()
    log.g("brocast EventName.Event_Popup_SmallGame_Finish")
    Event.RemoveListener(EventName.Event_Popup_SmallGame_Finish, this.Finish, this)
    Event.Brocast(EventName.Event_popup_order_finish, true)
end


function PopupSmallGameDescripe.IsNeedPopup(config, occasion, extra)
    if not ModelList.SmallGameModel:IsLevelEnough() then
        log.log("PopupSmallGameDescripe.IsNeedPopup 玩家等级不够")
        return false
    end
    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local currSmallGameId = ModelList.SmallGameModel.GetCurrentGameId()

    local playId = ModelList.CityModel.GetPlayIdByCity()
    
    if not ModelList.SmallGameModel:IsOpenTime() then
        log.log("PopupSmallGameDescripe.IsNeedPopup 不在开放时间 ", playId)
        return false
    end

    if not ModelList.SmallGameModel:IsPlayIdInAllowList() then
        log.log("PopupSmallGameDescripe.IsNeedPopup 不技持的玩法 ", playId)
        return false
    end

    if fun.read_value("PopupSmallGameDescripe" .. playerInfo.uid .. currSmallGameId,"") ~= "" then
        return false
    end

    if not extra then
        return false
    end
    --if occasion ~= PopupOrderOccasion.enterHallFromBattle then
    --    return false
    --end

    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if not playerInfo or not extra  then
        return false
    end
    --if not this.IsAllowPop("PopupSmallGameDescripe" .. playerInfo.uid, config) then
    --    return false
    --end
    return true
end

return this
