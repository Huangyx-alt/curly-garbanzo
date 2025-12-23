local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local DrinkingFrenzyBingoEffect = BaseBingoEffect:New("DrinkingFrenzyBingoEffect")
local this = DrinkingFrenzyBingoEffect
setmetatable(DrinkingFrenzyBingoEffect, BaseBingoEffect)
local private = {}

function DrinkingFrenzyBingoEffect:ShowBingoOrJackpot(bingoData, cb)
    --log.log("检查bingo出现问题 ShowBingoOrJackpot  a" , bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoType, currType = private.GetBingoCount(self, mIndex, v.bingo)
        --log.log("检查bingo出现问题 ShowBingoOrJackpot" , bingoData ,  k ,bingoType , currType)
        local bingoCount = #bingoType
        --if v.jackpot == 0 then
            local anima_name, spineAnimName = self:GetBingoAnimaName(v.bingo)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            if bingoCount < 4 then
                log.log("DrinkingFrenzyBingoEffect：ShowBingoOrJackpot bingo count < 4", bingoCount, mIndex, v)
                self:BingoEffect(mIndex, anima_name, spineAnimName, v.first_num, mIndex, bingoType, currType, cb)
            else
                log.log("DrinkingFrenzyBingoEffect：ShowBingoOrJackpot bingocount >= 4", bingoCount, mIndex, v)
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex, cb)
            end
        --else
        --    log.log("DrinkingFrenzyBingoEffect：ShowBingoOrJackpot 形成jackpot", bingoCount, mIndex, v)
        --    Event.Brocast(EventName.Box_Bingo_Coins, 0)
        --    BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
        --    self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
        --end
    end
end

function DrinkingFrenzyBingoEffect:BingoEffect(mapindex, anima_name, spineAnimName, cellIndex, cardid, bingoType, currType, cb)
    local par = self.cardView:GetCardMap(mapindex)
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    local bingoCount = #bingoType

    BattleEffectCache:GetSkillPrefab_BingoBang(cardid, self:GetBingoPrefabName(), par, 3, function(eff1)
        if eff1 then
            private.PlayBingoAudio(bingoCount)

            local anima = fun.get_component(eff1, fun.ANIMATOR)
            if fun.is_not_null(anima) and anima_name then
                anima:Play(anima_name)
            end
            
            if not string.is_empty(spineAnimName) then
                local refer = fun.get_component(eff1, fun.REFER)
                local spine = refer:Get(string.format("%s_spine", anima_name))
                if not IsNull(spine) then
                    spine:PlayByName(spineAnimName, false)
                end
            end
            
            --local cell_obj_pos = self.cardView:GetCardCell(mapindex, 13)
            --self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
            
            self:SetBingoShow(currType, eff1)
            self:ChangeSignCellColor(mapindex, currType)
        end
        --self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    end)

    LuaTimer:SetDelayFunction(2.25, function()
        fun.SafeCall(cb)
    end, nil, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzyBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid, cb)
    local par = self.cardView:GetCardMap(mapindex)
    BattleEffectCache:GetSkillPrefab_BingoBang(cardid, "DrinkingFrenzyJackpot", par, 0, function(eff1)
        if eff1 then
            private.PlayBingoAudio(4)
                                                                                                                                                                                                                                                                      
            --local ref = fun.get_component(eff1, fun.REFER)
            --local spine = ref:Get("spine")
            --spine:SetAnimation("start", nil, false, 0)
            --spine:AddAnimation("idle", nil, true, 0)
            
            --self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
    end)

    LuaTimer:SetDelayFunction(1.5, function()
        fun.SafeCall(cb)
    end, nil, LuaTimer.TimerType.Battle)
end

function DrinkingFrenzyBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
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
        --self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name)
    end
end

function DrinkingFrenzyBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name)
    --if ModelList.BattleModel:IsRocket() then
    --    return
    --end
    --local isShowing = BattleLogic.GetLogicModule(LogicName.SwitchLogic):IsShowing(cardId)
    ----local obj = self.cardView:GetParentView():GetSwitchView():GetSmallCardObj(cardId)
    --local obj = self.cardView:GetParentView():GetSwitchView():GetJackpotParent(cardId)
    --local newEffect = fun.get_instance(clone, obj)
    ----fun.set_parent(newEffect, obj, true)
    --fun.set_parent(newEffect, obj, false)
    --fun.set_same_position_with(newEffect, obj)
    --fun.set_gameobject_scale(newEffect, 0.2, 0.2, 1)
    --fun.set_active(newEffect, not isShowing)
    --Util.SetRaycastTarget(newEffect, false)
    --
    --if anima_name then
    --    local anima = fun.get_component(newEffect, fun.ANIMATOR)
    --    anima:Play(anima_name)
    --end
    --
    --if effectType == 0 then
    --    Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Bingo, cardId, newEffect)
    --else
    --    Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Jackpot, cardId, newEffect)
    --end
end

function DrinkingFrenzyBingoEffect:ChangeSignCellColor(cardId, bowlType)
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

function DrinkingFrenzyBingoEffect:SetBingoShow(bingoType, obj)
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
        UISound.play("drinkingbingo")
    elseif bingoCount == 2 then
        UISound.play("bingo_firework")
        UISound.play("drinkingdoublebingo")
    elseif bingoCount == 3 then
        UISound.play("bingo_firework")
        UISound.play("drinkingtriplebingo")
    elseif bingoCount == 4 then
        UISound.play("bingo_firework")
        UISound.play("drinkingquadrabingo")
    else
        UISound.play("bingo_firework")
        log.log("DrinkingFrenzyBingoEffect PlayBingoAudio bingoCount error", bingoCount)
    end
end

function DrinkingFrenzyBingoEffect:GetBingoPrefabName()
    if ModelList.BattleModel.GetIsJokerMachine() then
        return "DrinkingFrenzybingo"
    end
    return "DrinkingFrenzybingo"
end


function DrinkingFrenzyBingoEffect:GetBingoAnimaName(bingoCount)
    local anima_name, spineAnimName = "bingo", "animation"
    if bingoCount == 2 then
        anima_name = "doublebingo"
        spineAnimName = "animation"
    elseif bingoCount == 3 then
        anima_name = "triplebingo"
        spineAnimName = "animation"
    end
    return anima_name, spineAnimName
end

------------------------------------------------------------------------------------------End
return this