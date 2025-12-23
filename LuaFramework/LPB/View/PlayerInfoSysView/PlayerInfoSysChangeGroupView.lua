local PlayerInfoSysChangeGroupView = BaseView:New()
local this = PlayerInfoSysChangeGroupView
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items ={
    "mianObj",
    "content",
    "prefab",
}

function PlayerInfoSysChangeGroupView:New(data)
    local o = {}
    self.__index = self
    self.itemViewList = nil
    self.data = data
    setmetatable(o,self)
    return o
end

function PlayerInfoSysChangeGroupView:OnEnable()
    self.initUI = false
    self.hasInitGroup = false
    if self.itemViewList then
        self:RefreshItem()
    else
        self:InitGroup()
    end
end

function PlayerInfoSysChangeGroupView:ClickItemChoose(index)
    if self:CheckIsSameClick(index) then
        log.log("是相同的点击 不处理")
        return
    end

    self.lastChooseIndex = self.currentChooseIndex
    self.currentChooseIndex = index
    self:ReplaceChoose()
    self:SendChooseEvent(index)
end

function PlayerInfoSysChangeGroupView:ReplaceChoose()
    if self.lastChooseIndex and self.itemViewList[self.lastChooseIndex] then
        self.itemViewList[self.lastChooseIndex]:SetCancelChoose()
    end

    if self.currentChooseIndex and self.itemViewList[self.currentChooseIndex] then
        self.itemViewList[self.currentChooseIndex]:SetChoose(true)
    end
end

function PlayerInfoSysChangeGroupView:InitGroup()
    if self.hasInitGroup and self.initUI then
        return
    end
    self.hasInitGroup = true
    self.initUI = true

    local itemView = self:GetItemViewCode()
    local data = self:GetItemListData()
    local totalVerticalNum = 0
    self.itemViewList = {}
    local useIndex = 0
    for k , v in pairs(data) do
        if self:CheckItemVisiable(k) then
            useIndex = useIndex + 1
            local go = fun.get_instance(self.prefab,self.content)
            local pos , verticalIndex = self:GetItemPos(useIndex) 
            local item = itemView:New()
            item:SkipLoadShow(go)
            totalVerticalNum = verticalIndex
            fun.set_transform_pos(go.transform,pos.x,pos.y,pos.z,true)
            fun.set_active(go.transform,true)
            item:SetChooseFunc(self,self.ClickItemChoose)
            item:SetInfo(v,useIndex)
            if item:CheckUsing() then
                self:SetIndexData(useIndex)
            end
            self.itemViewList[useIndex] = item
        end
    end

    self:SetContentSize(totalVerticalNum)
    self:AutoBackView()
end

function PlayerInfoSysChangeGroupView:CheckItemVisiable(useIndex)
    return true
end

function PlayerInfoSysChangeGroupView:SetContentSize(totalVerticalNum)
    local achievementHight = totalVerticalNum * self:GetItemHeight()
    local odlSize = self.content.transform.sizeDelta
    self.content.transform.sizeDelta = Vector2.New(odlSize.x,odlSize.y + achievementHight)
end

function PlayerInfoSysChangeGroupView:AutoBackView()
    LuaTimer:SetDelayFunction(0.2, function()
        local targetPosY = self.content.transform.localPosition.y
        local targetPosX = self.content.transform.localPosition.x
        Anim.do_smooth_float_update(targetPosY , 0, 0.3, function(num)
            self.content.transform.localPosition = Vector2.New(targetPosX,num)
        end)
    end)
end

function PlayerInfoSysChangeGroupView:RefreshItem()
    -- local data = self:GetItemListData()
    -- for useIndex , item in pairs(self.itemViewList) do
    --     local itemData = data[useIndex]
    --     item:SetInfo(itemData , useIndex)
    --     if item:CheckUsing() then
    --         self:SetIndexData(useIndex)
    --     end
    -- end
end

function PlayerInfoSysChangeGroupView:OnDestroy()
    self.hasInitGroup = false
    self.itemViewList = nil
    self.initUI = false
    self.initUseFunc = nil
    self.initChooseIndex = nil
    self.lastChooseIndex = nil
    self.currentChooseIndex = nil
end

function PlayerInfoSysChangeGroupView:GetItemData(index)
    if self.itemViewList and self.itemViewList[index] then
        return self.itemViewList[index]:GetItemData()
    end
    return nil
end

function PlayerInfoSysChangeGroupView:GetChooseItemData()
    if self.currentChooseIndex and self.itemViewList and self.itemViewList[self.currentChooseIndex] then
        return self.itemViewList[self.currentChooseIndex]:GetItemData()
    end
    return nil
end

function PlayerInfoSysChangeGroupView:SetIndexData(useIndex)
    self.initChooseIndex = useIndex
    self.lastChooseIndex = useIndex
    self.currentChooseIndex = useIndex
end

function PlayerInfoSysChangeGroupView:CheckIsSameClick(index)
    if self.currentChooseIndex == index then
        return true
    end
    return false
end

function PlayerInfoSysChangeGroupView:CheckUseIndexToChange()
    if self.currentChooseIndex == self.initChooseIndex then
        return true
    end
    return false
end

function PlayerInfoSysChangeGroupView:ChangeInitByReqChoose()
    self.initChooseIndex = self.currentChooseIndex
end

function PlayerInfoSysChangeGroupView:SendChooseEvent(index)
end

function PlayerInfoSysChangeGroupView:GetItemViewCode()
end

function PlayerInfoSysChangeGroupView:GetItemListData()
    return self.data
end

function PlayerInfoSysChangeGroupView:GetItemPosFirst()
end

function PlayerInfoSysChangeGroupView:GetItemOffset()
end

function PlayerInfoSysChangeGroupView:GetItemPosHorizonalNum()
end

function PlayerInfoSysChangeGroupView:GetItemHeight()
end

function PlayerInfoSysChangeGroupView:GetItemPos(index)
    local verticalIndex = 1
    local mulIndex , left = math.modf(index / self:GetItemPosHorizonalNum())
    if left == 0 then
        verticalIndex = mulIndex
    else
        verticalIndex = mulIndex + 1
    end

    local horionalIndex =   1  --横向序号
    local itemPosHorizonalNum = self:GetItemPosHorizonalNum()
    local hor = index % itemPosHorizonalNum
    if hor == 0 then
        horionalIndex = itemPosHorizonalNum
    else
        horionalIndex = hor
    end
    local itemPosFirst = self:GetItemPosFirst()
    local itemOffset = self:GetItemOffset()
    local pos = Vector3.New(itemPosFirst.x + itemOffset.x * (horionalIndex - 1) , itemPosFirst.y + itemOffset.y * (verticalIndex - 1)   , 0)
    return pos , verticalIndex
end


return PlayerInfoSysChangeGroupView