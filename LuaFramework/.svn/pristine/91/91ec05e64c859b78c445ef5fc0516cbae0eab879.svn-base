local SolitaireCardSwitchItem = BaseChildView:New()
local this = SolitaireCardSwitchItem
this.cardPage = {}
this.itemRoots = {}
local MaxBowlCount = {13, 13, 1}
local cellWidth = 27
local cellHeight = 26.5
local offsetX = 1.5
local offsetY = 6

function SolitaireCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = SolitaireCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function SolitaireCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.Aim1 = ref:Get("Aim1")
        self.Aim2 = ref:Get("Aim2")
        self.JokerArea = ref:Get("JokerArea")
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
        fun.set_gameobject_pos(go, cellWidth * x + offsetX, -cellHeight * y + offsetY, 0, true)
        fun.set_active(go, true)
    end
    table.insert(this.cardPage, page)

    for i = 1, 2 do
        self:UpdateBowlState(self["Aim" .. i], false)
    end
end

function SolitaireCardSwitchItem:ShowAll(go, orderIndex)
    local ref = fun.get_component(go.transform, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.Aim1 = ref:Get("Aim1")
        self.Aim2 = ref:Get("Aim2")
        self.JokerArea = ref:Get("JokerArea")
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
        fun.set_gameobject_pos(go, cellWidth * x + offsetX, -cellHeight * y + offsetY, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
        items[i] = go
    end

    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(orderIndex)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(orderIndex)
    for i = 1, 2 do
        self:UpdateBowlState(self["Aim" .. i], bowlCount[i] >= maxCount[i])
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

function SolitaireCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("SolitaireGetxiaoka", items[i].obj, 1, function(effObj)
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
    local refTemp = fun.get_component(cardObj, fun.REFER)
    for i = 1, 2 do
        self:UpdateBowlState(refTemp:Get("Aim" .. i), bowlCount[i] >= MaxBowlCount[i])
    end
end

function SolitaireCardSwitchItem.OnDispose()
    this.cardPage = {}
    this.itemRoots = {}
    this:Close()
end

function SolitaireCardSwitchItem:UpdateBowlState(bowl, isBingo)
    local ref = fun.get_component(bowl, fun.REFER)
    if ref then
        local curModel = ModelList.BattleModel:GetCurrModel()
        local anima = ref:Get("anima")
        local over = ref:Get("bingo")
        fun.set_active(over, isBingo)
    end
end

return SolitaireCardSwitchItem