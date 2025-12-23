local BaseSingleCard = require("Combat.Common.View.BaseSingleCardView")
local LetemRollSingleCardView = BaseSingleCard:New()
local this = LetemRollSingleCardView

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
    "flash_clone",
    "gift_clone",
    "LetemRoll_item1",
    "LetemRoll_item2",
    "LetemRoll_item3",
    "LetemRoll_item4",
    "LetemRoll_item5",
    "imgBingo",
    "bingoTip",
    "flyRoot",
}

local CollectStates = {
    none = 0,
    waitApply = 3,
    applying = 6,
    showBingo = 8,
    finish = 10,
}

local shakeBuffFlyDelay1 = 2
local shakeBuffFlyDelay2 = 0.5
local shakeBuffFlyTime = 0.5
local diceShowAndFlyTime = 2
local freshDiceAnimTime = 0.8

function LetemRollSingleCardView:OnEnable(params)

end

function LetemRollSingleCardView:OnDisable()

end

function LetemRollSingleCardView:on_after_bind_ref()
end

function LetemRollSingleCardView:BindObj(obj, parentView)
    self.model = ModelList.BattleModel:GetCurrModel()
    self:on_init(obj, parentView)
    self:InitCellsColor()
    self:InitCollectProgress()
    self:InitBingoTip()
    self:InitCollectStateRecord()
    self.waitApplyEventList = nil
end

function LetemRollSingleCardView:InitCollectStateRecord()
    self.collectStateRecord = {}
    for i = 1, 3 do
        self:UpdateCollectState(i, CollectStates.none)
    end
end

function LetemRollSingleCardView:UpdateCollectState(index, state)
    log.log("LetemRollSingleCardView->UpdateCollectState", index, state)
    self.collectStateRecord[index] = state
end

function LetemRollSingleCardView:GetCollectState(index)
    log.log("LetemRollSingleCardView->GetCollectState", index, self.collectStateRecord[index])
    local state = self.collectStateRecord[index] or CollectStates.none
    return state
end

function LetemRollSingleCardView:Clone(name)
    local o = { name = name }
    setmetatable(o, self)
    self.__index = self
    return o
end

--
function LetemRollSingleCardView:AddBowlDrink(bowlTable, cardId, bowlType, lastCount, curCount, extra)
    local bowlCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBowlCount(cardId)
    local maxCount = BattleLogic.GetLogicModule(LogicName.Card_logic):GetMaxCount(cardId)
    log.log("LetemRollSingleCardView->AddBowlDrink", bowlType, maxCount, bowlCount)
    ---[[
    if bowlType == 1 then
        self:ShowCollectSimpleItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
        if curCount == 5 then
            log.log("LetemRollSingleCardView->AddBowlDrink full", cardId, bowlType)
        end
    elseif bowlType == 2 or bowlType == 3 then
        self:ShowCollectComplexItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
        log.log("LetemRollSingleCardView->AddBowlDrink full", cardId, bowlType)
    end
    --]]
end

function LetemRollSingleCardView:ShowCollectComplexItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("LetemRollSingleCardView->ShowCollectComplexItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    --CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, curCount - lastCount)
    self.model:CollectCardBingo(cardId, bowlType)
    if self:GetCollectState(2) == CollectStates.none then
        self:PrepareCollectShakeBuff1(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    elseif self:GetCollectState(3) == CollectStates.none then
        self:PrepareCollectShakeBuff2(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    else
        log.log("LetemRollSingleCardView->ShowCollectComplexItem error", cardId, bowlType, self.collectStateRecord)
    end
end

function LetemRollSingleCardView:ShowCollectSimpleItem(bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    log.log("LetemRollSingleCardView->ShowCollectSimpleItem:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    if lastCount >= maxCount[bowlType] then
        return
    end

    --CalculateBingoMachine.OnDataChange(cardId, 0, bowlType, curCount - lastCount)
    self.model:CollectCardBingo(cardId, bowlType)
    local location = self.model:GetCollectTargetLocation(cardId, curCount)
    local itemObj = self:GetCollectItemObj(location)
    self:PlayCollectItemAnim(itemObj, "act")
    UISound.play("letemrolldice")
    if curCount >= maxCount[bowlType] then
        self:UpdateCollectState(bowlType, CollectStates.applying)
        LuaTimer:SetDelayFunction(diceShowAndFlyTime, function()
            self.model:CheckCardBingo(cardId, 1, curCount)
        end, nil, LuaTimer.TimerType.Battle)
    end

    BattleEffectCache:GetSkillPrefabFromCache("LetemRollEmpty", itemObj, nil, diceShowAndFlyTime + 0.2, cardId)
end

function LetemRollSingleCardView:PlayCollectItemAnim(itemObj, animName)
    if fun.is_null(itemObj) then
        return
    end

    local anim = fun.get_component(itemObj, fun.ANIMATOR)
    anim:Play(animName)
end

function LetemRollSingleCardView:GetCollectItemObj(idx)
    if not idx then
        return
    end

    if idx < 1 or idx > 5 then
        return
    end

    local itemObj = self["LetemRoll_item" .. idx]

    return itemObj
end

function LetemRollSingleCardView:PrepareCollectShakeBuff1(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("LetemRollSingleCardView->PrepareCollectShakeBuff1:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    local signEffectObj = extra.signEffectObj
    local anim = fun.get_component(signEffectObj, fun.ANIMATOR)
    anim:Play("lock")

    local callback = function()
        self:UpdateCollectState(2, CollectStates.applying)
        self:StartCollectShakeBuff1(cardId, extra)
    end

    if self:GetCollectState(1) == CollectStates.finish then
        callback()
    else
        self:UpdateCollectState(2, CollectStates.waitApply)
        self:PushWaitApplyEvent(callback)
    end
end

function LetemRollSingleCardView:PrepareCollectShakeBuff2(bowlTable, cardId, bowlType, lastCount, curCount, maxCount, extra)
    log.log("LetemRollSingleCardView->PrepareCollectShakeBuff2:", bowlTable, cardId, bowlType, lastCount, curCount, maxCount)
    local signEffectObj = extra.signEffectObj
    local anim = fun.get_component(signEffectObj, fun.ANIMATOR)
    anim:Play("lock")

    local callback = function()
        self:UpdateCollectState(3, CollectStates.applying)
        self:StartCollectShakeBuff2(cardId, extra)
    end

    if self:GetCollectState(2) == CollectStates.finish then
        callback()
    else
        self:UpdateCollectState(3, CollectStates.waitApply)
        self:PushWaitApplyEvent(callback)
    end
end

function LetemRollSingleCardView:PushWaitApplyEvent(waitEvent)
    self.waitApplyEventList = self.waitApplyEventList or {}
    table.insert(self.waitApplyEventList, waitEvent)
end

function LetemRollSingleCardView:TryNextApplyEvent(waitEvent)
    if not self.waitApplyEventList then
        return false
    end

    if #self.waitApplyEventList == 0 then
        return false
    end

    local waitEvent = table.remove(self.waitApplyEventList, 1)
    if waitEvent then
        waitEvent()
        return true
    end

    return false
end

function LetemRollSingleCardView:GetShakeBuffFlyItem(index, signEffectObj)
    local targetPos = Vector3.zero
    if index == 1 then
        targetPos = self.LetemRoll_item4.transform.position
    else
        targetPos = self.LetemRoll_item5.transform.position
    end
    --[[
    local dis = Vector3.Distance(targetPos, fun.get_gameobject_pos(signEffectObj))
    return (dis / 4) * 1.2, targetPos
    --]]

    ---[[
    return shakeBuffFlyTime, targetPos
    --]]
end

function LetemRollSingleCardView:ShowShakeBuffCollect(index, signEffectObj, cardId)
    local oldParent = signEffectObj.transform.parent
    fun.set_parent(signEffectObj, self.flyRoot, false)
    local anim = fun.get_component(signEffectObj, fun.ANIMATOR)
    anim:Play("bingo")

    local effectName = "treasureFlyItem01"
    local flyObj = BattleEffectPool:Get(effectName, self.flyRoot)
    
    
    fun.set_same_position_with(flyObj, signEffectObj)
    fun.set_active(flyObj, false)
    local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
    local delayTime = shakeBuffFlyDelay1
    LuaTimer:SetDelayFunction(delayTime, function()
        fun.set_active(flyObj, true)
        flyAnim:Play("Fei")
    end, nil, LuaTimer.TimerType.Battle)

    delayTime = delayTime + shakeBuffFlyDelay2
    local moveTime, targetPos = self:GetShakeBuffFlyItem(index, flyObj)
    LuaTimer:SetDelayFunction(delayTime, function()
        if fun.is_not_null(oldParent) then
            fun.set_parent(signEffectObj, oldParent, false)
        end

        if fun.is_null(flyObj) then
            return
        end
        local coverObj = UnityEngine.GameObject.New()
        fun.set_parent(coverObj, flyObj.transform.parent, true)
        fun.set_gameobject_scale(flyObj, 1, 1, 1)
        coverObj.transform.position = targetPos
        local localTargetPos = fun.get_gameobject_pos(coverObj, true)
        localTargetPos = localTargetPos - fun.get_child(flyObj.transform, 0).localPosition
        Destroy(coverObj)

        --飞道具动画
        flyObj.transform:SetSiblingIndex(0)
        Anim.move(flyObj, localTargetPos.x, localTargetPos.y, localTargetPos.z, moveTime, true, true, function()
            --Destroy(flyObj)
            BattleEffectPool:Recycle(effectName, flyObj)
        end)
    end, nil, LuaTimer.TimerType.Battle)
    BattleEffectCache:GetSkillPrefabFromCache("LetemRollEmpty", self.flyRoot, nil, moveTime + delayTime + freshDiceAnimTime + 0.2, cardId)
    return moveTime + delayTime
end

function LetemRollSingleCardView:StartCollectShakeBuff1(cardId, extra)
    log.log("LetemRollSingleCardView->StartCollectShakeBuff1:")
    ---[[具体飞行效果
    local animTime = self:ShowShakeBuffCollect(1, extra.signEffectObj, cardId)
    --]]
    UISound.play("letemrollwilddice")
    LuaTimer:SetDelayFunction(animTime, function()
        self:CollectShakeBuff1Finish(cardId)
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollSingleCardView:CollectShakeBuff1Finish(cardId)
    self:ApplyShakeDice1(cardId)
end

function LetemRollSingleCardView:StartCollectShakeBuff2(cardId, extra)
    log.log("LetemRollSingleCardView->StartCollectShakeBuff2:")
    ---[[具体飞行效果
    local animTime = self:ShowShakeBuffCollect(2, extra.signEffectObj, cardId)
    --]]

    UISound.play("letemrollwilddice")
    LuaTimer:SetDelayFunction(animTime, function()
        self:CollectShakeBuff2Finish(cardId)
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollSingleCardView:CollectShakeBuff2Finish(cardId)
    self:ApplyShakeDice2(cardId)
end

function LetemRollSingleCardView:ApplyShakeDice1(cardId)
    log.log("LetemRollSingleCardView->ApplyShakeDice1:")
    for i = 1, 4 do
        local itemObj = self:GetCollectItemObj(i)
        self:PlayCollectItemAnim(itemObj, "change")
    end

    LuaTimer:SetDelayFunction(freshDiceAnimTime, function()
        self:ShakeDice1Finish(cardId)
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollSingleCardView:ShakeDice1Finish(cardId)
    log.log("LetemRollSingleCardView->ShakeDice1Finish:")
    self.model:CheckCardBingo(cardId, 2)
end

function LetemRollSingleCardView:ApplyShakeDice2(cardId)
    log.log("LetemRollSingleCardView->ApplyShakeDice2:")
    local itemObj = self:GetCollectItemObj(5)
    self:PlayCollectItemAnim(itemObj, "change")
    LuaTimer:SetDelayFunction(freshDiceAnimTime, function()
        self:ShakeDice2Finish(cardId)
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollSingleCardView:ShakeDice2Finish(cardId)
    log.log("LetemRollSingleCardView->ShakeDice2Finish:")
    self.model:CheckCardBingo(cardId, 3)
end

function LetemRollSingleCardView:ForbidCollider()
    if self.forbidCollide then
        fun.set_active(self.forbidCollide, true)
    end
end

function LetemRollSingleCardView:InitCellsColor()
    local curModel = ModelList.BattleModel:GetCurrModel()
    for i = 1, 25 do
        local color = curModel:GetCellColor(i)
        self:SetCellColor(i, color)
    end
end

function LetemRollSingleCardView:SetCellColor(index, color)
    local cellObj = self:GetCell(index)
    local refer = fun.get_component(cellObj, fun.REFER)
    if fun.is_not_null(refer) then
        local bg_tip = refer:Get("bg_tip")
        local imgName = "Yahtzeebcard0" .. (color + 1)
        bg_tip.sprite = AtlasManager:GetSpriteByName("LetemRollBingoAtlas", imgName)
    end
end

function LetemRollSingleCardView:InitCollectProgress()
    for i = 1, 5 do
        local ref = self["LetemRoll_item" .. i]
        local anima = fun.get_component(ref, fun.ANIMATOR)
        anima:Play("idle")
    end
end

function LetemRollSingleCardView:InitBingoTip()
    fun.set_active(self.bingoTip, false)
end

function LetemRollSingleCardView:ReadyShowBingo(cardId, bingoType)
    log.log("LetemRollSingleCardView->ReadyShowBingo ", bingoType)
    --local bowlType = bingoType[#bingoType]
    --local bowlType = #bingoType
    local bowlType = bingoType
    if bowlType == 1 then
        fun.set_active(self.bingoTip, true)
    end
    local anima = fun.get_component(self.bingoTip, fun.ANIMATOR)
    anima:Play("bingo" .. bowlType)
    self:UpdateCollectState(bowlType, CollectStates.showBingo)
end

function LetemRollSingleCardView:ShowBingoFinish(cardId, bingoType)
    log.log("LetemRollSingleCardView->ShowBingoFinish ", bingoType)
    --local bowlType = bingoType[#bingoType]
    --local bowlType = #bingoType
    local bowlType = bingoType
    self:UpdateCollectState(bowlType, CollectStates.finish)
    self:TryNextApplyEvent()
    self.model:CheckCardBingo2(cardId)
end

return this