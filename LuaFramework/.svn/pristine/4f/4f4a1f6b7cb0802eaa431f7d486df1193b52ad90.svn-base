local SeasonPowerUpChargeTipView = BaseView:New('SeasonPowerUpChargeTipView')
local this = SeasonPowerUpChargeTipView
this.ViewName = "SeasonPowerUpChargeTipView"

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "anima",
    "btn_close",
    "btn_buy",
    "Text1",
    "TextBtn",
    "PUsmCardsDi",
    "PUsmBuyIcon",
}

function SeasonPowerUpChargeTipView:Awake()
    self:on_init()
end

function SeasonPowerUpChargeTipView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function SeasonPowerUpChargeTipView:on_after_bind_ref()
    self.Text1.text = Csv.GetDescription(8074)
    self.TextBtn.text = "BUY NOW!"
    self:UpdatePuBuffCardIcon()
end

function SeasonPowerUpChargeTipView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonPowerUpChargeTipView:CloseView(callBack)
    --AnimatorPlayHelper.Play(self.anima, { "end", "SeasonPowerUpChargeTipViewend" }, false, function()
    if callBack then
        callBack()
    end
    Facade.SendNotification(NotifyName.CloseUI, self)
    --end)
end

function SeasonPowerUpChargeTipView:on_btn_close_click()
    self:CloseView()
end

function SeasonPowerUpChargeTipView:on_btn_buy_click()
    self:CloseView(function()
        log.log("SeasonPowerUpChargeTipView:on_btn_buy_click() ShowPUPack")
        ModelList.GiftPackModel:ShowPUPack()
    end)
end

function SeasonPowerUpChargeTipView:UpdatePuBuffCardIcon()
    local cardId = ModelList.CityModel:GetPuBuffCardId()
    local powerCard = Csv.GetData("new_powerup", cardId)
    log.log("PowerUpView:UpdatePuBuffCardIcon cardId ", cardId)
    if powerCard and fun.is_not_null(self.PUsmBuyIcon)then
        self.PUsmBuyIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", powerCard.icon)
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
}

return this