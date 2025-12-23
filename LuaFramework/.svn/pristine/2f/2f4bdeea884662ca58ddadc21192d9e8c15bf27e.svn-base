-- 对象池
ObjectPool = Clazz()

-- 初始化
function ObjectPool:init(para)
    self.item_class = para.class
    self.item_pool = {}
    self.container = para.container
    self.max = para.max
end

-- 取出
function ObjectPool:pop(item_id)
    self.item_pool[item_id] = self.item_pool[item_id] or {}
    local cur_pool = self.item_pool[item_id]
    if #cur_pool > 0 then
        return table.remove(cur_pool)
    else
        return self:add(item_id)
    end
end

-- 放入
function ObjectPool:push(item_id,item)
    self.item_pool[item_id] = self.item_pool[item_id] or {}
    local cur_pool = self.item_pool[item_id]
    if #cur_pool > self.max then
        item:destroy()
    else
        table.insert(self.item_pool[item_id], item)
        fun.set_parent(item.go,self.container)
        item:reset()
    end
end

-- 增加
function ObjectPool:add(item_id)
    local item = self.item_class.create(item_id)
    return item
end

-- 销毁
function ObjectPool:destroy()
    for k,v in pairs(self.item_pool) do
        for i,j in ipairs(v) do
            j:destroy()
        end
    end
    self.item_pool = nil
end