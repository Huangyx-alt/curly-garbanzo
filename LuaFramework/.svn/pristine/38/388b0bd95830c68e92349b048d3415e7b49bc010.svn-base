local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")
local BisonLogicCard = BaseLogicCard:New("BisonLogicCard")
local this = BisonLogicCard
this.moduleName = "BisonLogicCard"

local bowlTable={}
--- 禁止点击卡牌
local forbidClickTable = {}
local MAX_BINGO_COUNT = 4

function BisonLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    forbidClickTable = {0, 0, 0, 0}
    self:BaseInit()
end

function BisonLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlTable[i] = {0, 0, 0, 0, 0}
    end
end

function BisonLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function BisonLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

--- 增加收集物
function BisonLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
    cardId = tonumber(cardId)
    if isMax then
        local playid = ModelList.CityModel.GetPlayIdByCity()
        --addCount = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(bowlType) - bowlTable[cardId][bowlType]
        --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):AddHawaiiExtData(cardId,bowlType,addCount)
        addCount = 1
    end

    if bowlType >= 1  and bowlType <= 5 then
        bowlTable[cardId][bowlType] = bowlTable[cardId][bowlType] + addCount
    else
        log.log("BisonLogicCard:AddLogicBowlDrink bowlType error", bowlType)
    end

    local isForbid = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid()
    if not isForbid and self:GetBowlBingoCount(cardId) >= MAX_BINGO_COUNT then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardJackpotHandle(cardId)
    end
end

--- 另一侧有jackpot卡牌
function BisonLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function BisonLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    local max = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(type)
    return temp >= max
end

--- 是否全部卡牌达成jackpoat
function BisonLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

--- 4卡游戏时，若有两张卡达成jackpot，则移动2张达成jackpot的卡片，到3、4卡的位置
function BisonLogicCard:CheckAllCardJackpotHandle(currCardId)
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
function BisonLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then return end
    local otherJackpotId =self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId,otherJackpotId)
    end
end

--- 取消两个Jackpot的卡牌后移
function BisonLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

--- 获取所有收集物数量
function BisonLogicCard:GetBowlCount(cardId)
    return MAX_BINGO_COUNT
end

-- function BisonLogicCard:GetMaxCount(cardId)
--     local maxCount1 = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(1)
--     local maxCount2 = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(2)
--     local maxCount3 = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(3)
--     local maxCount4 = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(4)
--     return {maxCount1, maxCount2, maxCount3, maxCount4}
-- end

--- 获取卡牌bingo数量
function BisonLogicCard:GetBowlBingoCount(cardId)
    cardId = tonumber(cardId)
    local bingoCount = 0
    if bowlTable and bowlTable[cardId] then
        for m = 1, #bowlTable[cardId] do
            --if bowlTable[cardId][m] >= ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(m) then
            bingoCount = bingoCount + math.floor(bowlTable[cardId][m] / ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(m))
            --end
        end
    end
    return bingoCount
end

--- 获取收集进度最快的材料
function BisonLogicCard:GetFasterBowlType(cardId, excludeTypes)
    cardId = tonumber(cardId)
    local ret, temp
    table.each(bowlTable, function(v, cardID)
        if cardId == cardID then
            table.each(v, function(count, k)
                local max = ModelList.BattleModel:GetCurrModel():GetCollectiveMaxCount(k)
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
function BisonLogicCard:GetSkillNeedCells(cardId, excludeTypes)
    local type = self:GetFasterBowlType(cardId, excludeTypes)
    if not type then
        return
    end

    local cells = self:GetCellsByMaterialType(cardId, type)
    return cells, type
end

---获取类型材料对应的格子
---@param cardId table
function BisonLogicCard:GetCellsByMaterialType(cardId, type)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v2)
            if 4 == math.floor(v2.id / 10000000) and type == 1 then
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