--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};


-- //
-- // 摘要:
-- //     Describes network reachability options.
-- public enum NetworkReachability
-- {
--     //
--     // 摘要:
--     //     Network is not reachable.
--     NotReachable = 0,
--     //
--     // 摘要:
--     //     Network is reachable via carrier data network.
--     ReachableViaCarrierDataNetwork = 1,
--     //
--     // 摘要:
--     //     Network is reachable via WiFi or cable.
--     ReachableViaLocalAreaNetwork = 2
-- }

function Command.Execute(notifyName, ...)
    local state = tostring(UnityEngine.Application.internetReachability)
    log.r("network reachability options",state)
 
    if(state == "NotReachable")then 
        Facade.SendNotification(NotifyName.Net.DisconnectNet) 
    else
        --用来检测是否网络可以用
        Http.report_event("checkNetState", {},function(code, msg, data)
            if(code==-1)then 
                Facade.SendNotification(NotifyName.Net.DisconnectNet) 
            end 
        end)
    end

end

return Command;