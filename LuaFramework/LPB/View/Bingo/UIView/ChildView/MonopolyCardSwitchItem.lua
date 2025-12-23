local MonopolyCardSwitchItem = BaseChildView:New()
local this = MonopolyCardSwitchItem
this.cardPage = {}
this.itemRoots = {}

function MonopolyCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = MonopolyCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function MonopolyCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.ItemCtrlTemp = ref:Get("ItemCtrlTemp")
        fun.set_active(self.ItemCtrlTemp, false)
    end

    local page = {}
    for i = 1, 25 do
        local go = fun.get_instance(self.img_reap, self.content)
        fun.set_active(go, false, 0)
        local img = go:GetComponent(fun.IMAGE)
        local cell = { obj = go, image = img }
        table.insert(page, cell)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(go, 28 * x, -28 * y, 0, true)
        fun.set_active(go, true)
    end
    table.insert(this.cardPage, page)
    table.insert(this.itemRoots, self.ItemCtrlTemp.transform.parent)
    
    LuaTimer:SetDelayFunction(1, function()
        self:InitItemRewardCtrl()
    end,nil,LuaTimer.TimerType.Battle)
end

function MonopolyCardSwitchItem:ShowAll(go, orderIndex)
    local ref, ItemCtrlTemp = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        ItemCtrlTemp = ref:Get("ItemCtrlTemp")
        fun.eachChild(ItemCtrlTemp.transform.parent, function(child)
            fun.set_active(child, false)
        end)
    end
    
    local childCount = fun.get_child_count(self.content)
    for i = childCount, 1, -1 do
        if fun.get_child(self.content, i - 1).gameObject.activeSelf then
            Destroy(fun.get_child(self.content, i - 1).gameObject)
        end
    end
    
    local items = {}
    for i = 1, 25 do
        local go = fun.get_instance(self.img_reap, self.content)
        fun.set_active(go, false, 0)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(go, 28 * x, -28 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
        items[i] = go
    end
    --[[
    coroutine.start(function()
        WaitForSeconds(1.5)
        local groups = self.itemGroups[orderIndex]
        table.each(groups, function(cells, groupID)
            local pos = Vector3.zero
            table.each(cells, function(index)
                local cellObj = items[index]
                pos = pos + cellObj.transform.position
            end)
            pos = pos / #cells

            local itemCtrl = fun.get_instance(ItemCtrlTemp, ItemCtrlTemp.transform.parent)
            fun.set_active(itemCtrl, true)
            fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)

            --更新明暗状态
            local isAllSigned = self:IsGroupCellAllSigned(orderIndex, groupID)
            if isAllSigned then
                fun.set_img_color(itemCtrl, Color.New(1, 1, 1, 1))
            end
        end)
    end)
    --]]
end

local function IsAutoClick(currCardId, currIndex, cardId, signInfo)
    if not signInfo then
        return false
    end
    if currCardId == cardId then
        for i = 1, #signInfo do
            if signInfo[i].index == currIndex then
                return true
            end
        end
    end
    return false
end

function MonopolyCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
    local items = this.cardPage[pageIndex]
    if items then
        local isshowing = false
        for i = 1, #items do
            isshowing = false
            for k, v in pairs(newCard) do
                if i == v.index then
                    isshowing = true
                    items[i].obj.gameObject:SetActive(true)
                    if IsAutoClick(v.cardId, v.index, cardId, signInfo) then
                        BattleEffectCache:GetFreePrefabFromCache("MonopolyGetxiaoka", items[i].obj, 1, function(effObj)
                            fun.set_active(effObj, true)
                            fun.set_parent(effObj, effObj.transform.parent.parent)
                        end)
                    end
                    break
                end
            end
            items[i].obj.gameObject:SetActive(not isshowing)
        end
    end

    self:ShowItemRewardCtrl(pageIndex, cardId)
end

---计算每个卡牌上星星的位置
function MonopolyCardSwitchItem:InitItemRewardCtrl()
    self.itemGroups = {}
    LuaTimer:SetDelayFunction(4, function()
        local curModel = ModelList.BattleModel:GetCurrModel()
        table.each(curModel:GetRoundData(), function(cardData, cardID)
            cardID = tonumber(cardID)
            local temp = {}
            table.each(cardData.cards, function(cellData)
                local treasureItems = cellData:Treasure2Item()
                if treasureItems then
                    temp[treasureItems.groupid] = temp[treasureItems.groupid] or {}
                    table.insert(temp[treasureItems.groupid], cellData)
                end
            end)
            self.itemGroups[cardID] = {}
            table.each(temp, function(cells, groupID)
                self.itemGroups[cardID][groupID] = {}
                table.each(cells, function(cellData)
                    local cellIndex = cellData.index
                    table.insert(self.itemGroups[cardID][groupID], cellIndex)
                end)
            end)
        end)
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolyCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
    --标识pageindex是否有显示
    self.pageCtrls = self.pageCtrls or {}
    if GetTableLength(self.pageCtrls[pageIndex]) > 0 then
        table.each(self.pageCtrls[pageIndex], function(v)
            fun.set_active(v.itemCtrl, false)
        end)
    end
    self.pageCtrls[pageIndex] = {}
    
    --每个card的星星
    self.cardIems = self.cardIems or {}
    if self.cardIems[cardID] then
        table.each(self.cardIems[cardID], function(v)
            --更新明暗状态
            local isBroken = self:IsBroken(cardID, v.groupID)
            if isBroken then
                fun.set_active(v.itemCtrl, true)
            end
        end)
        
        self.pageCtrls[pageIndex] = self.cardIems[cardID]
    else
        self.cardIems[cardID] = {}
        local items = this.cardPage[pageIndex]
        local groups = self.itemGroups[cardID]
        table.each(groups, function(cells, groupID)
            local pos = Vector3.zero
            table.each(cells, function(index)
                local cellObj = items[index].obj
                pos = pos + cellObj.transform.position
            end)
            pos = pos / GetTableLength(cells)
            
            local root = this.itemRoots[pageIndex]
            local itemCtrl = fun.get_instance(self.ItemCtrlTemp, root)
            fun.set_active(itemCtrl, false)
            fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)
            table.insert(self.cardIems[cardID], {
                groupID = groupID,
                itemCtrl = itemCtrl
            })

            local isBroken = self:IsBroken(cardID, groupID)
            if isBroken then
                fun.set_active(itemCtrl, true)
            end
        end)
    end
end

function MonopolyCardSwitchItem:IsBroken(cardId, groupId)
    if groupId > 34003 then
        return false
    end

    local ret1 = self:IsGroupCellAllSigned(cardId, groupId)
    local ret2 = self:IsGroupCellAllSigned(cardId, 34004)
    return ret1 and ret2
end

function MonopolyCardSwitchItem:IsGroupCellAllSigned(cardID, groupID)
    local groups = self.itemGroups and self.itemGroups[cardID]
    if not groups then
        return false
    end
    local cells = groups[groupID]
    if not cells then
        return false
    end

    local ret = true
    table.each(cells, function(index)
        local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID, index)
        local signed = not cellData:IsNotSign()
        ret = ret and signed
    end)
    return ret
end

function MonopolyCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

return MonopolyCardSwitchItem