local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class PiggyBankGameCardView : GameCardView
local PiggyBankGameCardView = GameCardView:New("PiggyBankGameCardView")
local this = PiggyBankGameCardView

local private = {}
local bowlCount = {}
local newBingoType = {}

local interval = 0
local timeMemory = 0

local ItemIdMap = {
    "231001","231002","231003"
}

function this:OnEnable(bingoView, bingosiRef, is_open_search)
    self:BaseEnable(bingoView, bingosiRef, is_open_search)
    self:InitCardBowls()
end

function this:OnDisable()
    getmetatable(self).OnDisable(self)
    interval = 0
    timeMemory = 0
end

function this:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlCount[i] = { 0, 0, 0, 0 }
        newBingoType[i] = {}
    end
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:InitCardData()
end

function this:InitCardData()
    self.cellBgEffectList = {}

    table.each(self.model:GetRoundData(), function(cardData, cardID)
        local temp = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                local data = Csv.GetData("new_item", treasureItems.id)
                if 11 == data.result[1] then
                    --local groupId = treasureItems.groupid
                    local groupId = data.result[3]
                    if groupId then
                        temp[groupId] = temp[groupId] or {}
                        table.insert(temp[groupId], cellData)
                    else
                        log.log("PiggyBankGameCardView:InitCardData group error", treasureItems, data)
                    end
                else
                    log.log("PiggyBankGameCardView:InitCardData treasureItems error", treasureItems)
                end
            end
        end)

        table.each(temp, function(cellDatas, groupID)
            table.each(cellDatas, function(cellData)
                cellData:SetExtInfo({ groupID = groupID, groupCells = cellDatas })
            end)
        end)

        self:GetCard(cardID):InitCollectionLocation(deep_copy(temp))
    end)
end

function this:on_x_update()
    this.__index.on_x_update(self)
end

function this:AddBowlWater(cardId, bowlType, extra)
    cardId = tonumber(cardId)
    local addCount = 1
    local maxCount = Csv.GetCollectiveMaxCount(bowlType)
    if bowlCount[cardId][bowlType] < maxCount and bowlCount[cardId][bowlType] + addCount >= maxCount then
        table.insert(newBingoType[cardId], bowlType)
    end

    local lastCount = bowlCount[cardId][bowlType]
    local curCount = lastCount + addCount
    bowlCount[cardId][bowlType] = curCount

    local bowlCountRecord = deep_copy(bowlCount)
    self:GetCard(cardId):AddBowlDrink(bowlCountRecord, cardId, bowlType, lastCount, curCount, extra)
end

function this:GetBingoType(cardId, bingoCount)
    cardId = tonumber(cardId)
    local bingoType = {}
    for i = 1, #bowlCount[cardId] do
        if bowlCount[cardId][i] >= Csv.GetCollectiveMaxCount(i) then
            table.insert(bingoType, i)
            if #bingoType >= bingoCount then
                break
            end
        end
    end
    local tType = 1
    if #newBingoType[cardId] > 0 then
        tType = newBingoType[cardId][1]
        table.remove(newBingoType[cardId], 1)
    else
        tType = bingoType[1]
    end
    return bingoType, tType
end

function this:IsDrinkMax(cardId, drinkType)
    cardId = tonumber(cardId)
    return bowlCount[cardId][drinkType] >= Csv.GetCollectiveMaxCount(drinkType)
end

function this:JackpotCardMoveBackground(currCardId, moveCardId, currIndex, moveIndex)
    local card1 = self:GetCardMap(currCardId)
    local card2 = self:GetCardMap(moveCardId)
    if card2 then
        local switchPos = self:GetParentView():GetSwitchView():GetSmallCardObj(moveIndex)
        local oriPos = card2.transform.localScale
        fun.set_same_position_with(card2, switchPos)
        fun.set_gameobject_scale(card2, 0.2, 0.2, 1)
        Anim.scale_to_xy(card2, oriPos.x, oriPos.y, 1)
        local cardPos = card1.transform.position
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):EnterDoubleJackpotChangeCard()
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos = card1.transform.localPosition
        Anim.move(card1, currPos.x - 2000, currPos.y, currPos.z, 1, true, true)
    end
end

function this:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:StorageCellBgEffect(cardId, cellIndex, effect)
    local isContain = false
    if not self.cellBgEffectList[cardId] then
        self.cellBgEffectList[cardId] = {}
    end
    for i = 1, #self.cellBgEffectList[cardId] do
        if self.cellBgEffectList[cardId][i].cellIndex == cellIndex then
            table.insert(self.cellBgEffectList[cardId][i].effectList, effect)
            isContain = true
            break
        end
    end
    if not isContain then
        table.insert(self.cellBgEffectList[cardId], { cellIndex = cellIndex, effectList = { effect } })
    end
end

function this:GetCellBgEffect(cardId, cellIndex)
    if not self.cellBgEffectList[cardId] then
        return nil
    end
    for i = 1, #self.cellBgEffectList[cardId] do
        if self.cellBgEffectList[cardId][i].cellIndex == cellIndex then
            return self.cellBgEffectList[cardId][i].effectList
        end
    end
    return nil
end

function this:GetFlyTargetPos(cardId, itemType)
    return Vector3.zero
end

function this:PreviewPigLocation()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):PreviewPigLocation(i)
    end
    UISound.play("piggybankshow")
end

function this:ReadyShowBingo(cardId, bingoType)
    self:GetCard(cardId):ReadyShowBingo(cardId, bingoType)
end

function this:ShowBingoFinish(cardId, bingoType)
    self:GetCard(cardId):ShowBingoFinish(cardId, bingoType)
end

function this:ActiveUpgradePu(puIdx, cardId)
    self:GetCard(cardId):ActiveUpgradePu(puIdx, cardId)
end

function this:GetUpgradeBingoItems()
    local cardCount = self.model:GetCardCount()
    local cardAddPUBingoItems = {}
    for i = 1, cardCount do
        local info = {}
        info.cardId = i
        info.bingoItems = {}
        local bl = self:GetCard(i):GetItemBreakenList(i)
        for idx, piggy in ipairs(bl) do
            if piggy.upgraded then
                table.insert(info.bingoItems, ItemIdMap[piggy.itemType])
            end
        end
        table.insert(cardAddPUBingoItems, info)
    end

    return cardAddPUBingoItems
end

----------------------------------GM------------------------------------

local startId = 1
---每次调用将一张卡牌上的jackpot图案相关格子盖章
function this:GmSignTest()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        coroutine.start(function()
            table.each(jackpotRule, function(cellIndex)
                self:OnClickCardIgnoreJudgeByIndex(startId, cellIndex, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end)
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    else
        coroutine.start(function()
            for i = 25, 1, -1 do
                view:OnClickCardIgnoreJudgeByIndex(startId, i, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    end
end

---------------------------------------------------------------

function private.GetRoundCell(cardId, cellIndexs, groupid, step)
    local roundcell = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndexs[step])
    local treasureItems = nil
    if roundcell then
        treasureItems = roundcell:Treasure2Item()
    end

    if treasureItems and groupid == treasureItems.groupid then
        local ext = roundcell:GetExtInfo()

        if ext and ext.groupID then
            return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
        else
            return roundcell, step
        end
    elseif step < #cellIndexs then
        return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
    else
        return roundcell, step
    end
end

function private.GetRoundIndex(treasureItems, cellIndex)
    local ret
    local borderList = { 1, 6, 11, 16, 21, 5, 10, 15, 20, 25 }
    local isBorder = fun.is_include(cellIndex, borderList)

    if treasureItems.part == 1 then
        if treasureItems.isPivot then
            ret = { cellIndex + 5, cellIndex - 5, cellIndex + 1, cellIndex - 1 }
        else
            ret = { cellIndex - 5, cellIndex + 5, cellIndex - 1, cellIndex + 1 }
        end
    else
        if treasureItems.isPivot then
            if isBorder then
                ret = { cellIndex - 1, cellIndex + 1, cellIndex + 5, cellIndex - 5 }
            else
                ret = { cellIndex + 1, cellIndex - 1, cellIndex + 5, cellIndex - 5 }
            end
        else
            ret = { cellIndex - 1, cellIndex + 1, cellIndex + 5, cellIndex - 5 }
        end
    end

    return ret
end

return this