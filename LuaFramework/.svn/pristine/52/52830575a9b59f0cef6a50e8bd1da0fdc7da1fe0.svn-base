local BaseSignEffect = require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")
local ChristmasSynthesisSignEffect = BaseSignEffect:New("ChristmasSynthesisSignEffect")
setmetatable(ChristmasSynthesisSignEffect, BaseSignEffect)
local this = ChristmasSynthesisSignEffect
local itemShowCache = {}
local animRollTime = 2

function ChristmasSynthesisSignEffect:RegisterEvent()
    itemShowCache = {}
    --Event.AddListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function ChristmasSynthesisSignEffect:UnRegisterEvent()
    --Event.RemoveListener(EventName.Event_Sign_Cell_Background, self.CellBgEffect, self)
end

function ChristmasSynthesisSignEffect:TriggerSingleBingo(cardId, cellIndex)
    Event.Brocast(EventName.Event_Show_Skill_Bingo, cardId, cellIndex)
end

--格子盖章效果
function ChristmasSynthesisSignEffect:SignCardEffect(cardId, index, cardCell, signType, delay, self_bingo, giftLen)
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
    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)

    local effect = this.effectEntry:GetCellChip(cardId, index, cardCell)
    if signType == 1 then
        local play_name = this:GetBingoEffectName(signType + 1, self_bingo)
        this.effectEntry:AddDelayAnima(effect, play_name, delay, 0.5, 2)
    elseif signType == 2 then
        local play_name = this:GetBingoEffectName(signType + 1, self_bingo)
        this.effectEntry:AddDelayAnima(effect, play_name, delay, 0.5, 3)
    elseif signType == 0 then
        --local effect = ref_temp:Get("ef_Bingo_click")
        --fun.set_active(effect,true )
        local bundle = {}
        bundle.cardId = cardId
        bundle.index = index
        bundle.cardCell = cardCell
        bundle.isMateSign = false
        Event.Brocast(EventName.CardCellFirstSignEffect, bundle)

        ViewList.ChristmasSynthesisBingoView:GetCardView():CellSignChange(cardId, index)
        if self:GetCardView() then
            self:GetCardView():StorageCellBgEffect(tonumber(cardId), index, effect)
        end
        --- 0.5s的丢宝动画时间，结束后检查是否能合成
        --LuaTimer:SetDelayFunction(0.5, function ()
        --    ModelList.BattleModel:GetCurrBattleView():GetCardView():CellSignChange(cardId, index)
        --end)
    end

    if giftLen then
        local anima = fun.get_component(cardCell, fun.ANIMATOR)
        if anima then
            if giftLen > 0 and signType == 0 then
                local giftEffect = BattleEffectPool:Get("cell_get_gift")
                this.supplement:SetEffectScale(giftEffect)
                fun.set_same_position_with(giftEffect, cardCell)
                BattleEffectPool:DelayRecycle("cell_get_gift", giftEffect, 1)
            end
        end
    end
end

function ChristmasSynthesisSignEffect:StartRollCell(cardId, cellIdx)
end

--- 格子底部印章效果
function ChristmasSynthesisSignEffect:CellBgEffect(treasureType, cardId, cellIndex, iconName, part, pos)
end

--- 显示格子点击提示
function ChristmasSynthesisSignEffect:ShowNormalCellTip(cell, cardid, cellIndex)
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
function ChristmasSynthesisSignEffect:SetJokerBgOnSign(ref_temp, cardId, cellIndex)

end

return this
