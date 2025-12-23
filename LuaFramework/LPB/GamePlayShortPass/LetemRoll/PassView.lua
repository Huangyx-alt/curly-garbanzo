local base = require "GamePlayShortPass/Base/BasePassView"
local PassView = class("PassView", base)
local this = PassView
this.viewName = "PassView"

function PassView:on_btn_activate_click() 
   log.log("PassView:on_btn_activate_click")
   Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassPurchaseView")
end

function PassView:OnPurchasingPassSuccess()
    self:InitGoldPassInfo()
end

this.NotifyEnhanceList = 
{
    {notifyName = NotifyName.GamePlayShortPassView.UpdataBingoPassInfo,func = this.OnUpdataBingoPassInfo},
    {notifyName = NotifyName.GamePlayShortPassView.WatchAd,func = this.OnBingoPassWatchAd},
    {notifyName = NotifyName.GamePlayShortPassView.GemUnlockLevel,func = this.OnGemUnlockLevel},
    {notifyName = NotifyName.GamePlayShortPassView.ClaimReward,func = this.OnClaimReward},
    {notifyName = NotifyName.GamePlayShortPassView.ReceiveReward,func = this.OnReceiveReward},
    {notifyName = NotifyName.GamePlayShortPassView.Expired,func = this.OnExpired},
    {notifyName = NotifyName.GamePlayShortPassView.PurchasingPassSuccess,func = this.OnPurchasingPassSuccess},
}

return this 