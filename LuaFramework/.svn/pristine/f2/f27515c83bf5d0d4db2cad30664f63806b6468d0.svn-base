local GoldenTrainCardSwitchItem = BaseChildView:New()
local this = GoldenTrainCardSwitchItem
this.cardPage = {}

function GoldenTrainCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = GoldenTrainCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function GoldenTrainCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
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
        fun.set_active(go, i ~= 13)
    end
    table.insert(this.cardPage, page)
end


function GoldenTrainCardSwitchItem:GetCell(cardId, cellIdx)
    if cardId % 2 ~= 0 then
        return this.cardPage[1][cellIdx].obj
    else
        return this.cardPage[2][cellIdx].obj
    end
end

function GoldenTrainCardSwitchItem:ShowAll(go, orderIndex)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
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

function GoldenTrainCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("GoldenTraingetxiaoka", items[i].obj, 1, function(effObj)
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
end

function GoldenTrainCardSwitchItem.OnDispose()
    --self._gameObject = nil
    this.cardPage = {}
    this:Close()
end

return GoldenTrainCardSwitchItem