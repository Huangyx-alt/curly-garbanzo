local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local FullGameplayBannerView = HallCityBannerItem:New("FullGameplayBannerView")
local this = FullGameplayBannerView
local base = HallCityBannerItem

this.auto_bind_ui_items = {
    "left_time",
    "left_time_txt",
    "btn_banner",
}

function FullGameplayBannerView:OnEnable()
    base.OnEnable(self)
    Facade.RegisterViewEnhance(self)
    self:InitTime()
    fun.set_active(self.left_time, true)
end

function FullGameplayBannerView:OnDisable()
    base.OnDisable(self)
    Facade.RemoveViewEnhance(self)
end

function FullGameplayBannerView:GetLeftTime()
    local leftTime = ModelList.CityModel:GetFullGameplayRemainTime()
    return leftTime
end

function FullGameplayBannerView:HitBannerFunc()
    log.log("[FullGameplay] FullGameplayBannerView:HitBannerFunc()")
    Facade.SendNotification(NotifyName.ShowDialog, ViewList.FullGameplayPosterView)
    --Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayView, nil, nil, nil)
end

function FullGameplayBannerView:OnFullGameplayActivityEnd()
    log.log("[FullGameplay] FullGameplayBannerView:OnActivityEnd", self.bannerId)
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

function FullGameplayBannerView:FinishEndTime()
    log.log("[FullGameplay] FullGameplayBannerView:FinishEndTime", self.bannerId)
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

this.NotifyEnhanceList = {
    { notifyName = NotifyName.FullGameplay.ActivityEnd, func = this.OnFullGameplayActivityEnd },
}

return this