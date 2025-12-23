local BaseSignEffect =  require("View.Bingo.EffectModule.Card.SignEffect.BaseSignEffect")
local ThievesSignEffect = BaseSignEffect:New("ThievesSignEffect")
setmetatable(ThievesSignEffect,BaseSignEffect)
local this = ThievesSignEffect
local thievesList = {7, 17, 9, 19}

function ThievesSignEffect:RegisterEvent()
    Event.AddListener(EventName.Event_Christmas_Sign_Cell_Background, self.CellBgEffect, self)
end

function ThievesSignEffect:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Christmas_Sign_Cell_Background, self.CellBgEffect, self)
end

function ThievesSignEffect:TriggerSingleBingo(cardId, cellIndex)
    cardId = tonumber(cardId)

    local logicModule = BattleLogic.GetLogicModule(LogicName.Card_logic)
    if logicModule:IsJackpot(cardId) then
        return
    end
    
    local curModel, cardView = ModelList.BattleModel:GetCurrModel(), self:GetCardView()
    local target, thievesPos = cardView:GetCardMap((cardId))
    
    if ModelList.BattleModel:IsRocket() then
        --在小火箭界面使用5036里的数据
        local data = curModel:GetSettleExtraInfo("wolfMoon")
        data = table.find(data, function(k, v)
            local cellID = ConvertServerPos(v.pos)
            return v.cardId == cardId and cellID == cellIndex
        end)
        if data then
            thievesPos = ConvertServerPos(data.wolfPos)
        else
            thievesPos = curModel:GetValidThievesForBingoSkill(cardId, cellIndex)
        end
    else
        thievesPos = curModel:GetValidThievesForBingoSkill(cardId, cellIndex)
    end
    
    --添加ExtraData，结算时通知服务器
    curModel:GetRoundData(cardId):AddExtraUpLoadData("wolfMoon", {
        cardId = cardId,
        pos = ConvertCellIndexToServerPos(cellIndex),
        wolfPos = ConvertCellIndexToServerPos(thievesPos),
    }, "pos")
    
    --数据层更新
    BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceAllLogicLockTiers(cardId, thievesPos)

    local thievesTarget = cardView:GetCardCell(cardId, thievesPos)
    --技能效果
    BattleEffectCache:GetSkillPrefabFromCache("ThievesBingoSkill", thievesTarget, function(obj)
        UISound.play("thievesdynamic")
        
        if ModelList.BattleModel:IsRocket() then
            fun.set_gameobject_scale(obj,0.6,0.6,0.6)
        end
        
        --表现层更新
        LuaTimer:SetDelayFunction(1.2,function()
            curModel:RefreshSignLogicDelayTime()
            cardView:ReduceAllLockTiers(cardId, thievesPos)
        end)
    end, 3, cardId)
end

--格子盖章效果
function ThievesSignEffect:SignCardEffect(cardId,index, cardCell, signType, delay, self_bingo, giftLen)
    signType = signType or 0
    if self:CannotSignCell(cardId, index, signType) then return end
    delay = delay or 0
    for i = 1, fun.get_child_count(cardCell) do
        fun.set_active(fun.get_child(cardCell,i-1),false)
    end
    self:HideCellChild(cardCell, cardId)
    
    Event.Brocast(EventName.Magnifier_Close_Single_Cell, cardCell, false)
    
    if self_bingo then
        self:TriggerSingleBingo(cardId, index)
    end
end

function ThievesSignEffect:HideCellChild(cardCell, cardId)
    local ref_temp = fun.get_component(cardCell, fun.REFER)
    local number1 = ref_temp:Get("number1")
    fun.set_active(number1, false)
    local number2 = ref_temp:Get("number2")
    fun.set_active(number2, false)
    local number3 = ref_temp:Get("number3")
    fun.set_active(number3, false)
    local number4 = ref_temp:Get("number4")
    fun.set_active(number4, false)
    local doublebg = ref_temp:Get("doublebg")
    fun.set_active(doublebg, false)
    local gift = ref_temp:Get("gift")
    fun.set_active(gift, false)
    local bg_tip = ref_temp:Get("bg_tip")
    fun.set_active(bg_tip, false)

    self:HideJoker(ref_temp, cardId)
end

--- 格子底部印章效果
function ThievesSignEffect:CellBgEffect(drinkType, cardId, cellIndex)

end

return this