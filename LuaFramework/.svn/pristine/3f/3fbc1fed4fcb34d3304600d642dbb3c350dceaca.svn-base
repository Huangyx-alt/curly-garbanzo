--- 赛马bingo规则
local BaseBingoRule =  require("Combat.Machine.CalculateBingo.BaseBingoRule")
local HorseRacingBingoRule = BaseBingoRule:New("HorseRacingBingoRule")
local this = HorseRacingBingoRule
--setmetatable(HorseRacingBingoRule, {__index = BaseBingoRule})

local bowlCount={}
local currWishList ={}
local MaxWaterCount = {}
local wishItems = {}

function HorseRacingBingoRule:Start(loadData, wish_item)
    bowlCount = {}
    wishItems = {}
    currWishList = {}
    if wish_item then
        for i = 1, #wish_item do
            if wish_item[i] ~= 0 then
                table.insert(wishItems, wish_item[i])
            end
        end
    end
    local cardCount = #loadData.cardsInfo
    for i = 1, cardCount do
        bowlCount[i] = {
            drinkCount = { 0, 0, 0, 0, 0}, --4个酒杯的酒量，满4就bingo
            bingo = {}, --能形成bingo的酒杯ID
            jackpot = 0 --  0没有jackpot  1 形成了jackpot
        }
        currWishList[i] = {}
    end
    this:InitData()
    MaxWaterCount = {
        5, 5, 5, 5, 5
    }
    this.model = ModelList.BattleModel:GetCurrModel()
end

function HorseRacingBingoRule:CalculateBingo(cardId, cellIndex, ...)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    local num = {...}
    --[[
    for i= 1, #bowlCount do
        if #bowlCount[i].bingo > 0  then
            local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
            bingoInfo.isSuperBingo = this:IsSuperBingo(cardId, cellIndex)
            table.insert(newBingoInfoList, bingoInfo)
            bowlCount[i].bingo = {}
        end
    end
    --]]

    ---[[
    if #bowlCount[cardId].bingo > 0  then
        local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
        bingoInfo.isSuperBingo = this:IsSuperBingo(cardId, cellIndex)
        table.insert(newBingoInfoList, bingoInfo)
        bowlCount[cardId].bingo = {}
    end
    --]]

    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList,newBingoInfoList)
    end

    if this:CalculateJackpot(cardId) then
        local bingoInfo = { type = this.BingoType.JACKPOT, numbers = num,
                            cardId = cardId, totolCount = this.totalBingoCount[cardId], th = 0}
        table.insert(totalBingoInfoList,bingoInfo)
    end
    --this:CalculateCardWish(cardId)
    if #totalBingoInfoList >0 then
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

function HorseRacingBingoRule:IsSuperBingo(cardId, cellIndex)
    local col = this.model:CellIndex2Col(cellIndex)
    local level = this.model:GetCollectLevelByCardIdAndTrackIdx(cardId, col)

    return level == 1
end

function HorseRacingBingoRule:OnDataChange(cardId, cellIndex, ...)
    local arg = {...}
    local bowlType = arg[1]
    local addCount = arg[2]
    if bowlCount[cardId].drinkCount[bowlType] < MaxWaterCount[bowlType] and
            bowlCount[cardId].drinkCount[bowlType] + addCount >= MaxWaterCount[bowlType] then
        table.insert(bowlCount[cardId].bingo, bowlType)
    end
    bowlCount[cardId].drinkCount[bowlType] = bowlCount[cardId].drinkCount[bowlType] + addCount
    if bowlCount[cardId].drinkCount[bowlType] > MaxWaterCount[bowlType] then
        bowlCount[cardId].drinkCount[bowlType] = MaxWaterCount[bowlType]
    end
    --this:CalculateCardWish(cardId)
end

function HorseRacingBingoRule:CalculateJackpot(cardId)
    if bowlCount[cardId].jackpot == 1 then return false end
    local allBingo = true
    for i = 1, #bowlCount[cardId].drinkCount do
        if bowlCount[cardId].drinkCount[i] < MaxWaterCount[i] then
            allBingo = false
            break
        end
    end
    return allBingo
end

function HorseRacingBingoRule:ForceBingo()
    local max = 0
    local type = 0
    for i = 1, #bowlCount do
        if bowlCount[i] > max and bowlCount[i] < MaxWaterCount[1] then
            max = bowlCount[i]
            type = i
        end
    end
    return max, bowlCount
end

--- 计算是否出现wish,
function HorseRacingBingoRule:CalculateCardWish(cardId)
    local needShowThreeWish = false
    for i = 1, #bowlCount[cardId].drinkCount do
        if bowlCount[cardId].drinkCount[i] == MaxWaterCount[i] - 1 then
            needShowThreeWish = true
            currWishList[cardId] = this.model:GetRoundData(cardId):GetItemCells(wishItems)
            break
        end
    end
    if not needShowThreeWish then
        if currWishList[cardId] and #currWishList[cardId] > 0 then
            for i = 1, #currWishList[cardId] do
                Event.Brocast(EventName.CardBingoEffect_CancelShowWish,cardId,currWishList[cardId][i])
            end
        end
        currWishList[cardId] ={}
    else
        for i = 1, #currWishList[cardId] do
            Event.Brocast(EventName.CardBingoEffect_ShowWish,cardId,currWishList[cardId][i])
        end
    end
end

return this