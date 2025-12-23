--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, ...)
    --[[
    --todo 先挂载在场景中，后面考虑移除，使用动态加载
    local view, args = HandleNotifyParams(...);
    local callback = args[1]
    local show = args[2]
    local occasion = args[3] or PopupOrderOccasion.none --是否是弹出窗口时机
    local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    local autoHallView =  fun.find_child(game_ui,"HallMainAutoView")
    ViewList.HallMainAutoView.occasion = occasion
    Facade.SendNotification(NotifyName.SkipLoadShowUI,ViewList.HallMainAutoView,autoHallView,nil,function()
        if callback then
            callback()
        end
    end,show)
    --]]
end

return Command;