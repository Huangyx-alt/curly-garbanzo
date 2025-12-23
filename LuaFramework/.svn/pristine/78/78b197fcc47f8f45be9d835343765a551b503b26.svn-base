local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")

local GoldenTrainLogicCard = BaseLogicCard:New("GoldenTrainLogicCard")
local this = GoldenTrainLogicCard
this.moduleName = "GoldenTrainLogicCard"

local bowlTable={}
--- 禁止点击卡牌
local forbidClickTable={}
local maxCount = nil

function GoldenTrainLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0, 0, 0, 0, 0}
    self:BaseInit()
end

function GoldenTrainLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0, 0, 0, 0, 1}
    end

    maxCount = {}
    for i = 1, 5 do
        maxCount[i] = Csv.GetCollectiveMaxCount(i)
    end
end
--[[
function GoldenTrainLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function GoldenTrainLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

--- 增加酒水数量
function GoldenTrainLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)
    if isMax then
        local playid = ModelList.CityModel.GetPlayIdByCity()
        addCount = maxCount - bowlTable[cardId][bowlType]
    end

    bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            bowlTable[cardId][1] >= maxCount[1] and bowlTable[cardId][2] >= maxCount[2] and
            bowlTable[cardId][3] >= maxCount[3] and bowlTable[cardId][4] >= maxCount[4] and
            bowlTable[cardId][5] >= maxCount[5] then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

function GoldenTrainLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function GoldenTrainLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = maxCount[type]
    return temp >= max
end

function GoldenTrainLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function GoldenTrainLogicCard:CheckAllCardJackpotHandle(currCardId)
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
function GoldenTrainLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

--- 取消两个Jackpot的卡牌后移
function GoldenTrainLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

--- 获取最接近满杯的酒杯类型
function GoldenTrainLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    for i = 1, #bowlTable[cardId] do
        return bowlTable[cardId]
    end
end

---
function GoldenTrainLogicCard:GetMaxCount(cardId)
    return maxCount
end

--- 获取卡牌bingo数量
function GoldenTrainLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    local bingoFinishMap = {}
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            if bowlTable[cardId][m] >= maxCount[m] then
                bingoCount = bingoCount + 1
                bingoFinishMap[m] = true
            else
                bingoFinishMap[m] = false
            end
        end
    end
    return bingoCount, bingoFinishMap
end


--- 获取收集进度最快的材料
function GoldenTrainLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(bowlTable, function(v, cardID)
        if cardId == cardID then
            table.each(v, function(count, k)
                local max = maxCount[k]
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


---获取类型材料对应的格子
---@param cardId table
function GoldenTrainLogicCard:GetCellsByMaterialType(cardId, type)
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

--]]

function GoldenTrainLogicCard:GetSkillNeedCells(cardId, excludeTypes)
end

return this