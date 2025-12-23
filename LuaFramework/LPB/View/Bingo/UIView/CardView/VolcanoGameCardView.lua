local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class VolcanoGameCardView : GameCardView
local VolcanoGameCardView = GameCardView:New("VolcanoGameCardView")
local this = VolcanoGameCardView

local private = {}
local bowlCount = {}
local newBingoType = {}

local interval = 0
local timeMemory = 0

function this:OnEnable(bingoView, bingosiRef, is_open_search)
    self:BaseEnable(bingoView, bingosiRef, is_open_search)
    self:InitCardBowls()
end

function this:OnDisable()
    getmetatable(self).OnDisable(self)
    interval = 0
    timeMemory = 0
end

function this:InitCardBowls()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        bowlCount[i] = {0, 0, 0, 0,}
        newBingoType[i] = {}
    end
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:InitCardData()
    self:SetDefaultOpenCell()
    self:GetParentView():GetSwitchView():UpdateDefaultOpenCell()
    if self.model.dragonController then
        self.model.dragonController:InitDragons()
    end
end

local Type2Dragon = {"LongPink", "LongGreen", "LongRad", "LongBlue" }
function this:InitCardData()
    self.cellBgEffectList = {}

    --初始化火龙
    self.dragonCells = {}
    table.each(self.model:GetRoundData(), function(cardData, cardID)
        cardID = tonumber(cardID)
        self.dragonCells[cardID] = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                local data = Csv.GetData("item", treasureItems.id)
                --是火龙
                if 44 == data.result[1] then
                    table.insert(self.dragonCells[cardID], cellData.index)

                    --创建火龙ctrl
                    local dragonType = data.result[2]
                    local cardView = self:GetCard(cardID)
                    local dragonCtrl = BattleEffectPool:Get(Type2Dragon[dragonType])
                    if dragonCtrl then
                        cardView.dragonCtrlList = cardView.dragonCtrlList or {}
                        cardView.dragonCtrlList[dragonType] = dragonCtrl

                        --与格子位置同步
                        fun.set_parent(dragonCtrl, cardView.MoveRoot)
                        local cellBg = cellData:GetCellReferScript("bg_tip")
                        fun.set_same_position_with(dragonCtrl, cellBg)
                    end
                end
            end
        end)
    end)
end

function this:SetDefaultOpenCell()    
    for i = 1, #self.cardMap do
        table.each(self.dragonCells[i], function(cellIndex)
            local obj = self.cardMap[i][cellIndex]
            self:SignCardEffect(i, cellIndex, obj, 0, 0, false, 0)
            if not self.model:GetRoundData() then
                return
            end
            self.model:RefreshRoundDataByIndex(i, cellIndex, 1, false, -1)
            Event.Brocast(EventName.CardPower_Sign_Cell, i, cellIndex)
        end)

        --火山格子
        local obj = self.cardMap[i][13]
        self:SignCardEffect(i, 13, obj, 0, 0, false, 0)
        if not self.model:GetRoundData() then
            return
        end
        self.model:RefreshRoundDataByIndex(i, 13, 1, false, -1)
        Event.Brocast(EventName.CardPower_Sign_Cell, i, 13)
    end
end

function this:on_x_update()
    this.__index.on_x_update(self)
end

function this:AddBowlWater(cardId, bowlType, isMax)
    cardId = tonumber(cardId)
    if not isMax then
        isMax = false
    end
    local addCount = 1
    local maxCount = Csv.GetCollectiveMaxCount(bowlType)
    if isMax then
        addCount = maxCount - bowlCount[cardId][bowlType]
    end
    if bowlCount[cardId][bowlType] < maxCount and bowlCount[cardId][bowlType] + addCount >= maxCount then
        table.insert(newBingoType[cardId], bowlType)
    end
    
    self:GetCard(cardId):AddBowlDrink(bowlCount, cardId, bowlType, addCount)
end

function this:GetBingoType(cardId, bingoCount)
    cardId = tonumber(cardId)
    local bingoType = {}
    for i = 1, #bowlCount[cardId] do
        if bowlCount[cardId][i] >= Csv.GetCollectiveMaxCount(i) then
            table.insert(bingoType, i)
            if #bingoType >= bingoCount then
                break
            end
        end
    end
    local tType = 1
    if #newBingoType[cardId] > 0 then
        tType = newBingoType[cardId][1]
        table.remove(newBingoType[cardId], 1)
    else
        tType = bingoType[1]
    end
    return bingoType, tType
end

function this:IsDrinkMax(cardId, drinkType)
    cardId = tonumber(cardId)
    return bowlCount[cardId][drinkType] >= Csv.GetCollectiveMaxCount(drinkType)
end

function this:JackpotCardMoveBackground(currCardId, moveCardId, currIndex, moveIndex)
    local card1 = self:GetCardMap(currCardId)
    local card2 = self:GetCardMap(moveCardId)
    if card2 then
        local switchPos = self:GetParentView():GetSwitchView():GetSmallCardObj(moveIndex)
        local oriPos = card2.transform.localScale
        fun.set_same_position_with(card2, switchPos)
        fun.set_gameobject_scale(card2, 0.2, 0.2, 1)
        Anim.scale_to_xy(card2, oriPos.x, oriPos.y, 1)
        local cardPos = fun.get_gameobject_pos( card1)
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):EnterDoubleJackpotChangeCard()
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos =  fun.get_gameobject_pos(card1,true)
        Anim.move(card1, currPos.x - 2000, currPos.y, currPos.z, 1, true, true)
    end
end

function this:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:StorageCellBgEffect(cardId, cellIndex, effect)
    local isContain = false
    if not self.cellBgEffectList[cardId] then
        self.cellBgEffectList[cardId] = {}
    end
    for i = 1, #self.cellBgEffectList[cardId] do
        if self.cellBgEffectList[cardId][i].cellIndex == cellIndex then
            table.insert(self.cellBgEffectList[cardId][i].effectList, effect)
            isContain = true
            break
        end
    end
    if not isContain then
        table.insert(self.cellBgEffectList[cardId], { cellIndex = cellIndex, effectList = { effect } })
    end
end

function this:GetCellBgEffect(cardId, cellIndex)
    cardId = tonumber(cardId)
    if not self.cellBgEffectList[cardId] then
        return nil
    end
    for i = 1, #self.cellBgEffectList[cardId] do
        if self.cellBgEffectList[cardId][i].cellIndex == cellIndex then
            return self.cellBgEffectList[cardId][i].effectList
        end
    end
    return nil
end

function this:GetFlyTargetPos(cardId, itemType)
    local card, ctrlName = self:GetCard(cardId), string.format("Collectitem%s", itemType)
    local flyTarget = card[ctrlName]
    if fun.is_not_null(flyTarget) then
        return flyTarget.transform.position
    end
end

----------------------------------GM------------------------------------

local startId = 1
---每次调用将一张卡牌上的jackpot图案相关格子盖章
function this:GmSignTest()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        coroutine.start(function()
            table.each(jackpotRule, function(cellIndex)
                self:OnClickCardIgnoreJudgeByIndex(startId, cellIndex, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end)
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    else
        coroutine.start(function()
            for i = 25, 1, -1 do
                view:OnClickCardIgnoreJudgeByIndex(startId, i, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end
            startId = startId + 1
            if startId > cardCount then
                startId = 1
            end
        end)
    end
end

---------------------------------------------------------------

function private.GetRoundCell(cardId, cellIndexs, groupid, step)
    local roundcell = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndexs[step])
    local treasureItems = nil
    if roundcell then
        treasureItems = roundcell:Treasure2Item()
    end

    if treasureItems and groupid == treasureItems.groupid then
        local ext = roundcell:GetExtInfo()

        if ext and ext.groupID then
            return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
        else
            return roundcell, step
        end
    elseif step < #cellIndexs then
        return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
    else
        return roundcell, step
    end
end

function private.GetRoundIndex(treasureItems, cellIndex)
    local ret
    local borderList = { 1, 6, 11, 16, 21, 5, 10, 15, 20, 25 }
    local isBorder = fun.is_include(cellIndex, borderList)

    if treasureItems.part == 1 then
        if treasureItems.isPivot then
            ret = { cellIndex + 5, cellIndex - 5, cellIndex + 1, cellIndex - 1 }
        else
            ret = { cellIndex - 5, cellIndex + 5, cellIndex - 1, cellIndex + 1 }
        end
    else
        if treasureItems.isPivot then
            if isBorder then
                ret = { cellIndex - 1, cellIndex + 1, cellIndex + 5, cellIndex - 5 }
            else
                ret = { cellIndex + 1, cellIndex - 1, cellIndex + 5, cellIndex - 5 }
            end
        else
            ret = { cellIndex - 1, cellIndex + 1, cellIndex + 5, cellIndex - 5 }
        end
    end

    return ret
end

return this