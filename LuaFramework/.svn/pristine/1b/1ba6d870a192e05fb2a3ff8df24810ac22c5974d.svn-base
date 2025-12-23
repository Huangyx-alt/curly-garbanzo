local ShopItemBaseView = require "View/PeripheralSystem/MainShopView/ShopItemView/ShopItemBaseView"
local GemsShopItemView = ShopItemBaseView:New()
local this = GemsShopItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "textResourceNum",
    "itemIcon",
    "textVipPoint",
    "btn_buy",
    "textCost",

}

function GemsShopItemView:New(shopItemData)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.shopItemData = shopItemData
    log.log("商店创建item数据 b " , shopItemData)
    return o
end

function GemsShopItemView:Awake()
    self:on_init()
end

function GemsShopItemView:OnEnable()
    Facade.RegisterView(self)
    log.log("商店创建item数据 cx " , self.shopItemData)
    self:RefreshItem()
end

function GemsShopItemView:RefreshItem()
    for k ,v in pairs(self.shopItemData.item) do
        if v[1] == BingoBangEntry.itemType.Diamond then
            self.textResourceNum.text = fun.format_money_reward({id = v[1], value = v[2]})
        elseif v[1] == BingoBangEntry.itemType.VipPoints then
            self.textVipPoint.text = string.format("%s%s%s", "+" , v[2] , " VIP POINTS")
        end
    end
    self.itemIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", self.shopItemData.item_icon)
    self.textCost.text = "$" .. self.shopItemData.price
end

function GemsShopItemView:OnDisable()
end


this.NotifyList =
{

}

return this