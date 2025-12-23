--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-08-17 21:33:51
]]

--机台下载
-- TODO by LwangZg 运行时热更部分
require "Logic.MachineDownloadManager"
local Command = {};

function Command.Execute(notifyName, machineid)

    if MachinePortalManager.has_data() and MachineDownloadManager.enable_update then
        Command.Download(machineid)
    else
        --一般是debug模式走这里
        MachinePortalManager.get_portal_list_data("general",function ()
            Command.Download(machineid)
        end)
    end


    
end


function Command.Download(machineid)
    MachineDownloadManager.check_machine_version(machineid, 
    function(status) 
       
        if status.has_new_version then  
            Facade.SendNotification(NotifyName.Event_machine_download_start, machineid)
            MachineDownloadManager.start_download_machine(machineid, true)
        else
            Facade.SendNotification(NotifyName.Event_machine_download_skip, machineid)
        end
    end)
end

return Command;