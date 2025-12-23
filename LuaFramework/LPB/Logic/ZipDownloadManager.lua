require "Utils.MachineUtil"
--定义成全局的
ZipDownloadManager = {}
ZipDownloadManager.DOWNLOAD_STATE = 
{
    IDLE = 1,
    NEW_VERSION = 2,
    WAITING = 3,
    DOWNLOADING = 4,
    PAUSING = 5,
    DOWNLOAD_SUCCESS = 6,
    DOWNLOAD_FAILED = 7,
}

local zipsDownloadStatus = {}
local zipDownloaders = {}

local DownloadingZips = {}
local watingDownloadZips = {}
local pausedDownLoadZips = {}
local resumingDownloadZips = {}
local zipDownloadProgressRecords = {}
local downloadUrlStatus = {}       --key zipDownloadUrl   value ZipDownloadManager.DOWNLOAD_STATE    DOWNLOAD_SUCCESS DOWNLOAD_FAILED DOWNLOADING IDLE
ZipDownloadManager.zipDownloadPriority = 1

-- 开始下载指定Zip
function ZipDownloadManager.StartDownLoadZip(zipUrl, unzipDir, remoteMd5, isHighestPriority, extra)
    local willDownloadNow = false
    local task = {url = zipUrl, dir = unzipDir, md5 = remoteMd5, extra = extra,}
    if ZipDownloadManager.HasAnyZipDownloading() then
        if not ZipDownloadManager.IsZipDownloading(zipUrl) then
            if not isHighestPriority then
                ZipDownloadManager.AddToWaitingQueue(task)
            else
                willDownloadNow = true
            end
        end
    else
        willDownloadNow = true
    end

    if willDownloadNow then
        ZipDownloadManager.DownloadZipDirectly(task, isHighestPriority, true)
    end
end

function ZipDownloadManager.DownloadZipDirectly(task, isHighestPriority, inQueue)
    if not task or not task.url then
        log.log("ZipDownloadManager.DownloadZipDirectly 参数有问题", task, isHighestPriority, inQueue)
        return
    end

    local zipUrl = task.url
    if inQueue then
        ZipDownloadManager.AddToDownloadingQueue(task)
    end
    local unzipDir = task.dir or Util.DataPath
    ZipDownloadManager.RecordZipDownloadProgress(zipUrl, 0)
    downloadUrlStatus[zipUrl] = ZipDownloadManager.DOWNLOAD_STATE.DOWNLOADING
    local priority = ZipDownloadManager.zipDownloadPriority
    local downloader = SuperUnzipDownloader.create(zipUrl, unzipDir, priority)
    MD5Checker.add_md5_data(zipUrl, task.md5)
    downloader:add_event_listener(SuperDownloader.DownloadSuccess, function(owener, path)
        log.log("DownloadZipDirectly 下载成功,", path)
        ZipDownloadManager.RecordZipDownloadProgress(zipUrl, 100)
        ZipDownloadManager._UnzipSuccessCallback(task, inQueue)
        downloadUrlStatus[zipUrl] = ZipDownloadManager.DOWNLOAD_STATE.DOWNLOAD_SUCCESS
    end)
    downloader:add_event_listener(SuperDownloader.DownloadFail, function(owener, error)
        log.log("DownloadZipDirectly 下载失败,", zipUrl, error)
        downloadUrlStatus[zipUrl] = ZipDownloadManager.DOWNLOAD_STATE.DOWNLOAD_FAILED
        ZipDownloadManager._UnzipFailedCallback(task, error, inQueue)
    end)
    downloader:add_event_listener(SuperDownloader.DownloadUpdate, function(owener, progress)
        log.log("DownloadZipDirectly 更新下载进度,", zipUrl, progress)
        ZipDownloadManager._UnzipProgressCallback(task, progress)
    end)
    downloader:run(isHighestPriority)
    Facade.SendNotification(NotifyName.ZipResDownload.StartDownload, {url = zipUrl, extra = task.extra})
    ZipDownloadManager.zipDownloadPriority = ZipDownloadManager.zipDownloadPriority + 1
    zipDownloaders[zipUrl] = downloader
end

function ZipDownloadManager._UnzipSuccessCallback(task, inQueue)
    --Facade.SendNotification(NotifyName.Event_machine_download_success, zipUrl) --不弹提示
    local zipUrl = task.url
    local bundle = {}
    bundle.url = zipUrl
    bundle.extra = task.extra
    -- TODO 接口替换 by LwangZg
    local tempPath = CS.AssetsManager:GetFilePathFromStorage(zipUrl)
    Util.DeleteFile(tempPath)
    Facade.SendNotification(NotifyName.ZipResDownload.DownloadSucceed, bundle)
    if inQueue then
        ZipDownloadManager.RemoveTaskFromAllQueue(zipUrl)
        if fun.is_net_reachable() then
            ZipDownloadManager.StartNextDownloadTask()
        end
    end
end

function ZipDownloadManager._UnzipFailedCallback(task, error, inQueue)
    local zipUrl = task.url
    Util.DeleteFile(error.LocalPath or error)
    local bundle = {}
    bundle.url = zipUrl
    bundle.error = error
    bundle.extra = task.extra
    Facade.SendNotification(NotifyName.ZipResDownload.DownloadError, bundle) 
    if inQueue then
        ZipDownloadManager.RemoveTaskFromAllQueue(zipUrl)
        if fun.is_net_reachable() then
            ZipDownloadManager.StartNextDownloadTask()
        end
    end
end

function ZipDownloadManager._UnzipProgressCallback(task, progress)
    local zipUrl = task.url
    ZipDownloadManager.RecordZipDownloadProgress(zipUrl, progress)
    local bundle = {}
    bundle.url = zipUrl
    bundle.progress = progress
    bundle.extra = task.extra
    Facade.SendNotification(NotifyName.ZipResDownload.UpdateProgress, bundle)
end

function ZipDownloadManager.StartNextDownloadTask(exceptZip)
    if not ZipDownloadManager.HasAnyZipDownloading() then
        if #watingDownloadZips > 0 then
            local waitingZip = fun.table_pop_first(watingDownloadZips)
            if waitingZip ~= nil then
                ZipDownloadManager.StartDownLoadZip(waitingZip.url, waitingZip.dir, waitingZip.md5, false)
                return
            end
        end

        if #resumingDownloadZips > 0 then
            local resumingZip = fun.table_pop_first(resumingDownloadZips, exceptZip)
            if resumingZip ~= nil then
                zipDownloaders[resumingZip.url]:resume()
                return
            end
        end
    end
end

function ZipDownloadManager.RemoveTaskFromAllQueue(url)
    DownloadingZips = ZipDownloadManager.RemoveFromQueue(url, DownloadingZips)
    watingDownloadZips = ZipDownloadManager.RemoveFromQueue(url, watingDownloadZips)
    pausedDownLoadZips = ZipDownloadManager.RemoveFromQueue(url, pausedDownLoadZips)
    resumingDownloadZips = ZipDownloadManager.RemoveFromQueue(url, resumingDownloadZips)
end

function ZipDownloadManager.AddToWaitingQueue(task)
    ZipDownloadManager.AddToQueue(task, watingDownloadZips)
end

function ZipDownloadManager.AddToDownloadingQueue(task)
    ZipDownloadManager.AddToQueue(task, DownloadingZips)
end

function ZipDownloadManager.AddToQueue(task, queue)
    for i, v in ipairs(queue) do
        if v.url == task.url then
           return
        end
    end
    queue[#queue + 1] = task
end

function ZipDownloadManager.RemoveFromQueue(url, queue)
    local new_queue = {}

    for i = 1, #queue do
        local val = queue[i]
        if val.url ~= url then
          new_queue[#new_queue + 1] = val
        end
    end

    return new_queue
end

function ZipDownloadManager.ReadResLocalVersion(relativePath, encrypted)
    local absolutePath = UnityEngine.Application.persistentDataPath .. "/" .. relativePath
    local v = MyGame.VersionReader.GetLocalResVersion(absolutePath, encrypted)
    return v
end

function ZipDownloadManager.HasAnyZipDownloading()
    return #DownloadingZips > 0
end

function ZipDownloadManager.IsZipDownloading(zipUrl)
    for i, v in ipairs(DownloadingZips) do
        if v.url == zipUrl then 
             return true
        end
    end
end

function ZipDownloadManager.IsZipWaiting(zipUrl)
   for i, v in ipairs(watingDownloadZips) do
       if v.url == zipUrl then 
            return true
       end
   end
   return false
end

function ZipDownloadManager.IsZipPaused(zipUrl)
    for i, v in ipairs(pausedDownLoadZips) do
        if v.url == zipUrl then 
             return true
        end
    end
    return false
end

function ZipDownloadManager.GetZipDownloadState(zipUrl)
    if ZipDownloadManager.IsZipDownloading(zipUrl) then
        return ZipDownloadManager.DOWNLOAD_STATE.DOWNLOADING
    elseif ZipDownloadManager.IsZipWaiting(zipUrl) then
        return ZipDownloadManager.DOWNLOAD_STATE.WAITING
    elseif ZipDownloadManager.IsZipPaused(zipUrl) then
        return ZipDownloadManager.DOWNLOAD_STATE.PAUSING
    else
        return ZipDownloadManager.DOWNLOAD_STATE.IDLE
    end
end

function ZipDownloadManager.IsHasRequestDownload(zipUrl)
    return ZipDownloadManager.GetZipDownloadState(zipUrl) ~= ZipDownloadManager.DOWNLOAD_STATE.IDLE
end

function ZipDownloadManager.RecordZipDownloadProgress(zipUrl, percent)
    zipDownloadProgressRecords[zipUrl] = percent
end

function ZipDownloadManager.GetZipDownloadProgress(zipUrl)
    return zipDownloadProgressRecords[zipUrl]
end