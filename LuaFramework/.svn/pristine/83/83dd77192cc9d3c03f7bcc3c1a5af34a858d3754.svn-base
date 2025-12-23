--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-20 20:00:01
]]
local Command = {};

function Command.Execute(notifyName,machineid)
    --先设置citymodel
    ModelList.CityModel.SetDownloadList(machineid,true)
    local tmpmodData = Csv.GetData("modular",machineid)
    if tmpmodData then
        --TODO by LwangZg 运行时热更部分
        if resMgr then
            resMgr:RefreshModuleInfo(tmpmodData.modular_name)
        end
    end
    Facade.SendNotification(NotifyName.Event_machine_download_success_view, machineid)
end

return Command;