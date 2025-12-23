local EventLib = require "Common/eventlib"

local Event = {}
local events = {}

function Event.AddListener(event,handler,owner)
	if not event or type(event) ~= "string" then
		error("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect({handler = handler,owner = owner})
end

function Event.Brocast(event,...)
	--log.r("Brocast -----------",event)
	if not event then error("event is nil") end
	if not events[event] then
		-- error("brocast " .. event .. " has no event.")
		--log.i("brocast " .. event .. " has no event.")
		-- 暂时移除广播的事件必须有监听的限制
	 else
		events[event]:fire(...)
	 end
end

--同一个事件名有多个实例同时监听时要传实例(owner)进来，要不没法区分移除哪个实例的事件，会把所有的事件都移除了
function Event.RemoveListener(event,handler,owner)
	if not events[event] then
		--error("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler,owner)
	end
end

return Event