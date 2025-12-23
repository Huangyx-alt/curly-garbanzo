local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")

local GoldenTrainSignEffect = BaseSignEffect:New("GoldenTrainSignEffect")
setmetatable(GoldenTrainSignEffect, BaseSignEffect)
local this = GoldenTrainSignEffect
local itemShowCache = {}
local animRollTime = 2

function GoldenTrainSignEffect:RegisterEvent()
    itemShowCache = {}
    --Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GoldenTrainSignEffect:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function GoldenTrainSignEffect:TriggerSingleBingo(cardId, cellIndex)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function GoldenTrainSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then
        return
    end
    self:SaveCellSignEffect(cardId, index)
    delay = delay or 0
    for i = 1, fun.get_child_count(cardCell) do
        fun.set_active(fun.get_child(cardCell, i - 1), false)
    end
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    self:HideCellChild(ref_temp, cardId, index)
    self:StartRollCell(cardId, index)
    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    if self_bingo then
        --self:TriggerSingleBingo(cardId, index)
    end
    --Event.Brocast(EventName.Event_Collect_Item_By_Sign, cardId, index)
end

function GoldenTrainSignEffect:StartRollCell(cardId, cellIdx)
    if cellIdx == 13 then
        return
    end

    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIdx)
    local gift = curCell:GetGift()
    local effectName
    local playBoomEffect = false
    if fun.is_include(2031, gift) then
        --[[
        if curModel:GetSpecialCoinType() == 1 then
            curCell:SetGoldCoinType(1)
            effectName = "treasure02"
        else
            curCell:SetGoldCoinType(2)
            effectName = "treasure03"
        end
        --]]
        effectName = "treasure02"
        playBoomEffect = true
    else
        effectName = "treasure01"
        --curCell:SetGoldCoinType(0)
    end

    local cellObj = curCell:GetCellObj()
    --local parentObj = self:GetCardView():GetCard(cardId).storehouse
    local flyObj = BattleEffectPool:Get(effectName, cellObj)
    self:GetCardView():StorageCellBgEffect(cardId, cellIdx, flyObj)
    fun.set_parent(flyObj, cellObj, true)
    fun.set_same_position_with(flyObj, cellObj)
    local flyAnim = fun.get_component(flyObj, fun.ANIMATOR)
    flyAnim:Play("in")
    curCell.goldenTrainCoinEffect = flyObj
    LuaTimer:SetDelayFunction(animRollTime, function()
        Event.Brocast(EventName.Event_View_Collect_Item, cardId, cellIdx)
    end, false, LuaTimer.TimerType.Battle)

    if playBoomEffect then
        BattleEffectCache:GetSkillPrefabFromCache("GoldenTrainskill2lanbi", cellObj, function()
        end, 2, cardId)
    end

    BattleEffectCache:GetSkillPrefabFromCache("GoldenTrainEmpty", cellObj, nil, animRollTime + 0.2, cardId)

    UISound.play("goldentrainspin")
    LuaTimer:SetDelayFunction(1, function()
        UISound.play("goldentrainstop")
    end, false, LuaTimer.TimerType.Battle)
end

--- 格子底部印章效果
function GoldenTrainSignEffect:CellBgEffect(treasureType, cardId, cellIndex, iconName, part, pos)
end

--- 显示格子点击提示
function GoldenTrainSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
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
function GoldenTrainSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this