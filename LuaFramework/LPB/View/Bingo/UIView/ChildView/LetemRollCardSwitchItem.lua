local LetemRollCardSwitchItem = BaseChildView:New()
local this = LetemRollCardSwitchItem
this.cardPage = {}

function LetemRollCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = LetemRollCardSwitchItem })
    --self._data = cellData
    return self
end

local MaxBowlCount = 4

---初始化switch 分页卡牌
function LetemRollCardSwitchItem:InitMap(go, type)
    self:MountObj(go)
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
        --self:SetCellColor(i, go)
    end
    table.insert(this.cardPage, page)
    self:InitCollectProgress()
    self:InitBingoTip()
end

function LetemRollCardSwitchItem:MountObj(go)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.bowl1 = ref:Get("bowl1")
        self.bowl2 = ref:Get("bowl2")
        self.bowl3 = ref:Get("bowl3")
        self.bowl4 = ref:Get("bowl4")
        self.bowl5 = ref:Get("bowl5")
        self.imgBingo = ref:Get("imgBingo")
    end
end

function LetemRollCardSwitchItem:ShowAll(go, orderIndex)
    self:MountObj(go)
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
        --self:SetCellColor(i, go)
    end
    self:InitCollectProgress()
    self:InitBingoTip()

    self:UpdateCollectProgress(nil, orderIndex)
end

function LetemRollCardSwitchItem:SetCellColor(index, cellObj)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local color = curModel:GetCellColor(index)
    local imgName = "YahtzeeQhCard0" .. color
    local img = cellObj:GetComponent(fun.IMAGE)
    img.sprite = AtlasManager:GetSpriteByName("LetemRollBingoAtlas", imgName)
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

function LetemRollCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
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
                        BattleEffectCache:GetFreePrefabFromCache("LetemRollgetxiaoka", items[i].obj, 1, function(effObj)
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

    self:UpdateCollectProgress(fun.get_component(cardObj, fun.REFER), cardId)
end

function LetemRollCardSwitchItem.OnDispose()
    --self._gameObject = nil
    this.cardPage = {}
    this:Close()
end

function LetemRollCardSwitchItem:InitCollectProgress()
    for i = 1, 5 do
        local ref = self["bowl" .. i]
        local bg1 = ref:Get("bg1")
        local bg2 = ref:Get("bg2")
        local imgDice = ref:Get("imgDice")
        local imgDice6 = ref:Get("imgDice6")
        local dice = ref:Get("dice")
        fun.set_active(bg1, true)
        fun.set_active(bg2, false)
        fun.set_active(dice, false)
    end
end

function LetemRollCardSwitchItem:InitBingoTip()
    fun.set_active(self.imgBingo, false)
end

function LetemRollCardSwitchItem:UpdateCollectProgress(ref, cardId)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    
    for i = 1, 5 do
        local itemObj = nil
        local curModel = ModelList.BattleModel:GetCurrModel()
        local location = curModel:GetCollectTargetLocation(tonumber(cardId), i)
        if fun.is_not_null(ref) then
            itemObj = ref:Get("bowl" .. location)
        else
            itemObj = self["bowl" .. location]
        end
        self:ActiveItem(itemObj, location, bowlCount, maxCount, i)
    end

    if fun.is_not_null(ref) then
        self:UpdateBingoState(ref:Get("imgBingo"), bowlCount, maxCount)
    else
        self:UpdateBingoState(self.imgBingo, bowlCount, maxCount)
    end
end

function LetemRollCardSwitchItem:UpdateBingoState(imgBingo, bowlCount, maxCount)
    local contition1 = bowlCount[1] >= maxCount[1]
    local contition2 = bowlCount[2] >= maxCount[2]
    local contition3 = bowlCount[3] >= maxCount[3]

    fun.set_active(imgBingo, contition1)
    if contition2 and contition3 then
        imgBingo.sprite = AtlasManager:GetSpriteByName("LetemRollBingoAtlas", "YahtzeebCBingo3")
    elseif contition2 or contition3 then
        imgBingo.sprite = AtlasManager:GetSpriteByName("LetemRollBingoAtlas", "YahtzeebCBingo2")
    else
        imgBingo.sprite = AtlasManager:GetSpriteByName("LetemRollBingoAtlas", "YahtzeebCBingo1")
    end
end

function LetemRollCardSwitchItem:ActiveItem(ref, index, bowlCount, maxCount, logicIdx)
    if fun.is_null(ref) then
        return
    end

    local bg1 = ref:Get("bg1")
    local bg2 = ref:Get("bg2")
    local imgDice = ref:Get("imgDice")
    local imgDice6 = ref:Get("imgDice6")
    local dice = ref:Get("dice")
    fun.set_active(bg1, true)
    fun.set_active(bg2, false)
    if index < 4 then
        fun.set_active(imgDice, true)
        fun.set_active(imgDice6, false)
        fun.set_active(imgDice6, bowlCount[1] >= 5 and (bowlCount[2] >= maxCount[2] or bowlCount[3] >= maxCount[3]))
        fun.set_active(bg2, bowlCount[1] >= index)
    elseif index == 4 then
        fun.set_active(imgDice, true)
        fun.set_active(imgDice6, bowlCount[1] >= 5 and (bowlCount[2] >= maxCount[2] or bowlCount[3] >= maxCount[3]))
        fun.set_active(bg2, bowlCount[1] >= 5 and (bowlCount[2] >= maxCount[2] or bowlCount[3] >= maxCount[3]))
    elseif index == 5 then
        fun.set_active(imgDice, true)
        fun.set_active(imgDice6, bowlCount[1] >= 5 and bowlCount[2] >= maxCount[2] and bowlCount[3] >= maxCount[3])
        fun.set_active(bg2, bowlCount[1] >= 5 and bowlCount[2] >= maxCount[2] and bowlCount[3] >= maxCount[3])
    end

    fun.set_active(dice, bowlCount[1] >= logicIdx)
end

return LetemRollCardSwitchItem