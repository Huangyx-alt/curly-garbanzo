local DrinkingFrenzyCardSwitchItem = BaseChildView:New()
local this = DrinkingFrenzyCardSwitchItem
this.cardPage = {}
this.itemRoots = {}
this.showEffectList = {}

function DrinkingFrenzyCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = DrinkingFrenzyCardSwitchItem })
    return self
end

local MaxBowlCount = 4
local maxBowlCount =
{
    [1] = 4,
    [2] = 4,
    [3] = 1,
    [4] = 1
}

---初始化switch 分页卡牌
function DrinkingFrenzyCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        self.ItemCtrlTempSmall = ref:Get("ItemCtrlTempSmall")
        self.ItemCtrlTempBig = ref:Get("ItemCtrlTempBig")
        self.glassParent = ref:Get("glassParent")
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
        fun.set_gameobject_pos(go, 26.824 * x, -26.8 * y, 0, true)
        fun.set_active(go, true)
    end
    table.insert(this.cardPage, page)
    table.insert(this.itemRoots, self.ItemCtrlTempSmall.transform.parent)
    
    LuaTimer:SetDelayFunction(1, function()
        self:InitItemRewardCtrl()
    end,nil,LuaTimer.TimerType.Battle)
end


---计算每个卡牌上星星的位置
function DrinkingFrenzyCardSwitchItem:InitItemRewardCtrl()
    self.itemGroups = {}
    LuaTimer:SetDelayFunction(2, function()
        local curModel = ModelList.BattleModel:GetCurrModel()
        table.each(curModel:GetRoundData(), function(cardData, cardID)
            cardID = tonumber(cardID)
            local temp = {}
            table.each(cardData.cards, function(cellData)
                local treasureItems = cellData:Treasure2Item()
                if treasureItems then
                    temp[treasureItems.id] = temp[treasureItems.id] or {}
                    table.insert(temp[treasureItems.id], cellData)
                end
            end)
            self.itemGroups[cardID] = {}
            table.each(temp, function(cells, itemId)
                self.itemGroups[cardID][itemId] = {}
                table.each(cells, function(cellData)
                    local cellIndex = cellData.index
                    table.insert(self.itemGroups[cardID][itemId], cellIndex)
                end)
            end)
        end)
        log.log("计算小卡片数据" , self.itemGroups)
    end, nil, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzyCardSwitchItem:ShowAll(go, orderIndex)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        self.ItemCtrlTempSmall = ref:Get("ItemCtrlTempSmall")
        self.ItemCtrlTempBig = ref:Get("ItemCtrlTempBig")
        self.glassParent = ref:Get("glassParent")
    end
    local childCount = fun.get_child_count(self.content)
    for i = childCount, 1, -1 do
        if fun.get_child(self.content, i - 1).gameObject.activeSelf then
            Destroy(fun.get_child(self.content, i - 1).gameObject)
        end
    end
    for i = 1, 25 do
        local go = fun.get_instance(self.img_reap, self.content)
        fun.set_active(go, false, 0)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(go, 26.824 * x, -26.8 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
    end

    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(orderIndex)
    --local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(orderIndex)
    --log.log("测试小卡片bingo showall" , cardId , bowlCount)
    for i = 1, #bowlCount do
        fun.set_active(self["bowl" .. i], bowlCount[i] >= maxBowlCount[i])
    end
    if self.cardIems then
        for k , v in pairs(self.cardIems) do
            for z ,w in pairs(v) do
                fun.set_active(w.itemCtrl, false)
            end
        end    
    end
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

function DrinkingFrenzyCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
    --log.log("创建小格子酒杯 Refresh" , pageIndex  , cardId )
    --self:TurnCardHideEffect()
    local items = this.cardPage[pageIndex]
    if items then
        local isshowing = false
        for i = 1, #items do
            isshowing = false
            for k, v in pairs(newCard) do
                if i == v.index then
                    isshowing = true
                    items[i].obj.gameObject:SetActive(true)
                    break
                end
            end
            items[i].obj.gameObject:SetActive(not isshowing)
        end
    end
    self:ShowItemRewardCtrl(pageIndex, cardId)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local refTemp = fun.get_component(cardObj, fun.REFER)
    --log.log("测试小卡片bingo refresh" , cardId , bowlCount)
    for i = 1, #bowlCount do
        fun.set_active(refTemp:Get("bowl" .. i), bowlCount[i] >= maxBowlCount[i])
    end


end

function DrinkingFrenzyCardSwitchItem:ShowItemRewardCtrl(pageIndex, cardID)
    --标识pageindex是否有显示
    self.pageCtrls = self.pageCtrls or {}
    if GetTableLength(self.pageCtrls[pageIndex]) > 0 then
        table.each(self.pageCtrls[pageIndex], function(v)
            fun.set_active(v.itemCtrl, false)
        end)
    end
    self.pageCtrls[pageIndex] = {}

    --log.log("创建小格子酒杯 ShowItemRewardCtrl" , pageIndex  , cardID )
    --每个card的星星
    self.cardIems = self.cardIems or {}
    if self.cardIems[cardID] then
        table.each(self.cardIems[cardID], function(v)
            --更新明暗状态
            local isBroken = self:IsBroken(cardID, v.itemId,v.cardIndex)
            if isBroken and v.cardId == cardID then
                fun.set_same_position_with(v.itemCtrl, cellObj)
                fun.set_active(v.itemCtrl, true)
                --self:AddShowEffect(v.itemCtrl)
            end
        end)

        self.pageCtrls[pageIndex] = self.cardIems[cardID]
    else
        self.cardIems[cardID] = {}
        local items = this.cardPage[pageIndex]
        local groups = self.itemGroups[cardID]
        table.each(groups, function(cells, itemId)
            local root = this.itemRoots[pageIndex]
            if itemId == 261001 then
                for k, v in pairs(cells) do
                    local copyItem = self:GetSignEffect(cardID,itemId)
                    local itemObj = items[v].obj
                    local itemCtrl = fun.get_instance(copyItem, self.glassParent)
                    fun.set_active(itemCtrl, false)
                    local pos = itemObj.transform.position
                    fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)
                    --itemCtrl.transform.name = string.format("%s%s","testCellSmall:" , cardID )
                    --log.log("添加酒杯格子数据up" , v)
                    table.insert(self.cardIems[cardID], {
                        itemId = itemId,
                        itemCtrl = itemCtrl,
                        cardIndex = v,
                        cardId = cardID
                    })
                    local isBroken = self:IsBroken(cardID, itemId,v )
                    if isBroken then
                        fun.set_active(itemCtrl, true)
                        self:AddShowEffect(itemCtrl)
                    end
                end
            elseif itemId == 261002 or itemId == 261003 then
                local pos = Vector3.zero
                local logIndex = ""
                table.each(cells, function(index)
                    local cellObj = items[index].obj
                    pos = pos + cellObj.transform.position
                    logIndex = logIndex .. "_" .. index
                end)
                pos = pos / GetTableLength(cells)
                local itemObj = self:GetSignEffect(cardID,itemId)
                local itemCtrl = fun.get_instance(itemObj, self.glassParent)
                --itemCtrl.transform.name = string.format("%s%s","testCellBig:" , cardID )
                --itemCtrl.transform.name = string.format("%s%s%s%s%s","testCellBig:" , logIndex , "pos" , pos.x , pos.y)
                fun.set_active(itemCtrl, false)
                fun.set_gameobject_pos(itemCtrl, pos.x, pos.y, pos.z, false)
                table.insert(self.cardIems[cardID], {
                    itemId = itemId,
                    itemCtrl = itemCtrl,
                    cardIndex = v,
                    cardId = cardID
                })
                local isBroken = self:IsBroken(cardID, itemId)
                if isBroken then
                    fun.set_active(itemCtrl, true)
                    self:AddShowEffect(itemCtrl)
                end
            end
        end)
    end
end

function DrinkingFrenzyCardSwitchItem:IsBroken(cardId, itemId, cellIndex)
    if itemId == 261001 or itemId ==  261002 or itemId == 261003 then
        local ret1 = self:IsGroupCellAllSigned(cardId, itemId ,cellIndex)
        return ret1
    end

    return false
end


function DrinkingFrenzyCardSwitchItem:IsGroupCellAllSigned(cardID, itemId,cellIndex)
    local groups = self.itemGroups and self.itemGroups[cardID]
    if not groups then
        return false
    end
    local cells = groups[itemId]
    if not cells then
        return false
    end

    if itemId == 261001 then
        local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID, cellIndex)
        local signed = not cellData:IsNotSign()
        return signed
    elseif itemId == 261002 or itemId ==261003 then
        local ret = true
        table.each(cells, function(index)
            local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardID, index)
            local signed = not cellData:IsNotSign()
            ret = ret and signed
        end)
        return ret
    end
end

function DrinkingFrenzyCardSwitchItem:GetSignEffect(cardID, itemId)
    if itemId == 261001 then
        return self.ItemCtrlTempSmall
    elseif itemId == 261002 then
        return self.ItemCtrlTempBig
    elseif itemId == 261003 then
        return self.ItemCtrlTempBig
    end
end

function DrinkingFrenzyCardSwitchItem:AddShowEffect(obj)
    table.insert(this.showEffectList , obj)
end

function DrinkingFrenzyCardSwitchItem:TurnCardHideEffect()
    for k,v in pairs(this.showEffectList) do
        fun.set_active(v,false)
    end
    this.showEffectList = {}
end

function DrinkingFrenzyCardSwitchItem.OnDispose()
    --self._gameObject = nil
    this.cardPage = {}
    this.itemRoots = {}
    this.showEffectList = {}
    this:Close()
end

return DrinkingFrenzyCardSwitchItem