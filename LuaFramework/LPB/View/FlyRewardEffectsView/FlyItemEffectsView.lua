local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyItemEffectsView = FlyRewardEffectsView:New("FlyItemEffectsView",nil)
local this = FlyItemEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyItemEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FlyItemEffectsView:GetFlyTargetPos()
    return GetShowHeadIconPos()
end

function FlyItemEffectsView:GetAnimationName()
    --return "shopbuyitem"
    return "shopbuycoin"
end

function FlyItemEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyItemEffectsView