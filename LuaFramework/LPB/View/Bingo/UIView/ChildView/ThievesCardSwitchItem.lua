local ThievesCardSwitchItem = BaseChildView:New()
local this = ThievesCardSwitchItem
this.cardPage = {}
this.itemRoots = {}
local thievesCells = {7, 9 ,17 ,19}

function ThievesCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = ThievesCardSwitchItem })
    self.showEffectFlag = {}
    return self
end

---初始化switch 分页卡牌
function ThievesCardSwitchItem:InitMap(go, type)
    self.showEffectFlag = {}
    
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
        fun.set_gameobject_pos(go, 29 * x, -29 * y, 0, true)
        
        local isDefaultOpenCell = fun.is_include(i, thievesCells)
        fun.set_active(go, not isDefaultOpenCell)
    end

    table.insert(this.cardPage, page)
    table.insert(this.itemRoots, self.ItemCtrlTemp.transform.parent)

    coroutine.start(function()
        coroutine.wait(3)
        self:ShowItemRewardCtrl(1, 3)
        self:ShowItemRewardCtrl(2, 4)
    end)
end

function ThievesCardSwitchItem:ShowAll(go, orderIndex)
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
        fun.set_gameobject_pos(go, 29 * x, -29 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
        
        local isDefaultOpenCell = fun.is_include(i, thievesCells)
        if isDefaultOpenCell then fun.set_active(go, false) end
        
        items[i] = go
    end

    local bingoCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBingoCount(orderIndex)
    for i = 1, 4 do
        fun.set_active(self["bowl" .. i], i <= bingoCount)
    end

    coroutine.start(function()
        WaitForSeconds(1.5)
        local curModel = ModelList.BattleModel:GetCurrModel()
        table.each(thievesCells, function(cellIndex)
            local cellData = curModel:GetRoundData(orderIndex, cellIndex)
            local cellObj = items[cellData.index]
            local itemCtrl = fun.get_instance(ItemCtrlTemp, ItemCtrlTemp.transform.parent)
            fun.set_active(itemCtrl, true)
            itemCtrl.transform.position = cellObj.transform.position

            --更新状态
            local refer = fun.get_component(itemCtrl, fun.REFER)
            local unlockCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetThievesUnlockedTiers(orderIndex, cellIndex)
            for i = 1, unlockCount do
                local temp = refer:Get("lian" .. i)
                fun.set_active(temp, false)
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

function ThievesCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("ThievesGetxiaoka", items[i].obj, 1, function(effObj)
                            if effObj then
                                fun.set_active(effObj, true)
                                fun.set_parent(effObj, effObj.transform.parent.parent)
                            end
                        end)
                    end
                    break
                end
            end
            items[i].obj.gameObject:SetActive(not isshowing)
        end
    end

    local bingoCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBingoCount(cardId)
    local refTemp = fun.get_component(cardObj, fun.REFER)
    for i = 1, 4 do
        fun.set_active(refTemp:Get("bowl" .. i), i <= bingoCount)
    end

    self:ShowItemRewardCtrl(pageIndex, cardId)
end

function ThievesCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cardCount = curModel:GetCardCount()
    if cardID > cardCount then
        return
    end
    
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
        table.each(self.cardItems[cardID], function(v)
            fun.set_active(v.itemCtrl, true)
            
            --更新状态
            local unlockCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetThievesUnlockedTiers(cardID, v.cellIndex)
            for i = 1, unlockCount do
                local temp = v.itemCtrl:Get("lian" .. i)
                fun.set_active(temp, false)
                temp = v.itemCtrl:Get("bao" .. i)
                fun.set_active(temp, false)
            end

            if self:CheckCanShowEffect(cardID, v.cellIndex, unlockCount) then
                local temp = v.itemCtrl:Get("bao" .. unlockCount)
                if temp and not temp.gameObject.activeSelf then
                    fun.set_active(temp, true)
                end
            end
        end)

        self.pageCtrl[pageIndex] = self.cardItems[cardID]
    else
        --未缓存，创建
        self.cardItems[cardID] = {}
        local items = this.cardPage[pageIndex]
        table.each(thievesCells, function(cellIndex)
            local cellData = curModel:GetRoundData(cardID, cellIndex)
            local cellObj = items[cellData.index].obj
            local root = this.itemRoots[pageIndex]
            local itemCtrl = fun.get_instance(self.ItemCtrlTemp, root)
            fun.set_active(itemCtrl, true)
            itemCtrl.transform.position = cellObj.transform.position
            local refer = fun.get_component(itemCtrl, fun.REFER)
            
            table.insert(self.cardItems[cardID], {
                cellIndex = cellData.index,
                itemCtrl = refer
            })

            --更新状态
            local unlockCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetThievesUnlockedTiers(cardID, cellIndex)
            for i = 1, unlockCount do
                local temp = refer:Get("lian" .. i)
                fun.set_active(temp, false)
            end
        end)
    end
end

function ThievesCardSwitchItem:CheckCanShowEffect(cardID, thievesPos, unlockCount)
    self.showEffectFlag = self.showEffectFlag or {}
    self.showEffectFlag[cardID] = self.showEffectFlag[cardID] or {}
    self.showEffectFlag[cardID][thievesPos] = self.showEffectFlag[cardID][thievesPos] or {}
    self.showEffectFlag[cardID][thievesPos] = self.showEffectFlag[cardID][thievesPos] or {}
    if not self.showEffectFlag[cardID][thievesPos][unlockCount] then
        self.showEffectFlag[cardID][thievesPos][unlockCount] = true
        return true
    end
end

function ThievesCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

return ThievesCardSwitchItem