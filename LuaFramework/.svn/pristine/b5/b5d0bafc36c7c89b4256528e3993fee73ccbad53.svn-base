local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")
local ThievesLogicCard = BaseLogicCard:New("ThievesLogicCard")
local this = ThievesLogicCard
this.moduleName = "ThievesLogicCard"
local ThievesLockTiers = {}
local forbidClickTable = {}
local MaxTiers = 4
local ThievesPosList = { 7, 9, 17, 19 }
local private = {}

function ThievesLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardLogicData()
    forbidClickTable = { 0, 0, 0, 0 }
    self.ThievesFlagForSkill = {}
end

function ThievesLogicCard:InitCardLogicData()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        ThievesLockTiers[i] = {}
        table.each(ThievesPosList, function(ThievesPos)
            ThievesLockTiers[i][ThievesPos] = 0
        end)
    end
end

function ThievesLogicCard:Register()

end

function ThievesLogicCard:UnRegister()

end

--- 减少宝箱解锁层数
function ThievesLogicCard:ReduceLogicLockTiers(cardId, cellIndex)
    local affectCellList = {}
    cardId = tonumber(cardId)
    local tempX = math.modf((cellIndex - 1) / 5)
    local tempY = math.modf((cellIndex - 1) % 5)
    for i = -1, 1 do
        for k = -1, 1 do
            local new_x = tempX + i
            local new_y = tempY - k
            if new_x >= 0 and new_x <= 4 and new_y >= 0 and new_y <= 4 then
                local new_index = new_x * 5 + new_y + 1
                if new_index == 7 or new_index == 9 or new_index == 17 or new_index == 19 then
                    ThievesLockTiers[cardId][new_index] = ThievesLockTiers[cardId][new_index] + 1
                    if ThievesLockTiers[cardId][new_index] >= 0 then
                        table.insert(affectCellList, new_index)
                    end
                end
            end
        end
    end
    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            ThievesLockTiers[cardId][7] >= MaxTiers and ThievesLockTiers[cardId][9] >= MaxTiers and
            ThievesLockTiers[cardId][17] >= MaxTiers and ThievesLockTiers[cardId][19] >= MaxTiers then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardBeBingoHandle(cardId)
    end
    return affectCellList
end

function ThievesLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function ThievesLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function ThievesLogicCard:CheckAllCardBeBingoHandle(currCardId)
    --- 这里补充，假如第一次小火箭触发了全部jackpot，就忽略下一次小火箭
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

--- 4卡游戏时，若有两张卡达成jackpot，则移动2张达成jackpot的卡片，到3、4卡的位置
function ThievesLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

--- 取消两个Jackpot的卡牌后移
function ThievesLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function ThievesLogicCard:GetThievesUnlockedTiers(cardId, thievesPos)
    cardId = tonumber(cardId)
    return ThievesLockTiers[cardId] and ThievesLockTiers[cardId][thievesPos] or 0
end

--- 获取卡牌bingo数量
function ThievesLogicCard:GetBingoCount(cardId)
    cardId = tonumber(cardId)
    local unlockedTiers = 0
    if ThievesLockTiers and ThievesLockTiers[cardId] then
        table.each(ThievesPosList, function(ThievesPos)
            if ThievesLockTiers[cardId][ThievesPos] >= MaxTiers then
                unlockedTiers = unlockedTiers + 1
            end
        end)
    end
    return unlockedTiers
end

function ThievesLogicCard:IsThievesUnLocked(cardId, ThievesPos)
    if not cardId or not ThievesPos or not fun.is_include(ThievesPos, ThievesPosList) then
        return
    end

    cardId = tonumber(cardId)
    local curCount = ThievesLockTiers[cardId][ThievesPos]
    return curCount and curCount >= MaxTiers
end

---取解锁进度最慢的宝箱
function ThievesLogicCard:GetLockedThieves(cardId, excludeThievesPos)
    if not cardId then
        return
    end

    cardId = tonumber(cardId)
    local remainPrisons, tempCount, ret = 0

    table.each(ThievesLockTiers[cardId], function(prisonsCount, ThievesPos)
        if prisonsCount < MaxTiers then
            if not excludeThievesPos or not fun.is_include(ThievesPos, excludeThievesPos) then
                if (not tempCount or tempCount > prisonsCount) then
                    tempCount = prisonsCount
                    ret = ThievesPos
                    remainPrisons = MaxTiers - prisonsCount
                end
            end
        end
    end)

    return ret, remainPrisons
end

function ThievesLogicCard:GetLockedThievesForPreCal(cardId, needCount, excludeThievesPos, isMoonSkill)
    self.ThievesFlagForSkill = self.ThievesFlagForSkill or {}
    self.ThievesFlagForSkill[cardId] = self.ThievesFlagForSkill[cardId] or {}

    excludeThievesPos = excludeThievesPos or {}
    local temp, ret = self.ThievesFlagForSkill[cardId], {}
    table.each(temp, function(v, k)
        if v >= MaxTiers then
            table.insert(excludeThievesPos, k)
        end
    end)

    if needCount > 0 then
        for i = 1, needCount do
            local ThievesPos, remainPrisons = self:GetLockedThieves(cardId, excludeThievesPos)
            if ThievesPos then
                if not temp[ThievesPos] or temp[ThievesPos] < MaxTiers then
                    if isMoonSkill then
                        --Bingo技能直接释放宝箱
                        temp[ThievesPos] = MaxTiers
                    else
                        --Pu技能仅破坏一层
                        temp[ThievesPos] = temp[ThievesPos] or remainPrisons
                        temp[ThievesPos] = temp[ThievesPos] + 1
                    end
                    table.insert(ret, ThievesPos)
                end
            end
        end
    end

    if #ret == 0 then
        table.insert(ret, 7)
    end

    return ret
end

function ThievesLogicCard:ReduceAllLogicLockTiers(cardId, ThievesPos)
    cardId = tonumber(cardId)
    ThievesLockTiers[cardId][ThievesPos] = MaxTiers

    if not ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):GetForbid() and
            ThievesLockTiers[cardId][7] >= MaxTiers and ThievesLockTiers[cardId][9] >= MaxTiers and
            ThievesLockTiers[cardId][17] >= MaxTiers and ThievesLockTiers[cardId][19] >= MaxTiers then
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):SetForbid()
        ModelList.BattleModel:GetCurrModel():GetRoundData(cardId):BeJackpot()
        self:StatisticsRocketBingo()
        this:CheckDoubleJackpotHandle(cardId)
        this:CheckAllCardBeBingoHandle(cardId)
    end
end

function ThievesLogicCard:IsJackpot(cardID)
    cardID = tonumber(cardID)

    if self.model:GetRoundData(cardID):GetForbid() then
        return true
    end

    local data, ret = ThievesLockTiers[cardID]
    table.each(data, function(v)
        ret = ret and v >= MaxTiers
    end)
    return ret
end

function ThievesLogicCard:GetBingoType(cardId)
    cardId = tonumber(cardId)
    local bingoType = {}
    table.each(ThievesLockTiers[cardId], function(v)
        if v >= MaxTiers then
            table.insert(bingoType, v)
        end
    end)
    return bingoType
end

return this