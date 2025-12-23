
local ShopItemBaseView = BaseView:New("ShopItemBaseView")

ShopItemBaseView.auto_bind_ui_items = 
{
    "btn_buy",
}

function ShopItemBaseView:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ShopItemBaseView:Awake()
    self:on_init()
end

function ShopItemBaseView:OnEnable()
end

function ShopItemBaseView:RefreshItemData(data)
    self.shopItemData = data
    self:RefreshItem()
end

function ShopItemBaseView:RefreshItem()
end

function ShopItemBaseView:OnDisable()
end

function ShopItemBaseView:on_btn_buy_click()
    Event.Brocast(BingoBangEntry.mainShopViewEvent.ClickButtonPurchase ,self.shopItemData.id,self)
end

function ShopItemBaseView:GetViewPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end





return ShopItemBaseView