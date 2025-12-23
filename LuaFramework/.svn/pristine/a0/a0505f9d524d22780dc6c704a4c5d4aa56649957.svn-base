local GotYouCardSwitchItem = BaseChildView:New()
local this = GotYouCardSwitchItem
this.cardPage = {}

function GotYouCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = GotYouCardSwitchItem })
    --self._data = cellData
    return self
end

local MaxBowlCount = 5

---初始化switch 分页卡牌
function GotYouCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
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
       -- self:SetCellColor(i, go)
    end
    table.insert(this.cardPage, page)

    for i = 1, 3 do
        self:UpdateBowlState(i, self["bowl" .. i], 0, MaxBowlCount, type + 3)
    end
end

function GotYouCardSwitchItem:ShowAll(go, orderIndex)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
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
       -- self:SetCellColor(i, go)
    end
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(orderIndex)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(orderIndex)
    for i = 1, #bowlCount do
        self:UpdateBowlState(i, self["bowl" .. i], bowlCount[i], maxCount[i], orderIndex)
    end
end

function GotYouCardSwitchItem:SetCellColor(index, cellObj)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local color = curModel:GetCellColor(index)
    local imgName = "pigdeQhCard0" .. color
    local img = cellObj:GetComponent(fun.IMAGE)
    img.sprite = AtlasManager:GetSpriteByName("GotYouBingoAtlas", imgName)
end

function GotYouCardSwitchItem:UpdateBowlState(col, bowl, curCollect, target, cardId)
    local ref = fun.get_component(bowl, fun.REFER)
    if ref then
        local hourse1 = ref:Get("hourse1")
        local hourse2 = ref:Get("hourse2")
        local hourse3 = ref:Get("hourse3")
        local over = ref:Get("over")
        if curCollect >= target then
            fun.set_active(over, true)
            fun.set_active(hourse1, false)
            fun.set_active(hourse2, false)
            fun.set_active(hourse3, true)
        else
            fun.set_active(over, false)
            fun.set_active(hourse1, curCollect == 0)
            fun.set_active(hourse2, curCollect > 0)
            fun.set_active(hourse3, false)
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

function GotYouCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        --local anim = fun.get_component(items[i].obj,fun.ANIMATOR)
                        --if anim then        anim:Play("in")           end
                        BattleEffectCache:GetFreePrefabFromCache("GotYougetxiaoka", items[i].obj, 1, function(effObj)
                            if effObj then
                                fun.set_active(effObj, true)
                                if fun.is_not_null(effObj.transform.parent)  then
                                    fun.set_parent(effObj, effObj.transform.parent.parent)
                                end
                            end
                        end)
                        --local obj = BattleEffectPool:Get("CellGet",items[i].obj.gameObject)
                        --fun.set_active(obj,false)
                        --fun.set_active(obj,true)
                        --fun.set_gameobject_scale(obj,0.1,0.1,1)
                        --BattleEffectPool:DelayRecycle("CellGet",obj,2)
                    end
                    break
                end
            end
            items[i].obj.gameObject:SetActive(not isshowing)
        end
    end

    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local refTemp = fun.get_component(cardObj, fun.REFER)
    for i = 1, #bowlCount do
        --fun.set_active(refTemp:Get("bowl" .. i), bowlCount[i] >= MaxBowlCount)
        self:UpdateBowlState(i, refTemp:Get("bowl" .. i), bowlCount[i], MaxBowlCount, cardId)
    end
end

function GotYouCardSwitchItem.OnDispose()
    --self._gameObject = nil
    this.cardPage = {}
    this:Close()
end

return GotYouCardSwitchItem