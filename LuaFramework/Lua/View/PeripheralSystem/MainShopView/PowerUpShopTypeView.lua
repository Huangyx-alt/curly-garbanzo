local shopTypeBaseView = require "View/PeripheralSystem/MainShopView/ShopTypeBaseView"
local PowerUpShopTypeView = shopTypeBaseView:New()
local this = PowerUpShopTypeView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "shopItemScrollView",
    "shopItem",
    "Content",
    "textItemNum1",
    "textItemNum2",
    "textItemNum3",
    "textItemNum4",
    "textItemNum5",
    "textItemNum6",
    "textItemNum7",
    "textItemNum8",
    "textItemNum9",
}

local itemView = require "View/PeripheralSystem/MainShopView/ShopItemView/PowerUpShopItemView"

--local PuIdToText =
--{
--    BingoBangEntry.PUItemType.PUFreeDaub 
--}

function PowerUpShopTypeView:Awake()
    self:on_init()
end

function PowerUpShopTypeView:RefreshView()
    local ownPUData = ModelList.MainShopModel.GetOwnPU()
    for i =1 , 9 do
        local text = self["textItemNum" .. i]
        local num = 0
        if i == 1 then
            num = ownPUData[BingoBangEntry.PUItemType.PUFreeDaub] or 0
        elseif i == 2 then
            num = ownPUData[BingoBangEntry.PUItemType.PUExtraNumber] or 0
        elseif i == 3 then
            num = ownPUData[BingoBangEntry.PUItemType.PUDoubleXp] or 0
        elseif i == 4 then
            num = ownPUData[BingoBangEntry.PUItemType.PUX2Daub] or 0
        elseif i == 5 then
            num = ownPUData[BingoBangEntry.PUItemType.PUChest] or 0
        elseif i == 6 then
            num = ownPUData[BingoBangEntry.PUItemType.PUDauber] or 0
        elseif i == 7 then
            num = ownPUData[BingoBangEntry.PUItemType.PULuckyBang] or 0
        elseif i == 8 then
            num = ownPUData[BingoBangEntry.PUItemType.PUInstantBINGO] or 0
        elseif i == 9 then
            num = ownPUData[BingoBangEntry.PUItemType.PUDoubleWIN] or 0
        end
        text.text = fun.format_bonus_number(num)
    end
end

function PowerUpShopTypeView:GetItemView()
    return itemView
end

function PowerUpShopTypeView:GetItemData()
    local data = ModelList.MainShopModel:GetShopTypeData(BingoBangEntry.mainShopToggleType.PowerUp)
    return data
end

this.NotifyList =
{

}

return this