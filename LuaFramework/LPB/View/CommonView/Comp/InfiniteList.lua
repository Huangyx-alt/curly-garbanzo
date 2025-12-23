local InfiniteList = Clazz(ClazzBase, "InfiniteList")
local private = {}

function InfiniteList:New(options)
    local instance = CreateInstance_(InfiniteList)
    private.InitOptions(instance, options)
    return instance
end

function InfiniteList:UpdateListByData(data)
    self.listData = data
    private.UpdateScrollView(self)
end

function InfiniteList:OnDestroy()
    self.cacheItemList = {}
    if self.destroyTimerID then
        LuaTimer:Remove(self.destroyTimerID)
    end
end

----------------------Private Func-----------------------------

function private.InitOptions(self, options)
    self.tempItemCtrl = options.tempItemCtrl
    self.scrollView = options.scrollView
    self.content = self.scrollView.content

    self.luabehaviour = options.luabehaviour          --用于哪个View的列表
    self.itemView = options.itemView                  --item的显示逻辑View
    self.spacing = options.spacing or 0               --两个Item的间距
    self.paddingTop = options.paddingTop or 0         --content顶部距离View的距离
    self.paddingBottom = options.paddingBottom or 0   --content底部距离View的距离

    --Item的Height
    self.itemHeight = self.tempItemCtrl.transform.rect.height + self.spacing
    --View的Height
    self.viewHeight = self.scrollView.transform.rect.height
    --View中可以显示的item的数量
    self.showItemCount = math.ceil(self.viewHeight / self.itemHeight)
    
    fun.set_active(self.tempItemCtrl, false)
    --设置中心点
    fun.set_rect_pivot(self.tempItemCtrl, 0.5, 1)

    self.cacheItemList = {}
    private.CalculateViewPort(self)
    private.InitScrollView(self)
end

function private.CalculateViewPort(self)
    --viewPort中心点的世界坐标
    self.viewPortWorldPos = fun.get_rect_worldPos(self.scrollView.viewport)
    --viewPort的大小
    self.viewPortRect = self.scrollView.viewport.rect
    
    --viewPort四条边中心点的世界坐标
    --local pivot = self.scrollView.viewport.pivot
    self.viewPortBorder = {
        left = self.viewPortWorldPos.x,
        right = self.viewPortWorldPos.x + self.viewPortRect.width,
        bottom = self.viewPortWorldPos.y - self.viewPortRect.height,
        top = self.viewPortWorldPos.y,
    }
end

function private.UpdateTempObjs(self)
    --需要显示的数据总量
    self.clubsCount = 0
    table.each(self.listData, function(v, k)
        v.dataKey = k
        self.clubsCount = self.clubsCount + 1
    end)
    
    --缓存已经创建的item
    self.cacheItemList = table.values(self.cacheItemList)
    --标识正在显示中的数据
    self.showingItemList = {}
    
    --添加初始item
    local y = -self.paddingTop
    for i = 1, self.showItemCount + 4 do
        local view = self.cacheItemList[i]
        if not view then
            view = private.CreateNewItemCtrl(self, y, self.listData[i])
            view.go.name = "ItemTemp" .. i
            y = y - self.itemHeight
        else
            local go = view.go
            fun.set_rect_local_pos_y(go, y)
            if i <= self.clubsCount then
                fun.set_active(go.transform,true)
                y = y - self.itemHeight
                view:SetItemInfo(self.listData[i])
            else
                fun.set_active(go.transform,false)
            end
        end
        self.showingItemList[i] = true
    end

    LuaTimer:SetDelayFunction(0.1, function()
        private.CheckAllItems(self)
    end)
end

function private.UpdateScrollView(self)
    self.itemIndex = 0
    private.UpdateTempObjs(self)
    
    --content回到顶端
    fun.set_rect_local_pos_y(self.content, 0)
    --scrollView停止惯性移动
    self.scrollView:StopMovement()

    local content_height = self.paddingTop + self.paddingBottom +
            self.itemHeight * self.clubsCount - self.spacing

    --根据item的数量设置content的大小
    self.content.transform.sizeDelta = Vector2.New(0, content_height)
end

function private.InitScrollView(self)
    self.luabehaviour:AddScrollRectChange(self.scrollView.gameObject, function(value)
        --self.scrollView.velocity = self.scrollView.velocity / 3
        
        local contentY = self.content.transform.localPosition.y
        if contentY > 0 then
            --滑动速度
            local velocity = self.scrollView.velocity.y
            if velocity < 0 then
                --向上滑动
                --根据content底部当前位置应该对应第几个item
                local posY = math.abs(contentY) + self.viewHeight
                local tempIndex = Mathf.Round(posY / self.itemHeight)
                local index = math.max(tempIndex - self.showItemCount, 0)
                private.OnMoveUp(self, index)

            elseif velocity > 0 then
                --向下滑动
                --根据content顶部当前位置应该对应第几个item
                local tempIndex = Mathf.Round(math.abs(contentY) / self.itemHeight)
                local index = math.min(self.clubsCount - self.showItemCount, tempIndex)
                private.OnMoveDown(self, index)
            end
        end

        --添加计时器等待滑动停止一段时间后销毁多余生成的item
        if self.destroyTimerID then
            LuaTimer:Remove(self.destroyTimerID)
        end
        self.destroyTimerID = LuaTimer:SetDelayFunction(1, function()
            private.DestroyUnusedItemCtrl(self)
        end)
    end)
end

function private.OnMoveUp(self, index)
    if index < self.itemIndex then
        for i = index, self.itemIndex - 1 do
            local _index = i
            local isShowing = self.showingItemList[_index + 1]  --是否在显示中
            if not isShowing and _index >= 0 then
                local posY = -self.itemHeight * _index - self.paddingTop
                local itemData = self.listData[_index + 1]

                local item = private.GetDeActiveItem(self)
                if not item then
                    --全都被使用时，创建一个新的
                    item = private.CreateNewItemCtrl(self, posY, itemData)
                end
                
                fun.set_rect_local_pos_y(item.go, posY)
                item:SetItemInfo(itemData)
                item:SetActive(true)
                item.go.name = "Item" .. _index + 1
                
                self.showingItemList[itemData.dataKey] = true
            end
        end

        self.itemIndex = index
        LuaTimer:SetDelayFunction(UnityEngine.Time.deltaTime * 2, function()
            private.CheckAllItems(self)
        end)
    end
end 

function private.OnMoveDown(self, index)
    if index > self.itemIndex then
        for i = self.itemIndex + 1, index do
            local _index = i + self.showItemCount
            local isShowing = self.showingItemList[_index]  --是否在显示中
            if not isShowing and _index <= self.clubsCount then
                local posY = -self.itemHeight * (_index - 1) - self.paddingTop
                local itemData = self.listData[_index]

                local item = private.GetDeActiveItem(self)
                if not item then
                    --全都被使用时，创建一个新的
                    item = private.CreateNewItemCtrl(self, posY, itemData)
                end

                fun.set_rect_local_pos_y(item.go, posY)
                item:SetItemInfo(itemData)
                item:SetActive(true)
                item.go.name = "Item" .. _index

                self.showingItemList[itemData.dataKey] = true
            end
        end
        
        self.itemIndex = index
        LuaTimer:SetDelayFunction(UnityEngine.Time.deltaTime * 2, function()
            private.CheckAllItems(self)
        end)
    end
end

--创建一个新的ItemCtrl
function private.CreateNewItemCtrl(self, posY, itemData)
    local go = fun.get_instance(self.tempItemCtrl, self.content)
    fun.set_rect_local_pos_y(go, posY)
    fun.set_active(go.transform,true)
    
    local view = self.itemView:New(itemData)
    view:SkipLoadShow(go)
    table.insert(self.cacheItemList, view)
    return view
end

--移动时通过位置判断隐藏不在ViewPort中的item
function private.CheckAllItems(self)
    table.each(self.cacheItemList, function(itemView)
        local itemWorldPos = fun.get_rect_worldPos(itemView.go)
        local itemWorldPosY = itemWorldPos.y
        local dataKey = itemView:GetDataKey()
        if itemWorldPosY < self.viewPortBorder.bottom then
            --判断多一个itemHeight才算不在ViewPort
            if itemWorldPosY + self.itemHeight < self.viewPortBorder.bottom then
                if dataKey then self.showingItemList[dataKey] = false end
                itemView:SetActive(false)
            end
        else
            --判断多一个itemHeight才算不在ViewPort
            itemWorldPosY = itemWorldPosY - self.itemHeight
            if itemWorldPosY > self.viewPortBorder.top + self.itemHeight then
                if dataKey then self.showingItemList[dataKey] = false end
                itemView:SetActive(false)
            end
        end
    end)
end

--从被隐藏的item中取1个
function private.GetDeActiveItem(self)
    local ret
    table.each(self.cacheItemList, function(itemView)
        if not ret and not itemView.go.activeSelf then
            ret = itemView
        end
    end)
    return ret
end

--销毁多余的item
function private.DestroyUnusedItemCtrl(self)
    local usedCount, tempCount = self.showItemCount + 4, 0
    
    --使用中的
    table.each(self.cacheItemList, function(itemView)
        if itemView.go.activeSelf then
            tempCount = tempCount + 1
        end
    end)
    
    --销毁隐藏的
    table.each(self.cacheItemList, function(itemView, index)
        if not itemView.go.activeSelf then
            tempCount = tempCount + 1
            if tempCount > usedCount then
                Destroy(itemView.go)
                self.cacheItemList[index] = nil
            end
        end
    end)
end

return InfiniteList 

