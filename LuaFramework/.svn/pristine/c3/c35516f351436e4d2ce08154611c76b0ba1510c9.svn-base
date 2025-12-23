Eventer = Clazz()

function Eventer.create()
    local listener = Eventer:new()
    listener:init()
    return listener
end

function Eventer:init()
    self.events ={}
end

function Eventer:add(event, handler)
    Event.AddListener(event,handler)
    self.events[event] = handler
end

function Eventer:remove(event, handler)
    Event.RemoveListener(event,handler)(event,handler)
    self.events[event] = nil
end

function Eventer:remove_all()
   for k, v in pairs(self.events) do
       if k and v then
            Event.RemoveListener(k,v)
       end
   end
end