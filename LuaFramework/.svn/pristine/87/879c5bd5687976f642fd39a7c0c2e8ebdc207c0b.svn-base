local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class DrinkingFrenzyGameCardView : GameCardView
local DrinkingFrenzyGameCardView = GameCardView:New("DrinkingFrenzyGameCardView")
local this = DrinkingFrenzyGameCardView

local private = {}
private.ItemTypeToFlyTarget = { "LTRxiaditu", "LTRxiasyc", "LTRxiamati", "LTRxiayandou" }
local bowlCount = {}
--- 记录新bingo的类型
local newBingoType = {}

local interval = 0
local timeMemory = 0
local midItemGroupId1 = 26002
local midItemGroupId2 = 26003
local midItemGroupIds = { 26002, 26003, 26005, 26006, 26008, 26009, 26011, 26012, 26014, 26015 }

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
        bowlCount[i] = { 0, 0, 0, 0 }
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

        ---[重新分组
        local orgMidItemGroudId, orgMidItems
        local otherMidItemGroudId, otherMidItems
        for i, v in pairs(temp) do
            --if i == midItemGroupId1 or i == midItemGroupId2 then
            if IsValueInList(i, midItemGroupIds) then
                if #v == 4 then
                    table.sort(v, function(a, b)
                        return a.index < b.index
                    end)

                    local itemData = fun.GetDataFromCsvMatchCondition("item_synthetic", "groupid", i)
                    if itemData then
                        if itemData.part and itemData.part[1] == 1 then
                            orgMidItemGroudId = i
                            otherMidItemGroudId = orgMidItemGroudId + 100
                            orgMidItems = { v[1] }
                            otherMidItems = {}
                            for idx = 2, 4 do
                                if v[1].index == (v[idx].index + 5) or v[1].index == (v[idx].index - 5) then
                                    table.insert(orgMidItems, v[idx])
                                else
                                    table.insert(otherMidItems, v[idx])
                                end
                            end
                        elseif itemData.part and itemData.part[1] == 2 then
                            orgMidItemGroudId = i
                            otherMidItemGroudId = orgMidItemGroudId + 200
                            orgMidItems = { v[1] }
                            otherMidItems = {}
                            for idx = 2, 4 do
                                if v[1].index == (v[idx].index + 1) or v[1].index == (v[idx].index - 1) then
                                    table.insert(orgMidItems, v[idx])
                                else
                                    table.insert(otherMidItems, v[idx])
                                end
                            end
                        else
                            log.log("DrinkingFrenzyGameCardView:DrinkingFrenzyGameCardView 配表异常1 item_synthetic", i)
                            break
                        end
                    else
                        log.log("DrinkingFrenzyGameCardView:DrinkingFrenzyGameCardView 配表异常2 item_synthetic", i)
                    end
                elseif #v == 2 then
                    break
                else
                    log.log("DrinkingFrenzyGameCardView:DrinkingFrenzyGameCardView 数据异常1", #v)
                    break
                end
            end
        end

        if orgMidItemGroudId then
            if #orgMidItems == #otherMidItems then
                temp[orgMidItemGroudId] = orgMidItems
                temp[otherMidItemGroudId] = otherMidItems
            else
                log.log("DrinkingFrenzyGameCardView:DrinkingFrenzyGameCardView 重分组异常", temp[orgMidItemGroudId], orgMidItems, otherMidItems)
            end
        end
        --]]

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
function this:AddBowlWater(itemId,cardId, bowlType, isMax)
    cardId = tonumber(cardId)
    if not isMax then
        isMax = false
    end
    local addCount = 1
    log.log("数据有错误 itemId " , itemId)
    log.log("数据有错误 cardId " , cardId)
    log.log("数据有错误 bowlType " , bowlType)
    self:GetCard(cardId):AddBowlDrink(itemId,bowlCount, cardId, bowlType, addCount)
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
        local oriPos = fun.get_gameobject_scale(card2, true)
        fun.set_same_position_with(card2, switchPos)
        fun.set_gameobject_scale(card2, 0.2, 0.2, 1)
        Anim.scale_to_xy(card2, oriPos.x, oriPos.y, 1)
        local cardPos = fun.get_gameobject_pos(card1, false)
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):EnterDoubleJackpotChangeCard()
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos = fun.get_gameobject_pos(card1, true)
        Anim.move(card1, currPos.x - 2000, currPos.y, currPos.z, 1, true, true)
    end
end

function this:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
    Event.AddListener(EventName.Switch_View_Before, self.BeforeSwitchView, self)
    Event.AddListener(EventName.Switch_View_After, self.AfterSwitchView, self)
    Event.AddListener(EventName.Switch_View_End_Show, self.BeforeSwitchView, self)
end

function this:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.AddBowlWater, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
    Event.RemoveListener(EventName.Switch_View_Before, self.BeforeSwitchView, self)
    Event.RemoveListener(EventName.Switch_View_After, self.AfterSwitchView, self)
    Event.RemoveListener(EventName.Switch_View_End_Show, self.BeforeSwitchView, self)
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

function this:GetFlyItemParent(cardId)
    local card = self:GetCard(cardId)
    local flyParent = card:GetFlyItemParent()
    return flyParent
end

function this:ShowRightPlayerWaitBeer(cardId)
    local card = self:GetCard(cardId)
    card:ShowRightPlayerEnterEffect(cardId,true)
end


function this:GetFlyTargetPos(itemId,cardId, itemType)
    itemType = itemType or 1
    local card = self:GetCard(cardId)
    --local flyTarget = card[private.ItemTypeToFlyTarget[itemType]]
    local flyTarget = card:GetFlyGlassTarget(itemId, cardId)
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

local startCardId = 1
---每次调用将一张卡牌上的jackpot图案相关格子盖章
function this:GmSignTest()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        log.log("DrinkingFrenzyGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
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
        log.log("DrinkingFrenzyGameCardView:GmSignTest 一键达成jackpot fail no jackpotRuleId", cardCount, loadData)
    end
end

function this:ShowExtraBonusEffect()
    UISound.play("drinkingbonusshow")
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):ShowExtraBonusEffect(i)
    end
end

function this:ShowPlayerEnterEffect()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):ShowPlayerEnterEffect(i)
    end
end

function this:CheckAllCardAnimShowOver()
    local ret = true
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        ret = ret and self:GetCard(i):CheckAllAnimShowOver(i)
    end
    return ret
end

--展示maxbet时的特殊效果
function this:ShowMaxBetEffect(cb)
    self:AfterSwitchView()
    if self.model:GetIsMaxBet() then
        self:ShowExtraBonusEffect()
        LuaTimer:SetDelayFunction(3.7, function()
            fun.SafeCall(cb)
        end, nil, LuaTimer.TimerType.Battle)
    else
        self:ShowPlayerEnterEffect()
        LuaTimer:SetDelayFunction(2, function()
            fun.SafeCall(cb)
        end, nil, LuaTimer.TimerType.Battle)
    end
end

function this:BeforeSwitchView()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):BeforeSwitchView()
    end
end 

function this:AfterSwitchView()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):AfterSwitchView()
    end
end

return this