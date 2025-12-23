local TournamentTierInfoItem = require "View/Tournament/TournamentTierInfoItem"
local TournamentTopTierInfoItem = TournamentTierInfoItem:New()
local this = TournamentTopTierInfoItem
this.viewType = CanvasSortingOrderManager.LayerType.None


local anim = nil;
--local isShow = nil;

function TournamentTopTierInfoItem:New()
	local o = {}
	self.__index = self
	setmetatable(o,self)
	return o
end

function TournamentTopTierInfoItem:OnShow()
	if not self._isShow then
		self._isShow = true;
		self:PlayAnim("enter")
		-- anim = fun.get_component(self.go,fun.ANIMATOR);
		-- if anim then
		-- 	anim:Play("enter")
		-- end
	end
end

function TournamentTopTierInfoItem:OnHide()
	if self._isShow then
		self._isShow = false;
		-- anim = fun.get_component(self.go,fun.ANIMATOR);
		-- if anim then
		-- 	anim:Play("end")
		-- end
		self:PlayAnim("end")
	end
end

function TournamentTopTierInfoItem:PlayAnim(animName)
	anim = fun.get_component(self.go,fun.ANIMATOR);
	if anim then
		anim:Play(animName)
	end
end

return this;