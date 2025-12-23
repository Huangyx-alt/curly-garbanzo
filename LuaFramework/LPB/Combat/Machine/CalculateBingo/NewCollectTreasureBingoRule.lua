---  收集物品 bingo规则
---  jackpot修改：盖章形状达成jackpot
---  bingo修改：收集完所有道具后卡牌不可点击
local BaseBingoRule = require("Combat.Machine.CalculateBingo.BaseBingoRule")

local NewCollectTreasureBingoRule = BaseBingoRule:New("NewCollectTreasureBingoRule")
local this = NewCollectTreasureBingoRule
local treasureData = {}
local MaxCollectCount = {}

function NewCollectTreasureBingoRule:Start(loadData, ruleData)
    --jackpot盖章图形
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId and #jackpotRuleId > 0 then
        this.jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
    else
        this.jackpotRule = nil
    end
    
    treasureData = {}
    local cardCount, treasureCount = #loadData.cardsInfo, #ruleData.params
    for i = 1, cardCount do
        local collectCount = {}
        for j = 1, treasureCount do
            table.insert(collectCount, 0)
        end
        collectCount = this:HandleSpecial(collectCount)
        treasureData[i] = {
            collectCount = collectCount, --每种道具收集的进度
            bingo = {},
            jackpot = 0
        }
    end
    
    table.each(ruleData.params, function(v, index)
        MaxCollectCount[index] = v[2]
    end)
    this:HandleSpecialMax(MaxCollectCount)
    
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    if this.model then
        this.data = this.model:GetRoundData()
    end
end

--某些玩法需要特殊处理
function NewCollectTreasureBingoRule:HandleSpecial(collectCount)
    local playType = ModelList.BattleModel:GetGameType()
    if playType == PLAY_TYPE.PLAY_TYPE_EASTER_DAY then
        --收到到特殊道具会增加两个bingo
        return {0, 0, 0, 0, 0}
    end
    
    return collectCount
end

--某些玩法需要特殊处理
function NewCollectTreasureBingoRule:HandleSpecialMax()
    local playType = ModelList.BattleModel:GetGameType()
    if playType == PLAY_TYPE.PLAY_TYPE_EASTER_DAY then
        --收到到特殊道具会增加两个bingo
        MaxCollectCount = {1, 1, 1, 1, 1}
    end
end

function NewCollectTreasureBingoRule:CalculateBingo(cardId, cellIndex, ...)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    local args = { ... }
    local options = table.remove(args, 1)
    
    for i = 1, #treasureData do
        if #treasureData[i].bingo > 0 then
            local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
            table.insert(newBingoInfoList, bingoInfo)
            treasureData[i].bingo = {}
        end
    end
    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList, newBingoInfoList)
    end

    if this:CalculateJackpot(cardId, cellIndex) then
        local bingoInfo = { type = this.BingoType.JACKPOT, numbers = args,
                            cardId = cardId, totolCount = this.totalBingoCount[cardId], th = 0 }
        table.insert(totalBingoInfoList, bingoInfo)
    end

    if #totalBingoInfoList > 0 then
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId, options)
    else
        fun.SafeCall(options and options.onBingoShowComplete)
    end
end

function NewCollectTreasureBingoRule:OnDataChange(cardId, cellIndex, ...)
    local arg = { ... }
    local treasureType, addCount = arg[1], arg[2]
    local curCount, maxCount = treasureData[cardId].collectCount[treasureType], MaxCollectCount[treasureType]

    if curCount < maxCount and curCount + addCount >= maxCount  then
        self:AddTotalBingoCount(cardId)
        table.insert(treasureData[cardId].bingo, treasureType)
        log.r(string.format("[PirateShipLog] cardId:%s, bingo treasureType:%s, total bingo count:%s", cardId, treasureType, self.totalBingoCount[cardId]))
    end
    treasureData[cardId].collectCount[treasureType] = curCount + addCount
    if curCount > maxCount then
        curCount = maxCount
    end
end

function NewCollectTreasureBingoRule:CalculateJackpot(cardId, cellIndex)
    if this.jackpotRule and this.data then
        if fun.is_include(cellIndex, this.jackpotRule) then
            cardId = tostring(cardId)
            for k, v in pairs(this.data) do
                if k == cardId then
                    for n = 1, #this.jackpotRule do
                        local cell_index = this.jackpotRule[n]
                        if v.cards[cell_index].sign == 0 and cell_index ~= cellIndex then
                            return false
                        end
                    end
                    return true
                end
            end
        end
    end
end

function NewCollectTreasureBingoRule:CreateBingoInfo(bingoType, numbers,cardId)
    cardId = tonumber(cardId)
    local needForbidCard = ModelList.BattleModel:GetCurrModel():CheckIsMaxBingo(cardId)
    if needForbidCard then
        --达到Bingo上限
        return
    end
    
    local bingoInfo = {
        type = bingoType,
        numbers = deep_copy(numbers),
        cardId = cardId,
        totolCount = self.totalBingoCount[cardId],
        th = BingoOrderMachine:GetRecordBingoOrder(cardId)
    }
    return bingoInfo
end

return this