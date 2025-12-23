local EasterCardSwitchItem = BaseChildView:New()
local this = EasterCardSwitchItem
this.cardPage = {}
this.itemRoots = {}

function EasterCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = EasterCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function EasterCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        self.bowl5 = ref:Get("bowl5")
        self.ItemCtrlTemp = ref:Get("ItemCtrlTemp")
        self.ItemCtrlTemp2 = ref:Get("ItemCtrlTemp2")
        fun.set_active(self.ItemCtrlTemp, false)
        fun.set_active(self.ItemCtrlTemp2, false)
    end

    local page = {}
    for i = 1, 25 do
        local clone = fun.get_instance(self.img_reap, self.content)
        fun.set_active(clone, false, 0)
        local img = clone:GetComponent(fun.IMAGE)
        local cell = { obj = clone, image = img }
        table.insert(page, cell)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(clone, 22.5 * x, -22.5 * y, 0, true)
        fun.set_active(clone, true)
    end

    table.insert(this.cardPage, page)
    table.insert(this.itemRoots, self.ItemCtrlTemp.transform.parent)
    
    coroutine.start(function()
        coroutine.wait(3)
        self:InitItemRewardCtrl()
    end)
end

function EasterCardSwitchItem:ShowAll(go, orderIndex)
    local ref, ItemCtrlTemp = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        self.bowl5 = ref:Get("bowl5")
        ItemCtrlTemp = ref:Get("ItemCtrlTemp")
        ItemCtrlTemp2 = ref:Get("ItemCtrlTemp2")
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
        local clone = fun.get_instance(self.img_reap, self.content)
        fun.set_active(clone, false, 0)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(clone, 22.5 * x, -22.5 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(clone, isNotSign)
        items[i] = clone
    end

    local itemCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(orderIndex)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(orderIndex)
    local bingoCount = 0
    for i = 1, #itemCount do
        if itemCount[i] >= maxCount[i] then
            bingoCount = bingoCount + 1
        end
    end
    for i = 1, #itemCount do
        fun.set_active(self["bowl" .. i], i <= bingoCount)
    end

    coroutine.start(function()
        WaitForSeconds(1.5)
        
        table.each(self.itemGroups[orderIndex], function(v)
            local tempClone = v.itemType == 4 and self.ItemCtrlTemp2 or self.ItemCtrlTemp
            local itemCtrl = fun.get_instance(tempClone, tempClone.transform.parent)
            local cellObj = items[v.cellIndex]
            local pos = cellObj.transform.position

            fun.set_active(itemCtrl, true)
            fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)

            --格子颜色
            local child = fun.get_child(cellObj, 0)
            fun.set_active(child, true)
        end)
    end)
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

function EasterCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("EasterGetxiaoka", items[i].obj, 1, function(effObj)
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

    local itemCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    local bingoCount = 0
    for i = 1, #itemCount do
        if itemCount[i] >= maxCount[i] then
            bingoCount = bingoCount + 1
        end
    end
    local refTemp = fun.get_component(cardObj, fun.REFER)
    for i = 1, #itemCount do
        fun.set_active(refTemp:Get("bowl" .. i), i <= bingoCount)
    end

    self:ShowItemRewardCtrl(pageIndex, cardId)
end

---计算每个卡牌上星星的位置
function EasterCardSwitchItem:InitItemRewardCtrl()
    self.itemGroups = { }

    local curModel = ModelList.BattleModel:GetCurrModel()
    table.each(curModel:GetRoundData(), function(cardData, cardID)
        cardID = tonumber(cardID)
        self.itemGroups[cardID] = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                local data = Csv.GetData("item", treasureItems.id)
                if 42 == data.result[1] then
                    table.insert(self.itemGroups[cardID], {
                        cellIndex = cellData.index,
                        itemType = data.result[2],
                    })
                end
            end
        end)
    end)

    self:ShowItemRewardCtrl(1, 3)
    self:ShowItemRewardCtrl(2, 4)
end

function EasterCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
    --标识pageindex是否有显示
    self.pageCtrls = self.pageCtrls or {}
    if GetTableLength(self.pageCtrls[pageIndex]) > 0 then
        table.each(self.pageCtrls[pageIndex], function(v)
            fun.set_active(v.itemCtrl, false)
            fun.set_active(v.cellEggImg, false)
        end)
    end
    self.pageCtrls[pageIndex] = {}
    
    --每个card的星星
    self.cardItems = self.cardItems or {}
    if self.cardItems[cardID] then
        table.each(self.cardItems[cardID], function(v)
            fun.set_active(v.itemCtrl, true)
            fun.set_active(v.cellEggImg, true)
        end)
        self.pageCtrls[pageIndex] = self.cardItems[cardID]
    else
        self.cardItems[cardID] = {}
        local items = this.cardPage[pageIndex]
        table.each(self.itemGroups[cardID], function(v)
            local root = this.itemRoots[pageIndex]
            local tempClone = v.itemType == 4 and self.ItemCtrlTemp2 or self.ItemCtrlTemp
            local itemCtrl = fun.get_instance(tempClone, root)
            local cellObj = items[v.cellIndex].obj
            local pos = cellObj.transform.position
            
            fun.set_active(itemCtrl, true)
            fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)
            
            --格子颜色
            local child = fun.get_child(cellObj, 0)
            fun.set_active(child, true)
            
            table.insert(self.cardItems[cardID], {
                itemCtrl = itemCtrl,
                cellEggImg = child,
            })
        end)
    end
end

function EasterCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

return EasterCardSwitchItem