--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName, tipName)
    local tip_open_state = ModelList.PlayerInfoModel:GetTipState()
    if tip_open_state then
        Facade.SendNotification(NotifyName.System.CommonTipView.ShowTip, tipName)
    else
        Facade.SendNotification(NotifyName.ShowUI, ViewList.CommonTipView, function()
            Facade.SendNotification(NotifyName.System.CommonTipView.ShowTip, tipName)
        end)
    end
end

return Command;