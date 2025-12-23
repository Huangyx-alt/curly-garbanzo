require "State/Common/CommonState"

local VipAttributeBonusView = BaseView:New("VipAttributeBonusView","VipAttributeBonusAtlas")

local this = VipAttributeBonusView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "imgCurrentVip",
    "vipExpSlider",
    "imgNextVip",
    "textNextVipExp",
    "textVipExp",
    "btn_attr_left",
    "btn_attr_right",
    "textCurrentVip",
    "vipAttrItem",
    "itemParent"

}

local gridYDistance = -240
local gridXDistance = 422
local maxGridNum = 6

local vipAttrData =
{
    [0] = {[1] = {attrType = "VIPROOM"}},
    [1] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.1}},
    [2] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.2}},
    [3] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.3}},
    [4] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.4}},
    [5] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.5}},
    [6] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.6}},
    [7] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.7}},
    [8] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.8}},
    [9] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 0.9}},
    [10] = {[1] = {attrType = "VIPROOM"},[2] = {attrType = "TOURNAMENT"  , value = 1}},
}

local vipAttrItemCode = require "View/PeripheralSystem/VipAttributeBonusView/VipAttrItem"

function VipAttributeBonusView:Awake()
    self:on_init()
end

function VipAttributeBonusView:OnEnable()
    Facade.RegisterView(self)
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self:CurrentVipLevel(currVipLv)
    self.imgCurrentVip.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv)
    self.imgNextVip.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv + 1)
    self.showLevel = currVipLv
    self:InitItemGrid()
    self:InitVipProgress()
end

function VipAttributeBonusView:InitVipProgress()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    local vipPts = ModelList.PlayerInfoModel:GetVipPts()
    local vipInfo = Csv.GetData("new_vip", currVipLv)
    self.textVipExp.text = string.format("%s%s%s",vipPts, "/" , vipInfo.exp)
    self.vipExpSlider.value = vipPts/vipInfo.exp
    self.textNextVipExp.text = string.format("%s%s%s",vipInfo.exp - vipPts , " more points to reach VIP" , currVipLv + 1)
end

function VipAttributeBonusView:InitItemGrid()
    self.vipAttrItemList = {}
    local curVipLevelData = vipAttrData[self.showLevel]
    for i =1 , GetTableLength(curVipLevelData) do
        local itemView , grid = self:GetCreatItem(curVipLevelData[i])
        local pos = self:GetGridPos(i - 1)
        grid.transform.localPosition = pos
        self.vipAttrItemList[i] = itemView
    end
end

function VipAttributeBonusView:GetGridPos(index)
    local t1 , t2 = math.modf(index / 2)
    local verticalIndex = math.ceil(t1)
    if t2 == 0 then
        return Vector3.New(0,verticalIndex * gridYDistance,0)
    else
        return Vector3.New(gridXDistance,verticalIndex * gridYDistance,0)
    end
end

function VipAttributeBonusView:CurrentVipLevel(vipLevel)
    self.textCurrentVip.text = "VIP" .. vipLevel
end

function VipAttributeBonusView:RefreshVipLevel(vipLevel)
    if vipLevel > 10 or vipLevel < 0 then
        log.log("超过vip数量")
        return
    end
    self.showLevel = vipLevel
    self:CurrentVipLevel(vipLevel)
    --self.textCurrentVip.text = "VIP" .. self.showLevel
    local curVipLevelData = vipAttrData[vipLevel]
    local dataNum = GetTableLength(curVipLevelData)
    local ownGridNum = GetTableLength(self.vipAttrItemList)
    log.log("对比格子数量 " , dataNum  , "   " , ownGridNum)
    if dataNum > ownGridNum then
        --创建新格子
        for i = 1 , dataNum do
            local pos = self:GetGridPos(i - 1)
            if i > ownGridNum then
                local itemView = self:GetCreatItem(curVipLevelData[i])
                self.vipAttrItemList[i] = itemView
            else
                self.vipAttrItemList[i]:RefreshItemData(curVipLevelData[i])
            end
            self.vipAttrItemList[i]:ShowItem(pos)
        end
    elseif dataNum < ownGridNum then
        --隐藏部分格子
        for i = ownGridNum  , dataNum + 1 , -1  do
            self.vipAttrItemList[i]:HideItem()
        end
    else
        for i = 1 , ownGridNum do
            local pos = self:GetGridPos(i - 1)
            self.vipAttrItemList[i]:RefreshItemData(curVipLevelData[i])
            self.vipAttrItemList[i]:ShowItem(pos)
        end
    end
    self:RefreshButtonEnable()
end

function VipAttributeBonusView:RefreshButtonEnable()
    if self.showLevel == 0 then
        fun.enable_button(self.btn_attr_left,false)
        fun.enable_button(self.btn_attr_right , true)
    elseif self.showLevel == 10 then
        fun.enable_button(self.btn_attr_left,true)
        fun.enable_button(self.btn_attr_right , false)
    else
        fun.enable_button(self.btn_attr_left,true)
        fun.enable_button(self.btn_attr_right , true)
    end
end

function VipAttributeBonusView:GetCreatItem(itemData)
    local view = vipAttrItemCode:New(itemData)
    local grid = fun.get_instance(self.vipAttrItem, self.itemParent)
    view:SkipLoadShow(grid)
    return view,grid
end

function VipAttributeBonusView:OnDisable()
    Facade.RemoveView(self)
end

function VipAttributeBonusView:on_close()
end

function VipAttributeBonusView:OnDestroy()
    for k ,v in pairs(self.vipAttrItemList) do
        v:Close()
    end
    self.vipAttrItemList = {}
end

function VipAttributeBonusView:on_btn_attr_left_click()
    self:RefreshVipLevel(self.showLevel - 1)
end

function VipAttributeBonusView:on_btn_attr_right_click()
    self:RefreshVipLevel(self.showLevel + 1)
end

function VipAttributeBonusView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

return this

