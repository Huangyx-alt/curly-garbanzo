---bingo规则
local BaseBingoRule = require("Combat.Machine.CalculateBingo.BaseBingoRule")
local LetemRollBingoRule = BaseBingoRule:New("LetemRollBingoRule")
local this = LetemRollBingoRule
local diceWishData = {}
local currWishList = {}

local Private = {}

function LetemRollBingoRule:Start(loadData, ruleData)
    this.jackpotRule = nil
    self.DiceQueue = nil
    diceWishData = {}
    currWishList = {}
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    if this.model then
        this.data = this.model:GetRoundData()
    end
end

function LetemRollBingoRule:GetBingoType(cardId, cellIndex)
    local bingoType = 1
    --local curCell = this.model:GetRoundData(cardId, cellIndex)
    --local ext = curCell:GetExtInfo()
    --local groupCells = ext and ext.groupCells
    --if groupCells then
    --    bingoType = ext.groupID
    --end

    return bingoType
end

function LetemRollBingoRule:CalculateBingo(cardId, cellIndex, ...)
    --local totalBingoInfoList = {}
    --local newBingoInfoList = {}
    --local num = { ... }
    --
    --if #treasureData[cardId].bingo > 0 then
    --    local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
    --    bingoInfo.bingoType = this:GetBingoType(cardId, cellIndex)
    --    table.insert(newBingoInfoList, bingoInfo)
    --    treasureData[cardId].bingo = {}
    --end
    --
    --if #newBingoInfoList > 0 then
    --    fun.merge_array(totalBingoInfoList, newBingoInfoList)
    --end
    --
    --if this:CalculateJackpot(cardId, cellIndex) then
    --    local bingoInfo = {
    --        type = this.BingoType.JACKPOT,
    --        numbers = num,
    --        cardId = cardId,
    --        totolCount = this.totalBingoCount[cardId],
    --        th = 0
    --    }
    --    table.insert(totalBingoInfoList, bingoInfo)
    --end
    --
    --if #totalBingoInfoList > 0 then
    --    --Private.ChangeDiceQueueState(self, cardId, 1)
    --    Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    --end
end

function LetemRollBingoRule:CalculateBingo2(cardId, bingoType)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    --if #treasureData[cardId].bingo > 0 then
    --    local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, nil, cardId)
    --    bingoInfo.bingoType = this:GetBingoType(cardId, cellIndex)
    --    table.insert(newBingoInfoList, bingoInfo)
    --    treasureData[cardId].bingo = {}
    --end
    local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, nil, cardId)
    bingoInfo.bingoType = this:GetBingoType(cardId)
    table.insert(newBingoInfoList, bingoInfo)

    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList, newBingoInfoList)
    end

    --if this:CalculateJackpot(cardId, cellIndex) then
    --    local bingoInfo = {
    --        type = this.BingoType.JACKPOT,
    --        numbers = num,
    --        cardId = cardId,
    --        totolCount = this.totalBingoCount[cardId],
    --        th = 0
    --    }
    --    table.insert(totalBingoInfoList, bingoInfo)
    --end

    if #totalBingoInfoList > 0 then
        Private.ChangeDiceQueueState(self, cardId, 1, bingoType)
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

function LetemRollBingoRule:OnDataChange(cardId, cellIndex, ...)
    local arg = { ... }
    cardId = tonumber(cardId)
    local treasureType, addCount = arg[1], arg[2]
    if treasureType then
        if not diceWishData[cardId] then
            diceWishData[cardId] = {
                { count = 0, iswish = false, cells = {}, wishIndex = 0 },
                { count = 0, iswish = false, cells = {}, wishIndex = 0 },
                { count = 0, iswish = false, cells = {}, wishIndex = 0 } }
        end
        diceWishData[cardId][treasureType].count = diceWishData[cardId][treasureType].count + addCount
        table.insert(diceWishData[cardId][treasureType].cells, cellIndex)
        if diceWishData[cardId][1].count >= 5 then                                                -- 集齐5个骰子
            for i = 2, 3 do
                if not diceWishData[cardId][i].iswish and diceWishData[cardId][i].count == 3 then ---有3个碎片
                    -- 触发wish效果
                    local mapCellIndex = (diceWishData[cardId][i].cells and #diceWishData[cardId][i].cells > 0) and
                        diceWishData[cardId][i].cells[1] or cellIndex
                    local cellData = ModelList.LetemRollModel:GetRoundData(cardId, mapCellIndex)
                    local ext = cellData:GetExtInfo()
                    if ext and ext.groupCells then
                        for k = 1, #ext.groupCells do
                            if ext.groupCells[k].sign == 0 then
                                Event.Brocast(EventName.CardBingoEffect_ShowWish, cardId, ext.groupCells[k].index)
                                diceWishData[cardId].wishIndex = ext.groupCells[k].index
                                diceWishData[cardId][i].iswish = true
                                break
                            end
                        end
                    end
                elseif diceWishData[cardId][i].iswish and diceWishData[cardId][i].count == 4 then
                    -- wish效果取消
                    Event.Brocast(EventName.CardBingoEffect_CancelShowWish, cardId, diceWishData[cardId].wishIndex)
                    diceWishData[cardId][i].iswish = false
                end
            end
        end
    end

    --local curCount, maxCount = treasureData[cardId].collectCount[treasureType], MaxCollectCount[treasureType]
    --
    --if curCount < maxCount and curCount + addCount >= maxCount then
    --    table.insert(treasureData[cardId].bingo, treasureType)
    --end
    --treasureData[cardId].collectCount[treasureType] = curCount + addCount
    --if curCount > maxCount then
    --    curCount = maxCount
    --end

    ---计算bingo wish
end

function LetemRollBingoRule:CalculateJackpot(cardId, cellIndex)
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
function LetemRollBingoRule:SetInfo(setType, cardId, diceType, diceIndex)
    if setType and cardId then
        if setType == 1 then -- 新获取骰子
            Private.AddDice(self, cardId, diceType, diceIndex)
        elseif setType == 2 then
            Private.CheckDiceQueue(self, cardId, diceType)
        end
    end
end

---提供一个查询接口,再内部自定义逻辑
function LetemRollBingoRule:SeekInfo(seekType, cardId)
    if seekType then
        if seekType == 1 then -- 查询是否形成Bingo
            Private.ChangeDiceQueueState(self, cardId, 0)
            Private.CheckDiceQueue(self, cardId)
        elseif seekType == 99 then --查询是否完成bingo队列
            if not self.DiceQueue then return true end
            for k, v in pairs(self.DiceQueue) do
                if v.state == 1 then
                    return false
                end
                local normalDiceCount = 0
                local extraDiceCount = 0
                for k1, v1 in pairs(v.dices) do
                    if v1.diceType == 1 then
                        normalDiceCount = normalDiceCount + 1
                    else
                        extraDiceCount = extraDiceCount + 1
                    end
                end
                if normalDiceCount < 5 then --骰子数量少于5，不需要等待
                    return true
                else
                    if v.singleBingo == 0 then
                        return false
                    elseif extraDiceCount > 0 and v.doubleBingo == 0 then
                        return false
                    elseif extraDiceCount > 1 and v.tripleBingo == 0 then
                        return false
                    end
                end
            end
            return true
        end
    end
end

---增加卡牌盖章骰子和额外bingo
---@param diceType number 骰子类型1-卡牌盖章骰子 2-额外bingo
function Private.AddDice(self, cardId, diceType, diceIndex)
    if not self.DiceQueue then self.DiceQueue = {} end
    if diceType == 3 then diceType = 2 end
    if not self.DiceQueue[cardId] then
        self.DiceQueue[cardId] = {
            singleBingo = 0, ---0-未形成 1-形成
            doubleBingo = 0,
            tripleBingo = 0,
            state = 0,          ---0-未播放 1-播放中
            dices = {},
            extraDice1 = false, --收集到额外bingo拼图1
            extraDice2 = false, --收集到额外bingo拼图2
        }
    else
        if #self.DiceQueue[cardId] > 7 then
            log.e("LetemRollCardCollectView:AddDice diceQueue is full")
            return
        end
    end
    table.insert(self.DiceQueue[cardId].dices, {
        diceType = diceType,
        --diceIndex = diceIndex,
        state = 0, ---0-未播放 1-播放中 2-播放完成

    })
end

---检查队列是否满足播放
function Private.CheckDiceQueue(self, cardId, diceType)
    if diceType and self.DiceQueue and self.DiceQueue[cardId] then
        log.r("LetemRollCardCollectView:CheckDiceQueue diceType = ", diceType)
        if diceType == 2 then
            self.DiceQueue[cardId].extraDice1 = true
        elseif diceType == 3 then
            self.DiceQueue[cardId].extraDice2 = true
        end
    end
    if self.DiceQueue and self.DiceQueue[cardId].state == 0 then
        log.r("LetemRollCardCollectView:CheckDiceQueue diceQueue = ", self.DiceQueue[cardId].state,
            self.DiceQueue[cardId].singleBingo, self.DiceQueue[cardId].doubleBing, self.DiceQueue[cardId].tripleBingo)
        if self.DiceQueue[cardId].singleBingo == 0 then
            Private.CheckSingleBingo(self, cardId)
        elseif self.DiceQueue[cardId].doubleBingo == 0 then
            Private.CheckDoubleBingo(self, cardId)
        elseif self.DiceQueue[cardId].tripleBingo == 0 then
            Private.CheckTripleBingo(self, cardId)
        end
    end
end

---检查队列是否满足单Bingo
function Private.CheckSingleBingo(self, cardId)
    if self.DiceQueue[cardId].singleBingo == 0 then
        if #self.DiceQueue[cardId].dices >= 5 then
            local diceCount = 0
            for i = 1, #self.DiceQueue[cardId].dices do
                if self.DiceQueue[cardId].dices[i].diceType == 1 then
                    diceCount = diceCount + 1
                end
            end
            if diceCount >= 5 then
                self:CalculateBingo2(cardId, 1)
            end
        end
    end
end

---检查队列是否满足单Bingo
function Private.CheckDoubleBingo(self, cardId)
    if self.DiceQueue[cardId].doubleBingo == 0 then
        if self.DiceQueue[cardId].extraDice1 and #self.DiceQueue[cardId].dices >= 6 then
            self:CalculateBingo2(cardId, 2)
        end
    end
end

---检查队列是否满足单Bingo
function Private.CheckTripleBingo(self, cardId)
    if self.DiceQueue[cardId].tripleBingo == 0 then
        if self.DiceQueue[cardId].extraDice2 and #self.DiceQueue[cardId].dices >= 7 then
            self:CalculateBingo2(cardId, 3)
        end
    end
end

--- 队列改变状态
function Private.ChangeDiceQueueState(self, cardId, state, bingoType)
    if state == 1 and self.DiceQueue[cardId].state == 1 then
        log.e("状态重叠,已经在队列播放状态中")
    end
    self.DiceQueue[cardId].state = state
    if bingoType then
        if bingoType == 1 then
            self.DiceQueue[cardId].singleBingo = 1
        elseif bingoType == 2 then
            self.DiceQueue[cardId].doubleBingo = 1
        else
            self.DiceQueue[cardId].tripleBingo = 1
        end
    end
end

return this
