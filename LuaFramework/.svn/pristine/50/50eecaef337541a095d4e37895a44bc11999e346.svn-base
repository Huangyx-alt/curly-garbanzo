---bingo规则
local BaseBingoRule = require("Combat.Machine.CalculateBingo.BaseBingoRule")
local MonopolyBingoRule = BaseBingoRule:New("MonopolyBingoRule")
local this = MonopolyBingoRule
local itemWishData = {}
local currWishList = {}
local Private = {}

function MonopolyBingoRule:Start(loadData, ruleData)
    this.jackpotRule = nil
    itemWishData = {}
    currWishList = {}
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    if this.model then
        this.data = this.model:GetRoundData()
        this.bingoScoreTotalMap = this.model:GetBingoScoreTotalMap() --or {100, 300, 600, 1100}
    end
end

function MonopolyBingoRule:GetBingoType(cardId, cellIndex)
    local bingoType = 1
    return bingoType
end

function MonopolyBingoRule:CalculateBingo(cardId, cellIndex, ...)

end

function MonopolyBingoRule:InnerCalculateBingo(cardId, bingoType)
    local totalBingoInfoList = {}
    for i = 1, bingoType do
        if not self.ScoreCollectionRecord[cardId].bingoRecord[i] then
            local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, nil, cardId)
            bingoInfo.bingoType = this:GetBingoType(cardId)
            table.insert(totalBingoInfoList, bingoInfo)
            self.ScoreCollectionRecord[cardId].bingoRecord[i] = true
        end
    end

    if #totalBingoInfoList > 0 then
        --Private.ChangeCollectionQueueState(self, cardId, 1, bingoType)
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
        return true
    end

    return false
end

--只处理了wish相关逻辑
function MonopolyBingoRule:OnDataChange(cardId, cellIndex, ...)
    local arg = { ... }
    cardId = tonumber(cardId)
    local treasureType, addCount = arg[1], arg[2]
    if treasureType then
        if not itemWishData[cardId] then
            itemWishData[cardId] = {
                { count = 0, iswish = false, cells = {}, wishIndex = 0 },
                { count = 0, iswish = false, cells = {}, wishIndex = 0 },
                { count = 0, iswish = false, cells = {}, wishIndex = 0 } ,
                { count = 0, iswish = false, cells = {}, wishIndex = 0 } ,
            }
        end
        itemWishData[cardId][treasureType].count = itemWishData[cardId][treasureType].count + addCount
        table.insert(itemWishData[cardId][treasureType].cells, cellIndex)
        if itemWishData[cardId][4].count >= 4 then
            for i = 1, 3 do
                if not itemWishData[cardId][i].iswish and itemWishData[cardId][i].count == 3 then
                    self:TriggerWish(cardId, i)
                elseif itemWishData[cardId][i].iswish and itemWishData[cardId][i].count == 4 then
                    self:CancelWish(cardId, i)
                end
            end
        else
            local findPiggy = false
            for i = 1, 3 do
                if itemWishData[cardId][i].count >= 4 then
                    findPiggy = true
                    break
                end
            end
            if findPiggy then
                if not itemWishData[cardId][4].iswish and itemWishData[cardId][4].count == 3 then
                    self:TriggerWish(cardId, 4)

                elseif itemWishData[cardId][4].iswish and itemWishData[cardId][4].count == 4 then
                    self:CancelWish(cardId, 4)
                end
            end
        end
    end
end

-- 触发wish效果
function MonopolyBingoRule:TriggerWish(cardId, idx)
    local mapCellIndex = (itemWishData[cardId][idx].cells and #itemWishData[cardId][idx].cells > 0) and
    itemWishData[cardId][idx].cells[1] or cellIndex
    local cellData = ModelList.MonopolyModel:GetRoundData(cardId, mapCellIndex)
    local ext = cellData:GetExtInfo()
    if ext and ext.groupCells then
        for k = 1, #ext.groupCells do
            if ext.groupCells[k].sign == 0 then
                Event.Brocast(EventName.CardBingoEffect_ShowWish, cardId, ext.groupCells[k].index)
                itemWishData[cardId].wishIndex = ext.groupCells[k].index
                itemWishData[cardId][idx].iswish = true
                break
            end
        end
    end
end

-- wish效果取消
function MonopolyBingoRule:CancelWish(cardId, idx)   
    Event.Brocast(EventName.CardBingoEffect_CancelShowWish, cardId, itemWishData[cardId].wishIndex)
    itemWishData[cardId][idx].iswish = false
end

function MonopolyBingoRule:CalculateJackpot(cardId, cellIndex)
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

---提供一个查询接口,再内部自定义逻辑
function MonopolyBingoRule:SetInfo(setType, cardId, score)
    if setType and cardId then
        if setType == 1 then
            Private.AddScore(self, cardId, score)
        elseif setType == 2 then
            return Private.CheckCollectionBingo(self, cardId)
        end
    end
end

---提供一个查询接口,再内部自定义逻辑
function MonopolyBingoRule:SeekInfo(seekType, cardId)
    if seekType then
        if seekType == 1 then -- 查询是否形成Bingo
            --Private.ChangeCollectionQueueState(self, cardId, 0)
        elseif seekType == 99 then --查询是否完成bingo队列
            return true
        end
    end
end

function Private.AddScore(self, cardId, score)
    if not self.ScoreCollectionRecord then
        self.ScoreCollectionRecord = {}
    end

    if not self.ScoreCollectionRecord[cardId] then
        self.ScoreCollectionRecord[cardId] = {
            bingoRecord = {false, false, false, false},
            state = 0,          ---0-未播放 1-播放中
            totalScore = 0,
        }
    end

    self.ScoreCollectionRecord[cardId].totalScore = self.ScoreCollectionRecord[cardId].totalScore + score
end

---检查队列是否满足播放
function Private.CheckCollectionBingo(self, cardId, itemType)
    local stageIdx
    for i = 4, 1, -1 do
        if self.ScoreCollectionRecord[cardId].totalScore >= self.bingoScoreTotalMap[i] then
            stageIdx = i
            break
        end
    end
    
    if not stageIdx then
        return false
    end

    if self.ScoreCollectionRecord[cardId].bingoRecord[stageIdx] then
        return false
    end

    local triggerNewBingo = self:InnerCalculateBingo(cardId, stageIdx)

    return triggerNewBingo
end

return this