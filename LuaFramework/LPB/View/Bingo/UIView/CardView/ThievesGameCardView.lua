local GameCardView = require("View.Bingo.UIView.CardView.GameCardView")

---@class ThievesGameCardView : GameCardView
local ThievesGameCardView = GameCardView:New("ThievesGameCardView")
local this = ThievesGameCardView
setmetatable(ThievesGameCardView, { __index = GameCardView })

local thievesTiers = {}
--- 记录新bingo的类型
local newBingoType = {}
local MaxTiers = 4

--- 重载激活
function ThievesGameCardView:OnEnable(bingoView, bingosiRef, is_open_search)
    self:BaseEnable(bingoView, bingosiRef, is_open_search)
    self:InitCardLogicData()
    self.nextKey = {}
end

function ThievesGameCardView:RegisterExtraEvent()
    Event.AddListener(EventName.Event_View_Collect_Item, self.OnCollectItem, self)
    Event.AddListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

function ThievesGameCardView:UnRegisterExtraEvent()
    Event.RemoveListener(EventName.Event_View_Collect_Item, self.OnCollectItem, self)
    Event.RemoveListener(EventName.Event_Move_Jackpot_Card_Background, self.JackpotCardMoveBackground, self)
end

--- 卡牌数据初始化完成之后
function this:OnCardLoadOver()
    self:SetDefaultOpenCell()
end

function ThievesGameCardView:InitCardLogicData()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        thievesTiers[i] = {}
        thievesTiers[i][7] = 0
        thievesTiers[i][9] = 0
        thievesTiers[i][17] = 0
        thievesTiers[i][19] = 0
    end
end

function ThievesGameCardView:SetDefaultOpenCell()
    local cardCount = self.model:GetCardCount()
    for i = 1, cardCount do
        self.model:OnlyRefreshRoundDataByIndex(i, 7, -1)
        self.model:OnlyRefreshRoundDataByIndex(i, 9, -1)
        self.model:OnlyRefreshRoundDataByIndex(i, 17, -1)
        self.model:OnlyRefreshRoundDataByIndex(i, 19, -1)
        newBingoType[i] = {}
    end
end

function ThievesGameCardView:AffectRoundCellLockTiers(cardId, cellIndexList, extraPos)
    cardId = tonumber(cardId)
    if cellIndexList then
        for i = 1, #cellIndexList do
            local cellIndex = cellIndexList[i]
            local cell = self:GetCardCell(cardId, cellIndex)
            local unlockCount = thievesTiers[cardId][cellIndex] + 1
            thievesTiers[cardId][cellIndex] = unlockCount
            self:GetCard(cardId):ReduceLockTiers(cardId, cellIndex, unlockCount, cell, unlockCount == MaxTiers, self, thievesTiers[cardId])
        end
    end
end

function ThievesGameCardView:ReduceLockTiers(cardId, cellIndex)
    cardId = tonumber(cardId)

    local cell = self:GetCardCell(cardId, cellIndex)
    local unlockCount = thievesTiers[cardId][cellIndex] + 1
    thievesTiers[cardId][cellIndex] = unlockCount

    self:GetCard(cardId):ReduceLockTiers(cardId, cellIndex, unlockCount, cell, unlockCount == MaxTiers, self, thievesTiers[cardId])
end

function ThievesGameCardView:GetBingoType(cardId, bingoCount)
    cardId = tonumber(cardId)
    local bingoType = {}
    table.each(thievesTiers[cardId], function(v, k)
        if v >= MaxTiers and #bingoType < bingoCount then
            table.insert(bingoType, k)
        end
    end)
    return bingoType
end

--- 把两张有jackpot的卡移动到后面
function ThievesGameCardView:JackpotCardMoveBackground(currCardId, moveCardId, currIndex, moveIndex)
    local card1 = self:GetCardMap(currCardId)
    local card2 = self:GetCardMap(moveCardId)
    if card2 then
        local switchPos = self:GetParentView():GetSwitchView():GetSmallCardObj(moveIndex)
        local oriPos = card2.transform.localScale
        fun.set_same_position_with(card2, switchPos)
        fun.set_gameobject_scale(card2, 0.2, 0.2, 1)
        Anim.scale_to_xy(card2, oriPos.x, oriPos.y, 1)
        local cardPos = card1.transform.position
        BattleLogic.GetLogicModule(LogicName.SwitchLogic):EnterDoubleJackpotChangeCard()
        Anim.move(card2, cardPos.x, cardPos.y, cardPos.z, 1, false, true, function()
            BattleLogic.GetLogicModule(LogicName.SwitchLogic):ExitDoubleJackpotChangeCard()
        end)
    end
    if card1 then
        local currPos = card1.transform.localPosition
        Anim.move(card1, currPos.x - 2000, currPos.y, currPos.z, 1, true, true)
    end
end

function ThievesGameCardView:ReduceAllLockTiers(cardId, thievesPos)
    cardId = tonumber(cardId)

    if thievesTiers[cardId][thievesPos] >= MaxTiers then
        return
    end

    local cell = self:GetCardCell(cardId, thievesPos)
    thievesTiers[cardId][thievesPos] = MaxTiers

    self:GetCard(cardId):ReduceAllLockTiers(cardId, thievesPos, cell)
end

function ThievesGameCardView:OnShowJackpot()
    table.each(self:GetCardCell(), function(card, cardid)
        local card_ref = fun.get_component(self:GetCardMap(cardid), fun.REFER)
        local root = card_ref:Get("sign")
        table.each(card, function(cellObj)
            local signObj = fun.find_child(root, cellObj.name .. "/brand")
            fun.set_active(signObj, false)
        end)
    end)
end

function ThievesGameCardView:OnCollectItem(cardId, thievesPos, key)
    cardId = tonumber(cardId)
    self:GetCard(cardId):CollectItem(cardId, thievesPos, key)
end

function ThievesGameCardView:GetFlyTargetPos(cardId)
    self.nextKey = self.nextKey or {}
    self.nextKey[cardId] = self.nextKey[cardId] or 0
    self.nextKey[cardId] = self.nextKey[cardId] + 1
    
    local card, ctrlName = self:GetCard(cardId), string.format("Collectitem%s", self.nextKey[cardId])
    local flyTarget = card[ctrlName]
    if fun.is_not_null(flyTarget) then
        return flyTarget.transform.position, self.nextKey[cardId]
    end
end

return this