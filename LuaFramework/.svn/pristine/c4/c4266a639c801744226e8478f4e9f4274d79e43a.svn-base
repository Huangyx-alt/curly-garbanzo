local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class LetemRollGameCardView : GameCardView
local LetemRollGameCardView = GameCardView:New("LetemRollGameCardView")
local this = LetemRollGameCardView

local private = {}
private.ItemTypeToFlyTarget = { "LTRxiaditu", "LTRxiasyc", "LTRxiamati", "LTRxiayandou" }
local bowlCount = {}
--- 记录新bingo的类型
local newBingoType = {}

local interval = 0
local timeMemory = 0

--- 重载激活
function this:OnEnable(bingoView, bingosiRef, is_open_search)
    self:BaseEnable(bingoView, bingosiRef, is_open_search)
    --self:LoadRequire()
    --self:SetParentView(bingoView)
    --self:GetControlModel()
    --self:InitCardMapObj()
    --self:InitParams()
    ----self:GetLoadingData()
    --self:InitCity()
    --self:InitCallNumber(bingosiRef)
    --self:InitNumberCall()
    --Event.Brocast(EventName.Magnifier_Default_Attribute, is_open_search)
    --self.cardLoad:LoadNormalCardData(self.parent.Bg)
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
        bowlCount[i] = { 0, 0, 0, }
        newBingoType[i] = {}
    end
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:InitCardData()
end

function this:InitCardData()
    self.cellBgEffectList = {}
    table.each(self.model:GetRoundData(), function(cardData, cardID)
        local temp = {}
        table.each(cardData.cards, function(cellData)
            local treasureItems = cellData:Treasure2Item()
            if treasureItems then
                --n个为一组
                temp[treasureItems.groupid] = temp[treasureItems.groupid] or {}
                table.insert(temp[treasureItems.groupid], cellData)
            end
        end)

        table.each(temp, function(cellDatas, groupID)
            table.each(cellDatas, function(cellData)
                cellData:SetExtInfo({ groupID = groupID, groupCells = cellDatas })
            end)
        end)
    end)
end

function this:on_x_update()
    this.__index.on_x_update(self)
end

--- 增加具体酒水
function this:AddBowlWater(cardId, bowlType, extra)
    cardId = tonumber(cardId)
    local addCount = 1
    local maxCount = Csv.GetCollectiveMaxCount(bowlType)
    log.log("dghdgh0008 the bolwtype maxcountis", maxCount, bowlType)
    if bowlCount[cardId][bowlType] < maxCount and bowlCount[cardId][bowlType] + addCount >= maxCount then
        table.insert(newBingoType[cardId], bowlType)
    end

    local lastCount = bowlCount[cardId][bowlType]
    local curCount = lastCount + addCount
    bowlCount[cardId][bowlType] = curCount

    local bowlCountRecord = deep_copy(bowlCount)
    self:GetCard(cardId):AddBowlDrink(bowlCountRecord, cardId, bowlType, lastCount, curCount, extra)
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

--- bingo格子，直接倒满酒杯
function this:IsDrinkMax(cardId, drinkType)
    cardId = tonumber(cardId)
    return bowlCount[cardId][drinkType] >= Csv.GetCollectiveMaxCount(drinkType)
end

--- 把两张有jackpot的卡移动到后面
function this:JackpotCardMoveBackground(currCardId, moveCardId, currIndex, moveIndex)
    local card1 = self:GetCardMap(currCardId)
    local card2 = self:GetCardMap(moveCardId)
    if card2 then
        local switchPos = self:GetParentView():GetSwitchView():GetSmallCardObj(moveIndex)
        local oriPos = fun.get_gameobject_scale(card2,true)
        fun.set_same_position_with(card2, switchPos)
        fun.set_gameobject_scale(card2, 0.2, 0.2, 1)
        Anim.scale_to_xy(card2, oriPos.x, oriPos.y, 1)
        local cardPos = fun.get_gameobject_pos(card1,false)
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):EnterDoubleJackpotChangeCard()
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos = fun.get_gameobject_pos(card1,true)
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
    itemType = itemType or 1
    local card = self:GetCard(cardId)
    local flyTarget = card[private.ItemTypeToFlyTarget[itemType]]
    if fun.is_not_null(flyTarget) then
        local refer = fun.get_component(flyTarget, fun.REFER)
        if fun.is_not_null(refer) then
            local target = refer:Get("di")
            if fun.is_not_null(target) then
                return target.transform.position
            end
        end
    end
    return Vector3.zero
end

function this:ReadyShowBingo(cardId, bingoType)
    self:GetCard(cardId):ReadyShowBingo(cardId, bingoType)
end

function this:ShowBingoFinish(cardId, bingoType)
    self:GetCard(cardId):ShowBingoFinish(cardId, bingoType)
end

----------------------------------------------私有方法----------------------------------------------Begin
--已弃用
--[[
function private.GetRoundCell(cardId, cellIndexs, groupid, step)
    local roundcell = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, cellIndexs[step])
    local treasureItems = nil
    if roundcell then
        treasureItems = roundcell:Treasure2Item()
    end
    --groupid是配置表里的groupid
    if treasureItems and groupid == treasureItems.groupid then
        local ext = roundcell:GetExtInfo()
        --groupID是逻辑上的groupID
        if ext and ext.groupID then
            --该cell的地图属于其他组，重新找
            return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
        else
            return roundcell, step
        end
    elseif step < #cellIndexs then
        return private.GetRoundCell(cardId, cellIndexs, groupid, step + 1)
    else
        log.r("===============================>>出錯:沒找到item_synthetic的下半部分數據cardId:" .. tostring(cardId) .. " cellIndexs:" .. tostring(cellIndexs))
        return roundcell, step
    end
end

找到材料碎片可能的格子的次序集合
function private.GetRoundIndex(treasureItems, cellIndex)
    local ret
    local borderList = { 1, 6, 11, 16, 21, 5, 10, 15, 20, 25 }
    local isBorder = fun.is_include(cellIndex, borderList)

    if treasureItems.part == 1 then
        --横向
        if treasureItems.isPivot then
            --当是合成碎片中的主要部分
            --搜索顺序：右、左、下、上
            ret = { cellIndex + 5, cellIndex - 5, cellIndex + 1, cellIndex - 1 }
        else
            --当是合成碎片中的次要部分
            --搜索顺序：左、右、上、下
            ret = { cellIndex - 5, cellIndex + 5, cellIndex - 1, cellIndex + 1 }
        end
    else
        --竖向
        if treasureItems.isPivot then
            --当是合成碎片中的主要部分
            --搜索顺序：下、上、右、左
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
--]]
----------------------------------------------私有方法----------------------------------------------End

----------------------------------------------GM工具----------------------------------------------Begin
---[[
local startCardId = 1
---每次调用将一张卡牌上的jackpot图案相关格子盖章
function this:GmSignTest()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        log.log("LetemRollGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        coroutine.start(function()
            table.each(jackpotRule, function(cellIndex)
                self:OnClickCardIgnoreJudgeByIndex(startCardId, cellIndex, 0)
                WaitForFixedUpdate()
                WaitForSeconds(0.2)
            end)
            startCardId = startCardId + 1
            if startCardId > cardCount then
                startCardId = 1
            end
        end)
    else
        log.log("LetemRollGameCardView:GmSignTest 一键达成jackpot fail no jackpotRuleId", cardCount, loadData)
    end
end
--]]
----------------------------------------------GM工具----------------------------------------------End

return this