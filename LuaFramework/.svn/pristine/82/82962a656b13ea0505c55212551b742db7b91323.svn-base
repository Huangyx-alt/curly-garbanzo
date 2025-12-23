local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

local isAllPopOrderFinish = false

-- local openTournamentGuideTimeStamp = "openTournamentGuideTimeStamp"
-- local openTournamentGuideTimeString = "openTournamentGuideTimeString"


function PopupOrder.Execute(occasion,orderData)
    Event.AddListener(EventName.Event_show_first_tournament_guide_view,PopupOrder.Finish)

    if not ModelList.TournamentModel:IsActivityAvailable() then
        this.Finish()
        return
    end
    
    local flushUnixTime = ModelList.TournamentModel:GetflushUnixTime()
    if not this.IsAllowPop("openTournamentGuideTimeStamp"..flushUnixTime,orderData) then
        this.Finish()
        return
    end
    
    local isTrueGoldUser = ModelList.PlayerInfoModel:GetIsTrueGoldUser()
    --是否打开过更新宣传界面
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    local key = string.format("%s-%s", "HaveShowUpdatePosterView", userID)
    local ret = fun.get_int(key, 0)
    local checkHaveOpenUpdateView = ret == 1
    
    if this.CheckLvOpen() then
        if not checkHaveOpenUpdateView then
            if isTrueGoldUser then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldUpdatedPosterView)
            else
                Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameUpdatedPosterView)
            end
            fun.save_int(key, 1)
        else
            --大于活动等级 并且是首次弹出
            if ModelList.TournamentModel:CheckIsBlackGoldUser() then
                Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentBlackGoldGuideView,nil,false,true)
            else
                Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentGuideView,nil,false,true)
            end
        end
        local flushUnixTime = ModelList.TournamentModel:GetflushUnixTime()
        this.RefreshPopTime("openTournamentGuideTimeStamp"..flushUnixTime,orderData,2)
    else
        this.Finish()
    end
end

function PopupOrder.Finish()
    Event.RemoveListener(EventName.Event_show_first_tournament_guide_view,PopupOrder.Finish)
    log.g("brocast  EventName.Event_popup_order_finish ")
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

function PopupOrder.CheckLvOpen()
    local openLevel = ModelList.TournamentModel:GetUnlockTournamentLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    
    return myLevel >= openLevel
end

function PopupOrder.IsOrderFinish()
    if not ModelList.TournamentModel:IsActivityAvailable() then
        return false
    end
    
    local flushUnixTime = ModelList.TournamentModel:GetflushUnixTime()
    local nextCanShowTaskUnix = fun.read_value("openTournamentGuideTimeStamp"..flushUnixTime,0);
    local selftime = os.time()
    if this.CheckLvOpen()  and selftime > nextCanShowTaskUnix  then
        isAllPopOrderFinish = true
    else
        isAllPopOrderFinish = false
    end
    return false
end

function PopupOrder.IsPreOrderFinish()
    return isAllPopOrderFinish
end


-- function PopupOrder.CheckDayFirstOpen() 
--     --这里的原来写法只是跨天，凌晨的那种 现在改为隔24小时

--     local timeStamp =  ModelList.PlayerInfoModel.get_cur_client_time()
--     local timeString =  fun.date()

--     local lastOpenTimeStamp = UserData.get(openTournamentGuideTimeStamp,-1)
--     local lastOpenTimeString = UserData.get(openTournamentGuideTimeString, "-1")
--     if lastOpenTimeStamp < timeStamp and  lastOpenTimeString ~= timeString then
--         return true
--     end
--     return false
-- end

-- function PopupOrder.SaveOpenTime()
--     local openTimeStamp =  ModelList.PlayerInfoModel.get_cur_client_time()
--     local openTimeString =  fun.date()
--     UserData.set(openTournamentGuideTimeStamp ,openTimeStamp)
--     UserData.set(openTournamentGuideTimeString , openTimeString)
-- end



return PopupOrder