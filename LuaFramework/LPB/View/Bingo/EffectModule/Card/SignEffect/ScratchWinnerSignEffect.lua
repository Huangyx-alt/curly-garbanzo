local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local ScratchWinnerSignEffect = BaseSignEffect:New("ScratchWinnerSignEffect")
setmetatable(ScratchWinnerSignEffect, BaseSignEffect)
local this = ScratchWinnerSignEffect
local itemShowCache = {}
local animTime1 = 0.7
local animTime2 = 1.2
local animTime3 = 2
local animDelay1 = 0.4

function ScratchWinnerSignEffect:RegisterEvent()
    itemShowCache = {}
    Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function ScratchWinnerSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function ScratchWinnerSignEffect:TriggerSingleBingo(cardId, cellIndex)
    --ModelList.BattleModel:GetCurrModel():GetRoundData(cardId)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function ScratchWinnerSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    --缓存播放过格子盖章效果
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0
    for i = 1, fun.get_child_count(cardCell) do
        fun.set_active(fun.get_child(cardCell, i - 1), false)
    end
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)

    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end
    --创建Bingo道具
    Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

local function GetDieffectCell(view, cardId, cellIndex, part, step)
    if 1 == part then
        -- 横放
        if step then
            return view:GetCardCell(tonumber(cardId), step)
        else
            return view:GetCardCell(tonumber(cardId), cellIndex)
        end
    elseif 2 == part then
        -- 竖放
        if step then
            return view:GetCardCell(tonumber(cardId), step)
        else
            return view:GetCardCell(tonumber(cardId), cellIndex)
        end
    else
        return view:GetCardCell(tonumber(cardId), cellIndex)
    end
end

local DiEffectNameList = {"treasure01", "treasure02", "treasure03", "treasure04", "treasure05"}
local function GetDiEffectName(itemType, indexList)
    if itemType >= 1 and itemType <= 5 then
        return DiEffectNameList[itemType]
    else
        return DiEffectNameList[1]
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
--- 格子底部印章效果
function ScratchWinnerSignEffect:CellBgEffect(treasureType, cardId, cellIndex, indexList, extraParams)
    ---[=[
    local curModel = ModelList.BattleModel:GetCurrModel()
    local cellData = curModel:GetRoundData(cardId, cellIndex)
    local ext = cellData:GetExtInfo()
    local groupID = ext and ext.groupID
    local diEffectName = GetDiEffectName(treasureType, indexList)
    local diEffect = BattleEffectPool:Get(diEffectName)
    local parentObj = self:GetCardView():GetCard(cardId).storehouse
    fun.set_parent(diEffect, parentObj, false)

    local cellObj = cellData:GetCellObj()
    local pos = cellObj.transform.position
    fun.set_gameobject_pos(diEffect, pos.x, pos.y, pos.z, false)
    log.log("ScratchWinnerSignEffect:CellBgEffect 03 setPos", diEffectName, treasureType, cardId, cellIndex)

    local ref = fun.get_component(diEffect, fun.REFER)
    local anima = ref:Get("anima")
    local rewardDetail = ref:Get("rewardDetail")
    local text_reward1 = ref:Get("text_reward1")
    local mask = ref:Get("mask")
    if fun.is_not_null(rewardDetail) then
        fun.set_active(rewardDetail, false)
    end
    
    UISound.play("scratchwinnerscratch")
    if extraParams and extraParams.finishCollect then
        anima:Play("in")
        local cb = function()
            --LuaTimer:SetDelayFunction(animTime2, function()
                if treasureType <= 2 then
                    fun.set_active(rewardDetail, true)
                    text_reward1.text = curModel:GetBingoReward(treasureType, true)
                    UISound.play("scratchwinnerwin")
                    LuaTimer:SetDelayFunction(animTime3, function()
                        ModelList.BattleModel:GetCurrBattleView():ShowCoinFlyEffect(cardId, fun.get_gameobject_pos(cellObj, false))
                    end, false, LuaTimer.TimerType.Battle)
                    fun.set_active(rewardDetail, false, animTime3)
                end
                anima:Play("bingo")
                self:DisplaySameCellBingo(cardId, cellIndex, treasureType)
            --end, false, LuaTimer.TimerType.Battle)
        end
        LuaTimer:SetDelayFunction(animTime1, function()
            self:DisplaySameCellTip(cardId, cellIndex, treasureType, extraParams, cb)
        end, false, LuaTimer.TimerType.Battle)
    else
        anima:Play("in")
        LuaTimer:SetDelayFunction(animTime1, function()
            self:DisplaySameCellTip(cardId, cellIndex, treasureType, extraParams)
        end, false, LuaTimer.TimerType.Battle)
    end

    self:RecordShowedDiEffect(cardId, treasureType, diEffect)

    fun.set_gameobject_scale(diEffect, 1, 1, 1)
    if self.cardView and self.cardView["StorageCellBgEffect"] then
        self.cardView:StorageCellBgEffect(tonumber(cardId), cellIndex, diEffect)
    end

    --jokerbg的层级需要在bg之上
    local cellObj = self:GetCardView():GetCardCell(cardId, cellIndex)
    local ref_temp = fun.get_component(cellObj, fun.REFER)
    local jokerBg = ref_temp:Get("JokerBg")
    if not fun.is_null(jokerBg) then
        --fun.set_parent(jokerBg.transform.parent, bgCtrl)
    end
    --]=]
end

--- 显示格子点击提示
function ScratchWinnerSignEffect:DisplaySameCellTip(cardId, cellIndex, treasureType, ext, cb)
    LuaTimer:SetDelayFunction(animDelay1, function()
        if ViewList.ScratchWinnerExtraBallView then
            ViewList.ScratchWinnerExtraBallView:OnProgressGrowAudio()
        end
    end, false, LuaTimer.TimerType.Battle)

    if not cardId then
        return
    end

    if not treasureType then
        return 
    end

    local sameCells = itemShowCache[cardId][treasureType]
    local count1 = ext.totalCollectCount
    local count2 = ext.curCollectCount
    if treasureType == 5 then
        count1 = ext.totalCollectCount + 1
        count2 = ext.curCollectCount + 1
    end

    local animName = count1 .. "_" .. count2
    if sameCells then
        for i, v in ipairs(sameCells) do
            local ref = fun.get_component(v, fun.REFER)
            local anima = ref:Get("anima")
            local mask = ref:Get("mask")
            anima:Play("act", 0, 0)
            LuaTimer:SetDelayFunction(animDelay1, function()
                mask:Play(animName)
            end, false, LuaTimer.TimerType.Battle)
        end
    end

    if treasureType == 5 then
        local defaultItem = self.cardView:GetCard(cardId):GetDefaultItem()
        local ref = fun.get_component(defaultItem, fun.REFER)
        local rewardDetail = ref:Get("rewardDetail")
        fun.set_active(rewardDetail, false)
        local anima = ref:Get("anima")
        local mask = ref:Get("mask")
        anima:Play("act", 0, 0)
        LuaTimer:SetDelayFunction(animDelay1, function()
            mask:Play(animName)
        end)
    end

    LuaTimer:SetDelayFunction(animTime2, function()
        if cb then
            cb()
        end
    end, false, LuaTimer.TimerType.Battle)
end

--- 显示格子点击提示
function ScratchWinnerSignEffect:DisplaySameCellBingo(cardId, cellIndex, treasureType)
    if not cardId then
        return
    end

    if not treasureType then
        return 
    end
    local sameCells = itemShowCache[cardId][treasureType]
    if sameCells then
        for i, v in ipairs(sameCells) do
            local ref = fun.get_component(v, fun.REFER)
            local anima = ref:Get("anima")
            anima:Play("bingo")
        end
    end

    if treasureType == 5 then
        local defaultItem = self.cardView:GetCard(cardId):GetDefaultItem()
        local ref = fun.get_component(defaultItem, fun.REFER)
        local rewardDetail = ref:Get("rewardDetail")
        fun.set_active(rewardDetail, false)
        local anima = ref:Get("anima")
        anima:Play("bingo")
    end
end

function ScratchWinnerSignEffect:RecordShowedDiEffect(cardId, treasureType, diEffect)
    if not cardId then
        return
    end

    if not treasureType then
        return 
    end

    if not diEffect then
        return
    end

    if not itemShowCache[cardId] then
        itemShowCache[cardId] = {}
    end
    if not itemShowCache[cardId][treasureType] then
        itemShowCache[cardId][treasureType] = {}
    end

    table.insert(itemShowCache[cardId][treasureType], diEffect)
end

--- 显示格子点击提示
function ScratchWinnerSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
    local poolName = "CellGet"
    local cellData = ModelList.BattleModel:GetCurrModel():GetRoundData(cardid, cellIndex)
    if cellData then
        if cellData.isSignByGemPuSkill then
            --标识是被技能1盖章
            poolName = "CellGetPuSkill"
        end
        if cellData.isSignByGemBingoSkill then
            --标识是被技能2盖章
            poolName = "CellGetBingoSkill"
        end
    end
    
    self.__index.ShowNormalCellTip(self, cell, cardid, cellIndex, poolName)
end

--设置新的JokerBg
function ScratchWinnerSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this