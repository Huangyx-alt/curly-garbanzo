--名人堂 普通banner
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local DownloadUtility = require "View/CommonView/DownloadUtility"
local _DownloadUtility = DownloadUtility:New()
local HallofFameBannerItemView = HallCityBannerItem:New("HallofFameBannerItemView", "TournamentTrueGoldBannerAtlas")
local this = HallofFameBannerItemView

this.auto_bind_ui_items = {
    "left_time",
    "left_time_txt",
}

function HallofFameBannerItemView:OnEnable()
    self:InitTime()
end

function HallofFameBannerItemView:GetLeftTime()
    return ModelList.HallofFameModel:GetRemainTime()
end

function HallofFameBannerItemView:FinishEndTime()
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

function HallofFameBannerItemView:HitBannerFunc()
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
            local view = require("View/WinZone/WinZoneHelperView")
            Facade.SendNotification(NotifyName.ShowUI, view:New())
        end
    end
end

return this