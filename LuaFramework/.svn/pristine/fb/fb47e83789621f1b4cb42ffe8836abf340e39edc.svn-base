local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local GemQueenBingoEffect = BaseBingoEffect:New("GemQueenBingoEffect")
local this = GemQueenBingoEffect
setmetatable(GemQueenBingoEffect, BaseBingoEffect)
local private = {}

function GemQueenBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        if v.jackpot == 0 then
            local anima_name = self:GetBingoAnimaName(v.bingo)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoType, currType)
        else
            Event.Brocast(EventName.Box_Bingo_Coins, 0)
            BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
            self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
        end
    end
end

function GemQueenBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoType, currType)
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
            if anima then  anima:Play(anima_name) end
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

--显示Jackpot 特效
function GemQueenBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
    --if not self.cardView:IsCardShowing(tonumber(cardid)) then
    --    return
    --end
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromCache("GemQueenJackpot", par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(4)

            fun.set_parent(eff1, par,true)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            --fun.set_rect_offset_local_pos(eff1, 15)
            eff1.gameObject:SetActive(true)
                                                                                                                                                                                                                                                                               
            --Spine 动画
            local ref = fun.get_component(eff1, fun.REFER)
            local spine = ref:Get("spine")
            spine:SetAnimation("start", nil, false, 0)
            spine:AddAnimation("idle", nil, true, 0)
            
            self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 2)
    end, cardid, 2)
end

--- 在卡牌缩略图上显示bingo  jackpot效果
function GemQueenBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name)
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

--- 同道具的格子要变色
function GemQueenBingoEffect:ChangeSignCellColor(cardId, bowlType)
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

function GemQueenBingoEffect:SetBingoShow(bingoType, obj)
    local refCom = fun.get_component(obj, fun.REFER)
    if refCom then
        local o = refCom:Get(string.format("SDBingo0%s", bingoType))
        fun.set_active(o, true)
    end
end

-----------------私有方法----------------------------------------------

function private.GetBingoCount(self, cardId, bingoCount)
    return self:GetCardView():GetBingoType(cardId, bingoCount)
end

function private.PlayBingoAudio(bingoCount)
    if bingoCount == 1 then
        UISound.play("bingo_firework")
        --LuaTimer:SetDelayFunction(1.2, function()
            UISound.play("queencharms_bingo")
        --end)
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        --LuaTimer:SetDelayFunction(1.2, function()
            UISound.play("queencharms_doublebingo")
        --end)
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        --LuaTimer:SetDelayFunction(1.2, function()
            UISound.play("queencharms_triplebingo")
        --end)
    elseif bingoCount == 4 then
        UISound.play("jackpot_firework")
        --LuaTimer:SetDelayFunction(0.65, function()
            UISound.play("queencharms_jackpot")
        --end)
    end
end

return this