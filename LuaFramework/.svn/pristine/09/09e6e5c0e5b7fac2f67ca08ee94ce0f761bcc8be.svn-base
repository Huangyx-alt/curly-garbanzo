local shopTypeBaseView = require "View/PeripheralSystem/MainShopView/ShopTypeBaseView"
local ItemShopTypeView = shopTypeBaseView:New()
local this = ItemShopTypeView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "shopItemScrollView",
    "shopItem",
    "Content",
}

local itemView = require "View/PeripheralSystem/MainShopView/ShopItemView/ItemShopItemView"



function ItemShopTypeView:Awake()
    self:on_init()
end

function ItemShopTypeView:OnDisable()
end

function ItemShopTypeView:GetItemView()
    return itemView
end

function ItemShopTypeView:GetItemData()
    local data = ModelList.MainShopModel:GetShopTypeData(BingoBangEntry.mainShopToggleType.Items)
    return data
end

function ItemShopTypeView:GetItemNum()
end

function ItemShopTypeView:GetItemPrefab()
end

function ItemShopTypeView:on_btn_daily_gift_click()
end

this.NotifyList =
{

}

return this