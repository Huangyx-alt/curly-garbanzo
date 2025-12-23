
local ShopPurchaseConfirmItem = BaseView:New("ShopPurchaseConfirmItem")
local this = ShopPurchaseConfirmItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num"
}

function ShopPurchaseConfirmItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ShopPurchaseConfirmItem:Awake()
    self:on_init()
end

function ShopPurchaseConfirmItem:OnEnable()
    self._init = true
    if self.cacheData then
        self:SetReward(self.cacheData,self.isShop)
    end
end

function ShopPurchaseConfirmItem:OnDisable()
    self._init = nil
    self.cacheData = nil
end

function ShopPurchaseConfirmItem:GetRewardItemId()
    if self.cacheData then
        return self.cacheData.id
    end
    return nil
end

function ShopPurchaseConfirmItem:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function ShopPurchaseConfirmItem:SetReward(data)
    self.cacheData = data
    if self._init then
        self.icon_item.sprite = AtlasManager:GetSpriteByName("CommonAtlas",data.icon)
        self.text_num.text = tostring(data.num)
        self.icon_item:SetNativeSize()
    end
end

return this