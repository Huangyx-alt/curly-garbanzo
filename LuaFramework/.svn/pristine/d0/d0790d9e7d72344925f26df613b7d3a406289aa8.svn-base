local SeasonCardInfiniteList = Clazz(ClazzBase, "SeasonCardInfiniteList")

function SeasonCardInfiniteList.create(params)
    local instance = SeasonCardInfiniteList:new()
    instance:InitOptions(params)
    return instance
end

function SeasonCardInfiniteList:UpdateListByData(data)
    self.listData = data
    self:CalculateLayoutInfo()
    self:UpdateScrollView()
end

function SeasonCardInfiniteList:CalculateLayoutInfo()
    self.layoutInfoList = {}
    local startPos = 0
    local height1 = self.tempGroupItem1.transform.rect.height
    local height2 = self.tempGroupItem2.transform.rect.height
    for i, v in ipairs(self.listData) do
        local info = {}
        local height
        info.index = i
        info.topPosY = startPos
        
        if #v.cards < 6 then
            info.bottomPosY = startPos - height1
        else
            info.bottomPosY = startPos - height2
        end

        startPos = info.bottomPosY
        table.insert(self.layoutInfoList, info)
    end
    self.contentHeight = math.abs(startPos)
end

function SeasonCardInfiniteList:CalculateBoundary(offsetY)
    local topItem, bottomItem
    for i = 1, #self.layoutInfoList do
        if self.layoutInfoList[i].bottomPosY + offsetY >= 0 then
        else
            topItem = self.layoutInfoList[i]
            break
        end
    end

    for i = #self.layoutInfoList, 1, -1 do
        if self.layoutInfoList[i].topPosY + offsetY + self.viewHeight >= 0 then
            bottomItem = self.layoutInfoList[i]
            break
        end
    end

    return topItem, bottomItem
end

function SeasonCardInfiniteList:OnDestroy()
    self.cacheItemList = {}
end

function SeasonCardInfiniteList:InitOptions(params)
    self.tempGroupItem1 = params.groupItem1
    self.tempGroupItem2 = params.groupItem2
    self.tempCardItem = params.cardItem
    self.scrollView = params.scrollView
    self.content = params.scrollView.content
    self.luabehaviour = params.luabehaviour          --用于哪个View的列表
    self.groupItemView = params.groupItemView        --item的显示逻辑View
    self.cardItemView = params.cardItemView
    self.spacing = params.spacing or 0               --两个Item的间距
    self.paddingTop = params.paddingTop or 0         --content顶部距离View的距离
    self.paddingBottom = params.paddingBottom or 0   --content底部距离View的距离
    self.host = params.host
    --Item的Height
    self.itemHeight1 = self.tempGroupItem1.transform.rect.height + self.spacing
    self.itemHeight2 = self.tempGroupItem2.transform.rect.height + self.spacing
    --View的Height
    self.viewHeight = self.scrollView.transform.rect.height
    --View中可以显示的item的数量
    self.showItemCount = math.max(math.ceil(self.viewHeight / self.itemHeight1), math.ceil(self.viewHeight / self.itemHeight2))
    
    fun.set_active(self.tempGroupItem1, false)
    fun.set_active(self.tempGroupItem2, false)
    --设置中心点
    --fun.set_rect_pivot(self.tempGroupItem1, 0.5, 1)
    --fun.set_rect_pivot(self.tempGroupItem2, 0.5, 1)

    self.cacheItemList = {}
    self:InitScrollView()
end

function SeasonCardInfiniteList:UpdateTempObjs()
    --需要显示的数据总量
    self.groupsCount = 0
    table.each(self.listData, function(v, k)
        v.dataKey = k
        self.groupsCount = self.groupsCount + 1
    end)
    
    --缓存已经创建的item
    self.cacheItemList = table.values(self.cacheItemList)
    --标识正在显示中的数据
    self.showingItemList = {}
    
    --添加初始item
    local y = -self.paddingTop
    for i = 1, self.showItemCount + 1 do
        local groupData = self.listData[i]
        if groupData then
            local view = self:GetDeActiveItem(groupData)
            local itemHeight = #groupData.cards < 6 and self.itemHeight1 or self.itemHeight2
            if not view then
                view = self:CreateNewItem(y, groupData)
                view.go.name = "ItemTemp" .. i
                y = y - itemHeight
            else
                local go = view.go
                fun.set_rect_local_pos_y(go, y)
                if i <= self.groupsCount then
                    fun.set_active(go.transform, true)
                    y = y - itemHeight
                    local data = {index = groupData.dataKey, groupInfo = groupData, host = self.host}
                    view:SetData(data)
                    view:Refresh()
                else
                    fun.set_active(go.transform, false)
                end
            end
            self.showingItemList[i] = true
        end
    end
end

function SeasonCardInfiniteList:UpdateScrollView()
    self:UpdateTempObjs()
    --content回到顶端
    fun.set_rect_local_pos_y(self.content, 0)
    --scrollView停止惯性移动
    self.scrollView:StopMovement()
    --根据item的数量设置content的大小
    self.content.transform.sizeDelta = Vector2.New(0, self.contentHeight)
    self.topItemInSight, self.bottomItemInSight = self:CalculateBoundary(0)
end

function SeasonCardInfiniteList:InitScrollView()
    self.luabehaviour:AddScrollRectChange(self.scrollView.gameObject, function(value)
        local contentOffsetY = self.content.transform.localPosition.y
        if contentOffsetY > 0 then --滑动速度
            local velocity = self.scrollView.velocity.y
            if velocity < 0 then        --向上滑动, 内容往下走
                self:OnMoveUp(contentOffsetY)
            elseif velocity > 0 then    --向下滑动，内容往上走
                self:OnMoveDown(contentOffsetY)
            end
        end
    end)
end

function SeasonCardInfiniteList:CheckContentChangeByMoveDown(offsetY)
    if not self.topItemInSight or not self.bottomItemInSight then
        return false
    end

    if self.contentHeight <= self.viewHeight then
        return false 
    end

    if offsetY + self.topItemInSight.bottomPosY > 0 then
        return true
    end

    if offsetY + self.viewHeight + self.bottomItemInSight.bottomPosY > 0 then
        return true
    end

    return false
end

function SeasonCardInfiniteList:OnMoveDown(contentOffsetY)
    if self:CheckContentChangeByMoveDown(contentOffsetY) then
        local topItemInSight, bottomItemInSight = self:CalculateBoundary(contentOffsetY)
        --clear
        for i = self.topItemInSight.index + 1, topItemInSight.index do
            --undo do recycle
        end
        self:RecycleItems()

        --add
        for i = self.bottomItemInSight.index + 1, bottomItemInSight.index do
            self:FillVacancy(i)
        end

        self.topItemInSight, self.bottomItemInSight = topItemInSight, bottomItemInSight
    end
end

function SeasonCardInfiniteList:FillVacancy(index)
    local posY = self.layoutInfoList[index].topPosY
    local itemData = self.listData[index]
    local item = self:GetDeActiveItem(itemData)
    if not item then
        item = self:CreateNewItem(posY, itemData)
    else
        fun.set_rect_local_pos_y(item.go, posY)
        local data = {index = itemData.dataKey, groupInfo = itemData, host = self.host}
        item:SetData(data)
        item:Refresh()
        item:SetActive(true)
    end

    item.go.name = "Item" .. index
    self.showingItemList[itemData.dataKey] = true
end

function SeasonCardInfiniteList:CheckContentChangeByMoveUp(offsetY)
    if not self.topItemInSight or not self.bottomItemInSight then
        return false
    end

    if self.contentHeight <= self.viewHeight then
        return false 
    end

    if offsetY + self.topItemInSight.topPosY < 0 then
        return true
    end

    if offsetY + self.viewHeight + self.bottomItemInSight.topPosY < 0 then
        return true
    end

    return false
end

function SeasonCardInfiniteList:OnMoveUp(contentOffsetY)
    if self:CheckContentChangeByMoveUp(contentOffsetY) then
        local topItemInSight, bottomItemInSight = self:CalculateBoundary(contentOffsetY)
        --clear
        for i = self.bottomItemInSight.index + 1, bottomItemInSight.index do
            --undo do recycle
        end
        self:RecycleItems()

        --add
        for i = topItemInSight.index, self.topItemInSight.index - 1 do
            self:FillVacancy(i)
        end

        self.topItemInSight, self.bottomItemInSight = topItemInSight, bottomItemInSight
    end
end 

--创建一个新的ItemCtrl
function SeasonCardInfiniteList:CreateNewItem(offsetY, itemData)
    local go
    if #itemData.cards < 6 then
        go = fun.get_instance(self.tempGroupItem1, self.content)
    else
        go = fun.get_instance(self.tempGroupItem2, self.content)
    end
    fun.set_rect_local_pos_y(go, offsetY)
    fun.set_active(go.transform, true)
    local view = self.groupItemView:New()
    local data = {index = itemData.dataKey, groupInfo = itemData, host = self.host}
    view:SetData(data)
    view:SkipLoadShow(go)
    table.insert(self.cacheItemList, view)
    return view
end

function SeasonCardInfiniteList:RecycleItems()
    table.each(self.cacheItemList, function(groupItemView)
        local dataKey = groupItemView:GetDataKey()
        if dataKey < self.topItemInSight.index or dataKey > self.bottomItemInSight.index then
            self.showingItemList[dataKey] = false
            groupItemView:SetActive(false)
        end
    end)
end

--回收所有item
function SeasonCardInfiniteList:RecycleAllItems()
    table.each(self.cacheItemList, function(groupItemView)
        local dataKey = groupItemView:GetDataKey()
        self.showingItemList[dataKey] = false
        groupItemView:SetActive(false)
    end)
end

--从被隐藏的item中取1个
function SeasonCardInfiniteList:GetDeActiveItem(groupData)
    local ret
    table.each(self.cacheItemList, function(groupItemView)
        if not ret and not groupItemView.go.activeSelf and groupItemView:CanHandleData(groupData) then
            ret = groupItemView
        end
    end)
    return ret
end

--销毁多余的item
function SeasonCardInfiniteList:DestroyUnusedItems()
    local usedCount, tempCount = self.showItemCount + 1, 0
    --使用中的
    table.each(self.cacheItemList, function(groupItemView)
        if groupItemView.go.activeSelf then
            tempCount = tempCount + 1
        end
    end)

    --销毁隐藏的
    table.each(self.cacheItemList, function(groupItemView, index)
        if not groupItemView.go.activeSelf then
            tempCount = tempCount + 1
            if tempCount > usedCount then
                Destroy(groupItemView.go)
                self.cacheItemList[index] = nil
            end
        end
    end)
end

return SeasonCardInfiniteList