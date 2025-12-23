--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
--  战斗内重连
local Command = {};

--超过5个叫号的时间，弹出提示面板

local callNuberCount = 1

function Command.Execute(notifyName, ...)
    --local lastMissTime = Network.GetLastMissConnectTime()
    --if lastMissTime > 0 then
    --    local currTime = ModelList.PlayerInfoModel.get_cur_client_time()
    --    local interval = ModelList.BattleModel:GetCurrModel():GetCallNumberInterval()
    --    if currTime - lastMissTime >  callNuberCount * interval then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.BattleReconnectView,nil)
        --end
    --end
end

return Command;