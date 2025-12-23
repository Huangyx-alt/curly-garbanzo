local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local MonopolySingleCardView = BaseSingleCard:New();
local this = MonopolySingleCardView;

this.auto_bind_ui_items = {
    "B1",
    "B2",
    "B3",
    "B4",
    "B5",
    "I1",
    "I2",
    "I3",
    "I4",
    "I5",
    "N1",
    "N2",
    "N3",
    "N4",
    "N5",
    "G1",
    "G2",
    "G3",
    "G4",
    "G5",
    "O1",
    "O2",
    "O3",
    "O4",
    "O5",
    "b_letter",
    "reward1",
    "reward2",
    "reward_icon1",
    "rewardPar",
    "PerfectDaub",
    "letter_b",
    "letter_i",
    "letter_n",
    "letter_g",
    "letter_o",
    "icon",
    "ChipsContainer",
    "fooddz",
    "forbidCollide",
    "autoFlag",
    "storehouse",
    "signcellJBroot",
    "flyItemRoot",
    "gift_clone",
    "flash_clone",
    "displayRoot",
    "Item1",
    "Item2",
    "Item3",
    "Item4",
}

local CollectStates = {
    none = 0,       --初始化，未完整开发的
    waitShow = 1,
    showing = 2,
    waitApply = 3,
    applying = 6,
    showBingo = 8,
    finish = 10,
}

local ItemAnimName = {
    ruchang = "ruchang",
    show11 = "act",
    show12 = "upact",
    broken = "chui1",
    broken1 = "chui1",
    broken2 = "chui2",

    show2 = "enter",
    refresh = "chuxian",
    hammerblow = "ruchang",
    fly = "fei",
}

local pigPreviewAnimTime = 2
local ordinaryItemShowAnimTime = 1
local criticalItemShowAnimTime = 1
local flyHammerAnimTime = 0.3
local breakPiggyAnimTime = 3

function MonopolySingleCardView:OnEnable(params)
    Facade.RegisterViewEnhance(self)
end

function MonopolySingleCardView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function MonopolySingleCardView:BindObj(obj, parentView, cardId)
    self.model = ModelList.BattleModel:GetCurrModel()
    self:on_init(obj, parentView)
    self.bankFindRecord = {false, false}
    self.cardId = cardId
end

function MonopolySingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

function MonopolySingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function MonopolySingleCardView:InitCollectionLocation(groups)
    fun.set_active(self.Item3, false)
    fun.set_active(self.Item4, false)
    self.groupInfo = groups
    for i, v in ipairs(groups) do
        local pos = Vector3.zero
        local count = 1
        for idx, cell in ipairs(v) do
            local cellObj = cell:GetCellObj()
            pos = pos + fun.get_gameobject_pos(cellObj)
            count = idx
        end
        pos = pos / count
        local collectItem = self["Item" .. i]
        if fun.is_not_null(collectItem) then
            fun.set_gameobject_pos(collectItem, pos.x, pos.y, pos.z, false)
        end
    end
end

function MonopolySingleCardView:PreviewBankLocation(cardId)
    local bankValue1, bankValue2 = self.model:GetBankValues()
    for i = 1, 2 do
        local collectItem = self["Item" .. i]
        if fun.is_not_null(collectItem) then
            fun.set_parent(collectItem, self.displayRoot, false)
            fun.set_active(collectItem, true)
            --入场所预览动画
            self:PlayItemAnim(collectItem, ItemAnimName.ruchang)
            LuaTimer:SetDelayFunction(pigPreviewAnimTime, function()
                fun.set_parent(collectItem, self.storehouse, false)
            end, nil, LuaTimer.TimerType.Battle)
            
            local ref = fun.get_component(collectItem, fun.REFER)
            local lbl = ref:Get("Text")
            local text_reward = fun.get_component(lbl, "RollingSpriteNumber")
            text_reward:SetValue(bankValue1)
            if self.model:IsTriggerExtraReward() then
                text_reward:RollByTime(bankValue2, 0.5, function() 
                    text_reward:SetValue(bankValue2)
                end)
            end
        end
    end
end

function MonopolySingleCardView:PlayItemAnim(obj, animaName)
    local anim = fun.get_component(obj, fun.ANIMATOR)
    if fun.is_not_null(anim) and animaName then
        anim:Play(animaName)
    end
end

--undo
function MonopolySingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, lastCount, curCount, extra)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    log.log("MonopolySingleCardView->AddBowlDrink", bowlType, maxCount, bowlCount)
    self:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
end

--收集普通元素（猪）
function MonopolySingleCardView:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    log.log("MonopolySingleCardView->CollectOrdinaryItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    if curCount >= maxCount[bowlType] then
        self:ShowOrdinaryItem(cardId, bowlType, curCount)
    end
end

--普通元素（猪）展示动画
function MonopolySingleCardView:ShowOrdinaryItem(cardId, bowlType, curCount)
    log.log("MonopolySingleCardView->ShowOrdinaryItem:", cardId, bowlType, curCount)
    self.bankFindRecord[bowlType] = true
    BattleEffectCache:GetSkillPrefabFromCache("MonopolyEmpty", self.displayRoot, nil, ordinaryItemShowAnimTime + 0.2, cardId)
    local collectItem = self["Item" .. bowlType]
    fun.set_parent(collectItem, self.displayRoot, false)
    self:PlayItemAnim(collectItem, ItemAnimName.show11)
    UISound.play("piggybanknormalpig")
    LuaTimer:SetDelayFunction(ordinaryItemShowAnimTime, function()
        self:ShowOrdinaryItemFinish(cardId, bowlType, curCount)
    end, nil, LuaTimer.TimerType.Battle)
end

--普通元素（猪）展示动画完成
function MonopolySingleCardView:ShowOrdinaryItemFinish(cardId, bowlType, curCount)
    log.log("MonopolySingleCardView->ShowOrdinaryItemFinish:cardId, bowlType, curCount ", cardId, bowlType, curCount)
end

--undo no call
function MonopolySingleCardView:BreakPiggy(piggyInfo)
    log.log("MonopolySingleCardView->BreakPiggy:cardId, idx",piggyInfo.cardId, piggyInfo.itemType)
    --打破动画
    local collectItem = self["Item" .. piggyInfo.itemType]
    fun.set_parent(collectItem, self.displayRoot, false)
    fun.SetAsLastSibling(collectItem)

    LuaTimer:SetDelayFunction(breakPiggyAnimTime, function()
        self.model:CheckCardBingo(piggyInfo.cardId, piggyInfo.itemType, piggyInfo.curCount)--检测bingo
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:TryNextApplyEvent()
    log.log("MonopolySingleCardView->TryNextApplyEvent:一个bingo表现完成，尝试一下个")
end

function MonopolySingleCardView:ReadyShowBingo(cardId, bingoType)
    log.log("MonopolySingleCardView->ReadyShowBingo ", bingoType)
    --local bowlType = bingoType[#bingoType]
    --local bowlType = #bingoType
    local bowlType = bingoType
    --[[
    if bowlType == 1 then
        fun.set_active(self.bingoTip, true)
    end
    local anima = fun.get_component(self.bingoTip, fun.ANIMATOR)
    anima:Play("bingo" .. bowlType)
    --]]
end

function MonopolySingleCardView:ShowBingoFinish(cardId, bingoType)
    log.log("MonopolySingleCardView->ShowBingoFinish ", bingoType)
    --local bowlType = bingoType[#bingoType]
    --local bowlType = #bingoType

    self:TryNextApplyEvent()
    self.model:CheckCardBingo2(cardId)
end

function MonopolySingleCardView:OnOneNumberCallFinish(curNumber)
    --log.log("MonopolySingleCardView->OnOneNumberCallFinish ", curNumber)
    if not self.cardId then
        return
    end

    if self.cardId > self.model:GetCardCount() then
        return
    end

    if not curNumber then
        log.log("MonopolySingleCardView->OnOneNumberCallFinish Error number is nil")
        return
    end

    if curNumber < 46 then
        return
    end

    local hasNumber = self.model:GetIndexByNum(self.cardId, curNumber)
    if not hasNumber then
        return
    end

    self:ShakeDice()
end

function MonopolySingleCardView:ShakeDice()
    log.log("MonopolySingleCardView->ShakeDice ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        self:ShakeDiceFinish()
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:ShakeDiceFinish()
    log.log("MonopolySingleCardView->ShakeDiceFinish ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        self:CharacterMove()
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:CharacterMove()
    log.log("MonopolySingleCardView->CharacterMove ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        self:CharacterMoveFinish()
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:CharacterMoveFinish()
    log.log("MonopolySingleCardView->CharacterMoveFinish ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        self:CollectScore()
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:CollectScore()
    log.log("MonopolySingleCardView->CollectScore ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        --undo,分数计算
        self.model:CollectCardScore(self.cardId, 500)
        self:CollectScoreFinish()
        local hasNewBingo = self.model:CheckCardBingo(self.cardId)--检测bingo
        log.log("MonopolySingleCardView->CollectScore hasNewBingo", hasNewBingo)
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolySingleCardView:CollectScoreFinish()
    log.log("MonopolySingleCardView->CollectScoreFinish ", self.cardId)
    LuaTimer:SetDelayFunction(0.5, function()
        --self:ShakeDiceFinish()
    end, nil, LuaTimer.TimerType.Battle)
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.Bingo.OneNumberCallFinish, func = this.OnOneNumberCallFinish},
}

return this