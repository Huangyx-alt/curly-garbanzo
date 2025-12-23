local  GoldenTrainCardEffect = Clazz(ClazzBase, "GoldenTrainCardEffect")
local this = GoldenTrainCardEffect
this.delayPlayCardEffect = {}  --延迟播放的卡牌特效
this.showLetterTipEffect = true
---@type GameCardView
this.cardView = nil
local supplement = require("View.Bingo.EffectModule.Card.CardEffectSupplement.CardEffectSupplement")
local battleType = 0
function GoldenTrainCardEffect:SetCardView(cardView)
    this.cardView = cardView
    this.delayPlayCardEffect = {}
    this.model = ModelList.BattleModel:GetCurrModel()
    this:InitForBattle()
    supplement:Init(cardView)
end

function GoldenTrainCardEffect:InitForBattle()
    local gameType = this.model:GetGameType()
    battleType = ModelList.BattleModel:GetGameType()
end

function GoldenTrainCardEffect:AddCardEffect(cardid, args)
    args = args or {}
    this.delayPlayCardEffect[cardid] = { ani = args.anima, play_name = args.game_type_name .. "Reward" .. args.rewardLen }
end

--播放卡牌页签奖励动画
function GoldenTrainCardEffect:PlayCardRewardEffect()
    for k, v in pairs(this.delayPlayCardEffect) do
        v.ani:Play(v.play_name)
    end
end

--播放卡牌页签奖励动画
function GoldenTrainCardEffect:PlayCardFoodBagEffect(index)
    for k, v in pairs(this.delayPlayCardEffect) do
        if k == index then
            v.ani:Play("show")
            break
        end
    end
end

local Letter_names = {"letter_b", "letter_i", "letter_n", "letter_g", "letter_o"}

--叫号展示卡牌字母特效
-- 2022-2-23配合特效修改：特效从animator 改成代码激活特效
function GoldenTrainCardEffect:ShowCardLetterTip(call_type)
    if not this.showLetterTipEffect then return end
    local openObjName = "letter_"..string.lower(call_type)
    for i = 1, #this.cardView:GetCardMap() do
        local refer =  fun.get_component(this.cardView:GetCardMap(i),fun.REFER)
        for m = 1, 5 do
            fun.set_active(refer:Get(Letter_names[m]), Letter_names[m] == openObjName)
        end
    end
end

function GoldenTrainCardEffect:CardEnterEffect(cb)
    local count = this.model:GetCardCount()
    if  this.cardView.parent.go  == nil then
        log.r("missing bingo root view")
    end
    local anim = this.cardView.parent.hangup_anima or fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
    Event.Brocast(EventName.ShowBingoleftView)
    Event.Brocast(EventName.CallNumber_View_Active)
    if anim then
        this.cardView:ActiveMaps(count,true)
        if ModelList.BattleModel:GetBattleSuperMatch() then
            Event.Brocast(EventName.Event_Active_Super_Match_Card)
        end
        anim.enabled = true
        anim:Play(count.."enter")
        UISound.play("card_goin")
        Event.Brocast(EventName.Enable_Jackpot_View)
    end

    --动画控制了卡牌位移，同时卡牌上下切换是代码做的效果。琨哥说哪个改动小就用哪个，故：播放完卡牌入场，就关掉animator
    LuaTimer:SetDelayFunction(2,function()
        --local anim = fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
        if anim then
            anim.enabled = false
        end
    end,nil,LuaTimer.TimerType.Battle)
    
    fun.SafeCall(cb)
end

function GoldenTrainCardEffect:CardExitEffect()
   if ModelList.BattleModel:GetCurrBattleView():IsAuto() then
        local count = this.model:GetCardCount()
        if  this.cardView.parent.go  == nil then
            log.r("missing bingo root view")
        end
        local anim = this.cardView.parent.hangup_anima or fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
        if anim then
            local isShowPageOne = BattleLogic.GetLogicModule("switch_logic"):IsShowPageOne()
            anim.enabled = true
            anim:Play(((isShowPageOne and {count} or {string.format("%s_%s",count,count - 8)})[1]) .."exit")
            --log.g("CardExitEffect")
        end
        LuaTimer:SetDelayFunction(MCT.settle_transition_view_card_exit,function()
            --local anim = fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
            if anim and not fun.is_null(anim) then     anim.enabled = false end
        end,nil,LuaTimer.TimerType.Battle)
   else
        local count = this.model:GetCardCount()
        if  this.cardView.parent.go  == nil then
            log.r("missing bingo root view")
        end
        local anim = this.cardView.parent.hangup_anima or fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
        if anim then
            local isShowPageOne = BattleLogic.GetLogicModule("switch_logic"):IsShowPageOne()
            anim.enabled = true
            local stateName = count .. "exit"
            if not anim:HasState(0, UnityEngine.Animator.StringToHash(stateName)) then
                stateName = ((isShowPageOne and { count } or { string.format("%s_%s", count, count - 8) })[1]) .. "exit"
            end
            anim:Play(stateName)
            --log.g("CardExitEffect")
        end
        LuaTimer:SetDelayFunction(MCT.settle_transition_view_card_exit,function()
            --local anim = fun.get_component(this.cardView.parent.go,fun.ANIMATOR)
            if anim then     anim.enabled = false end
        end,nil,LuaTimer.TimerType.Battle)
    end
end

function GoldenTrainCardEffect:OnDisable()
    this.delayPlayCardEffect = {}
    this.showLetterTipEffect = true
end

--触发bingo效果
function GoldenTrainCardEffect:TriggerBingo(cardid, cellIndexList)
    cardid = tonumber(cardid)
    this.cardView:HideCardReward(cardid)
    local cellIndexs = {} --cellIndexs = cellIndexList
    if not this.cardView:IsCardShowing(cardid) then
        for n = 1, #cellIndexs do
            this.model:RefreshRoundDataByIndex(cardid, cellIndexs[n], 2, false)
        end
        return
    end

    local delayTime = 0
    for i = 1, #cellIndexs do
        local p = cellIndexs[i]
        local cell = this.cardView:GetCardCell(cardid,p)
        this.cardView:SignCard(this.cardView:GetCardCell(cardid, p), 1, delayTime, p, cardid)
        if i == #cellIndexs then
            local effect = BattleModuleList.GetModule("EffectEntry"):GetCellChip(cardid, p, cell)
            local last_roll = {lastRollCell = effect, lastCardId = cardid, lastNumbers = cellIndexs, endTime = UnityEngine.Time.time + delayTime}
            table.insert(this.cardView.lastRollCell, last_roll)
            this.cardView.waitRollOver = true
        end
        delayTime = delayTime + 0.05
    end
    this:CardMapPickEffect(cardid, 2)
end

--触发Jackpot效果
function GoldenTrainCardEffect:TriggerJackpot(cardid, cellIndexList, jackpotIndexs)
    local cellIndexs = {} --cellIndexs = cellIndexList
    cardid = tonumber(cardid)
    this.cardView:HideCardReward(cardid)
    if not this.cardView:IsCardShowing(cardid) then
        for n = 1, #jackpotIndexs do
            this.model:RefreshRoundDataByIndex(cardid, jackpotIndexs[n], 3, false)
        end
        for n = 1, #cellIndexs do
            if not fun.is_include(cellIndexs[n], jackpotIndexs) then
                this.model:RefreshRoundDataByIndex(cardid, cellIndexs[n], 2, false)
            end
        end
        --Event.Brocast(EventName.CardEffect_Jackpot_Shine)
        return
    end

    local delayTime = 0
    for i = 1, #cellIndexs do
        local p = cellIndexs[i]
        local cell = this.cardView:GetCardCell(cardid,p)
        local sign_type = 1
        if this.cardView:IsInTable(p, jackpotIndexs) then
            sign_type = 2
        end
        this.cardView:SignCard(this.cardView:GetCardCell(cardid,p), sign_type, delayTime, p, cardid)
        if i == #cellIndexs then
            local ref_temp = fun.get_component(cell, fun.REFER)
            --local effect = ref_temp:Get("ef_Bingo_click")
            local effect = BattleModuleList.GetModule("EffectEntry"):GetCellChip(cardid,p,cell)
            local last_roll = { lastRollCell = effect, lastCardId = cardid, lastNumbers = cellIndexs, endTime = UnityEngine.Time.time + delayTime }
            table.insert(this.cardView.lastRollCell, last_roll)
            this.cardView.waitRollOver = true
        end
        delayTime = delayTime + 0.05
    end
    --this.cardView:CardMapPickEffect(cardid, 2)
    this:CardMapPickEffect(cardid, 2)
    --Event.Brocast(EventName.CardEffect_Jackpot_Shine)
end

---@see 战斗背景震屏效果
local BgShake = function(anim,animName)
    if anim then anim:Play(animName,-1,0) end
end

local MapPlayGiftShakeByBingo  = function(mapIndex)
    mapIndex = tonumber(mapIndex)
    local animaObj = fun.find_child( this.cardView:GetCardMap(mapIndex),"b_letter")
    local ani = fun.get_component(animaObj, fun.ANIMATOR)
    ani:Play("gift_bingo",-1,0)
end

---@see  触发bingo,其他卡牌震屏效果
local OtherCardShake = function(currMapIndex)
    for k,v in pairs(this.cardView:GetCardMap()) do
        if v:GetCardObj() ~= currMapIndex then
            if this.cardView:IsCardShowing(k) then
                MapPlayGiftShakeByBingo(k)
            end
        end
    end
end

---@see 点击后地图抖动效果
---@param effectType  --bingo点击2,有道具点击3,普通pick点击1
function GoldenTrainCardEffect:CardMapPickEffect(mapIndex, effectType)
    mapIndex = tonumber(mapIndex)
    local aniName = supplement:GetShakeName(effectType)
    local animaObj = fun.find_child( this.cardView:GetCardMap(mapIndex),"b_letter")
    local ani = fun.get_component(animaObj, fun.ANIMATOR)
    if fun.is_not_null(ani) then
        local cuc = ani:GetCurrentAnimatorStateInfo(0)
        local bgAnim = fun.get_component(this.cardView:GetParentView().Bg.gameObject,fun.ANIMATOR)
        if effectType == 2 then
            supplement:PlaylBingoShake(ani, aniName, mapIndex, bgAnim)
        elseif effectType == 3 and not cuc:IsName("bingo") then
            supplement:PlaylGiftShake(ani, aniName, mapIndex, bgAnim)
        elseif effectType == 1 and not cuc:IsName("bingo") and not cuc:IsName("gift") then
            ani:Play(aniName, -1, 0)
        end
    end
end

---@see powerup丢道具震屏效果
function GoldenTrainCardEffect: PlayPowerupAddGiftShake(mapIndex)
    mapIndex = tonumber(mapIndex)
    local animaObj = fun.find_child( this.cardView:GetCardMap(mapIndex),"b_letter")
    local ani = fun.get_component(animaObj, fun.ANIMATOR)
    if fun.is_not_null(ani) then
        local cuc = ani:GetCurrentAnimatorStateInfo(0)
        local cucNext = ani:GetNextAnimatorClipInfoCount(0)
        if (cuc:IsName("idle") and cucNext == 0 ) then
            ani:Play("powerup",-1,0)
        end
    end
end

---日榜在战斗开局的表现
function GoldenTrainCardEffect:PlayCompetitionBattleStartEffect(cb)
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local info = dependentFile:GetDenpendentInfo()
    
    if info then
            Cache.load_prefabs(AssetList[info.battleStartEffectName], info.battleStartEffectName, function(obj)
                if obj then
                    info.showStartEffect(obj, cb)
                end
            end)
        --end)
    else
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(7)
        fun.SafeCall(cb)
    end
end

---小丑卡在战斗开局的正式表现
function GoldenTrainCardEffect:PlayJokerCardEnterEffect(cb)
    local cardJoker = require("View.Bingo.EffectModule.CardJoker.CardJokerEnterEffect")
    local playId = ModelList.BattleModel:GetGameCityPlayID()
    local isOpen = Csv.GetData("game_joker_setting",playId,"open_state")
    if isOpen and cardJoker and cardJoker:HasJokerCard()  then
        cardJoker:PlayJokerCardEnterEffect(cb)
    else
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(8)
        fun.SafeCall(cb)
    end
end

--- 第一个小丑卡在战斗开局的表现
function GoldenTrainCardEffect:PlayFirstJokerCardEnterEffect(cb)
    local cardJoker = require("View.Bingo.EffectModule.CardJoker.CardJokerEnterEffect")
    local playId = ModelList.BattleModel:GetGameCityPlayID()
    local isOpen = Csv.GetData("game_joker_setting",playId,"open_state")
    if isOpen and cardJoker and cardJoker:HasJokerCard() then
        cardJoker:PlayFirstJokerCardEnterEffect(cb)
    else
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(8)
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(9)
        fun.SafeCall(cb)
    end
end

--- 第一个小丑卡在战斗开局的退出表现
function GoldenTrainCardEffect:PlayFirstJokerCardExitEffect()
    local cardJoker = require("View.Bingo.EffectModule.CardJoker.CardJokerEnterEffect")
    if cardJoker  then
        cardJoker:PlayFirstJokerCardExitEffect()
    end
end

function GoldenTrainCardEffect.Register()
    if not this.isRegister then
        this.isRegister = true
        Event.AddListener(EventName.CardEffect_Enter_Effect,this.CardEnterEffect)
        Event.AddListener(EventName.CardEffect_Exit_Effect,this.CardExitEffect)
        Event.AddListener(EventName.CardEffect_Reward_Effect,this.PlayCardRewardEffect)
        Event.AddListener(EventName.CardEffect_Food_Bag_Drop_Effect,this.PlayCardFoodBagEffect)
        Event.AddListener(EventName.CardEffect_Letter_Effect,this.ShowCardLetterTip)
        Event.AddListener(EventName.CardEffect_Add_Card_Effect,this.AddCardEffect)
        Event.AddListener(EventName.CardEffect_MapClick_Effect,this.CardMapPickEffect)
        Event.AddListener(EventName.CardEffect_Map_PowerUp_Shake,this.PlayPowerupAddGiftShake)
        Event.AddListener(EventName.Trigger_Bingo, this.TriggerBingo)
        Event.AddListener(EventName.Trigger_Jackpot, this.TriggerJackpot)
        Event.AddListener(EventName.Competition_battle_start_effect, this.PlayCompetitionBattleStartEffect)
        Event.AddListener(EventName.Enter_Play_Joker_Card, this.PlayJokerCardEnterEffect)
        Event.AddListener(EventName.Enter_Play_First_Joker_Card, this.PlayFirstJokerCardEnterEffect)
        Event.AddListener(EventName.Event_Joker_Hide_First_Joker, this.PlayFirstJokerCardExitEffect)
    end
end

function GoldenTrainCardEffect.UnRegister()
    this.isRegister = false
    Event.RemoveListener(EventName.CardEffect_Enter_Effect,this.CardEnterEffect)
    Event.RemoveListener(EventName.CardEffect_Exit_Effect,this.CardExitEffect)
    Event.RemoveListener(EventName.CardEffect_Reward_Effect,this.PlayCardRewardEffect)
    Event.RemoveListener(EventName.CardEffect_Food_Bag_Drop_Effect,this.PlayCardFoodBagEffect)
    Event.RemoveListener(EventName.CardEffect_Letter_Effect,this.ShowCardLetterTip)
    Event.RemoveListener(EventName.CardEffect_Add_Card_Effect,this.AddCardEffect)
    Event.RemoveListener(EventName.CardEffect_MapClick_Effect,this.CardMapPickEffect)
    Event.RemoveListener(EventName.CardEffect_Map_PowerUp_Shake,this.PlayPowerupAddGiftShake)
    Event.RemoveListener(EventName.Trigger_Bingo, this.TriggerBingo)
    Event.RemoveListener(EventName.Trigger_Jackpot, this.TriggerJackpot)
    Event.RemoveListener(EventName.Competition_battle_start_effect, this.PlayCompetitionBattleStartEffect)
    Event.RemoveListener(EventName.Enter_Play_Joker_Card, this.PlayJokerCardEnterEffect)
    Event.RemoveListener(EventName.Enter_Play_First_Joker_Card, this.PlayFirstJokerCardEnterEffect)
    Event.RemoveListener(EventName.Event_Joker_Hide_First_Joker, this.PlayFirstJokerCardExitEffect)
end

return this