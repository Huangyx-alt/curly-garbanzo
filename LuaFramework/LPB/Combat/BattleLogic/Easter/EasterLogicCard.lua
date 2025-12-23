local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")
local EasterLogicCard = BaseLogicCard:New("EasterLogicCard")
local this = EasterLogicCard
this.moduleName = "EasterLogicCard"
local itemCount = {}
local MaxCollectCount = {}

function EasterLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    self:BaseInit()
end

function EasterLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        itemCount[i] = { 0, 0, 0, 0, 0 }
    end
    MaxCollectCount = { 1, 1, 1, 1, 1 }
end

function EasterLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.LogicCollectItem, self)
end

function EasterLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.LogicCollectItem, self)
end

function EasterLogicCard:LogicCollectItem(cardId, cellIndex, itemType, addCount)
    cardId = tonumber(cardId)
    itemCount[cardId][itemType] = itemCount[cardId][itemType] + addCount

    local isAllMax = true
    table.each(itemCount[cardId], function(v, k)
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

function EasterLogicCard:GetBingoType(cardId, bingoCount)
    bingoCount = bingoCount or 5
    cardId = tonumber(cardId)
    local bingoType = {}
    for i = 1, #itemCount[cardId] do
        if itemCount[cardId][i] >= MaxCollectCount[i] then
            table.insert(bingoType, i)
            if #bingoType >= bingoCount then
                break
            end
        end
    end
    return bingoType
end

function EasterLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function EasterLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = itemCount[cardID][type] or 0
    return temp >= MaxCollectCount[type]
end

function EasterLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function EasterLogicCard:CheckAllCardJackpotHandle(currCardId)
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

function EasterLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

function EasterLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function EasterLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    return itemCount[cardId]
end

function EasterLogicCard:GetMaxCount(cardId)
    return MaxCollectCount
end

function EasterLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    if itemCount and itemCount[cardId] then
        for m = 1, #itemCount[cardId] do
            if itemCount[cardId][m] >= MaxCollectCount[m] then
                bingoCount = bingoCount + 1
            end
        end
    end
    return bingoCount
end

function EasterLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(itemCount, function(v, cardID)
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

function EasterLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

function EasterLogicCard:GetCellsByMaterialType(cardId, type)
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