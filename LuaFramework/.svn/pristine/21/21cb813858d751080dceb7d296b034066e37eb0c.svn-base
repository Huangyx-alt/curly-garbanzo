
local BaseBingoRule =  require("Combat.Machine.CalculateBingo.BaseBingoRule")

local CollectTreasureBingoRule = BaseBingoRule:New("CollectTreasureBingoRule")
local this = CollectTreasureBingoRule

local bowlCount={}
local currWishList ={}
local wishItems = {}

function CollectTreasureBingoRule:Start(loadData,wish_item)
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
            drinkCount = { 0, 0, 0, 0 }, --4个酒杯的酒量，满4就bingo
            bingo = {}, --能形成bingo的酒杯ID
            jackpot = 0 --  0没有jackpot  1 形成了jackpot
        }
        currWishList[i] = {}
    end
    this:InitData()
    this.model = ModelList.BattleModel:GetCurrModel()
end

function CollectTreasureBingoRule:CalculateBingo(cardId,cellIndex,...)
    local totalBingoInfoList = {}
    local newBingoInfoList = {}
    local num = {...}
    for i= 1, #bowlCount do
        if #bowlCount[i].bingo > 0  then
            local bingoInfo = this:CreateBingoInfo(this.BingoType.BINGO, num, cardId)
            table.insert(newBingoInfoList, bingoInfo)
            bowlCount[i].bingo = {}
        end
    end
    if #newBingoInfoList > 0 then
        fun.merge_array(totalBingoInfoList,newBingoInfoList)
    end

    if this:CalculateJackpot(cardId) then
        local bingoInfo = { type = this.BingoType.JACKPOT, numbers = num,
                            cardId = cardId, totolCount = this.totalBingoCount[cardId], th = 0}
        table.insert(totalBingoInfoList,bingoInfo)
    end
    --this:CalculateCardWish(cardId)
    if #totalBingoInfoList > 0 then
        Event.Brocast(EventName.Player_Bingo_Reduce_Bingoleft, totalBingoInfoList, cardId)
    end
end

function CollectTreasureBingoRule:OnDataChange(cardId,cellIndex,...)
    local arg = {...}
    local bowlType = arg[1]
    local addCount = arg[2]
    bowlCount [cardId].drinkCount[bowlType] = bowlCount [cardId].drinkCount[bowlType] + addCount
    if bowlCount [cardId].drinkCount[bowlType] > Csv.GetCollectiveMaxCount(bowlType) then
        bowlCount [cardId].drinkCount[bowlType] = Csv.GetCollectiveMaxCount(bowlType)
    end
    local count = 0
    local totleCount = 0
    for key, value in pairs(bowlCount[cardId].drinkCount) do
        totleCount = totleCount + 1
        if value >= Csv.GetCollectiveMaxCount(key) then
            count = count + 1
        end
    end
    if count >= totleCount then
        table.insert(bowlCount[cardId].bingo,cardId)
    end
end

function CollectTreasureBingoRule:CalculateJackpot(cardId)
    --if bowlCount[cardId].jackpot == 1 then return false end
    local jackpotCount = 4 --写死了，可以读表的
    local bingoCount = math.min(ModelList.BattleModel:GetCurrModel():GetCardCount(),jackpotCount) 
    for key, value in pairs(bowlCount) do
        for i = 1, #value.drinkCount do
            if value.drinkCount[i]  < Csv.GetCollectiveMaxCount(i)  then
                bingoCount = bingoCount - 1
                break
            end
        end
    end
    return bingoCount == jackpotCount
end

function CollectTreasureBingoRule:ForceBingo()
    local max = 0
    local type = 0
    for i = 1, #bowlCount do
        if bowlCount[i] > max and bowlCount[i] < Csv.GetCollectiveMaxCount(i) then
            max = bowlCount[i]
            type = i
        end
    end
    return max,bowlCount
end



--- 计算是否出现wish,
--[[
function CollectTreasureBingoRule:CalculateCardWish(cardId)
    local needShowThreeWish = false
    for i = 1, #bowlCount[cardId].drinkCount do
        if bowlCount [cardId].drinkCount[i]  ==  Csv.GetCollectiveMaxCount(i) -1 then
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
--]]

return this