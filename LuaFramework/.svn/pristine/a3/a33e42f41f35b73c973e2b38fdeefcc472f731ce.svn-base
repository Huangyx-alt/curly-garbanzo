---@class LRU
local LRU = {}
LRU.__index = LRU

---@param max_size number 最大缓存容量
function LRU.new(max_size)
    local self = setmetatable({
        size = 0,
        capacity = max_size or 1000,
        nodeMap = {},
        head = {},  -- 虚拟头节点
        tail = {},  -- 虚拟尾节点
    }, LRU)
    
    self.head.next = self.tail
    self.tail.prev = self.head
    return self
end

-- 添加节点到链表头部
---@param node table 节点，包含 key 和 value
function LRU:addNode(node)
    local prev = self.head
    local next = self.head.next
    
    node.prev = prev
    node.next = next
    prev.next = node
    next.prev = node
end

-- 移除指定节点
---@param node table 要移除的节点
function LRU:removeNode(node)
    local prev = node.prev
    local next = node.next
    
    prev.next = next
    next.prev = prev
end

-- 移动到头部（标记最近使用）
---@param node table 要移动的节点
function LRU:moveToHead(node)
    self:removeNode(node)
    self:addNode(node)
end

-- 获取缓存值
---@param key any 缓存键
function LRU:get(key)
    local node = self.nodeMap[key]
    if not node then return nil end
    
    self:moveToHead(node)
    return node.value
end

-- 设置缓存值
---@param key any 缓存键
---@param value any 缓存值
function LRU:set(key, value)
    local node = self.nodeMap[key]
    
    if node then
        -- 更新现有节点
        node.value = value
        self:moveToHead(node)
    else
        -- 创建新节点
        node = { key = key, value = value }
        self.nodeMap[key] = node
        self:addNode(node)
        self.size = self.size + 1
        
        -- 淘汰最近最少使用
        if self.size > self.capacity then
            local last = self.tail.prev
            self:removeNode(last)
            self.nodeMap[last.key] = nil
            self.size = self.size - 1
        end
    end
end

-- 获取缓存命中率（调试用）
---@return number 命中率
function LRU:getHitRate()
    return self.hitCount and self.missCount 
        and self.hitCount / (self.hitCount + self.missCount) or 0
end

function LRU:setCapacity(num)
    self.capacity = num or 1000
end

function LRU:clear()
    local current = self.head.next
    while current ~= self.tail do
        local nextNode = current.next
        current.prev, current.next = nil, nil -- 断开引用
        current = nextNode
    end
    self.nodeMap = {}
    self.head.next = self.tail
    self.tail.prev = self.head
    self.size = 0
end

return LRU