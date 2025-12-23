local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local BisonBingoEffect = BaseBingoEffect:New("BisonBingoEffect")
local this = BisonBingoEffect
setmetatable(BisonBingoEffect, BaseBingoEffect)
local private = {}

function BisonBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        if v.jackpot == 0 then
            local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
            local bingoCount = #bingoType
            local anima_name = self:GetBingoAnimaName(v.bingo)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            if bingoCount < 4 then
                log.log("BisonBingoEffect：ShowBingoOrJackpot bingo count < 4", bingoCount, mIndex, v)
                self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType)
            else
                log.log("BisonBingoEffect：ShowBingoOrJackpot bingocount >= 4", bingoCount, mIndex, v)
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
        else
            log.log("BisonBingoEffect：ShowBingoOrJackpot 形成jackpot", bingoCount, mIndex, v)
            Event.Brocast(EventName.Box_Bingo_Coins, 0)
            BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
            self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
        end
    end
end

function BisonBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType)
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
end

function BisonBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromCache("BisonJackpot", par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(4)
            fun.set_parent(eff1, par, true)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            --fun.set_rect_offset_local_pos(eff1, 15)
            eff1.gameObject:SetActive(true)                                                                                                                                                                                                                                                                            
            -- local ref = fun.get_component(eff1, fun.REFER)
            -- local spine = ref:Get("spine")
            -- spine:SetAnimation("start", nil, false, 0)
            -- spine:AddAnimation("idle", nil, true, 0)
            self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 2)
    end, cardid, 2)
end

function BisonBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        UISound.play("jackpot_firework")
        UISound.play("bisonjackpot")
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

function BisonBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name)
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

function BisonBingoEffect:ChangeSignCellColor(cardId, bowlType)
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

function BisonBingoEffect:SetBingoShow(bingoType, obj)
    local refCom = fun.get_component(obj, fun.REFER)
    if refCom then
        local o = refCom:Get(string.format("SDBingo0%s", bingoType))
        fun.set_active(o, true)
    end
end

------------------------------------------------------------------------------------------Begin
function private.GetBingoCount(self, cardId, bingoCount)
    return self:GetCardView():GetBingoType(cardId, bingoCount)
end

--undo wait sound
function private.PlayBingoAudio(bingoCount)
    if bingoCount == 1 then
        UISound.play("bingo_firework")
        UISound.play("bisonbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("bison2bingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("bison3bingo")
    elseif bingoCount == 4 then
        UISound.play("bingo_firework")
        UISound.play("bison4bingo")
    elseif bingoCount == 5 then
        UISound.play("bingo_firework")
        UISound.play("piratepentabingo")
    end
end
------------------------------------------------------------------------------------------End
return this