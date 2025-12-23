local PirateShipCardSwitchItem = BaseChildView:New()
local this = PirateShipCardSwitchItem
this.cardPage = {}
this.itemRoots = {}

function PirateShipCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = PirateShipCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function PirateShipCardSwitchItem:InitMap(go, type)
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
        fun.set_gameobject_pos(go, 29 * x, -29 * y, 0, true)
        fun.set_active(go, i ~= 13)
    end

    table.insert(this.cardPage, page)
    table.insert(this.itemRoots, self.ItemCtrlTemp.transform.parent)
    
    coroutine.start(function()
        coroutine.wait(3)
        self:InitItemRewardCtrl()
    end)
end

function PirateShipCardSwitchItem:ShowAll(go, orderIndex)
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
        fun.set_gameobject_pos(go, 29 * x, -29 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
        if i == 13 then fun.set_active(go, false) end
        items[i] = go
    end

    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(orderIndex)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(orderIndex)
    local bingoCount = 0
    for i = 1, #bowlCount do
        if bowlCount[i] >= maxCount[i] then
            bingoCount = bingoCount + 1
        end
    end
    for i = 1, #bowlCount do
        fun.set_active(self["bowl" .. i], i <= bingoCount)
    end

    coroutine.start(function()
        WaitForSeconds(1.5)
        table.each(self.itemGroups[orderIndex], function(cellData)
            local cellObj = items[cellData.index]
            local itemCtrl = fun.get_instance(ItemCtrlTemp, ItemCtrlTemp.transform.parent)
            fun.set_active(itemCtrl, true)
            itemCtrl.transform.position = cellObj.transform.position

            --更新明暗状态
            if cellData.isGained then
                fun.set_active(itemCtrl, false)
                --fun.set_img_color(itemCtrl, Color.New(1, 1, 1, 1))
            end
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

function PirateShipCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("PirateShipGetxiaoka", items[i].obj, 1, function(effObj)
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

    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    local bingoCount = 0
    for i = 1, #bowlCount do
        if bowlCount[i] >= maxCount[i] then
            bingoCount = bingoCount + 1
        end
    end
    local refTemp = fun.get_component(cardObj, fun.REFER)
    for i = 1, #bowlCount do
        fun.set_active(refTemp:Get("bowl" .. i), i <= bingoCount)
    end

    self:ShowItemRewardCtrl(pageIndex, cardId)
end

function PirateShipCardSwitchItem:InitItemRewardCtrl()
    self.itemGroups = {}

    local curModel = ModelList.BattleModel:GetCurrModel()
    table.each(curModel:GetRoundData(), function(cardData, cardID)
        cardID = tonumber(cardID)
        self.itemGroups[cardID] = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                local data = Csv.GetData("new_item", treasureItems.id)
                --是宝箱
                if 11 == data.result[1] then
                    table.insert(self.itemGroups[cardID], cellData)
                end
            end
        end)
    end)
end

function PirateShipCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
    --其他卡片显示中的道具
    self.pageCtrl = self.pageCtrl or {}
    if GetTableLength(self.pageCtrl[pageIndex]) > 0 then
        table.each(self.pageCtrl[pageIndex], function(v)
            fun.set_active(v.itemCtrl, false)
        end)
    end
    self.pageCtrl[pageIndex] = {}
    
    --每个card的道具
    self.cardItems = self.cardItems or {}
    if self.cardItems[cardID] then
        --已经缓存
        local curModel = ModelList.BattleModel:GetCurrModel()
        table.each(self.cardItems[cardID], function(v)
            fun.set_active(v.itemCtrl, true)
            --更新明暗状态
            local cellData = curModel:GetRoundData(cardID, v.cellIndex)
            if cellData.isGained then
                fun.set_active(v.itemCtrl, false)
                --fun.set_img_color(v.itemCtrl, Color.New(1, 1, 1, 1))
            end
        end)

        self.pageCtrl[pageIndex] = self.cardItems[cardID]
    else
        --未缓存，创建
        self.cardItems[cardID] = {}
        local items = this.cardPage[pageIndex]
        table.each(self.itemGroups[cardID], function(cellData)
            local cellObj = items[cellData.index].obj
            local root = this.itemRoots[pageIndex]
            local itemCtrl = fun.get_instance(self.ItemCtrlTemp, root)
            fun.set_active(itemCtrl, true)
            itemCtrl.transform.position = cellObj.transform.position

            table.insert(self.cardItems[cardID], {
                cellIndex = cellData.index,
                itemCtrl = itemCtrl
            })
            
            if cellData.isGained then
                fun.set_active(itemCtrl, false)
                --fun.set_img_color(itemCtrl, Color.New(1, 1, 1, 1))
            end
        end)
    end
end

function PirateShipCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

return PirateShipCardSwitchItem