local ShopItemBaseView = require "View/PeripheralSystem/MainShopView/ShopItemView/ShopItemBaseView"
local ChipsShopItemView = ShopItemBaseView:New()
local this = ChipsShopItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "textResourceNum",
    "itemIcon",
    "textVipPoint",
    "btn_buy",
    "textCost",
 
}

function ChipsShopItemView:New(shopItemData)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.shopItemData = shopItemData
    return o
end

function ChipsShopItemView:Awake()
    self:on_init()
end

function ChipsShopItemView:OnEnable()
    Facade.RegisterView(self)
    self:RefreshItem()
end

function ChipsShopItemView:OnDisable()
end

function ChipsShopItemView:RefreshItem()
    for k ,v in pairs(self.shopItemData.item) do
        if v[1] == BingoBangEntry.itemType.Coin then
            local value = fun.ResetShopRewardValue(v[2])
            local showNum = math.ceil(value / 5) * 5
            self.textResourceNum.text = fun.format_money_reward({id = v[1], value = showNum})
        elseif v[1] == BingoBangEntry.itemType.VipPoints then
            self.textVipPoint.text = string.format("%s%s%s", "+" , v[2] , " VIP POINTS")
        end
    end
    self.itemIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", self.shopItemData.item_icon)
    self.textCost.text = "$" .. self.shopItemData.price
end


this.NotifyList =
{

}

return this