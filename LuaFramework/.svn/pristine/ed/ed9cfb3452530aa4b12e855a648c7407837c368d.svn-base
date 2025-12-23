local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyPlayerExpEffectsView = FlyRewardEffectsView:New("FlyPlayerexpView",nil)
local this = FlyPlayerExpEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyPlayerExpEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.viewName = "FlyPlayerexpView"
    return o
end

function FlyPlayerExpEffectsView:GetFlyTargetPos()
    --return GetTopVipIconPos()
    return GetPlayerEXPIconPos()
end

function FlyPlayerExpEffectsView:GetAnimationName()
    --return "shopbuyPlayerexp"
    return "shopbuycoin"
end

function FlyPlayerExpEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyPlayerExpEffectsView 