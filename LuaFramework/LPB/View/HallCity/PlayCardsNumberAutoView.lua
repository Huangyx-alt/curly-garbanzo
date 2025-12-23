
require "View/HallCity/PlayCardsNumberView"
require "View/HallCity/DiscountUtility"

PlayCardsNumberAutoView = PlayCardsNumberView:New()
local this = PlayCardsNumberAutoView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_card",
    "btn_play",
    "text_cost",
    "text_cardNum",
    "img_cards",
    "Img_cost",
    "coupon",
    "ultra_icon",
    "cardBox"
}

function PlayCardsNumberAutoView:New(genre)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._genre = genre or 8
    return o
end

function PlayCardsNumberAutoView:CheckCoupon(isFall)
    if isFall then
        self._isFall = isFall
    end
    if self._isFall then
        if self._genre == CardGenre.fourcard then
            self:SetCoupon(CouponType.discount_4card)
        elseif self._genre == CardGenre.sixcard then
            self:SetCoupon(CouponType.discount_6card)
        elseif self._genre == CardGenre.eightcard then
            self:SetCoupon(CouponType.discount_8card)  
        end 
    end
end

function PlayCardsNumberAutoView:SetInfo(betRate)
    self._betRate = betRate
    if self._init and betRate then
        self:SetCostShowText()
    end
    fun.set_active(self.ultra_icon, ModelList.UltraBetModel:IsActivityValid())

    self:ShowActivityItem()
end

function PlayCardsNumberAutoView:GetSingleCardCost()
    local singleCardCost = ModelList.CityModel:GetCostCoin(4)
    return singleCardCost / 4
end


function PlayCardsNumberAutoView:OnPlayCardsClick()
    Facade.SendNotification(NotifyName.AutoHallView.PlayCardsClick,self._genre)
end

function PlayCardsNumberAutoView:DoCardClick()
    local cost = self._play_cost
    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable,8008,self._res_id,self._play_cost,function()
        ModelList.CityModel:SetCardNumber(self._genre)
        ModelList.BattleModel:SaveLastBuyCardCost(cost)
        Facade.SendNotification(NotifyName.HallCity.ShowPowerUpView,false)
    end,nil,nil,SHOP_TYPE.SHOP_TYPE_CHIPS,GetCurHallView())
end

function PlayCardsNumberAutoView:ReplaceBtnPlayEvent2()
    local img = fun.get_component(self.btn_play,fun.IMAGE)
    img.raycastTarget = false
end
function PlayCardsNumberAutoView:Set2CardRayCast()
    local img = fun.get_component(self.btn_play,fun.IMAGE)
    img.raycastTarget = false
end