-------------------
--后进先出堆列表
-------------------
local Stack = {}   

function Stack:New()  
    local temp = {}  
    setmetatable(temp,{__index = Stack}) 
    temp:reset() 
    return temp  
end   
  
function Stack:reset()  
    self.stackList = {} 
    self.count = 0
end    
  
function Stack:pop(index)
    self.stackList[index or self.count] = nil
end  
  
function Stack:push(item)
    if item then
        self.count = self.count + 1
        self.stackList[self.count] = item
        return self.count
    end
    return nil
end  
  
function Stack:Count()  
    return self.count or 0
end 

function Stack:Current()
    return self.stackList[self.count] or self:GetCurrentRecursion()
end

function Stack:Previous()
    return self.stackList[self.count - 1]
end

function Stack:GetCurrentRecursion()
    while true do
        if self.stackList[self.count] or self.count == 1 then
            break
        end
        self.count = math.max(1,self.count - 1 )
    end
    return self.stackList[self.count]
end

return Stack