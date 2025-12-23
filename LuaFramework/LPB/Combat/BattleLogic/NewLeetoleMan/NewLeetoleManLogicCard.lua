local BaseLogicCard = require("Combat.BattleLogic.Base.BaseLogicCard")
local NewLeetoleManLogicCard = BaseLogicCard:New("NewLeetoleManLogicCard")
local this = NewLeetoleManLogicCard
this.moduleName = "NewLeetoleManLogicCard"
local bowlTable = {}
local MaxCollectCount = {}

function NewLeetoleManLogicCard:InitLogic()
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitCardBowls()
    self:BaseInit()
end

function NewLeetoleManLogicCard:InitCardBowls()
    local cardCount = self.model:GetCardCount()

    local loadData = ModelList.BattleModel:GetBackupLoadData()
    if loadData then
        local ruleData = Csv.GetData("new_bingo_rule", loadData.bingoRuleId[1])
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
        end
    end
end

function NewLeetoleManLogicCard:Register()
    Event.AddListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function NewLeetoleManLogicCard:UnRegister()
    Event.RemoveListener(EventName.Event_Logic_Collect_Item, self.AddLogicBowlDrink, self)
end

function NewLeetoleManLogicCard:AddLogicBowlDrink(cardId, cellIndex, bowlType, addCount, isMax)
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

function NewLeetoleManLogicCard:GetBingoType(cardId, bingoCount)
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

function NewLeetoleManLogicCard:IsOtherSideHaveOneJackpot(currCardId)
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

function NewLeetoleManLogicCard:IsTypeBingo(cardID, type)
    cardID = tonumber(cardID)
    local temp = bowlTable[cardID][type] or 0
    return temp >= MaxCollectCount[type]
end

function NewLeetoleManLogicCard:IsAllJackpot()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if not self.model:GetRoundData(i):GetForbid() then
            return false
        end
    end
    return true
end

function NewLeetoleManLogicCard:CheckAllCardJackpotHandle(currCardId)
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

function NewLeetoleManLogicCard:CheckDoubleJackpotHandle(currCardId)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local otherJackpotId = self:IsOtherSideHaveOneJackpot(currCardId)
    if otherJackpotId ~= 0 then
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):StartHideJackpotCardBackground(currCardId, otherJackpotId)
    end
end

function NewLeetoleManLogicCard:StopCardBackMove()
    if this.loopMoveCard then
        LuaTimer:Remove(this.loopMoveCard)
    end
end

function NewLeetoleManLogicCard:GetBowlCount(cardId)
    cardId = tonumber(cardId)
    return bowlTable[cardId]
end

function NewLeetoleManLogicCard:GetMaxCount(cardId)
    return MaxCollectCount
end

function NewLeetoleManLogicCard:GetBowlBingoCount(cardId)
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

function NewLeetoleManLogicCard:GetNextMaterialCell(cardId, isPreCalculateBingoSkill)
    cardId = tonumber(cardId)
    local cardData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    local ret = {}
    table.each(cardData.cards, function(cell)
        table.each(cell.hide_gift, function(v)
            local cfg = Csv.GetData("item", v.id, "result")
            if cfg and cfg[1] == 41 then
                --cell.isGained 用于判断格子是否已经被打开
                --cell.isUsedForBingoSkill 用于判断格子是否被技能占用，仅在新绿头人玩法中生效
                --cell.isMoveTarget 用于判断格子是否即将被打开，仅在新绿头人玩法中生效
                if not cell.isGained and not cell.isMoveTarget and not cell.isUsedForBingoSkill then
                    if isPreCalculateBingoSkill then
                        cell.isUsedForBingoSkill = true
                    end
                    table.insert(ret, cell)
                end
            end
        end)
    end)
    
    return ret
end

return this