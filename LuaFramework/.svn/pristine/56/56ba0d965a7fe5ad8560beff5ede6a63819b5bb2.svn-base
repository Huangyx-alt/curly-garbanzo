--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]
local base = require "GamePlayShortPass/Base/BasePassView"
local PassView = class("PassView",base)
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