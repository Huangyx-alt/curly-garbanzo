local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local GoldenTrainBingoEffect = BaseBingoEffect:New("GoldenTrainBingoEffect")
local this = GoldenTrainBingoEffect
setmetatable(GoldenTrainBingoEffect, BaseBingoEffect)
local private = {}
local bingoAnimTime = 2
local rollNumTime = 1

function GoldenTrainBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local bingoCount = v.bingo
        local bingoPathId = v.data.pathId
        if v.jackpot == 0 then
            local anima_name = self:GetBingoAnimaNameByPath(bingoPathId)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            if true then --目前暂定无禁用卡片效果
                log.log("GoldenTrainBingoEffect：ShowBingoOrJackpot bingo count < 4", bingoCount, mIndex, v)
                self:BingoEffect(mIndex, anima_name, v.first_num, mIndex, bingoCount, bingoPathId)
            else
                log.log("GoldenTrainBingoEffect：ShowBingoOrJackpot bingocount >= 4", bingoCount, mIndex, v)
                BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
                self:RampageBingoEffect(mIndex, anima_name, v.first_num, mIndex)
            end
        else
            log.log("GoldenTrainBingoEffect：ShowBingoOrJackpot 形成jackpot", bingoCount, mIndex, v)
            Event.Brocast(EventName.Box_Bingo_Coins, 0)
            BattleLogic.GetLogicModule(LogicName.Card_logic):ReduceRocketBingo()
            self:JackpotEffect(mIndex, "jackpot", v.first_num, mIndex)
        end
    end
end

function GoldenTrainBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid, bingoCount, bingoPathId)
    local par = self.cardView:GetCardMap(mapindex)
    local centerCellIdx = self:GetBingoCenterCellIdx(bingoPathId)
    local centerCell = self.cardView:GetCardCell(mapindex, centerCellIdx)
    --local pos = par.transform.position
    local pos = centerCell.transform.position
    log.log("GoldenTrainBingoEffect:BingoEffect", mapindex, anima_name, cellIndex, cardid, bingoCount, bingoPathId, centerCellIdx)
    self:PlayBingoCellEffect(cardid, bingoPathId)
    ModelList.BattleModel:GetCurrBattleView():PlayBackgroundAction("change")
    BattleEffectCache:GetPrefabFromPoolOrCache(self:GetBingoPrefabName(), centerCell, function(eff1)
        if eff1 then
            private.PlayBingoAudio(bingoCount)
            eff1.gameObject:SetActive(false)
            --fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            log.log("GoldenTrainBingoEffect:BingoEffect set pos", pos.x, pos.y)
            eff1.gameObject:SetActive(true)
            fun.set_same_world_scale_with(eff1, par)
            local anima = fun.get_component(eff1, fun.ANIMATOR)
            if fun.is_not_null(anima) and anima_name then
                anima:Play(anima_name)
            end
            local cell_obj_pos = self.cardView:GetCardCell(mapindex, centerCellIdx)
            self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
            --self:SetBingoShow(currType, eff1)
            --self:ChangeSignCellColor(mapindex, currType)
            BattleEffectPool:DelayRecycle(self:GetBingoPrefabName(), eff1, 3)
            --Destroy(eff1, 3)

            LuaTimer:SetDelayFunction(bingoAnimTime + 0.5 , function()
                local defaultItem = ViewList.GoldenTrainBingoView:GetCardView():GetCard(cardid):GetDefaultItem()
                if defaultItem then
                    local ref = fun.get_component(defaultItem, fun.REFER)
                    local text_reward = ref:Get("text_reward")
                    if bingoCount == 1 then
                        local anima = ref:Get("anima")
                        anima:Play("bingo")
                        UISound.play("goldentrainchainbreak")
                        local reward = ModelList.BattleModel:GetCurrModel():GetCardBingoReward2(cardid, bingoCount)
                        text_reward.text = reward
                        ModelList.BattleModel:GetCurrModel():SetCurBingoReward(cardid, reward)
                        LuaTimer:SetDelayFunction(2.3,function()
                            ViewList.GoldenTrainBingoView:GetCardView():ShowShakeAnima(cardid)
                        end, nil, LuaTimer.TimerType.Battle)
                    else
                        UISound.play("goldentraincoins")
                        local anima = ref:Get("anima")
                        anima:Play("Textadd")
                        self:StartRollRewardNumV2(text_reward, cardid, bingoCount)
                        --text_reward.text = ModelList.BattleModel:GetCurrModel():GetCardBingoReward2(cardid, bingoCount)
                        LuaTimer:SetDelayFunction(1.3,function()
                            ViewList.GoldenTrainBingoView:GetCardView():ShowShakeAnima(cardid)
                        end, nil, LuaTimer.TimerType.Battle)
                    end
                end
            end, false, LuaTimer.TimerType.Battle)
        end
        --local animaName = self:GetBingoAnimaName(bingoCount)
        self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name, centerCellIdx)
    end, cardid)
end

--简单，可能有突变
function GoldenTrainBingoEffect:StartRollRewardNumV1(num, cardId, bingoCount)
    local from = ModelList.BattleModel:GetCurrModel():GetCardBingoReward2(cardId, bingoCount - 1)
    local to = ModelList.BattleModel:GetCurrModel():GetCardBingoReward2(cardId, bingoCount)
    Anim.do_smooth_int2(num, from, to, rollNumTime, DG.Tweening.Ease.Linear, nil, function ()
        num.text = to
    end)
end

--无突变，复杂
function GoldenTrainBingoEffect:StartRollRewardNumV2(num, cardId, bingoCount)
    local from = ModelList.BattleModel:GetCurrModel():GetCurBingoReward(cardId)
    local to = ModelList.BattleModel:GetCurrModel():GetCardBingoReward2(cardId, bingoCount)
    local rollAnim = Anim.do_smooth_int2_tween(num, from, to, rollNumTime, DG.Tweening.Ease.Linear,
        function (value)
            ModelList.BattleModel:GetCurrModel():SetCurBingoReward(cardId, value)
        end,
        function ()
            num.text = to
            ModelList.BattleModel:GetCurrModel():SetRollAnim(cardId)
        end
    )

    ModelList.BattleModel:GetCurrModel():SetRollAnim(cardId, rollAnim)
end

function GoldenTrainBingoEffect:RampageBingoEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromCache("GoldenTrainJackpot", par, function(eff1)
        if eff1 then
            private.PlayBingoAudio(4)
            fun.set_parent(eff1, par, true)
            eff1.gameObject:SetActive(false)
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            --fun.set_rect_offset_local_pos(eff1, 15)
            eff1.gameObject:SetActive(true)                                                                                                                                                                                                                                                                            
            local ref = fun.get_component(eff1, fun.REFER)
            local spine = ref:Get("spine")
            spine:SetAnimation("start", nil, false, 0)
            spine:AddAnimation("idle", nil, true, 0)
            self:ShowCoinFlyEffect(mapindex, par.transform.position)
        end
        self:ShowEffectOnSmallCard(eff1, mapindex, 2)
    end, cardid, 2)
end

function GoldenTrainBingoEffect:JackpotEffect(mapindex, anima_name, cellIndex, cardid)
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    local bingoEffectName = self:GetBingoPrefabName()
    local eff1 = GoPool.pop(bingoEffectName)
    if eff1 then
        UISound.play("jackpot_firework")
        UISound.play("goldentrainjackpot")
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
        self:ShowEffectOnSmallCard(eff1, mapindex, 0, anima_name, 13)
    end
end

function GoldenTrainBingoEffect:ShowEffectOnSmallCard(clone, cardId, effectType, anima_name, centerCellIdx)
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
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Bingo, cardId, newEffect, centerCellIdx)
    else
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Jackpot, cardId, newEffect)
    end
end

function GoldenTrainBingoEffect:GetBingoPrefabName()
    if ModelList.BattleModel.GetIsJokerMachine() then
        return "GoldenTrainBingobingo"
    end
    return "GoldenTrainBingobingo"
end

function GoldenTrainBingoEffect:GetBingoAnimaNameByPath(pathId)
    local animaName
    if pathId < 6 then ---
        animaName = "heng"
    elseif pathId < 11 then--丨
        animaName = "shu"
    elseif pathId == 11 then --丶
        animaName = "xiezuo"
    elseif pathId == 12 then --丿
        animaName = "xieyou"
    elseif pathId == 13 then --田
        animaName = "xiao"
    else
        animaName = "heng"
    end

    return animaName
end

local pathId2CellIdxMap = {11, 12, 13, 14, 15, 3, 8, 13, 18, 23, 13, 13, 13}
function GoldenTrainBingoEffect:GetBingoCenterCellIdx(pathId)
    local cellIdx = pathId2CellIdxMap[pathId] or 13
    return cellIdx
end

function GoldenTrainBingoEffect:PlayBingoCellEffect(cardId, pathId)
    local bingoRule = Csv.GetData("client_bingo_rule", 1, "content")
    local cellIdxList = bingoRule[pathId]
    for i, v in ipairs(cellIdxList) do
        if v ~= 13 then
            local curModel = ModelList.BattleModel:GetCurrModel()
            local curCell = curModel:GetRoundData(cardId, v)
            --local effect = ViewList.GoldenTrainBingoView:GetCardView():GetCellBgEffect(cardId, v)
            local effect = curCell.goldenTrainCoinEffect
            if effect then
                local anima = fun.get_component(effect, fun.ANIMATOR)
                if anima then
                    anima:Play("bingo")
                end
            end
        end
    end
end

-----------------------------------------------------------private-----------------------------------------------------------Begin
function private.PlayBingoAudio(bingoCount)
    UISound.play("bingo_firework")
    UISound.play("goldentrainbingo")
end
-----------------------------------------------------------private-----------------------------------------------------------End
return this