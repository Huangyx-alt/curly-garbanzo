--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2021-03-25 14:59:30
]]
---ios 线性马达

TapTicManager = {}
TapTicManager._switch = true 
TapTicManager._is_support = false 

function TapTicManager.IsInit()
    if(not fun.is_null(TapticHelp))then 

        if(TapticHelp.IsSupport())then 
            TapTicManager._is_support = true 
        else
            TapTicManager._is_support = false 
        end 
    end

    local lastSwitchSetting = UserData.get("vibration",true)
    
    --local bool = AppConst.DevMode
    TapTicManager._switch = lastSwitchSetting 
  
    
    
    

end

function TapTicManager.Notification(index)
    log.r("TapTicManager.Selection()",TapTicManager._switch , TapTicManager._is_support)
    if(TapTicManager._switch and TapTicManager._is_support)then 
        TapticHelp.Notification(index)
    end
end

function TapTicManager.Impact(index)
    if(TapTicManager._switch and TapTicManager._is_support)then 
        TapticHelp.Impact(index)
    end
end

function TapTicManager.Selection()
    log.r("TapTicManager.Selection()",TapTicManager._switch , TapTicManager._is_support)
    if(TapTicManager._switch and TapTicManager._is_support)then 
        TapticHelp.Selection()
    end
end


--lxm 缓存震动属性
function TapTicManager.CacheSwitchState(state)
    TapTicManager._switch = state
    UserData.set("vibration",state)
end 