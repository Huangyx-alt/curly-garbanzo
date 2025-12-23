local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class GoldenTrainGameCardView : GameCardView
local GoldenTrainGameCardView = GameCardView:New("GoldenTrainGameCardView")
local this = GoldenTrainGameCardView

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
        newBingoType[i] = {}
    end
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:InitCardData()
    self:SetDefaultOpenCell()
end

--初始化单格数据
function this:InitCardData()
    self.cellBgEffectList = {}
    --table.each(self.model:GetRoundData(), function(cardData, cardID) end) --重新分组
end

function this:on_x_update()
    this.__index.on_x_update(self)
end

function this:OnCollectItem(cardId, cellIdx)
    cardId = tonumber(cardId)
    cellIdx = tonumber(cellIdx)
    self:GetCard(cardId):OnCollectItem(cardId, cellIdx)
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
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function ()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos = fun.get_gameobject_pos(card1, true)
        Anim.move(card1, currPos.x - 2000, currPos.y, currPos.z, 1, true, true)
    end
end

function this:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.OnCollectItem, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.OnCollectItem, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function this:StorageCellBgEffect(cardId, cellIndex, effect)
    local isContain = false
    cardId = tonumber(cardId)
    cellIndex = tonumber(cellIndex)
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
        table.insert(self.cellBgEffectList[cardId], { cellIndex = cellIndex, effectList =  effect  })
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

    return Vector3.zero
end

function this:ShowTrainInitalAnima()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self:GetCard(i):ShowTrainInitalAnima()
    end
end

function this:ShowShakeAnima(cardId)
    if not cardId then
        return
    end
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        if tonumber(cardId) == i then
            self:GetCard(i):ShowShakeAnima()
        end
    end
end

----------------------------------------------GM工具----------------------------------------------Begin
---[[
local startCardId = 1
---每次调用将一张卡牌上的jackpot图案相关格子盖章
function this:GmSignTestV0()
    local cardCount = self.model:GetCardCount()
    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        log.log("GoldenTrainGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        coroutine.start(function ()
            table.each(jackpotRule, function (cellIndex)
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
        log.log("GoldenTrainGameCardView:GmSignTest 一键达成jackpot fail no jackpotRuleId", cardCount, loadData)
    end
end

function this:GmSignTestV1()
    local cardCount = self.model:GetCardCount()
    log.log("GoldenTrainGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
    coroutine.start(function ()
        for cellIndex = 1, 25 do
            self:OnClickCardIgnoreJudgeByIndex(startCardId, cellIndex, 0)
            WaitForFixedUpdate()
            WaitForSeconds(0.2)
        end
        startCardId = startCardId + 1
        if startCardId > cardCount then
            startCardId = 1
        end
    end)
end

local colIdx = 1
function this:GmSignTestV2()
    local cardCount = self.model:GetCardCount()
    log.log("GoldenTrainGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
    coroutine.start(function ()
        for cellIndex = 1, 5 do
            self:OnClickCardIgnoreJudgeByIndex(startCardId, cellIndex + 5 * (colIdx - 1), 0)
            WaitForFixedUpdate()
            WaitForSeconds(0.2)
        end
        colIdx = colIdx + 1
        if colIdx > 5 then
            colIdx = 1
            startCardId = startCardId + 1
            if startCardId > cardCount then
                startCardId = 1
            end
        end
    end)
end

local cellIdx = 21
function this:GmSignTestV3()
    local cardCount = self.model:GetCardCount()
    log.log("GoldenTrainGameCardView:GmSignTest 一键达成jackpot succ", cardCount, startCardId)
    coroutine.start(function ()
        self:OnClickCardIgnoreJudgeByIndex(startCardId, cellIdx, 0)
        WaitForFixedUpdate()
        WaitForSeconds(0.2)

        cellIdx = cellIdx + 1
        if cellIdx > 25 then
            cellIdx = 1
            startCardId = startCardId + 1
            if startCardId > cardCount then
                startCardId = 1
            end
        end
    end)
end

function this:GmSignTest()
    --[[
    if colIdx < 5 then
        this:GmSignTestV2()
    else
        if cellIdx <= 25 then
            this:GmSignTestV3()
        else
            startCardId = startCardId + 1
            colIdx = 1
            cellIdx = 21
        end
    end
    --]]
    this:GmSignTestV0()
end
--]]
----------------------------------------------GM工具----------------------------------------------End

return this
