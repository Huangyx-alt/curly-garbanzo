---@class Queue lpb 队列容器
Queue = {}

function Queue:New()
    local o = {}
    setmetatable(o,{__index = Queue})
    o:reset()
    return o
end

function Queue:reset()
    self.count = 0
    self.queue = {}
end

--尾进
function Queue:push(t)
    self.count = self.count + 1
    table.insert(self.queue,t)
end

--头出
function Queue:pop()
    if self.count > 0 then
        self.count = self.count - 1
        return table.remove(self.queue,1)
    end
    return nil
end

return Queue