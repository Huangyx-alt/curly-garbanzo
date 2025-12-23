local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local DrinkingFrenzyLogicCard = BaseLogicCard:New("DrinkingFrenzyLogicCard")
local this = DrinkingFrenzyLogicCard
this.moduleName = "DrinkingFrenzyLogicCard"

local bowlTable={}
local forbidClickTable={}

function DrinkingFrenzyLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0,0,0,0}
    self:BaseInit()
end

function DrinkingFrenzyLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0,0,0,0}
    end
end

function DrinkingFrenzyLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

function DrinkingFrenzyLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

function DrinkingFrenzyLogicCard:GetReadyCollectIndex(cardId,itemId)
    local collectData = bowlTable[cardId]
    if itemId == 261001 then
        for i = 1 , 2 do
            local max = Csv.GetCollectiveMaxCount(i)
            if collectData[i] < max then
                return i
            end
        end
    else
        for i = 3 , 4 do
            local max = Csv.GetCollectiveMaxCount(i)
            if collectData[i] < max then
                return i
            end
        end
    end
    
end

function DrinkingFrenzyLogicCard:AddLogicBowlDrink(cardId,itemId)
    cardId = tonumber(cardId)
    local collectIndex = self:GetReadyCollectIndex(cardId , itemId)
    log.log("添加酒杯数据a" , bowlTable)
    log.log("添加酒杯数据b" , cardId)
    log.log("添加酒杯数据c" , collectIndex)
    bowlTable[cardId][collectIndex] = bowlTable[cardId][collectIndex] + 1 
    local playid = ModelList.CityModel.GetPlayIdByCity()

    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local maxCount1 = Csv.GetCollectiveMaxCount(1, playid, collectLevel)
    local maxCount2 = Csv.GetCollectiveMaxCount(2, playid, collectLevel)
    local maxCount3 = Csv.GetCollectiveMaxCount(3, playid, collectLevel)
    local maxCount4 = Csv.GetCollectiveMaxCount(4, playid, collectLevel)
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            bowlTable[cardId][1] >= maxCount1 and bowlTable[cardId][2] >= maxCount2 and
            bowlTable[cardId][3] >= maxCount3 and bowlTable[cardId][4] >= maxCount4 then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function DrinkingFrenzyLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function DrinkingFrenzyLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = Csv.GetCollectiveMaxCount(type)
    return temp >= max
end

function DrinkingFrenzyLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function DrinkingFrenzyLogicCard:CheckAllCardJackpotHandle(currCardId)
    --- ���ﲹ�䣬�����һ��С���������ȫ��jackpot���ͺ�����һ��С���
    if ModelList.BattleModel:IsRocket() then return end
    if self:IsAllJackpot() then
        if ModelList.BattleModel:IsGameing() then
            ModelList.BattleModel:GetCurrModel():SetReadyState(2)
            self:WaitUploadSettleData()
        end
    end
end


--- 4����Ϸʱ���������ſ����jackpot�����ƶ�2�Ŵ��jackpot�Ŀ�Ƭ����3��4����λ��
function DrinkingFrenzyLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

--- ȡ������Jackpot�Ŀ��ƺ���
function DrinkingFrenzyLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

--- ��ȡ��ӽ������ľƱ�����
function DrinkingFrenzyLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

---
function DrinkingFrenzyLogicCard:GetMaxCount(cardId)
    cardId = tonumber(cardId)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local maxCount1 = Csv.GetCollectiveMaxCount(1,playid)
    local maxCount2 = Csv.GetCollectiveMaxCount(2,playid)
    local maxCount3 = Csv.GetCollectiveMaxCount(3,playid)
    local maxCount4 = Csv.GetCollectiveMaxCount(4,playid)
    return {maxCount1,maxCount2,maxCount3,maxCount4}
end

--- ��ȡ����bingo����
function DrinkingFrenzyLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= Csv.GetCollectiveMaxCount(m) then
                bingoCount = bingoCount + 1
            end
        end
    end
    return bingoCount
end


--- ��ȡ�ռ��������Ĳ���
function DrinkingFrenzyLogicCard:GetFasterBowlType(cardId, excludeTypes)
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

---�ռ��������Ĳ��ϵ����и���
---@param cardId table
function DrinkingFrenzyLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

---��ȡ���Ͳ��϶�Ӧ�ĸ���
---@param cardId table
function DrinkingFrenzyLogicCard:GetCellsByMaterialType(cardId, type)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v2)
            if 4 == math.floor(v2.id/10000000) and type == 1 then
                --�ر�ͼ
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