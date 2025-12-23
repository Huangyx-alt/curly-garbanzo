local ShopItemBaseView = require "View/PeripheralSystem/MainShopView/ShopItemView/ShopItemBaseView"
local ItemShopItemView = ShopItemBaseView:New()
local this = ItemShopItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "textResourceNum",
    "itemIcon",
    "textVipPoint",
    "btn_buy",
    "textTimeTitle",
    "textCostMoney",
    "textCostItem",
}

function ItemShopItemView:New(shopItemData)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.shopItemData = shopItemData
    log.log("商店创建item数据 b " , shopItemData)
    return o
end

function ItemShopItemView:Awake()
    self:on_init()
end

function ItemShopItemView:OnEnable()
    Facade.RegisterView(self)
    self:RefreshItem()
end


function ItemShopItemView:RefreshItem()
    for k ,v in pairs(self.shopItemData.item) do
        if v[1] == BingoBangEntry.itemType.MagnifyingGlass then
            local value , time = fun.FormatTextToTimeReplace(v[2])
            self.textResourceNum.text = value
            self.textTimeTitle.text = time
        elseif v[1] == BingoBangEntry.itemType.VipPoints then
            self.textVipPoint.text = string.format("%s%s%s", "+" , v[2] , " VIP POINTS")
        end
    end

    if self.shopItemData.pay_type == BingoBangEntry.ShopPayType.Money then
        --money
        fun.set_active(self.textCostMoney , true)
        fun.set_active(self.textCostItem , false)
        self.textCostMoney.text = "$" .. self.shopItemData.price
        fun.set_active(self.textVipPoint,true)
    elseif self.shopItemData.pay_type == BingoBangEntry.ShopPayType.Diamond then
        --钻石
        fun.set_active(self.textCostMoney , false)
        fun.set_active(self.textCostItem , true)
        self.textCostItem.text = self.shopItemData.price
        fun.set_active(self.textVipPoint,false)
    end
    self.itemIcon.sprite =  AtlasManager:GetSpriteByName("ItemAtlas", self.shopItemData.item_icon)
end

function ItemShopItemView:OnDisable()
end

function ItemShopItemView:RefreshItemData(data)
end

function ItemShopItemView:on_btn_buy_click()
    if self.shopItemData.pay_type == BingoBangEntry.ShopPayType.Diamond then
        --花费钻石
        Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable, 8018, RESOURCE_TYPE.RESOURCE_TYPE_DIAMOND, self.shopItemData.price, function()
            Event.Brocast(BingoBangEntry.mainShopViewEvent.ClickButtonPurchase ,self.shopItemData.id,self)
        end, nil, nil, SHOP_TYPE.SHOP_TYPE_DIAMONDS)
    else
        Event.Brocast(BingoBangEntry.mainShopViewEvent.ClickButtonPurchase ,self.shopItemData.id,self)
    end
end

this.NotifyList =
{

}

return this