local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local NewLeetoleManBingoEffect = BaseBingoEffect:New("NewLeetoleManBingoEffect")
local this = NewLeetoleManBingoEffect
setmetatable(NewLeetoleManBingoEffect, BaseBingoEffect)
local private = {}

function NewLeetoleManBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = #bingoType
        if v.jackpot == 0 then
            local anima_name = self:GetBingoAnimaName(v.bingo)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            if bingoCount < 5 then
                self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType)
            else
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
        else
            Event.Brocast(EventName.Box_Bingo_Coins, 0)
            self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
        end
    end
end

function NewLeetoleManBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType

    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        BattleEffectCache:AddBindEffect(eff1, par, cardid)
        private.PlayBingoAudio(bingoCount)
        
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        
        local anima = fun.get_component(eff1, fun.ANIMATOR)
        anima:Play(anima_name)
        
        local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
        self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
        
        LuaTimer:SetDelayFunction(3,function()
            BattleEffectCache:RemoveBindEffect(eff1, cardid)
            GoPool.push(bingoEffectName, eff1)
        end, nil, LuaTimer.TimerType.Battle)
    end
    self:ShowEffectOnSmallCard(bingoEffectName, mapindex, 0, anima_name)
end

function NewLeetoleManBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position

    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        UISound.play("jackpot_firework")
        UISound.play("newleetolemanjackpot")
        BattleEffectCache:AddBindEffect(eff1, par, cardid)
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)

        local anima = fun.get_component(eff1, fun.ANIMATOR)
        anima:Play(anima_name)

        self:ShowCoinFlyEffect(mapindex, par.transform.position)

        LuaTimer:SetDelayFunction(3,function()
            BattleEffectCache:RemoveBindEffect(eff1, cardid)
            GoPool.push(bingoEffectName, eff1)
        end, nil, LuaTimer.TimerType.Battle)
    end
    self:ShowEffectOnSmallCard(bingoEffectName, mapindex, 0, anima_name)
end

function NewLeetoleManBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position

    local eff1 = GoPool.pop("NewLeetoleManJackpot")
    if eff1 then
        BattleEffectCache:AddBindEffect(eff1, par, cardid, 2)

        private.PlayBingoAudio(5)
        fun.set_parent(eff1, par,true)
        
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        fun.set_rect_offset_local_pos(eff1, -10, 10)

        local ref = fun.get_component(eff1, fun.REFER)
        local spine = ref:Get("spine")
        spine:SetAnimation("start", nil, false, 0)
        spine:AddAnimation("idle", nil, true, 0)

        self:ShowCoinFlyEffect(mapindex, par.transform.position)
    end
    self:ShowEffectOnSmallCard("NewLeetoleManJackpot", mapindex, 2)
end

function NewLeetoleManBingoEffect:ShowEffectOnSmallCard(pollName, cardId, effectType, anima_name)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    
    local isShowing = BattleLogic.GetLogicModule(LogicName.SwitchLogic):IsShowing(cardId)
    local switchView = self.cardView:GetParentView():GetSwitchView()
    local effectObj = switchView:GetSwitchEffect(effectType, cardId)
    if fun.is_null(effectObj) then
        local obj = self.cardView:GetParentView():GetSwitchView():GetSmallCardObj(cardId)
        effectObj = GoPool.pop(pollName)
        fun.set_parent(effectObj, obj, true)
        fun.set_rect_offset_local_pos(effectObj, 0, 3)
        fun.set_gameobject_scale(effectObj, 0.21, 0.21, 1)
        fun.set_active(effectObj, not isShowing)
        Util.SetRaycastTarget(effectObj, false)
    end

    if anima_name then
        local anima = fun.get_component(effectObj, fun.ANIMATOR)
        anima:Play(anima_name)
    end                                                                                          
    
    if effectType == 0 then
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Bingo, cardId, effectObj)
    else
        local ref = fun.get_component(effectObj, fun.REFER)
        local spine = ref:Get("spine")
        spine:SetAnimation("start", nil, false, 0)
        spine:AddAnimation("idle", nil, true, 0)
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Jackpot, cardId, effectObj)
    end
end

---------------------------------------------------------------

function private.GetBingoCount(self, cardId, bingoCount)
    local ret = BattleLogic.GetLogicModule(LogicName.Card_logic):GetBingoType(cardId, bingoCount)
    return ret
end

function private.PlayBingoAudio(bingoCount)
    if bingoCount == 1 then
        UISound.play("bingo_firework")
        UISound.play("newleetolemanbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("newleetolemandoublebingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("newleetolemantriplebingo")
    elseif bingoCount == 4 then
        UISound.play("bingo_firework")
        UISound.play("newleetolemanquadrabingo")    
    elseif bingoCount == 5 then
        UISound.play("bingo_firework")
        UISound.play("newleetolemanpentabingo")
    end
end

return this