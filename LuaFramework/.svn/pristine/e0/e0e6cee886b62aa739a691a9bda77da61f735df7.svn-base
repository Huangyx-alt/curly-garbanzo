local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local SolitaireLogicCard = BaseLogicCard:New("SolitaireLogicCard")
local this = SolitaireLogicCard
this.moduleName = "SolitaireLogicCard"
local bowlTable = {}
local MaxCollectCount = {}
local secondPokerTable = {}

function SolitaireLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    self:BaseInit()
end

function SolitaireLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0, 0, 0}
        secondPokerTable[i] = {{}, {}}
        local secondItems = self.model:GetSecondItemsByCardId(i)
        if secondItems then
            for idx, itemId in ipairs(secondItems) do
                local nominal, suit = self.model:GenNominalValue(itemId)
                table.insert(secondPokerTable[i][suit], nominal)                
            end
            bowlTable[i][1] = #secondPokerTable[i][1]
            bowlTable[i][2] = #secondPokerTable[i][2]
        end
    end
    MaxCollectCount = {13, 13, 1}
end

function SolitaireLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function SolitaireLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function SolitaireLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)    
    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount

    local isAllMax = true
    table.each(bowlTable[cardId], function(v, k)
        isAllMax = isAllMax and v >= MaxCollectCount[k]
    end)
    local curModel = ModelList.BattleModel:GetCurrModel()
    if not curModel:GetRoundData(cardId):GetForbid() and isAllMax then
        curModel:GetRoundData(cardId):SetForbid()
        curModel:GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function SolitaireLogicCard:GetBingoType(cardId, bingoCount)
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

function SolitaireLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

-- function SolitaireLogicCard:IsTypeBingo(cardID, type)
--     cardID = tonumber(cardID)
--     local temp = bowlTable[cardID][type] or 0
--     return temp >= MaxCollectCount[type]
-- end

function SolitaireLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function SolitaireLogicCard:CheckAllCardJackpotHandle(currCardId)
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

function SolitaireLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

function SolitaireLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function SolitaireLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

function SolitaireLogicCard:GetMaxCount(cardId)
    return MaxCollectCount
end

function SolitaireLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    local isValid = false
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= MaxCollectCount[m] then
                if m == 3 then
                    isValid = true
                else
                    bingoCount = bingoCount + 1
                end
            end
        end
    end

    if bingoCount == 2 and isValid then
        bingoCount = 3
    end

    return bingoCount, isValid
end

function SolitaireLogicCard:GetFasterBowlType(cardId, excludeTypes)
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

function SolitaireLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

function SolitaireLogicCard:GetCellsByMaterialType(cardId, type)
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