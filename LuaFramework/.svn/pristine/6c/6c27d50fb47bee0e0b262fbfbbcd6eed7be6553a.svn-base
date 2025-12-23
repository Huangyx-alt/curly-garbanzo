local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local HorseRacingBingoEffect = BaseBingoEffect:New("HorseRacingBingoEffect")
local this = HorseRacingBingoEffect
setmetatable(HorseRacingBingoEffect, BaseBingoEffect)
local private = {}

function HorseRacingBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = #bingoType
        if v.jackpot == 0 then
            local anima_name = self:GetBingoAnimaName(v.bingo, v.data)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            if bingoCount < 5 then
                log.log("HorseRacingBingoEffect：ShowBingoOrJackpot bingo count < 5", bingoCount, mIndex, v)
                self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType, v.data)
            else
                log.log("HorseRacingBingoEffect：ShowBingoOrJackpot bingocount >= 5", bingoCount, mIndex, v)
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex, v.data)
            end
        else
            log.log("HorseRacingBingoEffect：ShowBingoOrJackpot 形成jackpot", bingoCount, mIndex, v)
            Event.Brocast(EventName.Box_Bingo_Coins, 0)
            BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
            --self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
            self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex, v.data)
        end
    end
end

function HorseRacingBingoEffect:ShowBingoOrJackpotV2(bingoData)
    LuaTimer:SetDelayFunction(2, function()
        self:ShowBingoOrJackpotV1(bingoData)
    end, nil, LuaTimer.TimerType.Battle)
end

function HorseRacingBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType, ext)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType

    --BattleEffectCache:GetPrefabFromCache(self:GetBingoPrefabName(), par, function(eff1)
    --    if eff1 then
    --        private.PlayBingoAudio(bingoCount)
    --        eff1.gameObject:SetActive(false)
    --        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
    --        eff1.gameObject:SetActive(true)
    --        local anima = fun.get_component(eff1, fun.ANIMATOR)
    --        anima:Play(anima_name)
    --        local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
    --        self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
    --        self:SetBingoShow(currType, eff1)
    --        self:ChangeSignCellColor(mapindex, currType)
    --        Destroy(eff1, 3)
    --    end
    --    self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    --end, cardid)

    BattleEffectCache:GetPrefabFromPoolOrCache(self:GetBingoPrefabName(), par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(bingoCount, ext)
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
end

function HorseRacingBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid, ext)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromCache("HorseRacingJackpot", par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(5, ext)
            fun.set_parent(eff1, par, true)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            --fun.set_rect_offset_local_pos(eff1, 15)
            eff1.gameObject:SetActive(true)                                                                                                                                                                                                                                                                            
            local ref = fun.get_component(eff1, fun.REFER)
            if fun.is_not_null(ref) then
                local spine = ref:Get("spine")
                if fun.is_not_null(spine) then
                    spine:SetAnimation("start", nil, false, 0)
                    spine:AddAnimation("idle", nil, true, 0)
                end
            end
            self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 2, "jackpot")
    end, cardid, 2)
end

function HorseRacingBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid, ext)
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

function HorseRacingBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name)
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

function HorseRacingBingoEffect:ChangeSignCellColor(cardId, bowlType)
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

function HorseRacingBingoEffect:SetBingoShow(bingoType, obj)
    local refCom = fun.get_component(obj, fun.REFER)
    if refCom then
        local o = refCom:Get(string.format("SDBingo0%s", bingoType))
        fun.set_active(o, true)
    end
end

function HorseRacingBingoEffect:GetBingoPrefabName()
    if ModelList.BattleModel.GetIsJokerMachine() then
        return "HorseRacingBingobingoClown"
    end
    return "HorseRacingBingobingo"
end

function HorseRacingBingoEffect:GetBingoAnimaName(bingoCount, ext)
    local cityID = ModelList.BattleModel:GetGameCityPlayID()
    local cfg = table.find(Csv["bingo_reward"], function(k, v)
        if v.city_play_id ~= cityID then
            return
        end
        return bingoCount == v.bingo
    end)
    bingoCount = cfg and cfg.effects or bingoCount
    
    local anima_name = "bingo"
    if bingoCount == 2 then
        anima_name = "doublebingo"
    elseif bingoCount == 3 then
        anima_name = "triplebingo"
    elseif bingoCount == 4 then
        anima_name = "quadrabingo"
    elseif bingoCount == 5 then
        anima_name = "pentabingo"
    elseif bingoCount > 5 then
        anima_name = "bingorampage"
    end

    if ext and ext.isSuperBingo then
        anima_name = "Hoersebingo"
    end
    return anima_name
end

------------------------------------------------------------------------------------------Begin
function private.GetBingoCount(self, cardId, bingoCount)
    return self:GetCardView():GetBingoType(cardId, bingoCount)
end

function private.PlayBingoAudio(bingoCount, ext)
    if ext and ext.isSuperBingo then
        UISound.play("bingo_firework")
        UISound.play("horseracinggoldenbingo")
        return
    end

    if bingoCount == 1 then
        UISound.play("bingo_firework")
        UISound.play("horseracingbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("horseracing2bingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("horseracing3bingo")
    elseif bingoCount == 4 then
        UISound.play("bingo_firework")
        UISound.play("horseracing4bingo")
    elseif bingoCount == 5 then
        UISound.play("bingo_firework")
        UISound.play("horseracingjackpot")
        --UISound.play("horseracinggoldenbingo")
    else
        UISound.play("bingo_firework")
        log.log("HorseRacingBingoEffect PlayBingoAudio bingoCount error", bingoCount)
    end
end
------------------------------------------------------------------------------------------End
return this