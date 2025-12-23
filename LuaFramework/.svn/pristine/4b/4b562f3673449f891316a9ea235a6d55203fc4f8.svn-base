local shopTypeBaseView = require "View/PeripheralSystem/MainShopView/ShopTypeBaseView"
local GemsShopTypeView = shopTypeBaseView:New()
local this = GemsShopTypeView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "shopItemScrollView",
    "shopItem",
    "Content",
}

local itemView = require "View/PeripheralSystem/MainShopView/ShopItemView/GemsShopItemView"

function GemsShopTypeView:Awake()
    self:on_init()
end

function GemsShopTypeView:OnDisable()
end

function GemsShopTypeView:GetItemView()
    return itemView
end

function GemsShopTypeView:GetItemData()
    local data = ModelList.MainShopModel:GetShopTypeData(BingoBangEntry.mainShopToggleType.Gems)
    return data
end

function GemsShopTypeView:GetItemNum()
end

function GemsShopTypeView:GetItemPrefab()
end

this.NotifyList =
{

}

return this