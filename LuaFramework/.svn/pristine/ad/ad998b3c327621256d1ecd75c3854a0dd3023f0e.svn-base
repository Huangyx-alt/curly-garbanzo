local PopupDiamondPromotionPosterOrder = require "PopupOrder/PopupDiamondPromotionPosterOrder"
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local DiamondPromotionBannerItemView = HallCityBannerItem:New("DiamondPromotionBannerItemView")
local this = DiamondPromotionBannerItemView
local base = HallCityBannerItem

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
    "btn_banner",
    "txt_description",
}

function DiamondPromotionBannerItemView:OnEnable()
    base.OnEnable(self)
    Facade.RegisterViewEnhance(self)
    self:InitTime()
    fun.set_active(self.left_time, false)
    self.txt_description.text = Csv.GetDescription(30103)
end

function DiamondPromotionBannerItemView:OnDisable()
    base.OnDisable(self)
    Facade.RemoveViewEnhance(self)
end

function DiamondPromotionBannerItemView:GetLeftTime()
    local leftTime = 0
    if ModelList.GiftPackModel:IsPackAvailableByIcon("cEntdiamondsale") then
        local endTime = ModelList.GiftPackModel:GetPackExpireTimeByIcon("cEntdiamondsale")
        local currentTime = ModelList.PlayerInfoModel.get_cur_server_time()
        leftTime = endTime - currentTime
        log.log("DiamondPromotionBannerItemView:GetLeftTime() ", endTime, currentTime, leftTime)
    end
    return leftTime
end

function DiamondPromotionBannerItemView:HitBannerFunc()
    if ModelList.GiftPackModel:IsPackAvailableByIcon("cEntdiamondsale") or true then
        log.log("DiamondPromotionBannerItemView:HitBannerFunc()")
        Facade.SendNotification(NotifyName.ShowUI, ViewList.DiamondPromotionPosterView)
        --PopupDiamondPromotionPosterOrder.RecordPopTime()
    end
end

function DiamondPromotionBannerItemView:OnDiamondPromotionActivityEnd()
    log.log("DiamondPromotionBannerItemView:OnDiamondPromotionActivityEnd", self.bannerId)
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

this.NotifyEnhanceList = {
    {notifyName = NotifyName.DiamondPromotion.ActivityEnd, func = this.OnDiamondPromotionActivityEnd},
}

return this