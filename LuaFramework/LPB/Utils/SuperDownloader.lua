require "Utils.Eventer"
require "Utils.DownloadUtil"

SuperDownloader = Clazz()

SuperDownloader.DownloadSuccess = "SuperDownloader.DownloadSuccess"
SuperDownloader.DownloadFail = "SuperDownloader.DownloadFail"
SuperDownloader.DownloadUpdate = "SuperDownloader.DownloadUpdate"

SuperDownloader.State = {
    Idle = 0,
    Downloading = 1,
    Paused = 2,
    Complete = 3,
    Error = 4
}

SuperDownloader.id_generator = 1

function SuperDownloader.create(url_base, url_detail,  priority,server_md5)
    if not priority then priority = 0 end

    local loader = SuperDownloader:new()
    loader.id = SuperDownloader.id_generator
    loader.url_base = url_base
    loader.url_detail = url_detail
    loader.priority = priority
    loader.eventer = Eventer.create()
    loader.state = SuperDownloader.State.Idle
    loader.progrss = 0
    loader.retry_cnt = 5
    loader.disposed = false
    loader.md5 = server_md5
    MD5Checker.add_md5_data(url_detail, server_md5)
    SuperDownloader.id_generator  = SuperDownloader.id_generator  + 1
    return loader
end

function SuperDownloader:run(immediately)
    self:do_download(immediately)
end

function SuperDownloader:do_download(immediately)
    self.state = SuperDownloader.State.Downloading 
    DownloadUtil.start_download(self.url_base, self.url_detail, self.priority, function (arg)
        local path = arg.LocalPath
        if fun.file_exist(path) then
            if MD5Checker.check(path) then
                self:on_success(arg)    
                self.state = SuperDownloader.State.Complete
            else
                log.r(path, " not passed md5 check")
                fun.remove_file(path)
                if not self.disposed then
                    if self.retry_cnt > 0 then
                        self.retry_coroutine = fun.run(function()
                            self:retry_download(immediately) 
                        end)
                        self.retry_cnt = self.retry_cnt - 1
                    end
                end
            end
        end
    end,
    function (arg)
        self.state = SuperDownloader.State.Downloading
        self.progress = arg.Progress
        self:on_update(arg)
    end,
    function (arg)
        self:on_fail(arg)    
        self.state = SuperDownloader.State.Error
    end,
    {cross_scene = true, highest_priority = immediately or false})
end

function SuperDownloader:run_with_highest_priority()
    DownloadUtil.start_immediately(self.url)
end

function SuperDownloader:add_event_listener(event, handler)
    self.eventer:add(SuperDownloader.build_event_name(event, self), handler)
end

function SuperDownloader:remove_event_listener(event, handler)
    self.eventer:remove(SuperDownloader.build_event_name(event, self), handler)
end

function  SuperDownloader.build_event_name(event, loader)
    return event .. "." .. loader.id
end

function SuperDownloader:dispose()
    if not self.disposed then
        DownloadUtil.stop(self.url)
        self.eventer:remove_all()
        self.disposed = true
    end

    if self.retry_coroutine then
        fun.stop(self.retry_coroutine)
        self.retry_coroutine = nil
    end
end

function SuperDownloader:pause()
    self.state = SuperDownloader.State.Paused
    DownloadUtil.pause(self.url)
end

-- 继续下载后会自动触发update等重置state
function SuperDownloader:resume()
    DownloadUtil.resume(self.url)
end

function SuperDownloader:on_success(arg)
    Event.Brocast(SuperDownloader.build_event_name(SuperDownloader.DownloadSuccess, self), arg)
end

function SuperDownloader:on_update(arg)
    Event.Brocast(SuperDownloader.build_event_name(SuperDownloader.DownloadUpdate, self), arg)
end

function SuperDownloader:on_fail(arg)
    Event.Brocast(SuperDownloader.build_event_name(SuperDownloader.DownloadFail, self), arg)
end

function SuperDownloader:retry_download(immediately)
    coroutine.wait(1)
    self:do_download(immediately)
end