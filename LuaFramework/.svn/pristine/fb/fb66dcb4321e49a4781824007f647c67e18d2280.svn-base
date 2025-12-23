local ShopItemBaseView = require "View/PeripheralSystem/MainShopView/ShopItemView/ShopItemBaseView"
local PowerUpShopItemView = ShopItemBaseView:New()
local this = PowerUpShopItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "itemIcon",
    "textVipPoint",
    "btn_buy",
    "textItemNum4",
    "textItemNum3",
    "textItemNum2",
    "textItemNum1",
    "textCostMoney",
    "textCostItem",
    "item1",
    "item2",
    "item3",
    "item4",
 
}

local PUItemPos =
{
    [1] = {[1] = {x = 0 , y = 0 }},
    [2] = {[1] = {x = -83.7 , y = 0 } , [2] = {x= 87 , y = 0}},
    [3] = {[1] = {x = -83.7 , y = 36 } , [2] = {x= 87 , y = 36}, [3] = {x = -83.7, y = -29.4 }},
    [4] = {[1] = {x = -83.7 , y = 36 } , [2] = {x= 87 , y = 36}, [3] = {x = -83.7, y = -29.4 }, [4] = {x= 87,y=-29.4}},
    
}

function PowerUpShopItemView:New(shopItemData)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.shopItemData = shopItemData

    return o
end

function PowerUpShopItemView:Awake()
    self:on_init()
end

function PowerUpShopItemView:OnEnable()
    Facade.RegisterView(self)
    log.log("商店创建item数据 zxcc " , self.shopItemData)
    self:RefreshItem()
end

function PowerUpShopItemView:GetPUItemIdByIndex(index)
    local id = 0
    if index == 1 then
        id = BingoBangEntry.itemType.BluePU
    elseif index == 2 then
        id = BingoBangEntry.itemType.PurplePU
    elseif index == 3 then
        id = BingoBangEntry.itemType.RedPU
    elseif index == 4 then
        id = BingoBangEntry.itemType.ColorfulPU
    end
    return id
end

function PowerUpShopItemView:GetPUData(index)
    local itemId = self:GetPUItemIdByIndex(index)
    for  k , v in pairs(self.shopItemData.item) do
        if v[1] == itemId then
            return true
        end
    end
    return false
end

function PowerUpShopItemView:RefreshItem()
    local itemNum = 0
    local useItemList = {}
    for i = 1 , 4 do
        local item = self["item" .. i]
        local data = self:GetPUData(i)
        if data then
            itemNum = itemNum + 1
            useItemList[itemNum] = item
            fun.set_active(item , true)
        else
            fun.set_active(item , false)
        end
    end
    
    local itemPosData = PUItemPos[itemNum]
    for i =1 , itemNum do
        useItemList[i].transform.localPosition = itemPosData[i]
    end

    for k ,v in pairs(self.shopItemData.item) do
        if v[1] == BingoBangEntry.itemType.BluePU then
            self.textItemNum1.text = fun.format_money_reward({id = v[1], value = v[2]})
        elseif v[1] == BingoBangEntry.itemType.PurplePU then
            self.textItemNum2.text = fun.format_money_reward({id = v[1], value = v[2]})
        elseif v[1] == BingoBangEntry.itemType.RedPU then
            self.textItemNum3.text = fun.format_money_reward({id = v[1], value = v[2]})
        elseif v[1] == BingoBangEntry.itemType.ColorfulPU then
            self.textItemNum4.text = fun.format_money_reward({id = v[1], value = v[2]})
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
    self.itemIcon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", self.shopItemData.item_icon)
end


function PowerUpShopItemView:OnDisable()
end

function PowerUpShopItemView:RefreshItemData(data)
end

function PowerUpShopItemView:on_btn_buy_click()
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