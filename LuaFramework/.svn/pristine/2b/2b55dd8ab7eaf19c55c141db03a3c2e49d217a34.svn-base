local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local BravoGuideHelpBannerItemView = HallCityBannerItem:New("BravoGuideHelpBannerItemView")
local this = BravoGuideHelpBannerItemView
local base = HallCityBannerItem

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
    "btn_banner",
    "txt_description",
}

function BravoGuideHelpBannerItemView:OnEnable()
    base.OnEnable(self)
    Facade.RegisterViewEnhance(self)
  
end

function BravoGuideHelpBannerItemView:OnDisable()
    base.OnDisable(self)
    Facade.RemoveViewEnhance(self)
end

function BravoGuideHelpBannerItemView:GetLeftTime()
 
    return nil
end

function BravoGuideHelpBannerItemView:HitBannerFunc() 
    Facade.SendNotification(NotifyName.ShowUI,ViewList.BravoHelpGuideView)
end

function BravoGuideHelpBannerItemView:OnDiamondPromotionActivityEnd(data)
    log.log("BravoGuideHelpBannerItemView:BravoGuideHelpBannerItemView", self.bannerId)
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
    if ViewList.BravoHelpGuideView == nil or  ViewList.BravoHelpGuideView.go == nil then 
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,data,function()
            
            Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide, ClaimRewardViewType.CollectReward)
        end)
    end 
end

this.NotifyEnhanceList = {
  --  {notifyName = NotifyName.BravoGuideHelp.DeepLinkHit, func = this.OnDiamondPromotionActivityEnd},
}

return this