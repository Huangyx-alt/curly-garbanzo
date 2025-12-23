--[[
-- added by wsh @ 2017-12-05
-- 单例类,区分LPB Singleton
--]]
---@class TGameSingleton
local TGameSingleton = BaseClass("TGameSingleton");

function TGameSingleton:OnCreate() end

function TGameSingleton:OnDestroy() end

-- 只是用于启动模块
function TGameSingleton:Startup() end

function TGameSingleton:__init()
	assert(rawget(self._class_type, "Instance") == nil, self._class_type.__cname.." to create singleton twice!")
	rawset(self._class_type, "Instance", self)
	self:OnCreate()
end

function TGameSingleton:__delete()
	rawset(self._class_type, "Instance", nil)
	self:OnDestroy()
end

-- 不要重写
---@return TGameSingleton 单例类实例
function TGameSingleton:GetInstance()
	if rawget(self, "Instance") == nil then
		rawset(self, "Instance", self.New())
	end
	assert(self.Instance ~= nil)
	return self.Instance
end

return TGameSingleton;
