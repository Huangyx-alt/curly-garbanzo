local ShopVipAttributeView = BaseView:New("ShopVipAttributeView","ShopVipAttributeAtlas")

local this = ShopVipAttributeView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "imgCurrentVip",
    "vipExpSlider",
    "imgNextVip",
    "textNextVipExp",
    "textVipExp",
    "scroll",
    "Content",
    "vipAttrItem",
    
}
--
local ShopVipAttributeItem = require("View/PeripheralSystem/ShopVipAttributeView/ShopVipAttributeItem")

local itemStartPosX = -23
local itemOffsetX = 250

function ShopVipAttributeView:Awake()
    self:on_init()
end

function ShopVipAttributeView:OnEnable()
    Facade.RegisterView(self)
    self:InitVipInfo()
    self:InitAttributeScroll()
end

function ShopVipAttributeView:InitVipInfo()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self:LockCurrentVipItem(currVipLv)
    self.imgCurrentVip.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv)
    self.imgNextVip.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv + 1)
    local vipPts = ModelList.PlayerInfoModel:GetVipPts()
    local vipInfo = Csv.GetData("new_vip", currVipLv)
    self.textVipExp.text = string.format("%s%s%s",vipPts, "/" , vipInfo.exp)
    self.vipExpSlider.value = vipPts/vipInfo.exp
    self.textNextVipExp.text = string.format("%s%s%s",vipInfo.exp - vipPts , " more points to reach VIP" , currVipLv + 1)
end

function ShopVipAttributeView:InitAttributeScroll()
    self.vipAttributeList = {}
    local totalIndex = 0
    for k ,v in pairs(Csv.new_vip) do
        totalIndex = totalIndex + 1
        local go = fun.get_instance(self.vipAttrItem)
        fun.set_parent(go,self.Content)
        go.transform.localScale = Vector3.New(1,1,1)
        local code = ShopVipAttributeItem:New(k,v)
        code:SkipLoadShow(go,true,nil,true)
        go.transform.localPosition = Vector3.New(itemStartPosX + (k+1) * itemOffsetX,0,0)
        self.vipAttributeList[k] = code
    end

    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self.vipAttributeList[currVipLv]:ShowCurrVipOrder()
    local width = itemStartPosX + (totalIndex + 1 ) * itemOffsetX + 5
    fun.set_recttransform_native_size(self.Content ,  width ,893 )
end

function ShopVipAttributeView:OnDisable()
    Facade.RemoveView(self)
    for k ,v in pairs(self.vipAttributeList) do
        v:Close()
    end
    self.vipAttributeList = {}
end

function ShopVipAttributeView:OnDestroy()
   
end

function ShopVipAttributeView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ShopVipAttributeView:on_btn_vip_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ShopVipAttributeView:GetItemPos(itemIndex)
    return itemStartPosX + (itemIndex - 1) * itemOffsetX
end

function ShopVipAttributeView:LockCurrentVipItem(currVipLv)
    local localPos = self.Content.transform.localPosition
    if currVipLv == 0 then
        self.Content.transform.localPosition = Vector3.New(0,localPos.y,0)
    else
        local pos = -(itemOffsetX * (currVipLv + 1) + itemStartPosX)  -- 边界多像素 todo
        self.Content.transform.localPosition = Vector3.New(pos,localPos.y,0)        
    end
end


this.NotifyList = {
}

return this

