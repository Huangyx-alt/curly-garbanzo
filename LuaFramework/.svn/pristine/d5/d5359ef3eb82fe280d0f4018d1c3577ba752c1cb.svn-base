local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local LetemRollLogicCard = BaseLogicCard:New("LetemRollLogicCard")
local this = LetemRollLogicCard
this.moduleName = "LetemRollLogicCard"

local bowlTable={}
local forbidClickTable={}

function LetemRollLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0,0,0,0}
    self:BaseInit()
end

function LetemRollLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0,0,0,}
    end
end

function LetemRollLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

function LetemRollLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

function LetemRollLogicCard:AddLogicBowlDrink(cardId,cellIndex,bowlType,addCount,isMax)
    cardId = tonumber(cardId)
    if isMax then
        local playid = ModelList.CityModel.GetPlayIdByCity()
        addCount = Csv.GetCollectiveMaxCount(bowlType,playid) - bowlTable[cardId][bowlType]
        --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):AddHawaiiExtData(cardId,bowlType,addCount)
    end
    if bowlType == 1 then
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    elseif bowlType == 2 then
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    elseif bowlType == 3 then
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    end
    local playid = ModelList.CityModel.GetPlayIdByCity()

    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local maxCount1 = Csv.GetCollectiveMaxCount(1, playid, collectLevel)
    local maxCount2 = Csv.GetCollectiveMaxCount(2, playid, collectLevel)
    local maxCount3 = Csv.GetCollectiveMaxCount(3, playid, collectLevel)
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            bowlTable[cardId][1] >= maxCount1 and bowlTable[cardId][2] >= maxCount2 and
            bowlTable[cardId][3] >= maxCount3 then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function LetemRollLogicCard:IsOtherSideHaveOneJackpot(currCardId)
    local otherJackpotId = 0
    if self.model:GetCardCount() == 4 then
        local forbidCount = 0
        for i = 1, 4 do
            if  self.model:GetRoundData(i):GetForbid() then
                forbidCount = forbidCount + 1
                if i ~= currCardId then
                    otherJackpotId = i
                end
            end
        end
        if forbidCount == 2 and not (currCardId <= 2 and otherJackpotId <= 2)
                and not (currCardId >= 3 and otherJackpotId >= 3)  then
            return otherJackpotId
        else
            return 0
        end
    else
        return 0
    end
end

function LetemRollLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = Csv.GetCollectiveMaxCount(type)
    return temp >= max
end

function LetemRollLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function LetemRollLogicCard:CheckAllCardJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    if self:IsAllJackpot() then
        if ModelList.BattleModel:IsGameing() then
            ModelList.BattleModel:GetCurrModel():SetReadyState(2)
            self:WaitUploadSettleData()
        end
    end
end

function LetemRollLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

function LetemRollLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function LetemRollLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

---
function LetemRollLogicCard:GetMaxCount(cardId)
    cardId = tonumber(cardId)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local maxCount1 = Csv.GetCollectiveMaxCount(1,playid)
    local maxCount2 = Csv.GetCollectiveMaxCount(2,playid)
    local maxCount3 = Csv.GetCollectiveMaxCount(3,playid)
    return {maxCount1,maxCount2,maxCount3}
end

function LetemRollLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    local isValid = false
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= Csv.GetCollectiveMaxCount(m) then
                bingoCount = bingoCount + 1
                if m == 1 then
                    isValid = true
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

function LetemRollLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(bowlTable, function(v, cardID)
        if cardId == cardID then
            table.each(v, function(count, k)
                local max = Csv.GetCollectiveMaxCount(k)
                if count >= max then
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

---@param cardId table
function LetemRollLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

---@param cardId table
function LetemRollLogicCard:GetCellsByMaterialType(cardId, type)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v2)
            if 4 == math.floor(v2.id/10000000) and type == 1 then
                table.insert(ret, cell)
            else
                local cfg = Csv.GetData("item", v2.id, "result")
                if cfg and cfg[2] == type then
                    table.insert(ret, cell)
                end
            end
        end)
    end)
    return ret
end

return this