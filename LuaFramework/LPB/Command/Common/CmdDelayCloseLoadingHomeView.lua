--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, ...)
    ViewList.SceneLoadingHomeView:setProcess(1)
    -- ViewList.SceneLoadingHomeView.FadeOut()
    log.r("lxq CmdDelayCloseLoadingHomeView ")
    ViewList.EnterGameLoadingView.FadeOut()
    Invoke(function()
        Facade.SendNotification(NotifyName.CloseUI,ViewList.SceneLoadingHomeView)
    end,1)
    -- LuaTimer:SetDelayFunction(0.5,function()
    --     Facade.SendNotification(NotifyName.CloseUI,ViewList.SceneLoadingHomeView)
    -- end)
 
end

return Command;