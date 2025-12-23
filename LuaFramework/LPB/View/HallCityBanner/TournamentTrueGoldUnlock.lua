
--周榜可用 banner
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local HallCityTournamentUnlockBannerItem = HallCityBannerItem:New("HallCityTournamentUnlockBannerItem","TournamentTrueGoldBannerAtlas")
local this = HallCityTournamentUnlockBannerItem

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
}

function HallCityTournamentUnlockBannerItem:OnEnable()
    self:InitTime()
end

function HallCityTournamentUnlockBannerItem:GetLeftTime()
    return ModelList.TournamentModel:GetRemainTime()
end

function HallCityTournamentUnlockBannerItem:FinishEndTime()
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

function HallCityTournamentUnlockBannerItem:HitBannerFunc()
    if ModelList.TournamentModel:CheckIsBlackGoldUser() then
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentBlackGoldGuideView")
    else
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentGuideView")
    end
end


return this