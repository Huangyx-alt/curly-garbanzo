local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local PiggyBankBingoEffect = BaseBingoEffect:New("PiggyBankBingoEffect")
local this = PiggyBankBingoEffect
setmetatable(PiggyBankBingoEffect, BaseBingoEffect)
local private = {}

function PiggyBankBingoEffect:ShowBingoOrJackpot(bingoData, cb)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        local bingoCount = #bingoType
        local anima_name, spineAnimName = self:GetBingoAnimaName(v.bingo)
        Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
        --undo wait deal
        if bingoCount < 3 then
            log.log("PiggyBankBingoEffect->ShowBingoOrJackpot bingo count < 3", bingoCount, mIndex, v)
            self:BingoEffect(mIndex, anima_name, spineAnimName, v.first_num, mIndex, bingoType, cb)
        else
            log.log("PiggyBankBingoEffect->ShowBingoOrJackpot bingocount >= 3", bingoCount, mIndex, v)
            --local callback = function()
            --    BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex, cb)
            --end
            --self:TripleBingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType, callback)
        end
    end
end

function PiggyBankBingoEffect:BingoEffect(mapindex, anima_name, spineAnimName, cellIndex, cardid, bingoType, cb)
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
        
        fun.set_parent(eff1, par,true)
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        
        local anima = fun.get_component(eff1, fun.ANIMATOR)
        anima:Play(anima_name)

        if not string.is_empty(spineAnimName) then
            local refer = fun.get_component(eff1, fun.REFER)
            local spine = refer:Get(string.format("%s_spine", anima_name))
            if not IsNull(spine) then
                spine:PlayByName(spineAnimName, false)
            end
        end
        
        local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
        self:ShowCoinFlyEffect(mapindex, fun.get_gameobject_pos(cell_obj_pos))
        
        LuaTimer:SetDelayFunction(3,function()
            BattleEffectCache:RemoveBindEffect(eff1, cardid)
            GoPool.push(bingoEffectName, eff1)
        end, nil, LuaTimer.TimerType.Battle)
    end

    LuaTimer:SetDelayFunction(1.5, function()
        fun.SafeCall(cb)
        self:NotifiShowBingoFinish(cardid, bingoCount)
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankBingoEffect:TripleBingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType, callback)
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
            BattleEffectPool:DelayRecycle(sbingoEffectName, eff1, 3)
            --Destroy(eff1, 3)
        end
    end, cardid)

    LuaTimer:SetDelayFunction(1.7, function()
        if callback then
            callback()
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid, cb)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = fun.get_gameobject_pos(par)

    local eff1 = GoPool.pop("PiggyBankJackpot")
    if eff1 then
        BattleEffectCache:AddBindEffect(eff1, par, cardid, 2)

        private.PlayBingoAudio(5)
        fun.set_parent(eff1, par,true)
        
        fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
        --fun.set_rect_offset_local_pos(eff1, -10, 10)

        --local ref = fun.get_component(eff1, fun.REFER)
        --local spine = ref:Get("spine")
        --spine:SetAnimation("start", nil, false, 0)
        --spine:AddAnimation("idle", nil, true, 0)

        --self:ShowCoinFlyEffect(mapindex,fun.get_gameobject_pos( par))
    end

    LuaTimer:SetDelayFunction(1.2, function()
        fun.SafeCall(cb)
        self:NotifiShowBingoFinish(cardid, 3)
    end, nil, LuaTimer.TimerType.Battle)
end

function PiggyBankBingoEffect:NotifiReadyShowBingo(cardId, bingoType)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ReadyShowBingo(cardId, bingoType)
        end
    end
end

function PiggyBankBingoEffect:NotifiShowBingoFinish(cardId, bingoType, obj)
    local bingoView = ModelList.BattleModel:GetCurrBattleView()
    if bingoView then
        --local cardView = ModelList.BattleModel:GetCurrBattleView():GetCardView()
        local cardView = bingoView:GetCardView()
        if cardView then
            cardView:ShowBingoFinish(cardId, bingoType)
        end
    end
end

function PiggyBankBingoEffect:GetBingoAnimaName(bingoCount)
    local anima_name, spineAnimName = "bingo", "idle"
    if bingoCount == 2 then
        anima_name = "doublebingo"
        spineAnimName = "idle"
    elseif bingoCount >= 3 then
        return
    end
    return anima_name, spineAnimName
end

function PiggyBankBingoEffect:GetBingoPrefabName(bingoCount)
    return "PiggyBankbingo"
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
    elseif bingoCount >= 3 then
        UISound.play("bingo_firework")
        UISound.play("piggybanktriplebingo")
    end
end

return this