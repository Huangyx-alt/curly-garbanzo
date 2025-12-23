local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyVipExpEffectsView = FlyRewardEffectsView:New("FlyVipExpView",nil)
local this = FlyVipExpEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyVipExpEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FlyVipExpEffectsView:InitFly()
    UISound.play("vip_flyin")
end


function FlyVipExpEffectsView:GetFlyTargetPos()
    return GetTopVipIconPos()
end

function FlyVipExpEffectsView:GetAnimationName()
    --return "shopbuyeVipxp"
    return "shopbuycoin"
end

function FlyVipExpEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyVipExpEffectsView 