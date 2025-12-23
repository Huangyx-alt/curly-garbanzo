local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyJokerRocketEffectsView = FlyRewardEffectsView:New("FlyRocketEffectsView",nil)
local this = FlyJokerRocketEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyJokerRocketEffectsView:New(flyItemId,flyTargetPos)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._flyItemId = flyItemId
    o._flyTargetPos = flyTargetPos
    return o
end

function FlyJokerRocketEffectsView:GetFlyTargetPos()
    return self._flyTargetPos or GetTopRocketIconPos()
end

function FlyCoinEffectsView:OnSingleItemFlyComplete()
    local _curInstance = GetTopCurrencyInstance()
    if _curInstance and _curInstance.rocket_anim then
        fun.play_animator(_curInstance.rocket_anim, "act", true)
    end
end

function FlyJokerRocketEffectsView:GetAnimationName()
    --return "shopbuyrocket"
    return "shopbuycoin"
end

function FlyJokerRocketEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyJokerRocketEffectsView