
local VipAttrItem = BaseView:New("VipAttrItem")
local this = VipAttrItem

this.auto_bind_ui_items = {
    "attrIconOnly",
    "newTip",
    "textTitle",
    "attrGroup",
    "attrIcon",
    "textAttrValue",
}

local attrData =
{
    ["VIPROOM"]  = {iconName = "VipTIPtb01" , title = "VIP ROOM"},
    ["TOURNAMENT"]  = {iconName = "VipTIPtb04" , title = "TOURNAMENT"},
    --
    ["VIPROOMx"]  = {iconName = "VipTIPtb04" , title = "TOURNAMENT"},
    ["TOURNAMENTx"]  = {iconName = "VipTIPtb04" , title = "TOURNAMENT"},
    ["VIPROOMy"]  = {iconName = "VipTIPtb04" , title = "TOURNAMENT"},
    ["TOURNAMENTu"]  = {iconName = "VipTIPtb04" , title = "TOURNAMENT"},
}


function VipAttrItem:New(vipAttrData)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.vipAttrData = vipAttrData
    return o
end

function VipAttrItem:Awake()
    self:on_init()
end

function VipAttrItem:OnEnable()
    self:InitItem()
end

function VipAttrItem:OnDestroy()
    self:Close()
end

function VipAttrItem:InitItem()
    self.textTitle.text = attrData[self.vipAttrData.attrType].title
    if self.vipAttrData.attrType == "VIPROOM" then
        self:InitOnlyIconGrid()
    elseif self.vipAttrData.attrType == "TOURNAMENT" then
        self:InitAttrGrid()
    end
end

function VipAttrItem:HideItem()
    self.go.transform.position = Vector3.New(100000,100000,0)
end

function VipAttrItem:ShowItem(pos)
    self.go.transform.localPosition = pos
end

function VipAttrItem:RefreshItemData(data)
    self.vipAttrData = data
    self:InitItem()
end

function VipAttrItem:InitOnlyIconGrid()
    fun.set_active(self.attrIconOnly, true)
    fun.set_active(self.attrGroup, false)
    self.attrIconOnly.sprite = AtlasManager:GetSpriteByName("VipAttributeBonusAtlas", attrData[self.vipAttrData.attrType].iconName)
    
end

function VipAttrItem:InitAttrGrid()
    fun.set_active(self.attrIconOnly, false)
    fun.set_active(self.attrGroup, true)
    self.attrIcon.sprite = AtlasManager:GetSpriteByName("VipAttributeBonusAtlas", attrData[self.vipAttrData.attrType].iconName)
    self.textAttrValue.text = string.format("%s%s%s" , "+" ,self.vipAttrData.value * 100 , "%")
end


return VipAttrItem