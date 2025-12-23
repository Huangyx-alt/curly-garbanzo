local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local SolitaireBingoEffect = BaseBingoEffect:New("SolitaireBingoEffect")
local this = SolitaireBingoEffect
setmetatable(SolitaireBingoEffect, BaseBingoEffect)
local private = {}

function SolitaireBingoEffect:GetBingoAnimaName(bingoCount)    
    local anima_name = "bingo"
    if bingoCount == 2 then
        anima_name = "double1"
    elseif bingoCount == 3 then
        anima_name = "double2"
    elseif bingoCount == 4 then
        anima_name = "quadrabingo"
    elseif bingoCount == 5 then
        anima_name = "pentabingo"
    elseif bingoCount > 5 then
        anima_name = "bingorampage"
    end

    return anima_name
end

function SolitaireBingoEffect:GetBingoPrefabName()
    -- if ModelList.BattleModel.GetIsJokerMachine() then
    --     return "efBingobingoClown"
    -- end
    return "Solitairebingo"
end

function SolitaireBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = #bingoType
        local anima_name = self:GetBingoAnimaName(v.bingo)
        Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
        if bingoCount < 3 then
            log.log("SolitaireBingoEffect->ShowBingoOrJackpot bingo count < 3", bingoCount, mIndex, v)
            self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType)
        else
            log.log("SolitaireBingoEffect->ShowBingoOrJackpot bingocount >= 3", bingoCount, mIndex, v)
            local callback = function()
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
            self:TripleBingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType, callback)
        end
    end
end

function SolitaireBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType)
    self:NotifiReadyShowBingo(cardid, #bingoType)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = fun.get_gameobject_pos(par)
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

function SolitaireBingoEffect:TripleBingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType, callback)
    self:NotifiReadyShowBingo(cardid, #bingoType)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType
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

function SolitaireBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = fun.get_gameobject_pos(par)

    local eff1 = GoPool.pop("SolitaireJackpot")
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
    self:ShowEffectOnSmallCard("SolitaireJackpot", mapindex, 2)

    LuaTimer:SetDelayFunction(1.2, function()
        self:NotifiShowBingoFinish(cardid, 3)
    end, nil, LuaTimer.TimerType.Battle)
end

function SolitaireBingoEffect:ShowEffectOnSmallCard(pollName, cardId, effectType, anima_name)
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

function SolitaireBingoEffect:NotifiReadyShowBingo(cardId, bingoType)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ReadyShowBingo(cardId, bingoType)
        end
    end
end

function SolitaireBingoEffect:NotifiShowBingoFinish(cardId, bingoType, obj)
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
        UISound.play("solitairebingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("solitairedoublebingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("solitairedoublepayout")
    end
end

return this