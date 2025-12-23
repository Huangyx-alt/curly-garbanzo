local SeasonCardUniversalMenuView = BaseView:New("SeasonCardUniversalMenuView")
local this = SeasonCardUniversalMenuView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_buy",
    "btn_exchange",
    "btn_clown",
    "textBuy",
    "textExchange",
    "textClown",
    "iconBuy",
    "iconExchange",
    "iconClown",
    "redDot1",
    "textCount1",
    "redDot2",
    "textCount2",
    "iconAlbums",
    "btn_albums",
    "btn_test1",
}

function SeasonCardUniversalMenuView:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardUniversalMenuView:Awake()
end

function SeasonCardUniversalMenuView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.isWaitingShopViewClose = false
end

function SeasonCardUniversalMenuView:on_after_bind_ref()
    fun.set_active(self.btn_test1, false)
    self:InitView()
end

function SeasonCardUniversalMenuView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:RemoveClownCardTimer()
    self:RemoveUpdateTimer()
end

function SeasonCardUniversalMenuView:SetData(data)
    self.data = data
    log.log("SeasonCardUniversalMenuView:SetData", data)
end

function SeasonCardUniversalMenuView:SetParent(parent)
    self.parent = parent
end

function SeasonCardUniversalMenuView:InitView()
end

function SeasonCardUniversalMenuView:UpdateState()
    self:UpdateBuyBtnState()
    self:UpdateClownBtnState()
    self:UpdateExchangeBtnState()
    self:UpdateAlbumsBtnState()
    self:UpdateExchangeRedDot()
    self:UpdateClownCardRedDot()
    self:StartUpdateTimer()
end

function SeasonCardUniversalMenuView:UpdateClownBtnState()
    local showingSeasonId = ModelList.SeasonCardModel:GetShowingSeasonId()
    local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    if showingSeasonId == curSeasonId and ModelList.SeasonCardModel:IsHasClownCard() then
        fun.set_active(self.iconClown, true)
        self:SetClownCardLeftTime()
    else
        fun.set_active(self.iconClown, false)
        self:RemoveClownCardTimer()
    end
end

function SeasonCardUniversalMenuView:UpdateAlbumsBtnState()
    if self.parent.viewName == "SeasonCardGroupView" then
        local albums = ModelList.SeasonCardModel:GetAlbums()
        fun.set_active(self.iconAlbums, albums and #albums > 1)
    else
        fun.set_active(self.iconAlbums, false)
    end
end

function SeasonCardUniversalMenuView:UpdateBuyBtnState()
    fun.set_active(self.iconBuy, true)
end

function SeasonCardUniversalMenuView:UpdateExchangeBtnState()
    fun.set_active(self.iconExchange, true)
    -- local showingSeasonId = ModelList.SeasonCardModel:GetShowingSeasonId()
    -- local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    -- fun.set_active(self.iconExchange, showingSeasonId == curSeasonId)
    -- local isGray = not(showingSeasonId == curSeasonId)
    -- Util.SetUIImageGray(self.iconExchange.gameObject, isGray)
    -- Util.SetUIImageGray(self.btn_exchange.gameObject, isGray)
    -- Util.SetUIImageGray(self.redDot1.gameObject, isGray)
    -- Util.SetUIImageGray(self.redDot1.gameObject, isGray)
end

function SeasonCardUniversalMenuView:on_btn_buy_click()
    log.log("SeasonCardUniversalMenuView:on_btn_buy_click")
    local cb = function()
        self.parent:SetVisible(false)
    end

    self.isWaitingShopViewClose = true
    Facade.SendNotification(NotifyName.ShopView.PopupShop, PopupViewType.show, nil, SHOP_TYPE.SHOP_TYPE_OFFERS, cb)
end

function SeasonCardUniversalMenuView:on_btn_exchange_click()
    log.log("SeasonCardUniversalMenuView:on_btn_exchange_click")
    local showingSeasonId = ModelList.SeasonCardModel:GetShowingSeasonId()
    local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    if showingSeasonId == curSeasonId then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardExchangeView)
    else
        self:PopupTipDialog(30117)
    end
end

function SeasonCardUniversalMenuView:on_btn_albums_click()
    log.log("SeasonCardUniversalMenuView:on_btn_albums_click")
    -- ModelList.SeasonCardModel:C2S_SeasonSwithCheck()

    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardAlbumView)
    --self:TestLoadSprite()
end

function SeasonCardUniversalMenuView:on_btn_clown_click()
    log.log("SeasonCardUniversalMenuView:on_btn_clown_click")
    local data = {}
    data.seasonId = ModelList.SeasonCardModel:GetShowingSeasonId()
    ViewList.SeasonCardClownCardExchangeView:SetData(data)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardClownCardExchangeView)
end

function SeasonCardUniversalMenuView:on_btn_test1_click()
    log.log("SeasonCardUniversalMenuView:on_btn_test1_click")
end

function SeasonCardUniversalMenuView:SetClownCardLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetSoonestClownCardExpire()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.clownCardEndTime = expireTime - currentTime
    self:RemoveClownCardTimer()
    if self.clownCardEndTime > 0 then
        self.clownCardLoopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.clownCardEndTime >= 0 and self.textClown then
                self.textClown.text = fun.SecondToStrFormat(self.clownCardEndTime)
                self.clownCardEndTime = self.clownCardEndTime - 1
                if self.clownCardEndTime <= 0 then
                    self:UpdateClownBtnState()
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function SeasonCardUniversalMenuView:RemoveClownCardTimer()
    if self.clownCardLoopTime then
        LuaTimer:Remove(self.clownCardLoopTime)
        self.clownCardLoopTime = nil
    end
end

function SeasonCardUniversalMenuView:StartUpdateTimer()
    local deltaTime = 1
    self:RemoveUpdateTimer()
    self.updatedLoopTime = LuaTimer:SetDelayLoopFunction(0, deltaTime, -1, function()
        self:UpdateExchangeRedDot()
        self:UpdateClownCardRedDot()
    end)
end

function SeasonCardUniversalMenuView:RemoveUpdateTimer()
    if self.updatedLoopTime then
        LuaTimer:Remove(self.updatedLoopTime)
        self.updatedLoopTime = nil
    end
end

function SeasonCardUniversalMenuView:OnShopViewClose()
    log.log("SeasonCardUniversalMenuView:OnShopViewClose")
    if self.isWaitingShopViewClose then
        self.parent:SetVisible(true)
    end

    self.isWaitingShopViewClose = false
end

function SeasonCardUniversalMenuView:OnClownCardCountChange()
    log.log("SeasonCardUniversalMenuView:OnClownCardCountChange")
    self:UpdateClownBtnState()
    self:UpdateClownCardRedDot()
end

function SeasonCardUniversalMenuView:UpdateExchangeRedDot()
    local showingSeasonId = ModelList.SeasonCardModel:GetShowingSeasonId()
    local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    if showingSeasonId == curSeasonId then
        local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
        local starCount = ModelList.SeasonCardModel:GetStarCount() or 0
        local count = 0
        local boxInfoList = ModelList.SeasonCardModel:GetAllBoxInfo()
        for i, v in ipairs(boxInfoList) do
            local expireTime = v.flexibleData.cd
            local leftTime = expireTime - currentTime
            if leftTime > 0 then
            else
                local starCost = v.flexibleData.starNum
                if starCount >= starCost then
                    count = count + 1
                end
            end
        end

        fun.set_active(self.redDot1, count > 0)
        self.textCount1.text = count
    else
        fun.set_active(self.redDot1, false)
    end
end

function SeasonCardUniversalMenuView:UpdateClownCardRedDot()
    if ModelList.SeasonCardModel:IsHasClownCard() then
        local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
        local count = 0
        local clownCardList = ModelList.SeasonCardModel:GetAllClownCard()
        for i, v in ipairs(clownCardList) do
            local leftTime = v - currentTime
            if leftTime > 0 then
                count = count + 1
            end
        end

        fun.set_active(self.redDot2, count > 1)
        if count < 100 then
            self.textCount2.text = count
        else
            self.textCount2.text = "99"
        end
    end
end

function SeasonCardUniversalMenuView:PopupTipDialog(contentId, callback)
    local sureCallBack = function()
        if callback then
            callback()
        end
    end
    UIUtil.show_common_popup(contentId, true, sureCallBack)
end

function SeasonCardUniversalMenuView:OnCardAdd(params)
    self:UpdateExchangeRedDot()
end

function SeasonCardUniversalMenuView:OnExchangeCdChange(params)
    self:UpdateExchangeRedDot()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.ShopView.OnCloseViewFinish, func = this.OnShopViewClose},
    {notifyName = NotifyName.SeasonCard.ClownCardCountChange, func = this.OnClownCardCountChange},
    {notifyName = NotifyName.SeasonCard.CardAdd, func = this.OnCardAdd},
    {notifyName = NotifyName.SeasonCard.ExchangeCdChange, func = this.OnExchangeCdChange}, 
}

return this