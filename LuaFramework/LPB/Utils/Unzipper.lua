Unzipper = Clazz()

Unzipper.id_generator = 1

Unzipper.Event_unzip_success = "Event_unzip_success"
Unzipper.Event_unzip_fail = "Event_unzip_fail"
Unzipper.Event_unzip_update = "Event_unzip_update"

function Unzipper.create(src, dst)
  local unzipper = Unzipper:new()
  unzipper.id = Unzipper.id_generator
  unzipper.src = src
  unzipper.dst = dst
  unzipper.eventer = Eventer.create()
  
  Unzipper.id_generator = Unzipper.id_generator + 1
  return unzipper
end

function Unzipper:run()
    log.r("Unzipper",self.src, self.dst)
    UnzipManager.Instance:Unzip(self.src, self.dst, 
    function()
        self:on_success()
    end,
    function(error)
       self:on_fail(error)
    end,
    function (progress)
        self:on_update(progress)
    end)
end

function Unzipper:add_event_listener(evet, handler)
    self.eventer:add(Unzipper.build_event_name(evet, self), handler)
end

function Unzipper:remove_event_listener(evet, handler)
    self.eventer:remove(Unzipper.build_event_name(evet, self), handler)
end

function  Unzipper.build_event_name(evet, zipper)
    return evet.."."..zipper.id
end

function Unzipper:on_success()
    Event.Brocast(Unzipper.build_event_name(Unzipper.Event_unzip_success, self))
end

function Unzipper:on_fail(error)
    Event.Brocast(Unzipper.build_event_name(Unzipper.Event_unzip_fail, self), error)
end

function Unzipper:on_update(progress)
    Event.Brocast(Unzipper.build_event_name(Unzipper.Event_unzip_update, self), progress)
end

function Unzipper:dispose()

end