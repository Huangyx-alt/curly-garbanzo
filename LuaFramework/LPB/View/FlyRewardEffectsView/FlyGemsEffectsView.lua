local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyGemsEffectsView = FlyRewardEffectsView:New("FlyGemsEffectsView",nil)
local this = FlyGemsEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyGemsEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.viewName = "FlyGemsEffectsView"
    return o
end

function FlyGemsEffectsView:OnEnable_late()
    UISound.play("diamond_get")
end

function FlyGemsEffectsView:GetFlyTargetPos()
    return GetTopCurrencyRightIconPos()
end

function FlyGemsEffectsView:OnSingleItemFlyComplete()
    local _curInstance = GetTopCurrencyInstance()
    if _curInstance and _curInstance.diamond_anim then
        fun.play_animator(_curInstance.diamond_anim, "act", true)
    end
end

function FlyGemsEffectsView:GetAnimationName()
    --return "shopbuygems"
    return "shopbuycoin"
end

function FlyGemsEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyGemsEffectsView