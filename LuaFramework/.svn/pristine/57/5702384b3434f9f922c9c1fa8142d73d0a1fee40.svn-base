local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyGemsEffectsView = FlyRewardEffectsView:New("FlyGemsEffectsView",nil)
local this = FlyGemsEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyGemsEffectsView:New(flyItemId,flyTargetPos)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._flyItemId = flyItemId
    o._flyTargetPos = flyTargetPos
    return o
end

function FlyGemsEffectsView:OnEnable_late()
    UISound.play("diamond_get")
end
--
function FlyGemsEffectsView:GetFlyTargetPos()
    return  self._flyTargetPos or GetTopCurrencyRightIconPos()
end

function FlyGemsEffectsView:GetAnimationName()
    --return "shopbuygems"
    return "shopbuycoin"
end

function FlyGemsEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyGemsEffectsView