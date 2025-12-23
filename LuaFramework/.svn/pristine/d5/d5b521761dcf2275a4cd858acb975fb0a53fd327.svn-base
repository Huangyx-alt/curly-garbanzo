---bingo规则
local BaseBingoRule = require("Combat.Machine.CalculateBingo.BaseBingoRule")
local PiggyBankBingoRule = BaseBingoRule:New("PiggyBankBingoRule")
local this = PiggyBankBingoRule
local itemWishData = {}
local currWishList = {}

local Private = {}

function PiggyBankBingoRule:Start(loadData, ruleData)
    this.jackpotRule = nil
    self.CollectionQueue = nil
    itemWishData = {}
    currWishList = {}
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
    if this.model then
        this.data = this.model:GetRoundData()
    end
end

function PiggyBankBingoRule:GetBingoType(cardId, cellIndex)
    local bingoType = 1
    return bingoType
end

function PiggyBankBingoRule:CalculateBingo(cardId, cellIndex, options)
    fun.SafeCall(options and options.onBingoShowComplete)
end

function PiggyBankBingoRule:InnerCalculateBingo(cardId, bingoType)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, nil, cardId)
    bingoInfo.bingoType = this:GetBingoType(cardId)
    table.insert(newBingoInfoList, bingoInfo)

    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList, newBingoInfoList)
    end

    if #totalBingoInfoList > 0 then
        Private.ChangeCollectionQueueState(self, cardId, 1, bingoType)
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

--只处理了wish相关逻辑
function PiggyBankBingoRule:OnDataChange(cardId, cellIndex, ...)
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
function PiggyBankBingoRule:TriggerWish(cardId, idx)
    local mapCellIndex = (itemWishData[cardId][idx].cells and #itemWishData[cardId][idx].cells > 0) and
    itemWishData[cardId][idx].cells[1] or cellIndex
    local cellData = ModelList.PiggyBankModel:GetRoundData(cardId, mapCellIndex)
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
function PiggyBankBingoRule:CancelWish(cardId, idx)   
    Event.Brocast(EventName.CardBingoEffect_CancelShowWish, cardId, itemWishData[cardId].wishIndex)
    itemWishData[cardId][idx].iswish = false
end

function PiggyBankBingoRule:CalculateJackpot(cardId, cellIndex)
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
function PiggyBankBingoRule:SetInfo(setType, cardId, itemType)
    if setType and cardId then
        if setType == 1 then
            Private.AddItem(self, cardId, itemType)
        elseif setType == 2 then
            Private.CheckCollectionQueue(self, cardId, itemType)
        end
    end
end

---提供一个查询接口,再内部自定义逻辑
function PiggyBankBingoRule:SeekInfo(seekType, cardId)
    if seekType then
        if seekType == 1 then -- 查询是否形成Bingo
            Private.ChangeCollectionQueueState(self, cardId, 0)
        elseif seekType == 99 then --查询是否完成bingo队列
            if not self.CollectionQueue then return true end
            for k, v in pairs(self.CollectionQueue) do
                if v.state == 1 then
                    return false
                end

                if v.findCriticalItem then
                    if #v.normalItems >= 1 and v.singleBingo == 0 then
                        return false
                    elseif #v.normalItems >= 2 and v.doubleBingo == 0 then
                        return false
                    elseif #v.normalItems >= 3 and v.tripleBingo == 0 then
                        return false
                    end
                end
            end

            return true
        end
    end
end

function Private.AddItem(self, cardId, itemType)
    if not self.CollectionQueue then
        self.CollectionQueue = {}
    end

    if not self.CollectionQueue[cardId] then
        self.CollectionQueue[cardId] = {
            singleBingo = 0, ---0-未形成 1-形成
            doubleBingo = 0,
            tripleBingo = 0,
            state = 0,          ---0-未播放 1-播放中
            normalItems = {},
            findCriticalItem = false,
        }
    end

    if itemType == 4 then
        self.CollectionQueue[cardId].findCriticalItem = true
    else
        table.insert(self.CollectionQueue[cardId].normalItems, {
            itemType = itemType,
            state = 0, ---0-未播放 1-播放中 2-播放完成
        })
    end
end

---检查队列是否满足播放
function Private.CheckCollectionQueue(self, cardId, itemType)
    if self.CollectionQueue and self.CollectionQueue[cardId].state == 0 then
        if self.CollectionQueue[cardId].singleBingo == 0 then
            Private.CheckBingo(self, cardId, 1)
        elseif self.CollectionQueue[cardId].doubleBingo == 0 then
            Private.CheckBingo(self, cardId, 2)
        elseif self.CollectionQueue[cardId].tripleBingo == 0 then
            Private.CheckBingo(self, cardId, 3)
        end
    end
end

---检查队列是否满足单Bingo
function Private.CheckBingo(self, cardId, targetBingoCount)
    if not self.CollectionQueue[cardId].findCriticalItem then
        return
    end
    if #self.CollectionQueue[cardId].normalItems < targetBingoCount then
        return
    end
    self:InnerCalculateBingo(cardId, targetBingoCount)
end

--- 队列改变状态
function Private.ChangeCollectionQueueState(self, cardId, state, bingoType)
    if state == 1 and self.CollectionQueue[cardId].state == 1 then
        log.e("状态重叠,已经在队列播放状态中")
    end
    self.CollectionQueue[cardId].state = state
    if bingoType then
        if bingoType == 1 then
            self.CollectionQueue[cardId].singleBingo = 1
        elseif bingoType == 2 then
            self.CollectionQueue[cardId].doubleBingo = 1
        else
            self.CollectionQueue[cardId].tripleBingo = 1
        end
    end
end

return this