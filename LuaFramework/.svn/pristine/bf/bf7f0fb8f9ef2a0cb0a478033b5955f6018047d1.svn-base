--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};
local lastConnectTime = 0
function Command.Execute(notifyName, ...)
    local loginModel =  ModelList.loginModel
    log.r("----------TrySendConnect ")
    if not Network.isConnect and loginModel.connector and loginModel.connector.host and loginModel.connector.port and fun.is_not_null(CS.NetworkManager) then
        if os.time() - lastConnectTime> 0.5 then
            lastConnectTime = os.time()
            log.r("----------SendConnect "..tostring(loginModel.connector.host))
            Network.SendConnectState = 1
            -- by LwangZg 这里真正开始登录
            -- log.l("这里真正开始登录 地址: %s 端口: %s ",loginModel.connector.host,loginModel.connector.port)
            CS.NetworkManager:SendConnect(loginModel.connector.host, loginModel.connector.port);
        end
    end
end

return Command;