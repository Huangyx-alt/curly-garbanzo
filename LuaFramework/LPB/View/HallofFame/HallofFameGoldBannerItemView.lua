--名人堂 真金用户banner
local DownloadUtility = require "View/CommonView/DownloadUtility"
local _DownloadUtility = DownloadUtility:New()
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local HallofFameGoldBannerItemView = HallCityBannerItem:New("HallofFameGoldBannerItemView", "TournamentTrueGoldBannerAtlas")
local this = HallofFameGoldBannerItemView

this.auto_bind_ui_items = {
    "left_time",
    "left_time_txt",
}

function HallofFameGoldBannerItemView:OnEnable()
    self:InitTime()
end

function HallofFameGoldBannerItemView:GetLeftTime()
    return ModelList.HallofFameModel:GetRemainTime()
end

function HallofFameGoldBannerItemView:FinishEndTime()
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

function HallofFameGoldBannerItemView:HitBannerFunc()
    if not _DownloadUtility:NewNode(14, ViewList.HallCityView.btn_winzone) then
        return
    else
        if not ModelList.WinZoneModel:IsVipLevelEnough() then
            --UIUtil.show_common_popup(8039, true)
            return
        elseif not ModelList.WinZoneModel:IsPlayerLevelEnough() then
            --UIUtil.show_common_popup(8038, true)
            return
        else
            ModelList.BattleModel.RequireModuleLua("WinZone")
            Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldStartView)
        end
    end
end

return this