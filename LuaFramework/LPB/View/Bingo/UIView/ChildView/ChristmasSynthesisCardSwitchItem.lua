local ChristmasSynthesisCardSwitchItem = BaseChildView:New()
local this = ChristmasSynthesisCardSwitchItem
this.cardPage = {}

function ChristmasSynthesisCardSwitchItem:New(go)
    self = {}
    setmetatable(self, { __index = ChristmasSynthesisCardSwitchItem })
    --self._data = cellData
    return self
end

---初始化switch 分页卡牌
function ChristmasSynthesisCardSwitchItem:InitMap(go, type)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.Gift = ref:Get("Gift")
        self.GiftBG = ref:Get("GiftBG")
    end
    local page = {}
    for i = 1, 25 do
        local go = fun.get_instance(self.img_reap, self.content)
        local img = go:GetComponent(fun.IMAGE)
        local cell = { obj = go, image = img }
        table.insert(page, cell)
        local x = math.modf((i - 1) / 5)
        local y = math.modf((i - 1) % 5)
        fun.set_gameobject_pos(go, 24 * x, -24 * y, 0, true)
        fun.set_active(go, true)
    end
    table.insert(this.cardPage, { page = page, gift = self.Gift, giftBg = self.GiftBG })
end

---初始化切换卡牌父节点
function ChristmasSynthesisCardSwitchItem:InitParentView(parentView)
    this.parentView = parentView
    this.localRecordBingoInfo = {}
end

function ChristmasSynthesisCardSwitchItem:GetCell(cardId, cellIdx)
    if cardId % 2 ~= 0 then
        return this.cardPage[1].page[cellIdx].obj
    else
        return this.cardPage[2].page[cellIdx].obj
    end
end

function ChristmasSynthesisCardSwitchItem:ShowAll(go, orderIndex)
    local ref = fun.get_component(go, fun.REFER)
    if ref then
        self.content = ref:Get("content")
        self.img_reap = ref:Get("img_reap")
        self.Gift = ref:Get("Gift")
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
        fun.set_gameobject_pos(go, 24 * x, -24 * y, 0, true)
        local isNotSign = ModelList.BattleModel:GetCurrModel():GetRoundData(orderIndex, i):IsNotSign()
        fun.set_active(go, isNotSign)
    end
    self:ShowDetailGift(orderIndex, go)
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


function ChristmasSynthesisCardSwitchItem:Refresh(pageIndex, newCard, cardId, signInfo, cardObj)
    local items = this.cardPage[pageIndex].page
    if items then
        local isshowing = false
        for i = 1, #items do
            isshowing = false
            for k, v in pairs(newCard) do
                if i == v.index then
                    isshowing = true
                    items[i].obj.gameObject:SetActive(true)
                    if IsAutoClick(v.cardId, v.index, cardId, signInfo) then
                        BattleEffectCache:GetSkillPrefabFromCache("ChristmasSynthesisgetxiaoka", items[i].obj,
                            function (effObj)
                                if effObj then
                                    fun.set_active(effObj, true)
                                    if fun.is_not_null(effObj.transform.parent) then
                                        fun.set_parent(effObj, effObj.transform.parent.parent)
                                    end
                                end
                            end, 1)
                    end
                    break
                end
            end
            items[i].obj.gameObject:SetActive(not isshowing)
        end
        self:ShowGift(cardId, pageIndex)
    end
end

local function CheckGiftType(cardId)
    local data = CalculateBingoMachine.SeekInfo(3, cardId)
    if data and data.width then ---调用查询接口，查询是否有新形成的bingo
        local bgName = "SDXkDI" .. data.height .. "x" .. data.width
        if data.width * data.height == 9 then
            return "SDLwSmall33", data.firstCellIndex, 6, 0, 0, bgName
        elseif data.width == 3 and data.height == 4 then
            return "SDLwSmall34", data.firstCellIndex, 6, 0.5, 0, bgName
        elseif data.width == 3 and data.height == 5 then
            return "SDLwSmall35", data.firstCellIndex, 11, 0, 0, bgName
        elseif data.width == 4 and data.height == 3 then
            return "SDLwSmall34", data.firstCellIndex, 6, 0, 0.5, bgName
        elseif data.width == 4 and data.height == 4 then
            return "SDLwSmall44", data.firstCellIndex, 6, 0.5, 0.5, bgName
        elseif data.width == 4 and data.height == 5 then
            return "SDLwSmall45", data.firstCellIndex, 11, 0, 0.5, bgName
        elseif data.width == 5 and data.height == 3 then
            return "SDLwSmall35", data.firstCellIndex, 7, 0, 0, bgName
        elseif data.width == 5 and data.height == 4 then
            return "SDLwSmall45", data.firstCellIndex, 7, 0.5, 0, bgName
        elseif data.width == 5 and data.height == 5 then
            return "SDLwSmall56", data.firstCellIndex, 12, 0, 0, nil
        end
    end
    return nil
end

function ChristmasSynthesisCardSwitchItem:ShowGift(cardId, pageIndex)
    local giftName, giftFirstIndex, addIndex, indexOffsetX, indexOffsetY, bgName = CheckGiftType(cardId)
    if not this.localRecordBingoInfo[cardId] then
        this.localRecordBingoInfo[cardId] = {}
    end
    local data = this.localRecordBingoInfo[cardId]
    --if data.firstCellIndex ~= giftFirstIndex or data.bgName ~= bgName then
    if giftName and this.cardPage[pageIndex].gift then
        this.cardPage[pageIndex].gift.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", giftName)
        this.cardPage[pageIndex].gift:SetNativeSize()
        if not bgName then ---5*5的格子 不需要背景
            this.cardPage[pageIndex].giftBg.enabled = false
        else
            this.cardPage[pageIndex].giftBg.enabled = true
            this.cardPage[pageIndex].giftBg.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", bgName)
            this.cardPage[pageIndex].giftBg:SetNativeSize()
        end
        local x = math.modf((giftFirstIndex + addIndex - 1) / 5)
        local y = math.modf((giftFirstIndex + addIndex - 1) % 5)
        fun.set_gameobject_pos(this.cardPage[pageIndex].giftBg.gameObject, 24 * (x + indexOffsetX),
            -24 * (y + indexOffsetY), 0, true)
        fun.set_active(this.cardPage[pageIndex].giftBg, true)
        if this.parentView then
            this.parentView:ShowBingoFont(cardId, pageIndex, giftName)
        end
    else
        fun.set_active(this.cardPage[pageIndex].giftBg, false)
    end
    --this.localRecordBingoInfo[cardId] = { firstCellIndex = giftFirstIndex, bgName = bgName }
    --end

    --if giftName ~= nil and bgName == nil then ---形成jackpot了,需要显示
    --    if giftName and this.cardPage[pageIndex].gift then
    --        this.cardPage[pageIndex].gift.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", giftName)
    --        this.cardPage[pageIndex].gift:SetNativeSize()
    --        this.cardPage[pageIndex].giftBg.enabled = false ---5*5的格子 不需要背景
    --        local x = math.modf((giftFirstIndex + addIndex - 1) / 5)
    --        local y = math.modf((giftFirstIndex + addIndex - 1) % 5)
    --        fun.set_active(this.cardPage[pageIndex].giftBg, true)
    --        fun.set_gameobject_pos(this.cardPage[pageIndex].giftBg.gameObject, 24 * (x + indexOffsetX),
    --            -24 * (y + indexOffsetY), 0, true)
    --    end
    --end
end

function ChristmasSynthesisCardSwitchItem:ShowDetailGift(cardId, cardObj)
    local giftName, giftFirstIndex, addIndex, indexOffsetX, indexOffsetY, bgName = CheckGiftType(cardId)
    local refer = fun.get_component(cardObj, fun.REFER)
    local giftBg = refer:Get("GiftBG")
    if giftName and giftBg then
        local gift = refer:Get("Gift")
        if gift then
            gift.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", giftName)
            gift:SetNativeSize()
        end
        if not bgName then ---5*5的格子 不需要背景
            giftBg.enabled = false
        else
            giftBg.sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisBingoAtlas", bgName)
            giftBg:SetNativeSize()
        end
        local x = math.modf((giftFirstIndex + addIndex - 1) / 5)
        local y = math.modf((giftFirstIndex + addIndex - 1) % 5)
        fun.set_gameobject_pos(giftBg.gameObject, 24 * (x + indexOffsetX),
            -24 * (y + indexOffsetY), 0, true)
        fun.set_gameobject_scale(giftBg.gameObject, 0.9, 0.9, 1)
        fun.set_active(giftBg, true)
    else
        fun.set_active(giftBg, false)
    end
end

function ChristmasSynthesisCardSwitchItem.OnDispose()
    --self._gameObject = nil
    this.cardPage = {}
    this:Close()
end

return ChristmasSynthesisCardSwitchItem
