require "Utils.Unzipper"
-- require "Logic.Http" --大改网络模块 by LwangZg
SuperUnzipDownloader = Clazz(SuperDownloader)

-- 解压占整个流程百分比
SuperUnzipDownloader.unzip_percent = 0.01

function SuperUnzipDownloader.create(url, unzip_path, priority)
    if not priority then priority = 0 end

    local loader = SuperUnzipDownloader:new()
    loader.id = SuperDownloader.id_generator
    loader.url = url
    loader.priority = priority
    loader.eventer = Eventer.create()
    loader.state = SuperDownloader.State.Idle
    loader.progrss = 0
    loader.unzip_target = unzip_path
    loader.disposed = false
    loader.retry_cnt = 5
    SuperDownloader.id_generator  = SuperDownloader.id_generator  + 1
    return loader
end

function SuperUnzipDownloader:run(immediately)
    self:do_download(immediately)
end

function SuperUnzipDownloader:do_download(immediately)
    self.state = SuperDownloader.State.Downloading
    DownloadUtil.start_download("", self.url, self.priority, function (arg)
        
        local is_file_broken = true
        local path = arg.LocalPath
        if fun.file_exist(path) then
            if MD5Checker.check(path) then
                is_file_broken = false
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

        if not is_file_broken then
            self.state = SuperDownloader.State.Downloading
            log.r("superzip....",arg.LocalPath)
            self:continue_unzip(arg.LocalPath)
        else
            local error = "Download file broken "..self.url
            Http.report_error(ErrorReport.MACHINE_DOWNLOAD_ERROR, error)
            log.r("download...."..error)
            -- Panel.show_error(error, function ()
                
            -- end,false)
        end
    end,
    function (arg)
        self.state = SuperDownloader.State.Downloading
        self.progress = arg.Progress * (1 - SuperUnzipDownloader.unzip_percent)
        self:on_update(self.progress)
    end,
    function (arg)
        self:on_fail(arg)    
        self.state = SuperDownloader.State.Error
    end,
    {cross_scene = true, highest_priority = immediately or false})
end

function SuperUnzipDownloader:continue_unzip(file)

    local unzipper = Unzipper.create(file, self.unzip_target)
    unzipper:add_event_listener(Unzipper.Event_unzip_fail, function(owner, error)
        self:on_fail(error)
        self.state = SuperDownloader.State.Error
    end)

    unzipper:add_event_listener(Unzipper.Event_unzip_success, function()
        self:on_success(self.unzip_target)
        self.state = SuperDownloader.State.Complete
    end)

    unzipper:add_event_listener(Unzipper.Event_unzip_update, function( owner, progress )
        local fix_progress = 100 * (1 - SuperUnzipDownloader.unzip_percent) + progress * 100 * SuperUnzipDownloader.unzip_percent
        self:on_update(fix_progress)
        self.state = SuperDownloader.State.Downloading
    end)

    unzipper:run()
end

function SuperUnzipDownloader:retry_download(immediately)
    coroutine.wait(1)
    self:do_download(immediately)
end