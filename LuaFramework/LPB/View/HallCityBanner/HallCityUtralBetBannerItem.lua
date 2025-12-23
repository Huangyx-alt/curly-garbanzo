
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local HallCityUtralBetBannerItem = HallCityBannerItem:New("HallCityUtralBetBannerItem","MainBannerAtlas")
local this = HallCityUtralBetBannerItem
local base = HallCityBannerItem

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
}

function HallCityUtralBetBannerItem:OnEnable()
    base.OnEnable(self)
    Facade.RegisterViewEnhance(self)
    self:InitTime()
end

function HallCityUtralBetBannerItem:OnDisable()
    base.OnDisable(self)
    Facade.RemoveViewEnhance(self)
end

function HallCityUtralBetBannerItem:GetLeftTime()
    local leftTime = 0
    if ModelList.UltraBetModel:IsActivityValid() then
        local endTime = ModelList.UltraBetModel:GetActivityExpireTime()
        local currentTime = ModelList.UltraBetModel:GetCurrentTime()
        leftTime = endTime - currentTime
        log.log("dghdgh007 HallCityUtralBetBannerItem:GetLeftTime() ", endTime, currentTime, leftTime)
    end
    return leftTime
end

function HallCityUtralBetBannerItem:HitBannerFunc()
    if ModelList.UltraBetModel:IsActivityValid() then
        local curCityId = ModelList.CityModel.GetHomeCity()
        log.log("dghdgh007 HallCityUtralBetBannerItem:HitBannerFunc() cityId is ", curCityId)
        Facade.SendNotification(NotifyName.UltraBet.ClickBanner)
    end
end

function HallCityUtralBetBannerItem:OnUltraBetActivityEnd()
    local curCityId = ModelList.CityModel.GetHomeCity()
    log.log("dghdgh007 HallCityUtralBetBannerItem:OnUltraBetActivityEnd", self.bannerId)
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

this.NotifyEnhanceList = {
    {notifyName = NotifyName.UltraBet.ActivityEnd, func = this.OnUltraBetActivityEnd},
}

return this