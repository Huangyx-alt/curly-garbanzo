require "Utils.MachineUtil"

MachineDownloadManager = {}
MachineDownloadManager.enable_update = true
MachineDownloadManager.DOWNLOAD_STATE = 
{
    IDLE = 1,
    NEW_VERSION = 2,
    WAITING = 3,
    DOWNLOADING = 4,
    PAUSING = 5,
    DOWNLOAD_SUCCESS = 6,
    DOWNLOAD_FAILED = 7,
}

local assets_status = {}
local machine_loaders = {}
local machine_versions = {}
local downloading_machine = nil
local waiting_download_machines = {}
local paused_download_machines = {}
local resuming_download_machine = {}
local machine_download_anim_percents = {}
local downloadurl_status = {}       --key zipDownloadUrl   value MachineDownloadManager.DOWNLOAD_STATE    DOWNLOAD_SUCCESS DOWNLOAD_FAILED DOWNLOADING IDLE
local machine_download_sizes = {}  --key zipurl  value zipsize


MachineDownloadManager.machine_download_priority = 1

-- 开始下载指定机台
function MachineDownloadManager.start_download_machine(machine_id, is_highest_priority)


    local will_download_now = false
    if MachineDownloadManager.has_any_machine_downloading() then
        --若当前有其他机台在下载，先加入等待队列
        if downloading_machine ~= machine_id then
            if not  is_highest_priority then
                MachineDownloadManager.add_machine_to_waiting_queue(machine_id)
            else
                will_download_now = true
            end
        end
    else
        will_download_now = true
    end
    if will_download_now then
        log.i("start download machine "..machine_id)
        MachineDownloadManager.download_machine_directly(machine_id, is_highest_priority, true)
    end
 end


--[[
    @desc: 检测机台是否完成 ,这里需要递归调用下载机台版本,原来下载一个zip,现在更新逻辑修改成0-1,1-2,2-3小版本更新.
    author:{author}
    time:2020-12-01 15:35:47
     --@machine_id: 
    @return:
]]
function MachineDownloadManager.CheckMachineIsDownloadOver(machine_id)

end


function MachineDownloadManager._unzip_success_callback(machine_id,in_queue)
 
    Facade.SendNotification(NotifyName.Event_machine_download_success, machine_id)
    if machine_id ~= 10000 and machine_id ~= 10999 then
        SDK.event_download_end()
    end

    if in_queue then
        downloading_machine = nil
        MachineDownloadManager.remove_machine_from_all_queue(machine_id)
        if fun.is_net_reachable() then
            MachineDownloadManager.start_new_download_in_waiting_or_resume()
        end
    end
end

function MachineDownloadManager._unzip_failed_callback(machine_id,error,in_queue)
    downloading_machine = nil
    Util.DeleteFile(error.LocalPath or error);
    Facade.SendNotification(NotifyName.Event_machine_download_error, machine_id) 
    if in_queue then
        MachineDownloadManager.remove_machine_from_all_queue(machine_id)
        if fun.is_net_reachable() then
            MachineDownloadManager.start_new_download_in_waiting_or_resume()
        end
    end
    SDK.machine_download_failed(machine_id)
end

function MachineDownloadManager.get_machine_downloadurl(machine_id)
    -- downloadurl_status[downloadUrl]
    local status = assets_status[machine_id]
    if(status)then 
        --for k,v in pairs(status.packages) do
        --    log.r("get_machine_downloadurl",v.url,downloadurl_status[v.url])
        --    if(downloadurl_status[v.url]~=MachineDownloadManager.DOWNLOAD_STATE.DOWNLOAD_SUCCESS)then
        --        return v.url,v.md5
        --    end
        --end
        log.r("get_machine_downloadurl",status.packages.url,downloadurl_status[status.packages.url])
        if(downloadurl_status[status.packages.url]~=MachineDownloadManager.DOWNLOAD_STATE.DOWNLOAD_SUCCESS)then
            return status.packages.url,status.packages.latestMd5
        end
    end
    return nil 



end

function MachineDownloadManager.replace_machine_versionfile(machine_id,path,in_queue,is_highest_priority)
    --local data = MachinePortalManager.get_portal_data_by_machine_id(machine_id)
    --local moduleName =  string.lower(data.name):gsub("^%l", string.upper)
        local src_version_file = path.."m"..machine_id.."_version_temp.txt"
    local dst_version_file = path.."m"..machine_id.."_version.txt"
    Util.ReplaceFile(src_version_file, dst_version_file)
    
    local download_version = MachineDownloadManager.read_machine_local_version(machine_id)
    MachineDownloadManager.update_machine_local_version(machine_id,download_version) 
    MachineDownloadManager.download_machine_directly(machine_id, is_highest_priority, in_queue)
end

function MachineDownloadManager.init_machine_zip_size(machine_id)
    local status = assets_status[machine_id]
    if(status.download_size==nil)then  
        local size = 0 ;
        machine_download_sizes[status.packages.url] = status.packages.size
        size = status.packages.size+size
        --for k,v in pairs(status.packages) do
        --
        --    size = v.size+size
        --end
        status.download_size = size
    end
end




function MachineDownloadManager.download_machine_directly(machine_id, is_highest_priority, in_queue)

    --事件打点_游戏行为_开始下载机台
    SDK.event_download_begin(machine_id)

    local status = assets_status[machine_id]
    MachineDownloadManager.init_machine_zip_size(machine_id)
    if status and status.has_new_version and status.packages then

        local downloadUrl,urlMd5 = MachineDownloadManager.get_machine_downloadurl(machine_id);

        if(downloadUrl==nil)then 
            --下载成功，发通知
            MachineDownloadManager._unzip_success_callback(machine_id,in_queue)
            return 
        end
        
        if in_queue then
            downloading_machine = machine_id
        end 
        local unzipDir = Util.DataPath 
        if machine_id ~= 10000 and machine_id ~= 10999 then
            --SDK.event_download_begin(machine_id)
        end
        downloadurl_status[downloadUrl] = MachineDownloadManager.DOWNLOAD_STATE.DOWNLOADING
        local priority = MachinePortalManager.get_priority(machine_id, MachineDownloadManager.machine_download_priority)
        local loader = SuperUnzipDownloader.create(downloadUrl, unzipDir, priority)
        MD5Checker.add_md5_data(downloadUrl, urlMd5)
        loader:add_event_listener(SuperDownloader.DownloadSuccess, function (owener,path)

            --事件打点_游戏行为_机台下载成功
            SDK.machine_download_success(machine_id)

            -- 机台下载成功后，通过重命名version文件方法保证解压成功
            log.r("download_machine_directly 机台下载成功后，通过重命名version文件方法保证解压成功")
            downloadurl_status[downloadUrl] = MachineDownloadManager.DOWNLOAD_STATE.DOWNLOAD_SUCCESS
            log.r(machine_id,path,in_queue,is_highest_priority)
            MachineDownloadManager.replace_machine_versionfile(machine_id,path,in_queue,is_highest_priority)
        end)
        loader:add_event_listener(SuperDownloader.DownloadFail, function (owener,error)

            --事件打点_游戏行为_机台下载失败
            SDK.machine_download_failed(machine_id)

            downloadurl_status[downloadUrl] = MachineDownloadManager.DOWNLOAD_STATE.DOWNLOAD_FAILED
            MachineDownloadManager._unzip_failed_callback(machine_id,error,in_queue) 
        end)
        loader:add_event_listener(SuperDownloader.DownloadUpdate, function (owener, progress)
            local downloadSize = progress/100*machine_download_sizes[downloadUrl]
            status.progress = downloadSize / status.download_size
            log.r(machine_id,status.progress,"Event_machine_download_update")
            Facade.SendNotification(NotifyName.Event_machine_download_update, machine_id, status.progress,status.download_size)
        end)
        loader:run(is_highest_priority)
        MachineDownloadManager.machine_download_priority = MachineDownloadManager.machine_download_priority + 1
        machine_loaders[machine_id] = loader
    else
        

    end
end
 
function MachineDownloadManager.remove_machine_from_all_queue(machine_id)
    waiting_download_machines = MachineDownloadManager.remove_machine_from_queue(machine_id, waiting_download_machines)
    paused_download_machines = MachineDownloadManager.remove_machine_from_queue(machine_id, paused_download_machines)
    resuming_download_machine = MachineDownloadManager.remove_machine_from_queue(machine_id, resuming_download_machine)
end

 -- 暂停下载指定机台
function MachineDownloadManager.pause_machine_download(machine_id)
    if MachineDownloadManager.is_machine_waiting(machine_id) then
        waiting_download_machines = MachineDownloadManager.remove_machine_from_queue(machine_id, waiting_download_machines)
    else
        if not MachineDownloadManager.is_machine_pausing(machine_id) then
            local loader = machine_loaders[machine_id]
            if loader then
                loader:pause()
                MachineDownloadManager.add_machine_to_paused_queue(machine_id)
                --TODO 尝试新的下载
                downloading_machine = nil
                MachineDownloadManager.start_new_download_in_waiting_or_resume(machine_id, machine_id)
            end
        end
    end
end
 

 -- 继续下载指定机台
 function MachineDownloadManager.resume_machine_download(machine_id)
     if MachineDownloadManager.is_machine_pausing(machine_id) then
        -- 如果当前没有机台正在下载，则立即开始继续下载
        if not MachineDownloadManager.has_any_machine_downloading() then
            local loader = machine_loaders[machine_id]
            if loader then
                loader:resume()
                paused_download_machines = MachineDownloadManager.remove_machine_from_queue(machine_id, paused_download_machines)
                downloading_machine = machine_id
            end
        else
            -- 若当前有其他机台在下载，加入等待队列
            MachineDownloadManager.add_machine_to_resume_queue(machine_id)
        end
    else
        MachineDownloadManager.start_download_machine(machine_id, false) 
    end
 end

 function MachineDownloadManager.add_machine_to_resume_queue(machine_id)
    MachineDownloadManager.add_machine_to_queue(machine_id, resuming_download_machine)
 end
 
 function MachineDownloadManager.add_machine_to_paused_queue(machine_id)
    MachineDownloadManager.add_machine_to_queue(machine_id, paused_download_machines)
end

function  MachineDownloadManager.add_machine_to_waiting_queue(machine_id)
    MachineDownloadManager.add_machine_to_queue(machine_id, waiting_download_machines)
end

function MachineDownloadManager.add_machine_to_queue(machine_id, queue)
    for i, v in ipairs(queue) do
        if v == machine_id then
           return
        end
    end
    queue[#queue + 1] = machine_id
end

function MachineDownloadManager.remove_machine_from_queue(machine_id, queue)
    local new_queue = {}

    for i = 1, #queue do
        local val = queue[i]
        if val ~= machine_id then
          new_queue[#new_queue + 1] = val
        end
    end

    return new_queue
end

 -- 停止下载指定机台
function MachineDownloadManager.stop_machine_download(machine_id)
    local loader = machine_loaders[machine_id]
   
    if loader then
        loader:dispose()
        downloading_machine = nil
        MachineDownloadManager.start_new_download_in_waiting_or_resume(machine_id)
    end


    local status = assets_status[machine_id]
    if(status and status.packages)then 
        for k,v in pairs(status.packages) do
            downloadurl_status[v.url] = nil 
        end
    end
    machine_loaders[machine_id] = nil 
    assets_status[machine_id] = nil
    --事件打点_游戏行为_机台下载取消
    SDK.machine_download_cancel(machine_id)
 end

 function MachineDownloadManager.start_new_download_in_waiting_or_resume(except_machine)
    if not  MachineDownloadManager.has_any_machine_downloading() then
        local new_download_started = false
        if #waiting_download_machines > 0 then
            local waiting_machine = fun.table_pop_first(waiting_download_machines)
            if waiting_machine ~= nil then
                MachineDownloadManager.start_download_machine(waiting_machine,false)
                new_download_started = true
            end
        end

        if (not new_download_started) and (#resuming_download_machine > 0) then
            local resuming_machine = fun.table_pop_first(resuming_download_machine,except_machine)
            if resuming_machine ~= nil then
                machine_loaders[resuming_machine]:resume()
                new_download_started = true
            end
        end
    end
end
 
 -- 获取机台资源状态
 function MachineDownloadManager.get_machine_asset_status(machine_id)
     return assets_status[machine_id]
 end
 
 function MachineDownloadManager.status_prefix_builder(machine_id, key)
     return "machine."..machine_id..".status."..key
 end

 --- Machine Versions Manage
function MachineDownloadManager.read_machine_local_version(machine_id)
    return MachineUtil.read_machine_version(machine_id)
end

function MachineDownloadManager.update_machine_local_version(machine_id, version)
    if machine_versions[machine_id] == nil then
        machine_versions[machine_id] = {}
    end
    machine_versions[machine_id].local_version = version
end

function MachineDownloadManager.update_machine_server_version(machine_id, version)
    if machine_versions[machine_id] == nil then
        machine_versions[machine_id] = {}
    end
    machine_versions[machine_id].server_version = version
end

function MachineDownloadManager.get_machine_local_version(machine_id)
    if machine_versions[machine_id] == nil then
        machine_versions[machine_id] = {}
    end

    if machine_versions[machine_id].local_version == nil then
        local version = MachineDownloadManager.read_machine_local_version(machine_id)
        machine_versions[machine_id].local_version = version
    end

    return machine_versions[machine_id].local_version
end

function  MachineDownloadManager.get_machine_server_version(machine_id)
    if machine_versions[machine_id] == nil then
        machine_versions[machine_id] = {}
    end

    if machine_versions[machine_id].server_version == nil then
        local portal_data = MachinePortalManager.get_portal_data_by_machine_id(machine_id)

        local version = fun.NUMBER_MAX
        if portal_data then version = portal_data.version end
        machine_versions[machine_id].server_version = version
    end

    return machine_versions[machine_id].server_version
end

function MachineDownloadManager.is_machine_exsit_new_version(machine_id)
    local local_version  = MachineDownloadManager.get_machine_local_version(machine_id)
    local server_version = MachineDownloadManager.get_machine_server_version(machine_id)

    return local_version < server_version
end

function MachineDownloadManager.check_machine_version(machine_id, callback)
    local local_version = tonumber(MachineUtil.read_machine_version(machine_id))
    local portal_data = MachinePortalManager.get_portal_data_by_machine_id(machine_id)
    if(assets_status==nil)then 
        assets_status = {}
    end
    local status = {}
    status.machine_id = machine_id
    status.progress = 0

    if portal_data and portal_data.version then
        log.i(machine_id.." local version: "..local_version..", server version: "..portal_data.version)
    else
        log.i(machine_id.." local version: "..local_version..", has no server version ")
    end
    if portal_data and local_version >= portal_data.version then
        status.has_new_version = false
        assets_status[machine_id] = status
        if callback then callback(status) end
    else
        MachineUtil.query_machine_version(machine_id, local_version, function(has_update, new_version, data)
            --log.r("query_machine_version  machine_id "..machine_id.."     "..tostring(has_update))
            if has_update then
                status.has_new_version = true
                status.new_version = new_version
                status.packages = data.resourceInfo
                if not data.resourceInfo.size then
                    data.resourceInfo.size = 4000000
                end
                status.packages.size = data.resourceInfo.size
                MachineDownloadManager.update_machine_server_version(machine_id,new_version)
            else 
                status.has_new_version = false
            end
            assets_status[machine_id] = status
            if callback then callback(status) end
        end)
    end
end

function MachineDownloadManager.has_any_machine_downloading()
    return downloading_machine ~= nil
end

function  MachineDownloadManager.is_machine_downloading(machine_id)
    return downloading_machine == machine_id
end

function  MachineDownloadManager.is_machine_waiting(machine_id)
   for i, v in ipairs(waiting_download_machines) do
       if v == machine_id then 
            return true
       end
   end
   return false
end

function  MachineDownloadManager.is_machine_pausing(machine_id)
    for i, v in ipairs(paused_download_machines) do
        if v == machine_id then 
             return true
        end
    end
    return false
end

function MachineDownloadManager.get_machine_download_state(machine_id)
    if MachineDownloadManager.is_machine_downloading(machine_id) then
        return MachineDownloadManager.DOWNLOAD_STATE.DOWNLOADING
    elseif  MachineDownloadManager.is_machine_waiting(machine_id) then
        return MachineDownloadManager.DOWNLOAD_STATE.WAITING
    elseif MachineDownloadManager.is_machine_pausing(machine_id) then
        return MachineDownloadManager.DOWNLOAD_STATE.PAUSING
    elseif MachineDownloadManager.is_machine_exsit_new_version(machine_id) then
        return  MachineDownloadManager.DOWNLOAD_STATE.NEW_VERSION
    else
        return MachineDownloadManager.DOWNLOAD_STATE.IDLE
    end
end

function MachineDownloadManager.download_fake_machine(machine_id)
    local status = {}
    status.machine_id = machine_id
    status.progress = 0
    local local_version = tonumber(MachineUtil.read_machine_version(machine_id))
    MachineUtil.query_machine_version(machine_id, local_version, function(has_update, new_version, packages)
        if has_update then
            status.has_new_version = true
            status.new_version = new_version
            status.packages = packages
        else 
            status.has_new_version = false
        end
        --因为默认的
        MachineDownloadManager.update_machine_server_version(machine_id,new_version)
        assets_status[machine_id] = status

        if status.has_new_version then
            MachineDownloadManager.download_machine_directly(machine_id, false, false)
        end
    end)
end

function MachineDownloadManager.check_all_fake_machines_version()

    local fake_machines = {10000,10999}

    local local_versions = {}
    for i, v in ipairs(fake_machines) do
        local_versions[tostring(v)] = MachineDownloadManager.get_machine_local_version(v)
    end

    local json = TableToJson(local_versions)
    Http.check_versions(Http.APP_ID, json,function (code, msg, data)
        if code == RET.RET_SUCCESS then
            for k, v in pairs(data.versions) do
                log.r("update version machine_id:"..v.machineId.." version:"..v.version)
                MachineDownloadManager.update_machine_server_version(v.machineId, v.version)
            end
        end
    end)
end

function MachineDownloadManager.cache_machine_download_anim_percent(machine_id, percent)
    machine_download_anim_percents[machine_id] = percent
end

function MachineDownloadManager.get_machine_download_anim_percent(machine_id)
    return machine_download_anim_percents[machine_id]
end