local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")

local PiggyBankSingleCardView = BaseSingleCard:New();
local this = PiggyBankSingleCardView;

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
    "ef_Bingo_click",
    "flash_clone",
    "displayRoot",
    "Item1",
    "Item2",
    "Item3",
    "Item4",
    "ItemShowup1",
    "ItemShowup2",
    "ItemShowup3",
    "EffectRoot",
    "tishi_b",
    "tishi_i",
    "tishi_n",
    "tishi_g",
    "tishi_o",
    "TopShowRoot",
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

local UpgradeStates = {
    none = 0,
    waitUpgrade = 1,
    upgrading = 2,
    upgraded = 3,
    nonUpgradable = 10,
}

local ItemAnimName = {
    ruchang = "ruchang",
    show11 = "act",
    show12 = "upact",
    upgrade1 = "upA",
    upgrade2 = "up",
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
local upgradeAnimTime = 2

function PiggyBankSingleCardView:OnEnable(params)

end

function PiggyBankSingleCardView:OnDisable()

end

function PiggyBankSingleCardView:BindObj(obj, parentView)
    self.model = ModelList.BattleModel:GetCurrModel()
    self:on_init(obj, parentView)
    self:InitCollectStateRecord()
    self:InitUpgradeStateRecord()
    self.waitApplyEventList = nil
    self.findCriticalItem = false
    self.isHammerWorking = false
    self.itemWaitBreakList = {}
    self.itemBreakenList = {}
    self.activeUpgradePu = false
    self.eventAfterUpgradeList = {}
    self.eventAfterShowList = {}
end

function PiggyBankSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

function PiggyBankSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function PiggyBankSingleCardView:InitCollectionLocation(groups)
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

        local upItem = self["ItemShowup" .. i]
        if fun.is_not_null(upItem) then
            fun.set_gameobject_pos(upItem, pos.x, pos.y, pos.z, false)
            fun.set_active(upItem, false)
        end
    end
    self.oriHammerPos = fun.get_gameobject_pos(self.Item4, true)
end

function PiggyBankSingleCardView:PreviewPigLocation(cardId)
    for i = 1, 3 do
        local collectItem = self["Item" .. i]
        if fun.is_not_null(collectItem) then
            fun.set_parent(collectItem, self.displayRoot, false)
            --入场所预览动画
            self:PlayItemAnim(collectItem, ItemAnimName.ruchang)
            LuaTimer:SetDelayFunction(pigPreviewAnimTime, function()
                fun.set_parent(collectItem, self.storehouse, false)
            end, nil, LuaTimer.TimerType.Battle)
        end
    end

    --self:PreviewUpgradePuLocation(cardId)
end

function PiggyBankSingleCardView:PlayItemAnim(obj, animaName)
    local anim = fun.get_component(obj, fun.ANIMATOR)
    if fun.is_not_null(anim) and animaName then
        anim:Play(animaName)
    end
end

function PiggyBankSingleCardView:PreviewUpgradePuLocation(cardId)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cells = curModel.roundData:GetCells(cardId)
    local target
    for i, v in ipairs(cells) do
        if v:HasItem({821}) then
            target = v
            break
        end
    end

    if target then
        log.log("PiggyBankSingleCardView:PreviewUpgradePuLocation 有升级PU ", cardId, target.index, target.obj.name)
        BattleEffectCache:GetSkillPrefabFromCache("PiggyBankskillyanjing", target.obj, function(obj)
           --do something
        end, pigPreviewAnimTime, cardId)
    end
end

function PiggyBankSingleCardView:InitCollectStateRecord()
    self.collectStateRecord = {}
    for i = 1, 3 do
        self:UpdateCollectState(i, CollectStates.none)
    end
end

function PiggyBankSingleCardView:UpdateCollectState(index, state)
    log.log("PiggyBankSingleCardView->UpdateCollectState", index, state)
    self.collectStateRecord[index] = state
end

function PiggyBankSingleCardView:GetCollectState(index)
    log.log("PiggyBankSingleCardView->GetCollectState", index, self.collectStateRecord[index])
    local state = self.collectStateRecord[index] or CollectStates.none
    return state
end
--[[
    @desc: 
    author:{author}
    time:2025-03-17 15:51:56
    @return:
]]--
function PiggyBankSingleCardView:InitUpgradeStateRecord()
    self.upgradeStateRecord = {}
    for i = 1, 3 do
        self:UpdateUpgradeState(i, UpgradeStates.none)
    end
end

function PiggyBankSingleCardView:UpdateUpgradeState(index, state)
    log.log("PiggyBankSingleCardView->UpdateUpgradeState", index, state)
    self.upgradeStateRecord[index] = state
end

function PiggyBankSingleCardView:GetUpgradeState(index)
    log.log("PiggyBankSingleCardView->GetUpgradeState", index, self.upgradeStateRecord[index])
    local state = self.upgradeStateRecord[index] or UpgradeStates.none
    return state
end

--
function PiggyBankSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, lastCount, curCount, extra)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    log.log("PiggyBankSingleCardView->AddBowlDrink", bowlType, maxCount, bowlCount)
    ---[[
    if bowlType < 4 then
        self:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    elseif bowlType == 4 then
        self:CollectCriticalItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
        --self:ActiveUpgradePu(13, 1) 测试代码
        log.log("PiggyBankSingleCardView->AddBowlDrink full", cardId, bowlType)
    end
    --]]
end

--收集普通元素（猪）
function PiggyBankSingleCardView:CollectOrdinaryItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    log.log("PiggyBankSingleCardView->CollectOrdinaryItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    self.model:CollectCardBingo(cardId, bowlType)
    
    if curCount >= maxCount[bowlType] then
        self:TryShowOrdinaryItem(cardId, bowlType, curCount)
    end    
end

--普通元素（猪）展示动画
function PiggyBankSingleCardView:TryShowOrdinaryItem(cardId, bowlType, curCount)
    log.log("PiggyBankSingleCardView->TryShowOrdinaryItem:", cardId, bowlType, curCount)
    
    if self:GetUpgradeState(bowlType) == UpgradeStates.upgrading then --正在升级
        self:UpdateCollectState(bowlType, CollectStates.waitShow)
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:猪正在升级")
        local cb = function()
            self:ShowOrdinaryItem(cardId, bowlType, curCount)
        end

        self:AddAfterUpgradeEvent(bowlType, cb)
    else
        self:UpdateCollectState(bowlType, CollectStates.waitShow)
        self:ShowOrdinaryItem(cardId, bowlType, curCount)
    end
end

--普通元素（猪）展示动画
function PiggyBankSingleCardView:ShowOrdinaryItem(cardId, bowlType, curCount)
    log.log("PiggyBankSingleCardView->ShowOrdinaryItem:", cardId, bowlType, curCount)
    self:UpdateCollectState(bowlType, CollectStates.showing)
    BattleEffectCache:GetSkillPrefabFromCache("PiggyBankEmpty", self.displayRoot, nil, ordinaryItemShowAnimTime + 0.2, cardId)
    local collectItem = self["Item" .. bowlType]
    fun.set_parent(collectItem, self.displayRoot, false)
    --show动画
    if self:GetUpgradeState(bowlType) == UpgradeStates.upgraded then
        self:PlayItemAnim(collectItem, ItemAnimName.show12)
        UISound.play("piggybankpropig")
    else
        self:PlayItemAnim(collectItem, ItemAnimName.show11)
        UISound.play("piggybanknormalpig")
    end
    LuaTimer:SetDelayFunction(ordinaryItemShowAnimTime, function()
        self:ShowOrdinaryItemFinish(cardId, bowlType, curCount)
    end, nil, LuaTimer.TimerType.Battle)
end

--普通元素（猪）展示动画完成
function PiggyBankSingleCardView:ShowOrdinaryItemFinish(cardId, bowlType, curCount)
    log.log("PiggyBankSingleCardView->ShowOrdinaryItemFinish:cardId, bowlType, curCount ", cardId, bowlType, curCount)
    table.insert(self.itemWaitBreakList, {itemType = bowlType, cardId = cardId, curCount = curCount})
    self:UpdateCollectState(bowlType, CollectStates.waitApply)
    self:TryFlyHammerToPiggy()
end

function PiggyBankSingleCardView:TryFlyHammerToPiggy()
    if not self.findCriticalItem then
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:锤子未找出")
        return
    end

    if self.isHammerWorking then
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:锤子使用中")
        return
    end

    local piggyInfo = self.itemWaitBreakList[1]
    if not piggyInfo then
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:暂时无可以砸的猪")
        return
    end

    --[[暂不用处理此逻辑，前置流程已经保证了此条件
    --undo 确保已show完成
    if piggyInfo.isXX then
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:猪正在showing")
        return
    end
    --]]

    --升级相关
    if self:GetUpgradeState(piggyInfo.itemType) == UpgradeStates.upgrading then
        log.log("PiggyBankSingleCardView->TryFlyHammerToPiggy:猪正在升级 idx", piggyInfo.itemType)
        local cb = function()
            self:TryFlyHammerToPiggy()
        end

        self:AddAfterUpgradeEvent(piggyInfo.itemType, cb)
        return
    end

    table.remove(self.itemWaitBreakList, 1)
    self:UpdateCollectState(piggyInfo.itemType, CollectStates.applying)
    self.isHammerWorking = true
    self:FlyHammerToPiggy(piggyInfo)    
end

function PiggyBankSingleCardView:FlyHammerToPiggyOld(piggyInfo)
    log.log("PiggyBankSingleCardView->FlyHammerToPiggy", piggyInfo.cardId, piggyInfo.itemType)
    fun.set_parent(self.Item4, self.flyItemRoot, false)
    local ref = fun.get_component(self.Item4, fun.REFER)
    local flyObj = ref:Get("icon")
    flyObj = self.Item4
    local target = self["Item" .. piggyInfo.itemType]
    local targetPos = target.transform.position
    local distance = targetPos - fun.get_gameobject_pos(self.Item4)
    Anim.move(flyObj, distance.x, distance.y, 0, flyHammerAnimTime + 2, false, false, function()
        --self:FlyHammerToPiggyFinish(piggyInfo)
    end)
end

function PiggyBankSingleCardView:FlyHammerToPiggy(piggyInfo)
    log.log("PiggyBankSingleCardView->FlyHammerToPiggy", piggyInfo.cardId, piggyInfo.itemType)
    fun.set_parent(self.Item4, self.flyItemRoot, false)
    local ref = fun.get_component(self.Item4, fun.REFER)
    local flyObj = ref:Get("icon")
    flyObj = self.Item4
    self:PlayItemAnim(self.Item4, ItemAnimName.fly)
    local target = self["Item" .. piggyInfo.itemType]
    local targetPos = target.transform.localPosition
    local distance = targetPos - fun.get_gameobject_pos(self.Item4, true)
    Anim.move(flyObj, targetPos.x, targetPos.y, 0, flyHammerAnimTime, true, false, function()
        self:FlyHammerToPiggyFinish(piggyInfo)
    end)
end

function PiggyBankSingleCardView:FlyHammerToPiggyFinish(piggyInfo)
    log.log("PiggyBankSingleCardView->FlyHammerToPiggyFinish", piggyInfo.cardId, piggyInfo.itemType)
    fun.set_parent(self.Item4, self.storehouse, false)
    
    self:BreakPiggy(piggyInfo)
    fun.set_active(self.Item4, false)
    LuaTimer:SetDelayFunction(2, function()
        self:ResetHammer()
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankSingleCardView:BreakPiggy(piggyInfo)
    log.log("PiggyBankSingleCardView->BreakPiggy:cardId, idx",piggyInfo.cardId, piggyInfo.itemType)
    --打破动画
    local collectItem = self["Item" .. piggyInfo.itemType]
    fun.set_parent(collectItem, self.displayRoot, false)
    fun.SetAsLastSibling(collectItem)
    if self:GetUpgradeState(piggyInfo.itemType) == UpgradeStates.upgraded then
        self:PlayItemAnim(collectItem, ItemAnimName.broken2)
        piggyInfo.upgraded = true
        UISound.play("piggybankbreak")
    else
        self:PlayItemAnim(collectItem, ItemAnimName.broken1)
        UISound.play("piggybankbreak")
    end
    table.insert(self.itemBreakenList, piggyInfo)
    LuaTimer:SetDelayFunction(breakPiggyAnimTime, function()
        self.model:CheckCardBingo(piggyInfo.cardId, piggyInfo.itemType, piggyInfo.curCount)--检测bingo
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankSingleCardView:GetItemBreakenList()
    return self.itemBreakenList
end

--收集关键元素
function PiggyBankSingleCardView:CollectCriticalItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("PiggyBankSingleCardView->CollectCriticalItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    self.model:CollectCardBingo(cardId, bowlType)
    self.findCriticalItem = true
    --
    self:ShowCriticalItem(cardId, bowlType, curCount)
end

--关键元素（锤）展示动画
function PiggyBankSingleCardView:ShowCriticalItem(cardId, bowlType, curCount)
    log.log("PiggyBankSingleCardView->ShowCriticalItem:", cardId, bowlType, curCount)
    self.isHammerWorking = true
    BattleEffectCache:GetSkillPrefabFromCache("PiggyBankEmpty", self.displayRoot, nil, criticalItemShowAnimTime + 0.2, cardId)
    --show动画
    fun.set_parent(self.Item4, self.displayRoot, false)
    
    self:PlayItemAnim(self.Item4, ItemAnimName.show2)
    UISound.play("piggybankhammer")
    LuaTimer:SetDelayFunction(criticalItemShowAnimTime, function()
        self:ShowCriticalItemFinish(cardId, bowlType, curCount)
    end, nil, LuaTimer.TimerType.Battle)
end

--关键元素（锤）展示动画完成
function PiggyBankSingleCardView:ShowCriticalItemFinish(cardId, bowlType, curCount)
    log.log("PiggyBankSingleCardView->ShowCriticalItemFinish:", cardId, bowlType, curCount)
    self.isHammerWorking = false
    self:TryFlyHammerToPiggy()
end

--undo 重置锤子位置
function PiggyBankSingleCardView:ResetHammer()
    log.log("PiggyBankSingleCardView->ResetHammer")
    fun.set_active(self.Item4, true)
    local ref = fun.get_component(self.Item4, fun.REFER)
    local flyObj = ref:Get("icon")
    fun.set_gameobject_pos(flyObj, 0, 0, 0, true)
    local oriPos = self.oriHammerPos
    fun.set_gameobject_pos(self.Item4, oriPos.x, oriPos.y, oriPos.z, true)
    self:PlayItemAnim(self.Item4, ItemAnimName.refresh)
end

function PiggyBankSingleCardView:TryNextApplyEvent()
    log.log("PiggyBankSingleCardView->TryNextApplyEvent:一个bingo表现完成，尝试一下个")
    self:TryFlyHammerToPiggy()
end

function PiggyBankSingleCardView:ReadyShowBingo(cardId, bingoType)
    log.log("PiggyBankSingleCardView->ReadyShowBingo ", bingoType)
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

function PiggyBankSingleCardView:ShowBingoFinish(cardId, bingoType)
    log.log("PiggyBankSingleCardView->ShowBingoFinish ", bingoType)
    --local bowlType = bingoType[#bingoType]
    --local bowlType = #bingoType
    local bowlType = 1
    local brokenPiggy = self.itemBreakenList[bingoType]
    if brokenPiggy then
        bowlType = brokenPiggy.itemType
    else
        log.log("PiggyBankSingleCardView->ShowBingoFinish Error 未找到被打破的猪", cardId, bingoType, self.itemBreakenList)
    end
    self:UpdateCollectState(bowlType, CollectStates.finish)
    self.isHammerWorking = false
    self:TryNextApplyEvent()
    self.model:CheckCardBingo2(cardId)
end

function PiggyBankSingleCardView:ActiveUpgradePu(puIdx, cardId)
    log.log("PiggyBankSingleCardView->ActiveUpgradePu 激活PU", puIdx, cardId)
    if self.activeUpgradePu then
        return
    end

    self.activeUpgradePu = true
    for i = 1, 3 do
        self:TryUpgradePiggy(i, puIdx, cardId)
    end
end

function PiggyBankSingleCardView:TryUpgradePiggy(idx, puIdx, cardId)
    log.log("PiggyBankSingleCardView->TryUpgradePiggy 尝试升级猪 idx, cardId", idx, cardId)
    local curState = self:GetCollectState(idx)
    if curState == CollectStates.finish then
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级失败1", idx, cardId)
        self:UpdateUpgradeState(idx, UpgradeStates.nonUpgradable)
        return
    end

    if curState == CollectStates.showBingo then
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级失败2", idx, cardId)
        self:UpdateUpgradeState(idx, UpgradeStates.nonUpgradable)
        return
    end

    if curState == CollectStates.applying then
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级失败3", idx, cardId)
        self:UpdateUpgradeState(idx, UpgradeStates.nonUpgradable)
        return
    end

    if curState == CollectStates.none then
        self:UpdateUpgradeState(idx, UpgradeStates.waitUpgrade)
        self:UpgradePiggy(idx, cardId)
        return
    end
    
    if not self.findCriticalItem then
        if curState == CollectStates.waitApply then
            self:UpdateUpgradeState(idx, UpgradeStates.waitUpgrade)
            self:UpgradePiggy(idx, cardId)
            return
        end

        if curState == CollectStates.showing then
            self:UpdateUpgradeState(idx, UpgradeStates.waitUpgrade)
            -- push event to aftershowlist
            local cb = function() 
                self:UpgradePiggy(idx, cardId, true)
            end
            self:AddAfterShowEvent(idx, cb)
            return
        end
    end

    --[[之面处理完，不应走到这里
    if self.findCriticalItem and self:IsPuInItem(puIdx, idx) then --刚好这个集齐一个猪，且激活PU（先升级-show）
        if curState == CollectStates.showing then
            --push event to aftershowlist
            --self:UpgradePiggy(idx, cardId)
            return
        end
        return
    end
    --]]

    if self.findCriticalItem and self:IsPuInItem(puIdx, 4) then --刚好这个集齐锤子，且激活PU（先升级）
        if curState == CollectStates.waitApply then
            self:UpdateUpgradeState(idx, UpgradeStates.waitUpgrade)
            self:UpgradePiggy(idx, cardId)
            return
        end

        if curState == CollectStates.showing then
            self:UpdateUpgradeState(idx, UpgradeStates.waitUpgrade)
            --push event to aftershowlist
            local cb = function() 
                self:UpgradePiggy(idx, cardId, true)
            end
            self:AddAfterShowEvent(idx, cb)
            return
        end
    end

    if self.findCriticalItem and curState == CollectStates.waitApply then
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级失败4", idx, cardId)
        self:UpdateUpgradeState(idx, UpgradeStates.nonUpgradable)
        return
    end

    log.log("PiggyBankSingleCardView->TryUpgradePiggy Error 升级失败 其它情况", idx, cardId, curState, self:GetUpgradeState(idx), self.findCriticalItem)
end

function PiggyBankSingleCardView:IsPuInItem(puIdx, itemType)
    if not self.groupInfo or not self.groupInfo[itemType] then
        log.log("PiggyBankSingleCardView:IsPuInItem 分组数据有误", self.groupInfo, itemType)
        return false
    end
    
    local cells = self.groupInfo[itemType]
    for idx, cell in ipairs(cells) do
        if cell.index == puIdx then
            log.log("PiggyBankSingleCardView:IsPuInItem pu 在道具内", itemType)
            return true
        end
    end

    return false
end

function PiggyBankSingleCardView:UpgradePiggy(idx, cardId, needCheckBingo)
    log.log("PiggyBankSingleCardView->TryUpgradePiggy 开始升级", idx, cardId, needCheckBingo)
    self:UpdateUpgradeState(idx, UpgradeStates.upgrading)
    --升级动画
    local collectItem = self["Item" .. idx]
    fun.set_parent(collectItem, self.displayRoot, false)
    local collectState = self:GetCollectState(idx)
    if collectState < CollectStates.showing then
        self:PlayItemAnim(collectItem, ItemAnimName.upgrade1)
    else
        self:PlayItemAnim(collectItem, ItemAnimName.upgrade2)
    end
    
    UISound.play("piggybankpigup")
    LuaTimer:SetDelayFunction(upgradeAnimTime, function()
        self:UpgradePiggyFinish(idx,cardId,needCheckBingo)
        fun.set_parent(collectItem, self.storehouse, false)
    end, nil, LuaTimer.TimerType.Battle)

    LuaTimer:SetDelayFunction(upgradeAnimTime - 0.2, function()
        fun.set_active(self["ItemShowup" .. idx], true)
        fun.set_active(self["ItemShowup" .. idx], false, 0.5)
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankSingleCardView:UpgradePiggyFinish(idx, cardId, needCheckBingo)
    log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级完成", idx, cardId, needCheckBingo)
    self:UpdateUpgradeState(idx, UpgradeStates.upgraded)

    if needCheckBingo then
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级完成 检测bingo", idx, cardId, needCheckBingo)
        self:TryFlyHammerToPiggy()
        return
    end

    if self.eventAfterUpgradeList[idx] then --有后续待处理事，self.eventAfterUpgradeList[idx] 与 needCheckBingo互斥
        log.log("PiggyBankSingleCardView->TryUpgradePiggy 升级完成 有后续事件要处理", idx, cardId, needCheckBingo)
        self.eventAfterUpgradeList[idx]()
        self.eventAfterUpgradeList[idx] = nil
    end
end

function PiggyBankSingleCardView:AddAfterUpgradeEvent(idx, callback)
    log.log("PiggyBankSingleCardView:AddAfterUpgradeEvent ", idx)
    if self.eventAfterUpgradeList[idx] then 
        log.log("PiggyBankSingleCardView:AddAfterUpgradeEvent Error 已经设置过", idx)
    end
    self.eventAfterUpgradeList[idx] = callback
end

function PiggyBankSingleCardView:AddAfterShowEvent(idx, callback)
    log.log("PiggyBankSingleCardView:AddAfterShowEvent ", idx)
    if self.eventAfterShowList[idx] then 
        log.log("PiggyBankSingleCardView:AddAfterShowEvent Error 已经设置过", idx)
        return
    end
    self.eventAfterShowList[idx] = callback
end

return this