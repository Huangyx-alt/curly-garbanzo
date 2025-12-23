local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local DragonFortuneLogicCard = BaseLogicCard:New("DragonFortuneLogicCard")
local this = DragonFortuneLogicCard
this.moduleName = "DragonFortuneLogicCard"
local bowlTable = {}
local MaxCollectCount = {}

function DragonFortuneLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    self:BaseInit()
end

function DragonFortuneLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()

    local loadData = ModelList.BattleModel:GetBackupLoadData()
    if loadData then
        local ruleData = Csv.GetData("new_bingo_rule", loadData.bingoRuleId[i])
        if ruleData then
            local treasureCount = #ruleData.params
            for i = 1, cardCount do
                local tb = {}
                for j = 1, treasureCount do
                    table.insert(tb, 0)
                end
                bowlTable[i] = tb
            end
            table.each(ruleData.params, function(v, index)
                MaxCollectCount[index] = v[2]
            end)
            return
        end
    end

    for i = 1, cardCount do
        bowlTable[i] = { 0, 0, 0, 0}
    end
    MaxCollectCount = { 1, 1, 1, 1 }
end

function DragonFortuneLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function DragonFortuneLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function DragonFortuneLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    if isMax then
        addCount = Csv.GetCollectiveMaxCount(bowlType, playid) - bowlTable[cardId][bowlType]
    end
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

function DragonFortuneLogicCard:GetBingoType(cardId, bingoCount)
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

function DragonFortuneLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function DragonFortuneLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    return temp >= MaxCollectCount[type]
end

function DragonFortuneLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function DragonFortuneLogicCard:CheckAllCardJackpotHandle(currCardId)
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

function DragonFortuneLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

function DragonFortuneLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function DragonFortuneLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

function DragonFortuneLogicCard:GetMaxCount(cardId)
    return MaxCollectCount
end

function DragonFortuneLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= MaxCollectCount[m] then
                bingoCount = bingoCount + 1
            end
        end
    end
    return bingoCount
end

function DragonFortuneLogicCard:GetFasterBowlType(cardId, excludeTypes)
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

function DragonFortuneLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

function DragonFortuneLogicCard:GetCellsByMaterialType(cardId, type)
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