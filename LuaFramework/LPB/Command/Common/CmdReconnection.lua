--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, ...)
    local forceReconnect, args = HandleNotifyParams(...)
    --contentId, sureCallBack ,cancelCallBack,

    --静默重连
    if Network.CanBackgroundReconnect() then
        Network.BackgroundReconnect(forceReconnect)
    else
        local contentId = 0
        local sureCallBack =  nil
        local cancelCallBack =  nil
        if(Network.isConnect)then
            if Net.GetViewCountByType("CheckConnection")  >0 then
                return
            end
            sureCallBack = function ()
                Facade.SendNotification(NotifyName.Login.ConnectServer)
            end
            contentId = 8000
        else
            if Net.GetViewCountByType("ReloginTip")  >0 then
                return
            end
            contentId = 8005
            sureCallBack = function ()
                if fun.get_active_scene().name ~= "SceneLogin"then
                    UIUtil.LoadLogin()
                end
            end
        end
    end

end

return Command;