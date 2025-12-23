List = {}
List.__index = List

function List:New(t)--创建List对象
    local o = {itemType = t}
    setmetatable(o, self)
    o.count = 0
    return o
end

function List:Add(item)--添加元素
    self.count = self.count + 1
    table.insert(self, item)
end

function List:Clear()--清空
    local count = self.count --self:Count()
    for i=count,1,-1 do
        table.remove(self)
    end
    self.count = 0
end

function List:Contains(item)--是否包含某个元素
    local count = self.count --self:Count()
    for i=1,count do
        if self[i] == item then
            return true
        end
    end
    return false
end

function List:Count()--数量
    return self.count --table.getn(self)
end

function List:Find(predicate)--查找
    if (predicate == nil or type(predicate) ~= 'function') then
        print('predicate is invalid!')
        return
    end
    local count = self.count --self:Count()
    for i=1,count do
        if predicate(self[i]) then 
            return self[i] 
        end
    end
    return nil
end

function List:ForEach(action)--遍历，参数function
    if (action == nil or type(action) ~= 'function') then
        print('action is invalid!')
        return
    end
    local count = self.count --self:Count()
    for i=1,count do
        action(self[i])
    end
end

function List:IndexOf(item)--元素的在List中的索引
    local count = self.count --self:Count()
    for i=1,count do
        if self[i] == item then
            return i
        end
    end
    return 0
end

function List:LastIndexOf(item)
    local count = self.count --self:Count()
    for i=count,1,-1 do
        if self[i] == item then
            return i
        end
    end
    return 0
end

function List:Insert(index, item)--插入
    self.count = self.count + 1
    table.insert(self, index, item)
end

function List:ItemType()
    return self.itemType
end

function List:Remove(item)--移除
    if self.count > 0 then
        local idx = self:LastIndexOf(item)
        if (idx > 0) then
            self.count = self.count - 1
            table.remove(self, idx)
            self:Remove(item)
        end
    end
end

function List:RemoveAt(index)--在某个位置移除
    if self.count > 0 then
        self.count = self.count - 1
        table.remove(self, index)
    end
end

function List:Sort(comparison)--排序
    if (comparison ~= nil and type(comparison) ~= 'function') then
        print('comparison is invalid')
        return
    end
    if func == nil then
        table.sort(self)
    else
        table.sort(self, func)
    end
end

return List