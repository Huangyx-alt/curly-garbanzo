local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local LetemRollBingoEffect = BaseBingoEffect:New("LetemRollBingoEffect")
local this = LetemRollBingoEffect
setmetatable(LetemRollBingoEffect, BaseBingoEffect)
local private = {}

function LetemRollBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = #bingoType
        local anima_name = self:GetBingoAnimaName(v.bingo)
        Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
        --undo wait deal
        if bingoCount < 3 then
            log.log("LetemRollBingoEffect->ShowBingoOrJackpot bingo count < 3", bingoCount, mIndex, v)
            self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType)
        else
            log.log("LetemRollBingoEffect->ShowBingoOrJackpot bingocount >= 3", bingoCount, mIndex, v)
            local callback = function()
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
            self:TripleBingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType, callback)
        end
    end
end

function LetemRollBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType)
    self:NotifiReadyShowBingo(cardid, #bingoType)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType
    BattleEffectCache:GetPrefabFromPoolOrCache(self:GetBingoPrefabName(), par, function(eff1)
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
            self:SetBingoShow(currType, eff1)
            self:ChangeSignCellColor(mapindex, currType)
            BattleEffectPool:DelayRecycle(self:GetBingoPrefabName(), eff1, 3)
            --Destroy(eff1, 3)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    end, cardid)

    LuaTimer:SetDelayFunction(1.5, function()
        self:NotifiShowBingoFinish(cardid, bingoCount)
    end, nil, LuaTimer.TimerType.Battle)
end


function LetemRollBingoEffect:TripleBingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType, callback)
    self:NotifiReadyShowBingo(cardid, #bingoType)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType
    BattleEffectCache:GetPrefabFromPoolOrCache(self:GetBingoPrefabName(), par, function(eff1)
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
            self:SetBingoShow(currType, eff1)
            self:ChangeSignCellColor(mapindex, currType)
            BattleEffectPool:DelayRecycle(self:GetBingoPrefabName(), eff1, 3)
            --Destroy(eff1, 3)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    end, cardid)

    LuaTimer:SetDelayFunction(1.7, function()
        if callback then
            callback()
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromCache("LetemRollJackpot", par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(4)
            fun.set_parent(eff1, par, true)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            --fun.set_rect_offset_local_pos(eff1, 15)
            eff1.gameObject:SetActive(true)                                                                                                                                                                                                                                                                            
            local ref = fun.get_component(eff1, fun.REFER)
            local spine = ref:Get("spine")
            if fun.is_not_null(spine) then
                spine:SetAnimation("start", nil, false, 0)
                spine:AddAnimation("idle", nil, true, 0)
            end
            self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 2)
    end, cardid, 2)

    LuaTimer:SetDelayFunction(1.2, function()
        self:NotifiShowBingoFinish(cardid, 3)
    end, nil, LuaTimer.TimerType.Battle)
end

function LetemRollBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        UISound.play("jackpot_firework")
        UISound.play("minerjackpot")
        BattleEffectCache:AddBindEffect(eff1, par, cardid)
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)

        local anima = fun.get_component(eff1, fun.ANIMATOR)
        if fun.is_not_null(anima) and anima_name then
            anima:Play(anima_name)
        end

        self:ShowCoinFlyEffect(mapindex, par.transform.position)

        LuaTimer:SetDelayFunction(3,function()
            BattleEffectCache:RemoveBindEffect(eff1, cardid)
            GoPool.push(bingoEffectName, eff1)
        end, nil, LuaTimer.TimerType.Battle)
        self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    end
end

function LetemRollBingoEffect:GetBingoPrefabName()
    if ModelList.BattleModel.GetIsJokerMachine() then
        return "LetemRollBingobingo"
    end
    return "LetemRollBingobingo"
end

function LetemRollBingoEffect:GetBingoAnimaName(bingoCount)
    local cityID = ModelList.BattleModel:GetGameCityPlayID()
    local cfg = table.find(Csv["bingo_reward"], function(k, v)
        if v.city_play_id ~= cityID then
            return
        end
        return bingoCount == v.bingo
    end)
    bingoCount = cfg and cfg.effects or bingoCount
    
    local anima_name = "bingo01"
    if bingoCount == 2 then
        anima_name = "bingo02"
    elseif bingoCount == 3 then
        anima_name = "bingo03"
    end

    return anima_name
end

function LetemRollBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name)
    if ModelList.BattleModel:IsRocket() then
        return
    end
    local isShowing = BattleLogic.GetLogicModule(LogicName.SwitchLogic):IsShowing(cardId)
    local obj = self.cardView:GetParentView():GetSwitchView():GetSmallCardObj(cardId)
    local newEffect = fun.get_instance(clone, obj)
    fun.set_parent(newEffect, obj, true)
    fun.set_gameobject_scale(newEffect, 0.2, 0.2, 1)
    fun.set_active(newEffect, not isShowing)
    Util.SetRaycastTarget(newEffect, false)

    if anima_name then
        local anima = fun.get_component(newEffect, fun.ANIMATOR)
        anima:Play(anima_name)
    end
    
    if effectType == 0 then
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Bingo, cardId, newEffect)
    else
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Jackpot, cardId, newEffect)
    end
end

function LetemRollBingoEffect:ChangeSignCellColor(cardId, bowlType)
    local cells = BattleLogic.GetLogicModule(LogicName.Card_logic):GetCellsByMaterialType(cardId, bowlType)
    for i = 1, #cells do
        local effectList = self.cardView:GetCellBgEffect(cardId, cells[i].index)
        if effectList then
            for m = 1, #effectList do
                local an = fun.get_component(effectList[m], fun.ANIMATOR)
                if an then
                    an:Play("change")
                end
            end
        end
    end
end

function LetemRollBingoEffect:SetBingoShow(bingoType, obj)
    local refCom = fun.get_component(obj, fun.REFER)
    if refCom then
        local o = refCom:Get(string.format("SDBingo0%s", bingoType))
        fun.set_active(o, true)
    end
end

function LetemRollBingoEffect:NotifiReadyShowBingo(cardId, bingoType)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ReadyShowBingo(cardId, bingoType)
        end
    end
end

function LetemRollBingoEffect:NotifiShowBingoFinish(cardId, bingoType, obj)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowBingoFinish(cardId, bingoType)
        end
    end
end

------------------------------------------------------------------------------------------Begin
function private.GetBingoCount(self, cardId, bingoCount)
    return self:GetCardView():GetBingoType(cardId, bingoCount)
end

function private.PlayBingoAudio(bingoCount)
    if bingoCount == 1 then
        UISound.play("bingo_firework")
        UISound.play("letemrollbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("letemrolldoublebingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("letemrollyahtzee")
    elseif bingoCount == 4 then
        UISound.play("bingo_firework")
    else
        UISound.play("bingo_firework")
        log.log("LetemRollBingoEffect->PlayBingoAudio bingoCount error", bingoCount)
    end
end
------------------------------------------------------------------------------------------End
return this