ClazzBase = {}
ClazzBase.name = "ClazzBase"

function ClazzBase:New()
	local o =  {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ClazzBase:new()
	local o =  {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function ClazzBase:init(...)
	log.r("override in sub class")
end

function Clazz(base, name)
    local r = {}
    base = base or ClazzBase
    setmetatable(r, base)
	base.__index = base
	-- self.super这种写法是有问题的，如果这个类有子类的话，这个self.super就会被重新赋值成这个类，最终形成无终点的递归调用，导致栈溢出
	-- 建议有self.super的类不要再派生子类，或者用Cell.on_init(self,para)代替self.super
	r.super = base
	r.name = name
    return r
end

function Create(clazz,...)
    local r = clazz:new()
    r:init(...)
    return r
end

--- 新建一个clazz对象实例
function CreateInstance_(clazz, name, ...)
	local instance = {}
	instance.className = name
	instance.base = clazz
	setmetatable(instance, { __index = clazz })
	return instance
end

--Clazz, table, CreateInstance_