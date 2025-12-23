local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local MonopolyLogicCard = BaseLogicCard:New("MonopolyLogicCard")
local this = MonopolyLogicCard
this.moduleName = "MonopolyLogicCard"
local bowlTable = {}
local scoreTable = {}
local scoreRecordTable = {}
local MaxCollectCount = {}

function MonopolyLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    self:BaseInit()
end

function MonopolyLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0, 0}
        scoreTable[i] = 0
        scoreRecordTable[i] = {}
    end
    MaxCollectCount = {1, 1}
end

function MonopolyLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
    Event.AddListener(EventName.Event_Logic_Collect_Score, self.AddLogicScore, self)
end

function MonopolyLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
    Event.RemoveListener(EventName.Event_Logic_Collect_Score, self.AddLogicScore, self)
end

function MonopolyLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)    
    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
end

function MonopolyLogicCard:AddLogicScore(cardId, info)
    cardId = tonumber(cardId)
    scoreTable[cardId] = scoreTable[cardId] + info.score
    table.insert(scoreRecordTable[cardId], info)
    --undo
    local isAllMax = false
    local curModel = ModelList.BattleModel:GetCurrModel()
    if not curModel:GetRoundData(cardId):GetForbid() and isAllMax then
        curModel:GetRoundData(cardId):SetForbid()
        curModel:GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

--undo
function MonopolyLogicCard:GetBingoType(cardId, bingoCount)
    bingoCount = bingoCount or 5
    cardId = tonumber(cardId)
    local bingoType = {}
    for i = 1, #bowlTable[cardId] do
        if bowlTable[cardId][i] >= MaxCollectCount[i] then
            table.insert(bingoType, i)
            if #bingoType >= bingoCount then
                break
            end
        end
    end
    return bingoType
end

function MonopolyLogicCard:IsOtherSideHaveOneJackpot(currCardId)
    local otherJackpotId = 0
    if self.model:GetCardCount() == 4 then
        local forbidCount = 0
        for i = 1, 4 do
            if self.model:GetRoundData(i):GetForbid() then
                forbidCount = forbidCount + 1
                if i ~= currCardId then
                    otherJackpotId = i
                end
            end
        end
        if forbidCount == 2 and not (currCardId <= 2 and otherJackpotId <= 2)
                and not (currCardId >= 3 and otherJackpotId >= 3) then
            return otherJackpotId
        else
            return 0
        end
    else
        return 0
    end
end

--undo
function MonopolyLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    return temp >= MaxCollectCount[type]
end

function MonopolyLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function MonopolyLogicCard:CheckAllCardJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    if self:IsAllJackpot() then
        if ModelList.BattleModel:IsGameing() then
            ModelList.BattleModel:GetCurrModel():SetReadyState(2)
            self:WaitUploadSettleData()
        end
    end
end

function MonopolyLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

function MonopolyLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function MonopolyLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

function MonopolyLogicCard:GetMaxCount(cardId)
    return MaxCollectCount
end

function MonopolyLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    local isValid = false
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= MaxCollectCount[m] then
                if m == 4 then
                    isValid = true
                else
                    bingoCount = bingoCount + 1
                end
            end
        end
    end

    if isValid then
        return bingoCount
    else
        return 0
    end
end

function MonopolyLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(bowlTable, function(v, cardID)
        if cardId == cardID then
            table.each(v, function(count, k)
                if count >= MaxCollectCount[k] then
                    return
                end

                local percent = count / (max or 1)
                local include = fun.is_include(k, excludeTypes)
                if (not temp or percent > temp) and not include then
                    temp = percent
                    ret = k
                end
            end)
        end
    end)
    return ret
end

function MonopolyLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

--undo
function MonopolyLogicCard:GetCellsByMaterialType(cardId, type)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v2)
            if 4 == math.floor(v2.id / 10000000) then
                local itemId = Csv.GetData("item_synthetic", v2.id, "itemid")
                local cfg = Csv.GetData("item", itemId, "result")
                if cfg and cfg[2] == type then
                    table.insert(ret, cell)
                end
            end
        end)
    end)
    return ret
end

return this