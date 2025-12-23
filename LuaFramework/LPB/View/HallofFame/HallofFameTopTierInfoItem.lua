local HallofFameTierInfoItem = require "View/HallofFame/HallofFameTierInfoItem"
local HallofFameTopTierInfoItem = HallofFameTierInfoItem:New()
local this = HallofFameTopTierInfoItem
this.viewType = CanvasSortingOrderManager.LayerType.None


local anim = nil
--local isShow = nil

function HallofFameTopTierInfoItem:New()
	local o = {}
	self.__index = self
	setmetatable(o,self)
	return o
end

function HallofFameTopTierInfoItem:OnShow()
	if not self._isShow then
		self._isShow = true
		self:PlayAnim("enter")
		-- anim = fun.get_component(self.go,fun.ANIMATOR)
		-- if anim then
		-- 	anim:Play("enter")
		-- end
	end
end

function HallofFameTopTierInfoItem:OnHide()
	if self._isShow then
		self._isShow = false
		-- anim = fun.get_component(self.go,fun.ANIMATOR)
		-- if anim then
		-- 	anim:Play("end")
		-- end
		self:PlayAnim("end")
	end
end

function HallofFameTopTierInfoItem:PlayAnim(animName)
	anim = fun.get_component(self.go,fun.ANIMATOR)
	if anim then
		anim:Play(animName)
	end
end

return this