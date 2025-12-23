local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local SolitaireSingleCardView = BaseSingleCard:New();
local this = SolitaireSingleCardView;

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
    "TSRoot",
    "CollectArea",
    "ListArea",
    "JokerArea",
    "Aim1",
    "Aim2",
    "LayoutH1",
    "CollectItem1",
    "CollectItem2",
    "CollectItem3",
    "SmallCollectItem3",
    "DoublePayout",
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
    show11 = "fan",
    show2 = "actda",
    show3 = "actxiao",
    fly = "fei",
    arrive1 = "overblack",
    arrive2 = "overred",
    accomplish = "bingo",
    pickUp = "tai",
}

local ordinaryItemShowAnimTime = 1
local criticalItemShowAnimTime = 1.2
local flyFragmentAnimTime1 = 0.6
local flyFragmentAnimTime2 = 0.3
local secondCardsInitAnimTime = 2.4
local shellSkillDelayTime = 0.1
local pearlFlyTime = 0.5
local shellSkillStage1AnimTime = 2
local shellSkillStage2DelayTime = 1.5
local smallJokerDelayShow = 0.7
local primaryCardsPickUpTime = 0.3
local secondCardsPickUpTime = 0.3
local newShellSkillAnimTime = 2.5

local AceIds = {241001, 241014}

function SolitaireSingleCardView:OnEnable(params)

end

function SolitaireSingleCardView:OnDisable()

end

function SolitaireSingleCardView:BindObj(obj, parentView, cardId)
    self.model = ModelList.BattleModel:GetCurrModel()
    self.cardId = cardId
    self.cardCount = self.model:GetCardCount()
    self:on_init(obj, parentView)

    self.findCriticalItem = false
    self.secondCardPokerList = {}
    self.secondPokerNominalValueList1 = {}
    self.secondPokerNominalValueList2 = {}
    self.pokerNominal2ItemMap1 = {}
    self.pokerNominal2ItemMap2 = {}
    self.progressBlack = 0
    self.progressRed = 0
    self.solitaireCount = 0
    self.curRoundLength = 0
    self.finishBingoCount = 0
    self.solitaireBusyState = {false, false}
    self.isFindTowAceInAdvance = false
    self.needRecheckBingo = false
    self.isShowCriticalItemFinish = false
    fun.set_active(self.DoublePayout, false)

    self:InitCollectStateRecord()

    if self.cardId <= self.cardCount then
        self:InitSecondCardItemData()
        self:InitSecondCardItemUI()
    end
end

function SolitaireSingleCardView:GetHightestRoot()
    --[[
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        return bingoView.highestRoot or self.flyItemRoot        
    end
    --]]

    return self.flyItemRoot
end

function SolitaireSingleCardView:IsSolitaireBusy(suit)
    return self.solitaireBusyState[suit]
end

function SolitaireSingleCardView:SetSolitaireBusy(suit)
    self.solitaireBusyState[suit] = true
end

function SolitaireSingleCardView:CancelSolitaireBusy(suit)
    self.solitaireBusyState[suit] = false
end

function SolitaireSingleCardView:InitSecondCardItemData()
    self.originalSecondPokerData = self.model:GetSecondItemsByCardId(self.cardId)
    self.secondPokerData = deep_copy(self.originalSecondPokerData)
    if #self.secondPokerData == 14 then
        self.isFindTowAceInAdvance = true
        for i = 14, 1, -1 do
            if self.secondPokerData[i] == AceIds[1] or self.secondPokerData[i] == AceIds[2] then
                table.remove(self.secondPokerData, i)
            end
        end
    end
    table.sort(self.secondPokerData)
    
    local ref = fun.get_component(self.ListArea, fun.REFER)
    for i = 1, 12 do
        local poker = ref:Get("poker" .. i)
        table.insert(self.secondCardPokerList, poker)
    end
    
    local suite1Count = 0
    local suite2Count = 0
    for i, v in ipairs(self.secondPokerData) do
        local item = self:GenPokerItem(v, i, self.secondCardPokerList[i], true)
        local suit, nominal = item.suit, item.nominal
        self:AddItem2Map(suit, nominal, item)
        self:UpdateCollectState(suit, nominal, CollectStates.waitApply)
        if suit == 1 then
            suite1Count = suite1Count + 1
        elseif suit == 2 then
            suite2Count = suite2Count + 1
        end
    end

    local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
end

function SolitaireSingleCardView:UpdateProgress(suit, delta)
    delta = delta or 1
    if suit == 1 then
        self.progressBlack = self.progressBlack + delta
    elseif suit == 2 then
        self.progressRed = self.progressRed + delta
    end
end

function SolitaireSingleCardView:GetProgress(suit)
    if suit == 1 then
        return self.progressBlack
    elseif suit == 2 then
        return self.progressRed
    end

    return -1
end

function SolitaireSingleCardView:GenPokerItem(id, idx, obj, isSecond)
    local nominal, suit = self.model:GenNominalValue(id)
    local item = {}
    item.id = id
    item.nominal = nominal
    item.suit = suit
    item.go = obj
    item.isSecond = isSecond
    item.index = idx --副牌区位置1~12/主牌区格子位置 -1 为两个提前给出的A
    return item
end

function SolitaireSingleCardView:AddItem2Map(suit, nominal, item)
    local map 
    if suit == 1 then
        map = self.pokerNominal2ItemMap1
    elseif suit == 2 then
        map = self.pokerNominal2ItemMap2
    end
    if not map then
        log.log("SolitaireSingleCardView:AddItem2Map Error", suit, nominal)
        return
    end

    if map[nominal] then
        log.log("SolitaireSingleCardView:AddItem2Map 位置已被占用", suit, nominal)
    else
        map[nominal] = item
    end
end

function SolitaireSingleCardView:GetPokerItem(suit, nominal)
    local map 
    if suit == 1 then
        map = self.pokerNominal2ItemMap1
    elseif suit == 2 then
        map = self.pokerNominal2ItemMap2
    end
    if not map then
        log.log("SolitaireSingleCardView:GetPokerItem Error", suit, nominal)
        return
    end

    return map[nominal]
end

function SolitaireSingleCardView:InitSecondCardItemUI()
    --[[v1
    for i, v in ipairs(self.secondPokerData) do
        local poker = self.secondCardPokerList[i]
        if fun.is_not_null(poker) then
            local itemRef = fun.get_component(poker, fun.REFER)
            local pokerImg = itemRef:Get("poker")
            local iconName = self.model:GetIconName(v)
            pokerImg.sprite = AtlasManager:GetSpriteByName("SolitaireBingoAtlas", iconName)
        end
    end
    --]]

    ---[[v2
    coroutine.start(function()
        for i = 1, (self.cardId - 1) * 12 do
            WaitForEndOfFrame()
        end
        for i, v in ipairs(self.secondPokerData) do
            local poker = self.secondCardPokerList[i]
            WaitForEndOfFrame()
            if fun.is_not_null(poker) then
                local itemRef = fun.get_component(poker, fun.REFER)
                local pokerImg = itemRef:Get("poker")
                local iconName = self.model:GetIconName(v)
                pokerImg.sprite = AtlasManager:GetSpriteByName("SolitaireBingoAtlas", iconName)
            end
        end
    end)
    --]]
end

function SolitaireSingleCardView:TrySignCell(cardId, index, powerId)
    local cardPower = BattleModuleList.GetModule("CardPower")
    local cardView = cardPower.cardView
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardId, index)
    if cellData:IsNotSign() then
        --cellData.isSignByGemPuSkill = true
        log.log("SolitaireSingleCardView:初始盖章", cardId, index)
        cardPower.cardView:OnClickCardIgnoreJudgeByIndex(cardId, index, powerId)
    end
    cardPower:ChangeCellState(cardId, index, 10)
end

function SolitaireSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

function SolitaireSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function SolitaireSingleCardView:OnGameReady(cardId)
    self:TryPlayShellSkill(cardId)
    self:PlaySecondCardsInitAnim(cardId)
end

function SolitaireSingleCardView:PlaySecondCardsInitAnim(cardId)
    if cardId == 1 then
        UISound.play("solitairestartpoker")
    end

    local anim = fun.get_component(self.ListArea, fun.ANIMATOR)
    local layoutH = fun.get_component(self.LayoutH1, fun.HORIZONTALLAYOUT)
    fun.enable_component(layoutH, false)
    if self.model:IsTriggerExtraReward() then
        self:PlayItemAnim(self.ListArea, "actbeike")
    else
        self:PlayItemAnim(self.ListArea, "act")
    end
    LuaTimer:SetDelayFunction(secondCardsInitAnimTime, function()
        fun.enable_component(anim, false)
        --fun.enable_component(layoutH, true)
    end, nil, LuaTimer.TimerType.Battle)
end

function SolitaireSingleCardView:TryPlayShellSkill(cardId)
    if self.model:IsTriggerExtraReward() then
        LuaTimer:SetDelayFunction(shellSkillDelayTime, function()
            self:PlayShellSkill(cardId)
        end, nil, LuaTimer.TimerType.Battle)
    end
end

function SolitaireSingleCardView:PlayShellSkill(cardId)
    if cardId == 1 then
        UISound.play("solitairepearlshell")
    end
    self:PlayShellSkillV2(cardId)
end

--暂时弃用
function SolitaireSingleCardView:PlayShellSkillV1(cardId)
    local targetCellIndexs = self.model:GetPearPositionListByCardId(cardId)
    if not targetCellIndexs then
        log.log("SolitaireSingleCardView:PlayShellSkill Error 1", cardId)
        return
    end

    local centerCell = self:GetCell(13)
    BattleEffectCache:GetSkillPrefabFromCache("Solitaireskill2beikeget", centerCell, function(obj)
        --UISound.play("wait sound")
        LuaTimer:SetDelayFunction(shellSkillStage1AnimTime, function()
            BattleEffectPool:Recycle("Solitaireskill2beikeget", obj)
        end, nil, LuaTimer.TimerType.Battle)

        LuaTimer:SetDelayFunction(shellSkillStage2DelayTime, function()
            table.each(targetCellIndexs, function(index, key)
                local localIdx = ConvertServerPos(index)
                local cellObj = self:GetCell(localIdx)
                BattleEffectCache:GetSkillPrefabFromCache("Solitaireskill2beike", cellObj, function(getObj)
                    fun.set_parent(getObj, self.flyItemRoot)
                    fun.set_same_position_with(getObj, centerCell)
                    local callback = function()
                        self:TrySignCell(cardId, localIdx, 145)
                        BattleEffectPool:Recycle("Solitaireskill2beike", getObj)
                    end
                    self:ShowFlyPearl(getObj, centerCell, cellObj, callback)
                end)
            end)
        end, nil, LuaTimer.TimerType.Battle)        
    end, 2, cardId)
end

function SolitaireSingleCardView:PlayShellSkillV2(cardId)
    if not self.isFindTowAceInAdvance then
        return
    end

    local centerCell = self:GetCell(13)
    BattleEffectCache:GetSkillPrefabFromCache("Solitaireskill2beikeget", centerCell, function(obj)
        --UISound.play("wait sound")
        LuaTimer:SetDelayFunction(newShellSkillAnimTime, function()
            BattleEffectPool:Recycle("Solitaireskill2beikeget", obj)
            self:FindTwoAceInAdvance(cardId)
        end, nil, LuaTimer.TimerType.Battle)
    end, 3, cardId)
end

function SolitaireSingleCardView:FindTwoAceInAdvance(cardId)
    local diEffectName = "CollectItem1"
    for i, v in ipairs(AceIds) do
        local diEffect = BattleEffectPool:Get(diEffectName)
        local data = Csv.GetData("item", v)
        fun.set_gameobject_scale(diEffect, 1, 1, 1)
        local ref = fun.get_component(diEffect, fun.REFER)
        if fun.is_not_null(ref) then
            local poker = ref:Get("poker")
            poker.sprite = AtlasManager:GetSpriteByName("SolitaireBingoAtlas", data.icon)
        end
        local item = self:GenPokerItem(v, -1, diEffect, false)
        local suit, nominal = item.suit, item.nominal
        self:AddItem2Map(suit, nominal, item)
        self:FlyOneFragmentFinish(item)
    end
end

function SolitaireSingleCardView:PlayItemAnim(obj, animaName)
    local anim = fun.get_component(obj, fun.ANIMATOR)
    if fun.is_not_null(anim) and animaName then
        anim:Play(animaName)
    end
end

function SolitaireSingleCardView:InitCollectStateRecord()
    self.collectStateRecord = {}
    for i = 1, 3 do
        self.collectStateRecord[i] = {}
        local len = i == 3 and 1 or 13
        for j = 1, len do
            self:UpdateCollectState(i, j, CollectStates.none)
        end
    end
end

function SolitaireSingleCardView:UpdateCollectState(suit, index, state)
    log.log("SolitaireSingleCardView->UpdateCollectState", suit, index, state)
    self.collectStateRecord[suit][index] = state
end

function SolitaireSingleCardView:GetCollectState(suit, index)
    log.log("SolitaireSingleCardView->GetCollectState", index, self.collectStateRecord[suit][index])
    local state = self.collectStateRecord[suit][index] or CollectStates.none
    return state
end

--刮出了一某个碎片
function SolitaireSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, lastCount, curCount, extra)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    log.log("SolitaireSingleCardView->AddBowlDrink", bowlType, maxCount, bowlCount)
    ---[[
    if bowlType < 3 then
        self:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    elseif bowlType == 3 then
        log.log("SolitaireSingleCardView->AddBowlDrink full", cardId, bowlType)
        self:CollectCriticalItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    end
    --]]
end

--收集普通元素（A-K）
function SolitaireSingleCardView:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("SolitaireSingleCardView->CollectOrdinaryItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    if curCount == maxCount[bowlType] then --完成一条龙
        self.model:CollectCardBingo(cardId, bowlType)
    end
    
    local item = self:GenPokerItem(extra.itemId, extra.idx, extra.obj, false)
    local suit, nominal = item.suit, item.nominal
    self:AddItem2Map(suit, nominal, item)
    
    self:UpdateCollectState(bowlType, nominal, CollectStates.waitShow)
    self:ShowOrdinaryItem(cardId, bowlType, curCount, item)
end

--普通元素（A-K）展示动画
function SolitaireSingleCardView:ShowOrdinaryItem(cardId, bowlType, curCount, item)
    log.log("SolitaireSingleCardView->ShowOrdinaryItem:", cardId, bowlType, curCount)
    self:UpdateCollectState(bowlType, item.nominal, CollectStates.showing)
    BattleEffectCache:GetSkillPrefabFromCache("SolitaireEmpty", self.displayRoot, nil, ordinaryItemShowAnimTime + 0.2, cardId)
    local collectItem = item.go
    local parentRoot = self:GetHightestRoot()
    fun.set_parent(collectItem, parentRoot, false)
    self:PlayItemAnim(collectItem, ItemAnimName.show11)
    UISound.play("solitairepokershow")
    LuaTimer:SetDelayFunction(ordinaryItemShowAnimTime, function()
        self:ShowOrdinaryItemFinish(cardId, bowlType, curCount, item)
    end, nil, LuaTimer.TimerType.Battle)
end

--普通元素（A-K）展示动画完成
function SolitaireSingleCardView:ShowOrdinaryItemFinish(cardId, bowlType, curCount, item)
    log.log("SolitaireSingleCardView->ShowOrdinaryItemFinish:cardId, bowlType, curCount ", cardId, bowlType, curCount)
    fun.set_parent(item.go, self.displayRoot, false)
    self:UpdateCollectState(bowlType, item.nominal, CollectStates.waitApply)
    self:TryStartSolitaire(item)
end

function SolitaireSingleCardView:TryStartSolitaire(item)
    if self:IsSolitaireBusy(item.suit) then 
        log.log("SolitaireSingleCardView->TryStartSolitaire:正在接龙ing", item.suit)
        return
    end

    local progress = self:GetProgress(item.suit)
    if progress + 1 ~= item.nominal then
        log.log("SolitaireSingleCardView->TryStartSolitaire:不是下一片段")
        return
    end

    self.curRoundLength = 0

    self:SetSolitaireBusy(item.suit)
    self:UpdateCollectState(item.suit, item.nominal, CollectStates.applying)
    self:FlyOneFragment(item)   
end

function SolitaireSingleCardView:FlyOneFragment(item)
    log.log("SolitaireSingleCardView->FlyOneFragment", self.cardId)
    self.curRoundLength = self.curRoundLength + 1
    if item.isSecond then
        self:FlyOneSecondaryFragment(item)
    else
        self:FlyOnePrimaryFragment(item)
    end
end

function SolitaireSingleCardView:FlyOnePrimaryFragment(item)
    log.log("SolitaireSingleCardView->FlyOnePrimaryFragment", self.cardId, item.suit, item.nominal)
    BattleEffectCache:GetSkillPrefabFromCache("SolitaireEmpty", self.displayRoot, nil, primaryCardsPickUpTime + flyFragmentAnimTime1 + 0.2, self.cardId)
    local target = self["Aim" .. item.suit]
    local parentRoot = self:GetHightestRoot()--self.flyItemRoot
    fun.set_parent(item.go, parentRoot, false)
    fun.SetAsLastSibling(item.go)

    self:PlayItemAnim(item.go, ItemAnimName.pickUp)
    LuaTimer:SetDelayFunction(secondCardsPickUpTime, function()
        self:PlayItemAnim(item.go, ItemAnimName.fly)
        local targetPos = target.transform.position
        local distance = targetPos - fun.get_gameobject_pos(item.go, false)    
        Anim.move(item.go, targetPos.x, targetPos.y, 0, flyFragmentAnimTime1, false, false, function()
            self:FlyOneFragmentFinish(item)
        end)
    end, nil, LuaTimer.TimerType.Battle)
end

function SolitaireSingleCardView:FlyOneSecondaryFragment(item)
    log.log("SolitaireSingleCardView->FlyOneSecondaryFragment", self.cardId, item.suit, item.nominal)
    BattleEffectCache:GetSkillPrefabFromCache("SolitaireEmpty", self.displayRoot, nil, secondCardsPickUpTime + flyFragmentAnimTime2 + 0.2, self.cardId)
    local target = self["Aim" .. item.suit]
    local parentRoot = self:GetHightestRoot()--self.flyItemRoot
    --[[
    fun.set_parent(item.go, parentRoot, false)
    fun.SetAsLastSibling(item.go)
    --]]
    self:PlayItemAnim(item.go, ItemAnimName.pickUp)
    LuaTimer:SetDelayFunction(secondCardsPickUpTime, function()
        self:PlayItemAnim(item.go, ItemAnimName.fly)
        local targetPos = target.transform.position
        local distance = targetPos - fun.get_gameobject_pos(item.go, false)
        Anim.move(item.go, targetPos.x, targetPos.y, 0, flyFragmentAnimTime2, false, false, function()
            self:FlyOneFragmentFinish(item)
        end)
    end, nil, LuaTimer.TimerType.Battle)
end

function SolitaireSingleCardView:FlyOneFragmentFinish(item)
    log.log("SolitaireSingleCardView->FlyOneFragmentFinish", self.cardId, item.suit, item.nominal)
    UISound.play("solitairepokercollect" .. self.curRoundLength)
    local target = self["Aim" .. item.suit]
    fun.set_parent(item.go, target, true)
    fun.SetAsLastSibling(item.go)
    if item.suit == 2 then
        self:PlayItemAnim(item.go, ItemAnimName.arrive2)
    else
        self:PlayItemAnim(item.go, ItemAnimName.arrive1)
    end
    
    self:UpdateCollectState(item.suit, item.nominal, CollectStates.finish)
    self:UpdateProgress(item.suit)
    LuaTimer:SetDelayFunction(0.1, function()
        self:TryNextFrament(item)
    end, nil, LuaTimer.TimerType.Battle)
end

function SolitaireSingleCardView:TryNextFrament(item)
    local progress = self:GetProgress(item.suit)
    if progress == 13 then --完成了
        self:AccomplishSolitaire(item)
    else
        local collectState = self:GetCollectState(item.suit, progress + 1)
        if collectState == CollectStates.waitApply then --有下一个
            local nextItem = self:GetPokerItem(item.suit, progress + 1)
            if nextItem then
                self:FlyOneFragment(nextItem)
            else
                log.log("SolitaireSingleCardView->TryNextFrament Error 未找到下一个", item.suit, progress + 1)
            end
        else --无下一个了
            self:StopSolitaire(item)
        end
    end
end

function SolitaireSingleCardView:StopSolitaire(item)
    self:CancelSolitaireBusy(item.suit)
end

function SolitaireSingleCardView:AccomplishSolitaire(item)
    log.log("SolitaireSingleCardView->AccomplishSolitaire:cardId, idx",self.cardId, item.suit)
    self:CancelSolitaireBusy(item.suit)
    self:PlayItemAnim(item.go, ItemAnimName.accomplish)
    local ret = self.model:CheckCardBingo(self.cardId, item.suit)--检测是否有bingo达成
    if not ret then 
        self.needRecheckBingo = true 
    end

    self.solitaireCount = self.solitaireCount + 1
end

--收集关键元素
function SolitaireSingleCardView:CollectCriticalItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("SolitaireSingleCardView->CollectCriticalItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    self.model:CollectCardBingo(cardId, bowlType)
    self.findCriticalItem = true
    --
    self:ShowCriticalItem(cardId, bowlType, curCount,  extra.obj)
end

--关键元素（joker）展示动画
function SolitaireSingleCardView:ShowCriticalItem(cardId, bowlType, curCount, itemObj)
    log.log("SolitaireSingleCardView->ShowCriticalItem:", cardId, bowlType, curCount)
    
    BattleEffectCache:GetSkillPrefabFromCache("SolitaireEmpty", self.displayRoot, nil, criticalItemShowAnimTime + 0.2, cardId)
    --show动画
    local parentRoot = self:GetHightestRoot()--self.displayRoot
    fun.set_parent(itemObj, parentRoot, false)
    self:PlayItemAnim(itemObj, ItemAnimName.show2)
    UISound.play("solitairejokershow")
    LuaTimer:SetDelayFunction(smallJokerDelayShow, function()
        self:PlayItemAnim(self.SmallCollectItem3, ItemAnimName.show3)
    end, nil, LuaTimer.TimerType.Battle)
    LuaTimer:SetDelayFunction(criticalItemShowAnimTime, function()
        self:ShowCriticalItemFinish(cardId, bowlType, curCount, itemObj)
    end, nil, LuaTimer.TimerType.Battle)
end

--关键元素（joker）展示动画完成
function SolitaireSingleCardView:ShowCriticalItemFinish(cardId, bowlType, curCount, itemObj)
    log.log("SolitaireSingleCardView->ShowCriticalItemFinish:", cardId, bowlType, curCount)
    fun.set_parent(itemObj, self.displayRoot, false)
    self.isShowCriticalItemFinish = true
    if self.finishBingoCount >= 2 then
        self.model:CheckCardBingo(self.cardId, bowlType)--检测是否有bingo达成
    end
end

function SolitaireSingleCardView:ReadyShowBingo(cardId, bingoType)
    log.log("SolitaireSingleCardView->ReadyShowBingo ", bingoType)
end

function SolitaireSingleCardView:ShowBingoFinish(cardId, bingoType)
    log.log("SolitaireSingleCardView->ShowBingoFinish ", bingoType)
    self.model:FinishCurCardBingo(cardId)
    self.finishBingoCount = self.finishBingoCount + 1
    if self.needRecheckBingo then --播bingo期间，检测了另一个bingo
        self.model:CheckCardBingo(self.cardId, 2)
        self.needRecheckBingo = false
        if bingoType == 2 then
            log.log("SolitaireSingleCardView->ShowBingoFinish ERROR! bingoType = 2 and self.needRecheckBingo")
        end
        return
    end

    --期间是否又有新bingo达成 (double payout 是否可以生效)
    if bingoType == 2 and self.isShowCriticalItemFinish then
        local nextBingo = bingoType + 1
        self.model:CheckCardBingo(self.cardId, nextBingo)--检测是否有bingo达成
    end
end

function SolitaireSingleCardView:ShowFlyPearl(flyObj, startObj, endObj, finishCb)
    local startPos, endPos = fun.get_gameobject_pos(startObj), fun.get_gameobject_pos(endObj)
    local node1Dir, node2Dir = this:GetOffsetDir(startPos, endPos)
    local pathNodes = {}
    pathNodes[1] = fun.get_gameobject_pos(startObj, false)
    pathNodes[4] = fun.get_gameobject_pos(endObj, false)
    local distance = Vector3.Distance(startPos, endPos)
    if distance > 1.5 then
        --两个格子中间是否至少间隔一个格子
        pathNodes[2] = startPos + node1Dir
        pathNodes[3] = endPos + node2Dir
    else
        pathNodes[2] = startPos + node1Dir * 3
        pathNodes[3] = endPos + node2Dir * 0.5
    end

    --控制方向
    if not self.dirFlag then
        self.dirFlag = true
    else
        self.dirFlag = false
    end

    --贝塞尔曲线
    local retPath = this:GetBeizerList(pathNodes, 20)
    local flyTime, delayTime = pearlFlyTime, 0
    Anim.smooth_move(flyObj, retPath, flyTime, delayTime, 1, 8, function()
        if finishCb then
            finishCb()
        end
    end)
end

--控制起始角度和结束角度
function SolitaireSingleCardView:GetOffsetDir(startPos, endPos)
    local dir = (endPos - startPos).normalized
    local angle = self.dirFlag and 150 or -150
    local q1 = Quaternion.AngleAxis(angle, Vector3.forward)
    local node1Dir = q1 * dir
    
    dir = (startPos - endPos).normalized
    angle = self.dirFlag and -60 or 60
    local q2 = Quaternion.AngleAxis(angle, Vector3.forward)
    local node2Dir = q2 * dir
    return node1Dir, node2Dir
end

function SolitaireSingleCardView:GetBeizerList(pathNodes, segmentNum)
    local path = {}
    for i = 1, segmentNum do
        local t = i / segmentNum
        local pos = this:CalculateCubicBezierPoint(t, pathNodes[1], pathNodes[2], pathNodes[3], pathNodes[4])
        table.insert(path, pos)
    end
    return path
end

function SolitaireSingleCardView:CalculateCubicBezierPoint(t, p0, p1, p2, p3)
    local arg1 = 1 - t
    local arg2 = arg1 * arg1
    local arg3 = arg2 * arg1
    local tt = t * t
    local ttt = t * t * t
    
    local pos = p0 * arg3 + p1 * 3 * t * arg2 + p2 * 3 * tt * arg1 + p3 * ttt
    return pos
end

function SolitaireSingleCardView:ShowCustomizedStageAfterRocket()
    log.log("SolitaireSingleCardView:ShowCustomizedStageAfterRocket", self.cardId, self.findCriticalItem, self.solitaireCount)
    if not self.findCriticalItem then
        return false
    end

    if self.solitaireCount ~= 1 then
        return false
    end

    fun.set_active(self.DoublePayout, true)
    self:PlayItemAnim(self.DoublePayout, "double2")
    UISound.play("solitairedoublepayout")
    return true
end

return this