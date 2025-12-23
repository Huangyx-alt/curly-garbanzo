local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class SolitaireGameCardView : GameCardView
local SolitaireGameCardView = GameCardView:New("SolitaireGameCardView")
local this = SolitaireGameCardView

local private = {}
local bowlCount = {}
local newBingoType = {}
local secondPokerTable = {}

local interval = 0
local timeMemory = 0
local MaxCountMap = {13, 13, 1}

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
        bowlCount[i] = {0, 0, 0}
        newBingoType[i] = {}
        secondPokerTable[i] = {{}, {}}
        local secondItems = self.model:GetSecondItemsByCardId(i)
        if secondItems then
            for idx, itemId in ipairs(secondItems) do
                local nominal, suit = self.model:GenNominalValue(itemId)
                table.insert(secondPokerTable[i][suit], nominal)                
            end
            bowlCount[i][1] = #secondPokerTable[i][1]
            bowlCount[i][2] = #secondPokerTable[i][2]
        end
    end
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:InitCardData()
    self:SetDefaultOpenCell()
end

function this:InitCardData()
    self.cellBgEffectList = {}

    table.each(self.model:GetRoundData(), function(cardData, cardID)
        local temp = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                local data = Csv.GetData("item", treasureItems.id)
                if 46 == data.item_type then
                    --local groupId = treasureItems.groupid
                    local groupId = this.model:ItemId2Group(treasureItems.id)
                    if groupId then
                        temp[groupId] = temp[groupId] or {}
                        table.insert(temp[groupId], cellData)
                    else
                        log.log("SolitaireGameCardView:InitCardData group error", treasureItems, data)
                    end
                else
                    log.log("SolitaireGameCardView:InitCardData treasureItems error", treasureItems)
                end
            end
        end)
        log.log("SolitaireGameCardView:InitCardData temp ", temp)
        table.each(temp, function(cellDatas, groupID)
            table.each(cellDatas, function(cellData)
                local treasureItems = cellData:Treasure2Item()
                local nominalValue = self.model:GenNominalValue(treasureItems.id)
                cellData:SetExtInfo({ groupID = groupID, groupCells = cellDatas, nominalValue = nominalValue})
            end)
        end)
    end)
end

--- 设置默认打开的格子undo
function this:SetDefaultOpenCell()
    local currModel = ModelList.BattleModel:GetCurrModel()
    local loadData = currModel:LoadGameData()
    for i = 1, #self.cardMap do
        local cellIndex = {13}
        if loadData and loadData.cardsInfo then
            for i = 1, #loadData.cardsInfo do
                local id = loadData.cardsInfo[i].cardId
                if tostring(id) == tostring(loadData.cardsInfo[i].cardId) then
                    cellIndex = loadData.cardsInfo[i].beginMarkedPos
                    break
                end
            end
        end
        for m = 1, #cellIndex do
            local cell =  ConvertServerPos(cellIndex[m])
            local obj = self.cardMap[i][cell]
            self:SignCardEffect(i, cell , obj, 0, 0, false, 0)
            if not self.model:GetRoundData() then
                return
            end
            self.model:RefreshRoundDataByIndex(i, cell, 1, false, -1)
            Event.Brocast(EventName.CardPower_Sign_Cell, i, cell)
        end
    end
end

function this:on_x_update()
    this.__index.on_x_update(self)
end

function this:GetCollectiveMaxCount(collectiveType)
    --return Csv.GetCollectiveMaxCountt(collectiveType)
    if MaxCountMap[collectiveType] then
        return MaxCountMap[collectiveType]
    else
        log.log("SolitaireGameCardView:GetCollectiveMaxCount error collectiveType is ", collectiveType)
        return 1
    end
end

function this:AddBowlWater(cardId, bowlType, extra)
    cardId = tonumber(cardId)
    local addCount = 1
    local maxCount = this:GetCollectiveMaxCount(bowlType)
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
        if bowlCount[cardId][i] >= this:GetCollectiveMaxCount(i) then
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
    return bowlCount[cardId][drinkType] >= this:GetCollectiveMaxCount(drinkType)
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

function this:ShowCustomizedStageAfterRocket(finishCb)
    local cardCount = self.model:GetCardCount()
    local needWaitFlag = false
    for i = 1, cardCount do
        if self:GetCard(i):ShowCustomizedStageAfterRocket(i) then
            needWaitFlag = true
        end
    end
    
    if needWaitFlag then
        LuaTimer:SetDelayFunction(2.5, function()
            if finishCb then
                finishCb()
            end
        end, nil, LuaTimer.TimerType.Battle)
    else
        if finishCb then
            finishCb()
        end
    end
end

function this:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
    Event.AddListener(EventName.Show_Customized_State_After_Rocket, self.ShowCustomizedStageAfterRocket, self)
end

function this:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
    Event.RemoveListener(EventName.Show_Customized_State_After_Rocket, self.ShowCustomizedStageAfterRocket, self)
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

function this:OnGameReady()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):OnGameReady(i)
    end
    --UISound.play("wait sound")
end

function this:ReadyShowBingo(cardId, bingoType)
    self:GetCard(cardId):ReadyShowBingo(cardId, bingoType)
end

function this:ShowBingoFinish(cardId, bingoType)
    self:GetCard(cardId):ShowBingoFinish(cardId, bingoType)
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

return this