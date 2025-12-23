---  解锁格子 bingo规则
---  jackpot修改：盖章形状达成jackpot
---  bingo修改：收集完所有道具后卡牌不可点击
local BaseBingoRule = require("Combat.Machine.CalculateBingo.BaseBingoRule")

local NewLockTiersRule = BaseBingoRule:New("NewLockTiersRule")
local this = NewLockTiersRule
local treasureData = {}
local MaxTiers = {}            --格子的解锁等级

function NewLockTiersRule:Start(loadData, ruleData)
    --jackpot盖章图形
    local jackpotRuleId = loadData.jackpotRuleId
    if #jackpotRuleId > 0 then
        this.jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
    else
        this.jackpotRule = nil
    end
    
    treasureData = {}
    table.each(loadData.cardsInfo, function(cardInfo)
        local cardID = cardInfo.cardId
        local tempUnlockData = {}
        table.each(ruleData.params, function(v, k)
            local cellIndex = ConvertServerPos(v[1])
            tempUnlockData[cellIndex] = 0
            MaxTiers[cellIndex] = v[2]
        end)
        treasureData[cardID] = {
            unlockData = tempUnlockData,
            bingo = {},
            jackpot = 0
        }
    end)
    
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    if this.model then
        this.data = this.model:GetRoundData()
    end
end

function NewLockTiersRule:CalculateJackpot2(cardId, cellIndex, ...)
    local totalBingoInfoList = {}
    local num = { ... }
    if this:CheckJackpot(cardId, cellIndex) then
        local bingoInfo = { type = this.BingoType.JACKPOT, numbers = num,
                            cardId = cardId, totolCount = this.totalBingoCount[cardId], th = 0 }
        table.insert(totalBingoInfoList, bingoInfo)
    end
    if #totalBingoInfoList > 0 then
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

function NewLockTiersRule:CalculateBingo(cardId, cellIndex, ...)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    local num = { ... }
    for i = 1, #treasureData do
        if #treasureData[i].bingo > 0 then
            local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
            --bingoInfo.wolfPos = cellIndex
            table.insert(newBingoInfoList, bingoInfo)
            treasureData[i].bingo = {}
        end
    end
    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList, newBingoInfoList)
    end

    if this:CheckJackpot(cardId, cellIndex) then
        local bingoInfo = { type = this.BingoType.JACKPOT, numbers = num,
                            cardId = cardId, totolCount = this.totalBingoCount[cardId], th = 0 }
        table.insert(totalBingoInfoList, bingoInfo)
    end

    if #totalBingoInfoList > 0 then
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

function NewLockTiersRule:OnDataChange(cardId, cellIndex, ...)
    local arg = {...}
    local unlockCount = arg[1]
    local unlockData = treasureData[cardId].unlockData
    
    if unlockData[cellIndex] < MaxTiers[cellIndex] then
        unlockData[cellIndex] = unlockCount
        if unlockData[cellIndex] >= MaxTiers[cellIndex] then
            log.log(string.format("[ThievesLog] CardID:%s，保险箱位置:%s，收集完成，添加bingodata", cardId, cellIndex))
            table.insert(treasureData[cardId].bingo, 0)
        end
    end
end

function NewLockTiersRule:CheckJackpot(cardId, cellIndex)
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

function NewLockTiersRule:GetBingoType(cardId)
    cardId = tonumber(cardId)
    
    local bingoType = {}
    local unlockData = treasureData[cardId].unlockData
    table.each(unlockData, function(v, k)
        if v >= MaxTiers[k] then
            table.insert(bingoType, v)
        end
    end)
    return bingoType
end

return this