local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local MonopolyBingoEffect = BaseBingoEffect:New("MonopolyBingoEffect")
local this = MonopolyBingoEffect
setmetatable(MonopolyBingoEffect, BaseBingoEffect)
local private = {}

function MonopolyBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        --local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = v.bingo
        local anima_name = self:GetBingoAnimaName(v.bingo)
        Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
        --undo wait deal
        if bingoCount < 4 then
            log.log("MonopolyBingoEffect->ShowBingoOrJackpot bingo count < 4", bingoCount, mIndex, v)
            self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoCount)
        else
            log.log("MonopolyBingoEffect->ShowBingoOrJackpot bingocount >= 4", bingoCount, mIndex, v)
            local callback = function()
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
            self:TripleBingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoCount, callback)
        end
    end
end

function MonopolyBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoCount)
    self:NotifiReadyShowBingo(cardid, bingoCount)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = fun.get_gameobject_pos(par)
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        BattleEffectCache:AddBindEffect(eff1, par, cardid)
        private.PlayBingoAudio(bingoCount)
        
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        
        local anima = fun.get_component(eff1, fun.ANIMATOR)
        anima:Play(anima_name)
        
        local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
        self:ShowCoinFlyEffect(mapindex, fun.get_gameobject_pos(cell_obj_pos))
        
        LuaTimer:SetDelayFunction(3,function()
            BattleEffectCache:RemoveBindEffect(eff1, cardid)
            GoPool.push(bingoEffectName, eff1)
        end, nil, LuaTimer.TimerType.Battle)
    end
    self:ShowEffectOnSmallCard(bingoEffectName, mapindex, 0, anima_name)

    LuaTimer:SetDelayFunction(1.5, function()
        self:NotifiShowBingoFinish(cardid, bingoCount)
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolyBingoEffect:TripleBingoEffect(mapindex, anima_name, cellIndex, cardid, bingoCount, callback)
    self:NotifiReadyShowBingo(cardid, bingoCount)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoEffectName = self:GetBingoPrefabName()
    BattleEffectCache:GetPrefabFromPoolOrCache(bingoEffectName, par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(bingoCount)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            eff1.gameObject:SetActive(true)
            local anima = fun.get_component(eff1, fun.ANIMATOR)
            if fun.is_not_null(anima) and anima_name then
                anima:Play(anima_name)
            end
            local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
            self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
            --self:SetBingoShow(currType, eff1)
            BattleEffectPool:DelayRecycle(self:GetBingoPrefabName(), eff1, 3)
            --Destroy(eff1, 3)
        end
        self:ShowEffectOnSmallCard(bingoEffectName, mapindex, 0, anima_name)
    end, cardid)

    LuaTimer:SetDelayFunction(1.7, function()
        if callback then
            callback()
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolyBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = fun.get_gameobject_pos(par)

    local eff1 = GoPool.pop("MonopolyJackpot")
    if eff1 then
        BattleEffectCache:AddBindEffect(eff1, par, cardid, 2)

        private.PlayBingoAudio(5)
        fun.set_parent(eff1, par,true)
        
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        fun.set_rect_offset_local_pos(eff1, -10, 10)

        --local ref = fun.get_component(eff1, fun.REFER)
        --local spine = ref:Get("spine")
        --spine:SetAnimation("start", nil, false, 0)
        --spine:AddAnimation("idle", nil, true, 0)

        self:ShowCoinFlyEffect(mapindex,fun.get_gameobject_pos( par))
    end
    self:ShowEffectOnSmallCard("MonopolyJackpot", mapindex, 2)

    LuaTimer:SetDelayFunction(1.2, function()
        self:NotifiShowBingoFinish(cardid, 4)
    end, nil, LuaTimer.TimerType.Battle)
end

function MonopolyBingoEffect:ShowEffectOnSmallCard(pollName, cardId, effectType, anima_name)
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
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Jackpot, cardId, effectObj)
    end
end

function MonopolyBingoEffect:NotifiReadyShowBingo(cardId, bingoType)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ReadyShowBingo(cardId, bingoType)
        end
    end
end

function MonopolyBingoEffect:NotifiShowBingoFinish(cardId, bingoType, obj)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowBingoFinish(cardId, bingoType)
        end
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
        UISound.play("piggybankbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("piggybankdoublebingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("piggybanktriplebingo")
    end
end

return this