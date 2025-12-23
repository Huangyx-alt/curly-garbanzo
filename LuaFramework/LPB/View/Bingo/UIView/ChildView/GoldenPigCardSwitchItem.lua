local GoldenPigCardSwitchItem = BaseChildView:New()
local this = GoldenPigCardSwitchItem
this.cardPage = {}
this.itemRoots = {}

function GoldenPigCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = GoldenPigCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function GoldenPigCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
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

function GoldenPigCardSwitchItem:ShowAll(go, orderIndex)
    local ref, ItemCtrlTemp = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        
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

function GoldenPigCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("GoldenPigGetxiaoka", items[i].obj, 1, function(effObj)
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

---计算每个卡牌上星星的位置
function GoldenPigCardSwitchItem:InitItemRewardCtrl()
    self.itemGroups = { }

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

function GoldenPigCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
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
            fun.set_active(v.itemCtrl, true)
            --更新明暗状态
            local isAllSigned = self:IsGroupCellAllSigned(cardID, v.groupID)
            if isAllSigned then
                fun.set_img_color(v.itemCtrl, Color.New(1, 1, 1, 1))
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
            fun.set_active(itemCtrl, true)
            fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)
            table.insert(self.cardIems[cardID], {
                groupID = groupID,
                itemCtrl = itemCtrl
            })

            local isAllSigned = self:IsGroupCellAllSigned(cardID, groupID)
            if isAllSigned then
                fun.set_img_color(itemCtrl, Color.New(1, 1, 1, 1))
            end
        end)
    end
end

function GoldenPigCardSwitchItem:IsGroupCellAllSigned(cardID, groupID)
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

function GoldenPigCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

return GoldenPigCardSwitchItem