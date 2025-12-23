local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyCoinEffectsView = FlyRewardEffectsView:New("FlyCoinEffectsView",nil)
local this = FlyCoinEffectsView
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

function FlyCoinEffectsView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.viewName = "FlyCoinEffectsView"
    return o
end

function FlyCoinEffectsView:OnEnable_late()
    UISound.play("coin_fly")
end

function FlyCoinEffectsView:GetFlyTargetPos()
    return GetTopCurrencyLeftIconPos()
end

function FlyCoinEffectsView:OnSingleItemFlyComplete()
    local _curInstance = GetTopCurrencyInstance()
    if _curInstance and _curInstance.coin_anim then
        fun.play_animator(_curInstance.coin_anim, "act", true)
    end
end

function FlyCoinEffectsView:GetAnimationName()
    return "shopbuycoin"
end

function FlyCoinEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyCoinEffectsView