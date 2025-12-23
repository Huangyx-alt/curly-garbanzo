local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local HorseRacingLogicCard = BaseLogicCard:New("HorseRacingLogicCard")
local this = HorseRacingLogicCard
this.moduleName = "HorseRacingLogicCard"

local bowlTable={}
local forbidClickTable={}
local maxCount = 5

function HorseRacingLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0,0,0,0}
    self:BaseInit()
end

function HorseRacingLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0, 0, 0, 0, 0}
    end
end

function HorseRacingLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function HorseRacingLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function HorseRacingLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)
    if isMax then
        local playid = ModelList.CityModel.GetPlayIdByCity()
        addCount = maxCount - bowlTable[cardId][bowlType]
    end

    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            bowlTable[cardId][1] >= maxCount and bowlTable[cardId][2] >= maxCount and
            bowlTable[cardId][3] >= maxCount and bowlTable[cardId][4] >= maxCount and
            bowlTable[cardId][5] >= maxCount then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function HorseRacingLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function HorseRacingLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = maxCount
    return temp >= max
end

function HorseRacingLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function HorseRacingLogicCard:CheckAllCardJackpotHandle(currCardId)
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
function HorseRacingLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

--- ȡ������Jackpot�Ŀ��ƺ���
function HorseRacingLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

--- ��ȡ��ӽ������ľƱ�����
function HorseRacingLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

---
function HorseRacingLogicCard:GetMaxCount(cardId)
    return {maxCount, maxCount, maxCount, maxCount, maxCount}
end

--- ��ȡ����bingo����
function HorseRacingLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= maxCount then
                bingoCount = bingoCount + 1
            end
        end
    end
    return bingoCount
end


--- ��ȡ�ռ��������Ĳ���
function HorseRacingLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(bowlTable, function(v, cardID)
        if cardId == cardID then
            table.each(v, function(count, k)
                local max = maxCount
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
function HorseRacingLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

---��ȡ���Ͳ��϶�Ӧ�ĸ���
---@param cardId table
function HorseRacingLogicCard:GetCellsByMaterialType(cardId, type)
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