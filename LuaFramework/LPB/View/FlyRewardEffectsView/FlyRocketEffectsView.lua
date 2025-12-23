local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyRocketEffectsView = FlyRewardEffectsView:New("FlyRocketEffectsView",nil)
local this = FlyRocketEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyRocketEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FlyRocketEffectsView:GetFlyTargetPos()
    return GetTopRocketIconPos()
end

function FlyRocketEffectsView:GetAnimationName()
    --return "shopbuyrocket"
    return "shopbuycoin"
end

function FlyRocketEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyRocketEffectsView