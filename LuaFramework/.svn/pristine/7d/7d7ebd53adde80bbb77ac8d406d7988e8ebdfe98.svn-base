
local ShopVipAttributeItem = BaseView:New("ShopVipAttributeItem")
local this = ShopVipAttributeItem

this.auto_bind_ui_items = {
    "line1",
    "line2",
    "vipUse",
    "currentVipBg",
    "vipIcon",
    "textBoxRewardLevel",
    "textStoreGifts",
    "boxItem",
}


function ShopVipAttributeItem:New(vipLevel, vipData)
    local o = {}
    self.__index = self
    self.vipLevel = vipLevel
    self.vipData = vipData
    setmetatable(o,self)
    return o
end

function ShopVipAttributeItem:Awake()
    self:on_init()
end

function ShopVipAttributeItem:OnEnable()
    self:RefreshItem()
end

function ShopVipAttributeItem:RefreshItem()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self.vipIcon.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. self.vipLevel)
    fun.set_active(self.boxItem , true )
    fun.set_active(self.currentVipBg , currVipLv == self.vipLevel)
    self.textBoxRewardLevel.text = self.vipLevel
    self.textStoreGifts.text = string.format("%s%s%s","+", self.vipData.shop_added , "%")
end

function ShopVipAttributeItem:ShowCurrVipOrder()
    fun.SetAsLastSibling(self.go)
end

function ShopVipAttributeItem:OnDestroy()
    self:Close()
end


return ShopVipAttributeItem