--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, ...)

    if Network.isConnect == false then 
        return 
    end 

    local view, args = HandleNotifyParams(...);
    local callback = args[1]
    -- local show = args[2]
    -- local enableParams = args[3]
    -- local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    local betRate = ModelList.CityModel:GetBetRate() or 1 -- 默认倍数1
    
    --动态出现 

    -- 判断倍数

    local data = ModelList.CityModel:GetPowerUpRange()
    local playid =  ModelList.CityModel.GetPlayIdByCity()
    local playType = ModelList.CityModel.GetCurPlayType()
    --local isNormalFlag = Csv.CheckisNormalOrAuto(playid)
    
    --当玩家开启ultra_bet活动后，全部bet下都开放小丑PU机台
    local isUltraBetOpen = ModelList.UltraBetModel:IsActivityValidForCurPlay()
    local isJokerOpen = ModelList.CityModel:CheckIsJokerOpen(playid)
    local checkForceUseMaster = isUltraBetOpen and isJokerOpen
    if checkForceUseMaster then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpViewMaster, function(go)
            if callback then
                callback(go)
            end
            Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.goback)
            SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
        end,nil,nil)
        return
    end
    
    --if isNormalFlag then 
        if data[playid][1].bet[1] <= betRate and betRate <= data[playid][1].bet[2] then 
            Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpView,function (go)
                if callback then
                    callback(go)
                end
                Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.goback)
                SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
            end,nil,nil)   
        elseif data[playid][2].bet[1] <= betRate and betRate <= data[playid][2].bet[2] then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpViewSilver,function (go)
                if callback then
                    callback(go)
                end
                Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.goback)
                SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
            end,nil,nil)  
        elseif data[playid][3].bet[1] <= betRate and betRate <= data[playid][3].bet[2] then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpViewGoldNova,function (go)
                if callback then
                    callback(go)
                end
                Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.goback)
                SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
            end,nil,nil)  
        elseif data[playid][4].bet[1] <= betRate and betRate <= data[playid][4].bet[2] then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpViewMaster,function (go)
                if callback then
                    callback(go)
                end
                Event.Brocast(EventName.Event_topbar_change,false,TopBarChange.goback)
                SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
            end,nil,nil)  
        end 
    -- else 
    --     Facade.SendNotification(NotifyName.ShowUI, ViewList.PowerUpView,function ()
    --         if callback then
    --             callback()
    --         end
    --         SDK.open_powerups_shop(ProcedureManager.GetCurrentSceneName())
    --     end,nil,nil)   
    -- end 
        
end
 
return Command;