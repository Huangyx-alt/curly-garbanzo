local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local GemQueenLogicCard = BaseLogicCard:New("GemQueenLogicCard")
local this = GemQueenLogicCard
this.moduleName = "GemQueenLogicCard"

local bowlTable={}
--- 禁止点击卡牌
local forbidClickTable={}

function GemQueenLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0,0,0,0}
    self:BaseInit()
end

function GemQueenLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0,0,0,0}
    end
end

function GemQueenLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

function GemQueenLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item,self.AddLogicBowlDrink,self)
end

--- 增加酒水数量
function GemQueenLogicCard:AddLogicBowlDrink(cardId,cellIndex,bowlType,addCount,isMax)
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
    elseif bowlType == 4 then
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    end
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local maxCount1 = Csv.GetCollectiveMaxCount(1,playid)
    local maxCount2 = Csv.GetCollectiveMaxCount(2,playid)
    local maxCount3 = Csv.GetCollectiveMaxCount(3,playid)
    local maxCount4 = Csv.GetCollectiveMaxCount(4,playid)
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

function GemQueenLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function GemQueenLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = Csv.GetCollectiveMaxCount(type)
    return temp >= max
end

function GemQueenLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function GemQueenLogicCard:CheckAllCardJackpotHandle(currCardId)
    --- 这里补充，假如第一次小火箭触发了全部jackpot，就忽略下一次小火箭
    if ModelList.BattleModel:IsRocket() then return end
    if self:IsAllJackpot() then
        if ModelList.BattleModel:IsGameing() then
            ModelList.BattleModel:GetCurrModel():SetReadyState(2)
            self:WaitUploadSettleData()
        end
    end
end


--- 4卡游戏时，若有两张卡达成jackpot，则移动2张达成jackpot的卡片，到3、4卡的位置
function GemQueenLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

--- 取消两个Jackpot的卡牌后移
function GemQueenLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

--- 获取最接近满杯的酒杯类型
function GemQueenLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

---
function GemQueenLogicCard:GetMaxCount(cardId)
    cardId = tonumber(cardId)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local maxCount1 = Csv.GetCollectiveMaxCount(1,playid)
    local maxCount2 = Csv.GetCollectiveMaxCount(2,playid)
    local maxCount3 = Csv.GetCollectiveMaxCount(3,playid)
    local maxCount4 = Csv.GetCollectiveMaxCount(4,playid)
    return {maxCount1,maxCount2,maxCount3,maxCount4}
end

--- 获取卡牌bingo数量
function GemQueenLogicCard:GetBowlBingoCount(cardId)
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


--- 获取收集进度最快的材料
function GemQueenLogicCard:GetFasterBowlType(cardId, excludeTypes)
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

---收集进度最快的材料的所有格子
---@param cardId table
function GemQueenLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

---获取类型材料对应的格子
---@param cardId table
function GemQueenLogicCard:GetCellsByMaterialType(cardId, type)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v2)
            if 4 == math.floor(v2.id/10000000) and type == 1 then
                --藏宝图
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