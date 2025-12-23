DownloadUtil = {}

function DownloadUtil.start_download(url_base, url_detail, priority, on_success, on_update, on_fail, opts)
    -- TODO 接口替换 by LwangZg
    CS.AssetsManager:Get(url_base, url_detail, priority, on_success, 
        on_fail, on_update)

    if opts.highest_priority then
        CS.AssetsManager:StartImmediately(url_base, url_detail)
    end
end

function DownloadUtil.pause(url)
    -- TODO 接口替换 by LwangZg
    CS.AssetsManager:Pause(url)
end

function DownloadUtil.resume(url)
    -- TODO 接口替换 by LwangZg
    CS.AssetsManager:Resume(url)
end
 
function DownloadUtil.stop(url)
    -- TODO 接口替换 by LwangZg
    CS.AssetsManager:Stop(url)
end

function  DownloadUtil.start_immediately(url_base, url_detail)
    -- TODO 接口替换 by LwangZg
    CS.AssetsManager:StartImmediately(url_base, url_detail)
end
