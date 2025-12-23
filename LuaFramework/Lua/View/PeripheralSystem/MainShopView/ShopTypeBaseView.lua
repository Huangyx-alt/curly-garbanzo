
local ShopTypeBaseView = BaseView:New("ShopTypeBaseView")

ShopTypeBaseView.auto_bind_ui_items = {
    "shopItemScrollView",
    "shopItem",
    "Content",
}

function ShopTypeBaseView:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ShopTypeBaseView:Awake()
    self:on_init()
end

function ShopTypeBaseView:OnEnable()
    self:InitScrollView()
    self:RefreshView()
end

function ShopTypeBaseView:RefreshView()
end

function ShopTypeBaseView:InitScrollView()
    if self.shopItemList and GetTableLength(self.shopItemList) > 0 then
        self:RefreshScrollItem()
        return
    end
    local itemView = self:GetItemView()
    local data = self:GetItemData()
    local itemNum = GetTableLength(data)
    self.shopItemList = {}
    for i = 1 , itemNum do
        local item = fun.get_instance(self.shopItem,self.Content)
        local code = itemView:New(data[i])
        code:SkipLoadShow(item)
        self.shopItemList[i] = code
    end
end

function ShopTypeBaseView:OnDisable()
end

function ShopTypeBaseView:OnDestroy()
    for k , v in pairs(self.shopItemList) do
        v:Close()
    end
    self.shopItemList = {}
    log.log("清除已有的商店item数据")
end

function ShopTypeBaseView:RefreshScrollItem()
    local data = self:GetItemData()
    log.log("商店创建item数据xzxc a ",data )
    for k, v in pairs(self.shopItemList) do
        v:RefreshItemData(data[k])
    end
end

function ShopTypeBaseView:OnChangeShopType()
end

function ShopTypeBaseView:GetItemNum()
end

function ShopTypeBaseView:GetItemData()
end

function ShopTypeBaseView:ReOpen()
end

function ShopTypeBaseView:GetItemView()

end

function ShopTypeBaseView:GetView()
    if self.go then
        return self.go
    end
    return nil
end

function ShopTypeBaseView:GetTransform()
    if self.go then
        return self.go.transform
    end
end

function ShopTypeBaseView:SetShopTypeActivity(state)
    fun.set_active(self.go, state)
end

function ShopTypeBaseView:IsShopActivity()
    return self.go.activeInHierarchy
end


return ShopTypeBaseView