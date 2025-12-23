local ballEffectItem = require("View/Bingo/SettleModule/ChildView/ChristmasSynthesisExtraBallEffectItem")
local ballItem = require("View/Bingo/SettleModule/ChildView/ChristmasSynthesisExtraBallItem")

local ChristmasSynthesisExtraBallView = BaseView:New('ChristmasSynthesisExtraBallView', 'ChristmasSynthesisExtraBallAtlas')

local this = ChristmasSynthesisExtraBallView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
this.auto_bind_ui_items = {
    "root",
    "btn_extraBall",
    "coin",
    "btn_end",
    "RewardText1",
    "RewardText2",
    "RewardText3",
    "RewardText4",
    "RewardText5",
    "RewardText6",
    "BallPrefab",
    "CardNode1",
    "CardNode2",
    "CardNode3",
    "CardNode4",
    "CardWishNode",
    "CollectPrefab",
    "ExtraBallAnima",
    "ExtraBallBall",
    "ExtraBallNumber1",
    "ExtraBallNumber2",
    "ExtraBallType",
    "BallsParent",
    "BallPos2",
    "BallPos3",
    "BallPos4",
    "BallPos5",
    "BallPos6",
    "BallPos7",
    "BallPos8",
    "BallPos9",
    "BallPos10",
    "BallPos11",
    "BallPos12",
    "BallPos13",
    "BallPos14",
    "BallPos15",
    "BallPos1",
    "btn_continue",
    "HitEffect",
    "wishFrame",
    "CardWishFrameNode",
    "glow",
    "BonusNode",
    "WildHitEffect",
    "WildBall",
    "CardWildNode",
    "GoldValueText",
    "TotalWinText",
    "NewNode",
}

local card_list = {}
local transitionAnimTime = 2
local bonusAnimTotalTime = 3
local hitTipAnim1 = 1   --普通号
local hitTipAnim2 = 2   --圣诞球
local hitTipAnim3 = 1   --奖励事件
local bonusDelayTime = 0.5
local bonusSonwBallDelay = 2
local bonusTipAndHitDelay = 1.6

function ChristmasSynthesisExtraBallView:Awake()
    self:on_init()
    fun.set_active(self.BonusNode, false)
    fun.set_active(self.WildBall, false)
    fun.set_active(self.NewNode, false)
    self.GoldValueText:SetKMB(true)
    self.TotalWinText:SetKMB(true)

    --- 清理金币飞行池,避免战斗金币回收问题,导致一直播放金币chips声音
    this.moduleList = require("View.Bingo.BattleModuleList")
    if this.moduleList then
        this.effContainer = this.moduleList.GetModule("EffectEntry") --效果模块，较为常用，单独设置一个直接引用
        if this.effContainer then
            this.effContainer:ClearCoinPool()
        end
        this.effContainer = nil
    end
    this.moduleList = nil
end

function ChristmasSynthesisExtraBallView:OnEnable()
    this.info = ModelList.ChristmasSynthesisModel:GetSmallGameData()
    this:ReadyForCurrentView()
    this:ShowRewardsInfo()
--    this:TryCalculateCardCollects()
    this:ShowCurrentRoundCost()
    this:RegisterEvent()
    this:OnTimeOut()
    ModelList.BattleModel:GetCurrBattleView():SetContainerForOtherView(self.go)
    UISound.stop_loop("chips")
    UISound.stop_loop("settlement_bgm")
    UISound.play_loop("ChristmasSynthesis")
    this:ClearAllJokerData()
    this.finishTranstion = false
    this.finishShowBonus = false
    this.isWildBallShowing = false
    this.hitCount = nil
    this.isWaitingEnd = false
    this:StartTransition()
    self:UpdateGoldValue(true)
    self:UpdateTotalWin(true)
    this.isOpenShop = false
end

function ChristmasSynthesisExtraBallView:GetCards()
    return ModelList.BattleModel:GetCurrModel():GetCards()
end

function ChristmasSynthesisExtraBallView:BuildFsm()
    FsmCreator:Create("ChristmasSynthesisExtraBallView", self, {
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankEnterState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankDaubState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankBingoState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankJackpotState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankPowerState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankEndState"),
        require("View.Bingo.SettleModule.State.ClimbRank.ClimbRankTeammateAwardState"),
    })
    self.state = {
        ClimbRankEnterState = "ClimbRankEnterState",
        ClimbRankBingoState = "ClimbRankBingoState",
        ClimbRankDaubState = "ClimbRankDaubState",
        ClimbRankJackpotState = "ClimbRankJackpotState",
        ClimbRankPowerState = "ClimbRankPowerState",
        ClimbRankEndState = "ClimbRankEndState",
        ClimbRankTeammateAwardState = "ClimbRankTeammateAwardState",
    }
    self._fsm:StartFsm(self.state.ClimbRankEnterState)
end

function ChristmasSynthesisExtraBallView:OnDisable()
    local eoc = ModelList.BattleModel:GetCurrBattleView():GetEffectObjContainer()
    if fun.is_not_null(eoc) and fun.is_not_null(ViewList.SettleRocketView) and fun.is_not_null(ViewList.SettleRocketView.go) then
        ModelList.BattleModel:GetCurrBattleView():SetContainerForOtherView(ViewList.SettleRocketView.go)
    end
    card_list = nil
    if this.changeIdleAnimaLoop then
        LuaTimer:Remove(this.changeIdleAnimaLoop)
        this.changeIdleAnimaLoop = nil
    end
    if this.autoEndWaitTimer then
        LuaTimer:Remove(this.autoEndWaitTimer)
        this.autoEndWaitTimer = nil
    end
    if this.CheckViewOpenTimer then
        LuaTimer:Remove(this.CheckViewOpenTimer)
        this.CheckViewOpenTimer = nil
    end
    this.HadSettle = nil
    this.reqExit = nil
    this:UnRegisterEvent()
    if this.collectEffectsCache then
        for i = 1, #this.collectEffectsCache do
            Destroy(this.collectEffectsCache[i])
        end
        this.collectEffectsCache = nil
    end
    if this.collectEffects then
        this.collectEffects = nil
    end
    if this.extraBallIndex then
        this.extraBallIndex = nil
    end
    if this.WaitSignTimer then
        LuaTimer:Remove(this.WaitSignTimer)
        this.WaitSignTimer = nil
    end
    if this.hitEffectsCache then
        this.hitEffectsCache = nil
    end

    UISound.stop_loop("ChristmasSynthesis")
    UISound.play_loop("settlement_bgm")
end

function ChristmasSynthesisExtraBallView:OnDestroy()
    local eoc = ModelList.BattleModel:GetCurrBattleView():GetEffectObjContainer()
    if fun.is_not_null(eoc) and fun.is_not_null(ViewList.SettleRocketView) and fun.is_not_null(ViewList.SettleRocketView.go) then
        ModelList.BattleModel:GetCurrBattleView():SetContainerForOtherView(ViewList.SettleRocketView.go)
    end

    self:Destroy()
    if this.changeIdleAnimaLoop then
        LuaTimer:Remove(this.changeIdleAnimaLoop)
        this.changeIdleAnimaLoop = nil
    end
    if this.autoEndWaitTimer then
        LuaTimer:Remove(this.autoEndWaitTimer)
        this.autoEndWaitTimer = nil
    end
    if this.CheckViewOpenTimer then
        LuaTimer:Remove(this.CheckViewOpenTimer)
        this.CheckViewOpenTimer = nil
    end
    this.HadSettle = nil
    this.reqExit = nil
    this:UnRegisterEvent()
    if this.collectEffects then
        this.collectEffects = nil
    end
    if this.extraBallIndex then
        this.extraBallIndex = nil
    end
    if this.WaitSignTimer then
        LuaTimer:Remove(this.WaitSignTimer)
        this.WaitSignTimer = nil
    end
    if this.hitEffectsCache then
        this.hitEffectsCache = nil
    end
end

function ChristmasSynthesisExtraBallView:GetNodeList()
    return { self.Node1, self.Node2, self.Node3, self.Node4 }
end

---当某个中奖组合仅剩余1个图案需要收集时，显示改图案所在位置
function ChristmasSynthesisExtraBallView:TryCalculateCardCollects()
    ---当当前卡牌入场动画播放完之后，切换到idle状态，再加载图案效果
    if this.root then
        local stateInfo = self.root:GetCurrentAnimatorStateInfo(0)
        if stateInfo and not stateInfo:IsName("idle") then
            LuaTimer:SetDelayFunction(0.2, function ()
                this:TryCalculateCardCollects()
            end)
            log.e("return TryCalculateCardCollects")
            return
        end
    else
        return
    end

    if not this.collectEffects then
        this.collectEffects = {} 
    end
    this.cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount()
    for i = 1, this.cardCount do
        ---获取仅剩1个需要收集时的座标列表
        local card_collects = ModelList.ChristmasSynthesisModel:GetWishCellInfoList(i)
        local curBingoType = ModelList.ChristmasSynthesisModel:GetCurrentBingoType(i)
        this:TryRemoveWishEffectByAreaChange(i, card_collects)
        log.log("ChristmasSynthesisExtraBallView:TryCalculateCardCollects wishInfo bingotype ", card_collects, curBingoType)
        if not this.collectEffects[i] then
            this.collectEffects[i] = {} 
        end

        local model = ModelList.ChristmasSynthesisModel
        if card_collects then
            local first = true
            local hasPlayingBigIdle = this:HasPlayingBigIdle(i)
            for k = 1, #card_collects do
                log.log("ChristmasSynthesisExtraBallView:TryCalculateCardCollects wishInfo ", card_collects[k])
                local wishCellIdx = card_collects[k].wishCellIndex
                if wishCellIdx and wishCellIdx > 0 and wishCellIdx < 26 then
                    if this:LossCollectEffects(i, wishCellIdx) then
                        
                        local collect = nil
                        local ballEffect = nil
                        ---先从this.collectEffectsCache中查找，如果找不到，则instinateate一个新的
                        if this.collectEffectsCache and #this.collectEffectsCache > 0 then
                            ballEffect = this.collectEffectsCache[1]
                            collect = ballEffect.go
                            table.remove(this.collectEffectsCache, 1)
                            fun.set_active(collect, true)
                        else
                            collect = fun.get_instance(this.CollectPrefab, this.CardWishNode)
                            ballEffect = ballEffectItem:New()
                            ballEffect:SkipLoadShow(collect, true, this)
                        end
                        table.insert(this.collectEffects[i], { effect = ballEffect, cellIndex = wishCellIdx })
                        local cell = model:GetRoundData(i, wishCellIdx)
                        local bigIdle = first and (not hasPlayingBigIdle)
                        local frame = this:CreateWishFrame(card_collects[k], ballEffect)
                        ballEffect:SetType(i, wishCellIdx, card_collects[k].weight, cell:GetNumber(), bigIdle, frame)
                        first = false
                        fun.set_same_position_with(collect, cell:GetCellObj())
                    end
                else
                    log.log("ChristmasSynthesisExtraBallView:TryCalculateCardCollects wishCellIndex ERROR ", wishCellIdx)
                end
            end
        end
    end
    if not this.changeIdleAnimaLoop then
        ---4秒换一个去变大
        this.changeIdleAnimaLoop = LuaTimer:SetDelayLoopFunction(4, 4, -1, function ()
            this:ChangeCollectSize()
        end)
    else
        --[[
        LuaTimer:Remove(this.changeIdleAnimaLoop)
        this.changeIdleAnimaLoop = LuaTimer:SetDelayLoopFunction(4, 4, -1, function ()
            this:ChangeCollectSize()
        end)
        --]]
    end
end

function ChristmasSynthesisExtraBallView:GetWishFrameAnimName(width, height)
    if width == height then
        return "ItemShow_" .. width .. "_"  .. width
    elseif width > height then
        return "ItemShow_" .. height .. "_"  .. width .. "heng"
    else
        return "ItemShow_" .. width .. "_"  .. height .. "shu"
    end
end

function ChristmasSynthesisExtraBallView:CreateWishFrame(wishInfo, wishCellItem)
    local frame = wishCellItem:GetFrameObj()
    if fun.is_null(frame) then
        frame = fun.get_instance(this.wishFrame, this.CardWishFrameNode)
    end

    local width = wishInfo.height
    local height = wishInfo.width
    local startCellIdx = wishInfo.cellIdxList[1]
    local endCellIdx = wishInfo.cellIdxList[wishInfo.weight]
    local eigenvalue = this:GenWishEigenvalue(wishInfo)

    --测试数据，
    --[[
    width, height, startCellIdx, endCellIdx = 3, 3, 1, 13
    --]]
    local model = ModelList.ChristmasSynthesisModel
    local startCell = model:GetRoundData(wishInfo.cardId, startCellIdx)
    local endCell = model:GetRoundData(wishInfo.cardId, endCellIdx)
    local pos1 = fun.get_gameobject_pos(startCell:GetCellObj(), false)
    local pos2 = fun.get_gameobject_pos(endCell:GetCellObj(), false)
    local x = (pos1.x + pos2.x) / 2
    local y = (pos1.y + pos2.y) / 2
    fun.set_gameobject_pos(frame, x, y, 0, false)

    if fun.is_not_null(card_list[1]) then
        local targetScale = fun.get_gameobject_scale(card_list[1], true)
        fun.set_gameobject_scale(frame, targetScale.x, targetScale.y, 1)
    end

    local animName = this:GetWishFrameAnimName(width, height)
    local anima = fun.get_component(frame, fun.ANIMATOR)
    local frameInfo = {}
    frameInfo.frameObj = frame
    frameInfo.anima = anima
    frameInfo.startCellIdx = startCellIdx
    frameInfo.endCellIdx = endCellIdx
    frameInfo.animName = animName
    frameInfo.eigenvalue = eigenvalue

    return frameInfo
end

function ChristmasSynthesisExtraBallView:GenWishEigenvalue(wishInfo)
    local width = wishInfo.height
    local height = wishInfo.width
    local startCellIdx = wishInfo.cellIdxList[1]
    local endCellIdx = wishInfo.cellIdxList[wishInfo.weight]
    --local eigenvalue = width * 65536 + height * 1024 + startCellIdx
    local eigenvalue = startCellIdx * 64 + endCellIdx
    return eigenvalue
end

--- 检查collectEffects是否已经有对应cardId和cellIndex的元素，如果没有则添加(这里可以不考虑eigenvalue)
function ChristmasSynthesisExtraBallView:LossCollectEffects(cardId, cellIndex)
    if this.collectEffects and this.collectEffects[cardId] then
        for i = 1, #this.collectEffects[cardId] do
            if this.collectEffects[cardId][i].cellIndex == cellIndex then
                return false
            end
        end
    end
    return true
end

---每4s切换一次格子大小特效
function ChristmasSynthesisExtraBallView:ChangeCollectSize()
    if this.collectEffects then
        for i = 1, #this.collectEffects do
            local effectCount = #this.collectEffects[i]
            local bigIdelIndex = nil

            if #this.collectEffects[i] > 1 then ---大于一个，才需要切换
                bigIdelIndex = 1
                for k = 1, #this.collectEffects[i] do
                    if this.collectEffects[i][k].effect:IsBigIdle() then
                        this.collectEffects[i][k].effect:PlayIdle(false)
                        --播放下一个
                        if k + 1 <= effectCount then
                            bigIdelIndex = k + 1
                        else
                            bigIdelIndex = 1
                        end
                    else
                        this.collectEffects[i][k].effect:PlayIdle(false)
                    end
                end
            elseif #this.collectEffects[i] == 1 then
                this.collectEffects[i][1].effect:PlayIdle(true)
            end
            if bigIdelIndex then
                this.collectEffects[i][bigIdelIndex].effect:PlayIdle(true)
            end
        end
    end
end

function ChristmasSynthesisExtraBallView:HasPlayingBigIdle(cardId)
    if this.collectEffects and this.collectEffects[cardId] then
        for i = 1, #this.collectEffects[cardId] do
            if this.collectEffects[cardId][i].effect:IsBigIdle() then
                return true
            end
        end
    end

    return false
end

---随机播放collectEffects里的动画
function ChristmasSynthesisExtraBallView:PlayAnima()
    if this.collectEffects then
        for i = 1, #this.collectEffects do
            if this.collectEffects[i] then
                for k = 1, #this.collectEffects[i] do

                end
            end
        end
    end
end

---切换卡牌的父物体，过度到另一个界面使用，期间卡牌不能被隐藏，
function ChristmasSynthesisExtraBallView:ReadyForCurrentView()
    local count = ModelList.ChristmasSynthesisModel:GetCardCount()
    if ModelList.BattleModel:GetCurrBattleView() then
        card_list = ModelList.BattleModel:GetCurrBattleView():GetCardMapsObject()
    end
    if card_list then
        for i = 1, #card_list do
            if not Util.IsNull(card_list[i]) and i <= count then
                fun.set_parent(card_list[i], this["CardNode" .. i], false)
                card_list[i].transform.localPosition = Vector3.zero
            end
        end
        BattleEffectCache.CardHideAllBindEffect()
        BattleEffectPool.CardHideAllBindEffect()
    end
end

---刷新奖励信息
function ChristmasSynthesisExtraBallView:ShowRewardsInfo()
    if this.info and this.info.bingoReward then
        for i = 1, #this.info.bingoReward do
            this["RewardText" .. i].text = "+" .. fun.NumInsertComma(this.info.bingoReward[i].reward)
        end
    end
end

function ChristmasSynthesisExtraBallView:on_x_update()
    self:CheckAnima()
end

function ChristmasSynthesisExtraBallView:Exit()
    ViewList.GameSettleView:OpenRound4()
end

local function GetExtraBallTpye(num)
    if num <= 15 then
        return "CallB", "b_ball_red"
    elseif num <= 30 then
        return "CallI", "b_ball_yellow"
    elseif num <= 45 then
        return "CallN", "b_ball_green"
    elseif num <= 60 then
        return "CallG", "b_ball_blue"
    else
        return "CallO", "b_ball_purple"
    end
end

--- 收到服务器返回,开始播放摇号
function ChristmasSynthesisExtraBallView:ShowExtraBall(index)
    this:UpdateGoldValue(false)
    local currIndex = 1
    if index then
        if not this.extraBallIndex then this.extraBallIndex = 1 end
        currIndex = index[#index]
        if this.reqExit or (not currIndex and this.HadSettle) then
            this:SetWaitState(false)
            this:on_btn_end_click()
            return
        end
        if currIndex > this.extraBallIndex then -- 前后端完成的叫号顺序不一致，做一次同步

        end
        this.extraBallIndex = currIndex + 1
    end

    if this.info and this.info.shakerBall and this.info.shakerBall[currIndex] then
        if this.info.shakerBall[currIndex].index == currIndex then
            local num = this.info.shakerBall[currIndex].number
            if num == 99 then
                this["ExtraBallBall"].sprite = AtlasManager:GetSpriteByName("ChristmasSynthesisExtraBallAtlas", "ScratchJSPerson2Big")
                fun.set_active(this["ExtraBallType"], false)
                fun.set_active(this["ExtraBallNumber1"], false)
                fun.set_active(this["ExtraBallNumber2"], false)
            else
                fun.set_active(this["ExtraBallType"], true)
                fun.set_active(this["ExtraBallNumber1"], true)
                if num <= 9 then
                    this["ExtraBallNumber1"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. num)
                    fun.set_rect_local_pos(this["ExtraBallNumber1"], 0, -14.1, 0)
                    fun.set_active(this["ExtraBallNumber2"], false)
                else
                    this["ExtraBallNumber1"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas",
                        "nub_" .. math.floor(num / 10))
                    this["ExtraBallNumber2"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", "nub_" .. math.fmod(num, 10))
                    fun.set_rect_local_pos(this["ExtraBallNumber1"], -21.3, -14.1, 0)
                    fun.set_rect_local_pos(this["ExtraBallNumber2"], 15.1, -14.1, 0)
                    fun.set_active(this["ExtraBallNumber2"], true)
                end
                local type, color = GetExtraBallTpye(num)
                this["ExtraBallBall"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", color)
                this["ExtraBallType"].sprite = AtlasManager:GetSpriteByName("BattleExtraAtlas", type)
            end
            this.smallBallIndex = currIndex
            log.r("ShowExtraBall " .. this.smallBallIndex)
            UISound.play("santablessingspin")
            AnimatorPlayHelper.Play(self.ExtraBallAnima, { "act", "ScratchJSBallact" }, false, function ()
                this:PlaySmallBallEnterAnima()
            end)
        end
    end

    this:ResetTimeOut()
end

--- 播放小球出现动画
function ChristmasSynthesisExtraBallView:PlaySmallBallEnterAnima()
    if this.smallBallIndex and this.smallBallIndex > 0 then
        local callNum = this.info.shakerBall[this.smallBallIndex].number
        local collect = fun.get_instance(this.BallPrefab, this.BallsParent)
        local ball = ballItem:New()
        ball:SkipLoadShow(collect, true, this)
        local isEffect = this:CheckTakeEffect(callNum)
        ball:SetType(callNum, isEffect)
        fun.set_same_position_with(collect, this["BallPos" .. this.smallBallIndex])
    end
    UISound.play("santablessingspinstop")
    this:ShowCurrentRoundCost()
    this:TrySignCard(this.info.shakerBall[this.smallBallIndex].number)
    --this:TryCalculateCardCollects()
    this:SetWaitState(false)
    this:CheckOver()
end

--- 根据叫号盖章
function ChristmasSynthesisExtraBallView:CheckTakeEffect(callNumber)
    for i = 1, this.cardCount do
        local data = ModelList.ChristmasSynthesisModel:GetRoundDataByNum(i, callNumber)
        if data and data.index > 0 then
            --local isSigned = ModelList.ChristmasSynthesisModel:GetRoundData(i, data.index).sign
            local isSigned = data.sign
            if isSigned == 0 then
                return true
            end
        end
    end

    return false
end

--- 根据叫号盖章
function ChristmasSynthesisExtraBallView:TrySignCard(callNumber)
    if callNumber == 99 then
        self:TrySignCardSpecial(callNumber)
    else
        self:TrySignCardNormal(callNumber)
    end
end

--- 根据叫号盖章
function ChristmasSynthesisExtraBallView:TrySignCardNormal(callNumber)
    --local view = ModelList.BattleModel:GetCurrBattleView().cardView
    this.hitCount = {}
    for i = 1, this.cardCount do
        local data = ModelList.ChristmasSynthesisModel:GetRoundDataByNum(i, callNumber)
        if data and data.index > 0 then
            local isSigned = ModelList.ChristmasSynthesisModel:GetRoundData(i, data.index).sign
            if isSigned == 0 then
                if not this:PlayHitEffect(i, data.index) then
                    this:LoadHitEffect(i, data.index, hitTipAnim1)
                end
                table.insert(this.hitCount, { cardId = i, cellIndex = data.index })
            end
        end
    end
    if #this.hitCount > 0 then
        this.WaitSignTimer = LuaTimer:SetDelayFunction(hitTipAnim1, function ()
            local view = ModelList.BattleModel:GetCurrBattleView().cardView
            if view then
                for i = 1, #this.hitCount do
                    if view then
                        view:ExtraBallClickCard(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                        this:TryRemoveWishEffectByHit(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                    end
                end
            end
            this:TryCalculateCardCollects()
            this.hitCount = nil
            LuaTimer:Remove(this.WaitSignTimer)
            this.WaitSignTimer = nil
            this:UpdateTotalWin(false)
        end)
    end
end

--- 圣诞球盖章
function ChristmasSynthesisExtraBallView:TrySignCardSpecial(callNumber)
    --this:TrySignCardSpecialV1(callNumber)
    this:TrySignCardSpecialV2(callNumber)
end

--- 圣诞球盖章
function ChristmasSynthesisExtraBallView:TrySignCardSpecialV1(callNumber)
    --local view = ModelList.BattleModel:GetCurrBattleView().cardView
    fun.set_active(self.WildBall, true)
    this.hitCount = {}
    local bonusEvent = this.info.shakerBall[this.smallBallIndex].bonusEvent
    if not bonusEvent or #bonusEvent < 1 then
        return
    end
    this:ShowAccompanyEffect()
    for i, v in ipairs(bonusEvent) do
        local index = ConvertServerPos(v.pos)
        local cell = ModelList.ChristmasSynthesisModel:GetRoundData(v.cardId, index)
        if cell and cell.index > 0 then
            local isSigned = cell.sign
            if isSigned == 0 then
                this:TryRemoveWishEffectByHit(v.cardId, index)
                this:PlayWildHitEffect(v.cardId, index, hitTipAnim2)
                table.insert(this.hitCount, { cardId = v.cardId, cellIndex = index })
            else
                log.log("ChristmasSynthesisExtraBallView:TrySignCardSpecial 格子被盖过章", v, index)
            end
        else
            log.log("ChristmasSynthesisExtraBallView:TrySignCardSpecial 找不到格子", v, index)
        end
    end

    LuaTimer:SetDelayFunction(hitTipAnim2, function ()
            this:HideAccompanyEffect()
        end
    )

    if #this.hitCount > 0 then
        this.WaitSignTimer = LuaTimer:SetDelayFunction(hitTipAnim2, function ()
            local view = ModelList.BattleModel:GetCurrBattleView().cardView
            if view then
                for i = 1, #this.hitCount do
                    if view then
                        view:ExtraBallClickCard(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                    end
                end
            end
            this:TryCalculateCardCollects()
            this.hitCount = nil
            LuaTimer:Remove(this.WaitSignTimer)
            this.WaitSignTimer = nil
            this:UpdateTotalWin(false)

            fun.set_active(self.WildBall, false)
        end)
    end
end

--- 圣诞球盖章
function ChristmasSynthesisExtraBallView:TrySignCardSpecialV2(callNumber)
    --local view = ModelList.BattleModel:GetCurrBattleView().cardView
    fun.set_active(self.WildBall, true)
    this.isWildBallShowing = true
    local bonusEvent = this.info.shakerBall[this.smallBallIndex].bonusEvent
    if not bonusEvent or #bonusEvent < 1 then
        return
    end
    this:ShowAccompanyEffect()
    UISound.play("santablessingmerge")

    LuaTimer:SetDelayFunction(bonusTipAndHitDelay, function()
        this:TrySignCardBonus(bonusEvent)
    end, false, LuaTimer.TimerType.Battle)

    LuaTimer:SetDelayFunction(bonusSonwBallDelay, function()
        this:ShowBonusSnowball(bonusEvent)
    end, false, LuaTimer.TimerType.Battle)

    LuaTimer:SetDelayFunction(bonusAnimTotalTime, function ()
            this:HideAccompanyEffect()
            this.isWildBallShowing = false
            fun.set_active(self.WildBall, false)
        end
    )
end

function ChristmasSynthesisExtraBallView:StartTransition()
    --[[
    LuaTimer:SetDelayFunction(transitionAnimTime, function()
        this:FinishTransition()
    end, false, LuaTimer.TimerType.Battle)
    --]]

    AnimatorPlayHelper.Play(self.root,{"enter", "ChristmasSynthesisExtraBallViewenter"}, false, function()
        this:FinishTransition()
    end)
end

function ChristmasSynthesisExtraBallView:FinishTransition()
    this.finishTranstion = true
    this:TryCalculateCardCollects()
    if this:HasBonus() then
        LuaTimer:SetDelayFunction(bonusDelayTime, function()
            this:StartShowBonus()
        end, false, LuaTimer.TimerType.Battle)
    else
        this:FinishShowBonus()
    end
end

function ChristmasSynthesisExtraBallView:HasBonus()
    local bonusEvent = this.info.bonusEvent
    if not bonusEvent then
        return false
    end

    if #bonusEvent < 1 then
        return false
    end

    return true
end

function ChristmasSynthesisExtraBallView:StartShowBonus()
    fun.set_active(self.BonusNode, true)
    self:ShowBonusEnterEffect()
    UISound.play("santablessingevent")
    LuaTimer:SetDelayFunction(bonusTipAndHitDelay, function()
        this:ShowBonusTipAndHit()
    end, false, LuaTimer.TimerType.Battle)

    LuaTimer:SetDelayFunction(bonusSonwBallDelay, function()
        this:ShowBonusSnowball(this.info.bonusEvent)
    end, false, LuaTimer.TimerType.Battle)

    LuaTimer:SetDelayFunction(bonusAnimTotalTime, function()
        this:FinishShowBonus()
    end, false, LuaTimer.TimerType.Battle)
end

function ChristmasSynthesisExtraBallView:ShowBonusEnterEffect()
    local ref = fun.get_component(self.BonusNode, fun.REFER)
    local bonusEffect = ref:Get("BonusEffect")
    fun.set_active(bonusEffect, true)
    local anima = fun.get_component(bonusEffect, fun.ANIMATOR)
    if fun.is_not_null(anima) then
        anima:Play("xueskill01")
    end
end

function ChristmasSynthesisExtraBallView:ShowBonusTipAndHit()
    this:TrySignCardBonus(this.info.bonusEvent)
end

function ChristmasSynthesisExtraBallView:ShowBonusSnowball(bonusEvent)
    --local bonusEvent = this.info.bonusEvent
    if not bonusEvent or #bonusEvent < 1 then
        return
    end
    local ref = fun.get_component(self.BonusNode, fun.REFER)
    for i, v in ipairs(bonusEvent) do
        local index = ConvertServerPos(v.pos)
        local snowball = fun.get_instance(ref:Get("snowball" .. v.cardId), self.BonusNode)
        local cell = ModelList.ChristmasSynthesisModel:GetRoundData(v.cardId, index)
        fun.set_same_position_with(snowball, cell:GetCellObj())
        fun.set_active(snowball, true)
        LuaTimer:SetDelayFunction(2, function()
            Destroy(snowball)
        end, false, LuaTimer.TimerType.Battle)
    end
end

function ChristmasSynthesisExtraBallView:FinishShowBonus()
    this.finishShowBonus = true
end

--- 额外奖励盖章
function ChristmasSynthesisExtraBallView:TrySignCardBonus(bonusEvent)
    --local view = ModelList.BattleModel:GetCurrBattleView().cardView
    this.hitCount = {}
    --local bonusEvent = this.info.bonusEvent
    if not bonusEvent or #bonusEvent < 1 then
        return
    end

    for i, v in ipairs(bonusEvent) do
        local index = ConvertServerPos(v.pos)
        local data = ModelList.ChristmasSynthesisModel:GetRoundData(v.cardId, index)
        if data and data.index > 0 then
            local isSigned = data.sign
            if isSigned == 0 then
                if not this:PlayHitEffect(v.cardId, index) then
                    this:LoadHitEffect(v.cardId, index, hitTipAnim3)
                end
                table.insert(this.hitCount, { cardId = v.cardId, cellIndex = index })
            end
        end
    end

    if #this.hitCount > 0 then
        this.WaitSignTimer = LuaTimer:SetDelayFunction(hitTipAnim3, function ()
            local view = ModelList.BattleModel:GetCurrBattleView().cardView
            if view then
                for i = 1, #this.hitCount do
                    if view then
                        view:ExtraBallClickCard(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                        this:TryRemoveWishEffectByHit(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                    end
                end
            end
            this:TryCalculateCardCollects()
            this.hitCount = nil
            LuaTimer:Remove(this.WaitSignTimer)
            this.WaitSignTimer = nil
            this:UpdateTotalWin(false)
        end)
    end
end

--- 加载命中特效
function ChristmasSynthesisExtraBallView:LoadHitEffect(cardId, cellIndex, delayDestroyTime)
    local hitEffectObj = nil
    ---先从this.hitEffectsCache中查找，如果找不到，则instinateate一个新的
    if this.hitEffectsCache and #this.hitEffectsCache > 0 then
        hitEffectObj = this.hitEffectsCache[1]
        table.remove(this.hitEffectsCache, 1)
    else
        hitEffectObj = fun.get_instance(this.HitEffect, this.CardWishNode)
    end
    local cell = ModelList.ChristmasSynthesisModel:GetRoundData(cardId, cellIndex)
    fun.set_same_position_with(hitEffectObj, cell:GetCellObj())
    fun.set_active(hitEffectObj, true)

    LuaTimer:SetDelayFunction(delayDestroyTime, function ()
        if this and this.hitEffectsCache and fun.is_not_null(hitEffectObj) then
            fun.set_active(hitEffectObj, false)
            table.insert(this.hitEffectsCache, hitEffectObj)
        end
    end)
end

--- 加载命中特效
function ChristmasSynthesisExtraBallView:PlayWildHitEffect(cardId, cellIndex, delayDestroyTime)
    local hitEffectObj = nil
    hitEffectObj = fun.get_instance(this.WildHitEffect, this.CardWildNode)
    local cell = ModelList.ChristmasSynthesisModel:GetRoundData(cardId, cellIndex)
    fun.set_same_position_with(hitEffectObj, cell:GetCellObj())
    fun.set_active(hitEffectObj, true)
    fun.set_same_world_scale_with(hitEffectObj, cell:GetCellObj())

    LuaTimer:SetDelayFunction(delayDestroyTime, function ()
        Destroy(hitEffectObj)
    end)
    UISound.play("santablessingmerge")
end

---检查是否是collectEffects里的,有则移除对应效果
function ChristmasSynthesisExtraBallView:PlayHitEffect(cardId, cellIndex)
    if this.collectEffects and this.collectEffects[cardId] then
        for i = 1, #this.collectEffects[cardId] do
            if this.collectEffects[cardId][i].cellIndex == cellIndex then
                if this.collectEffects[cardId][i].effect then
                    this.collectEffects[cardId][i].effect:PlayHit()
                    return true
                end
            end
        end
    end
    return false
end

function ChristmasSynthesisExtraBallView:ShowAccompanyEffect()
    fun.set_active(self.NewNode, true)
    local ref = fun.get_component(self.NewNode, fun.REFER)
    local bonusEffect = ref:Get("BonusEffect")
    fun.set_active(bonusEffect, true)
    local anima = fun.get_component(bonusEffect, fun.ANIMATOR)
    if fun.is_not_null(anima) then
        anima:Play("xueskill02")
    end
end

function ChristmasSynthesisExtraBallView:HideAccompanyEffect()
    fun.set_active(self.NewNode, false)
end

---被叫中则移除对应wish效果
function ChristmasSynthesisExtraBallView:TryRemoveWishEffectByHit(cardId, cellIndex)
    if this.collectEffects and this.collectEffects[cardId] then
        for i = #this.collectEffects[cardId], 1, -1 do
            if this.collectEffects[cardId][i].cellIndex == cellIndex then
                if this.collectEffects[cardId][i].effect then
                    this.collectEffects[cardId][i].effect:Abandon()
                end

                this:PushCollectEffects2Cache(this.collectEffects[cardId][i].effect)
                table.remove(this.collectEffects[cardId], i)
                return
            end
        end
    end
end

function ChristmasSynthesisExtraBallView:PushCollectEffects2Cache(effect)
    if not this.collectEffectsCache then
        this.collectEffectsCache = {}
    end

    table.insert(this.collectEffectsCache, effect)
end

---移除不再是或发生改变（成为了更大）的wish效果
function ChristmasSynthesisExtraBallView:TryRemoveWishEffectByAreaChange(cardId, wishInfoList)
    if this.collectEffects and this.collectEffects[cardId] then
        local eigenvalueList = {}
        for _, wishInfo in ipairs(wishInfoList) do
            eigenvalueList[wishInfo.wishCellIndex] = this:GenWishEigenvalue(wishInfo)
        end

        for i = #this.collectEffects[cardId], 1, -1 do
            local isUpgrade, isRemove = false, false
            local newEigenvalue = eigenvalueList[this.collectEffects[cardId][i].cellIndex]
            if newEigenvalue then
                if this.collectEffects[cardId][i].effect then
                    local oldEigenvalue = this.collectEffects[cardId][i].effect:GetEigenValue()
                    if oldEigenvalue ~= newEigenvalue then
                        isUpgrade = true
                    end
                end
            else
                isRemove = true
            end

            if isUpgrade or isRemove then
                if this.collectEffects[cardId][i].effect then
                    this.collectEffects[cardId][i].effect:Abandon()
                end
                this:PushCollectEffects2Cache(this.collectEffects[cardId][i].effect)
                table.remove(this.collectEffects[cardId], i)
            end
        end
    end
end

--- 展示当前回合的开销
function ChristmasSynthesisExtraBallView:ShowCurrentRoundCost()
    if not this.extraBallIndex then this.extraBallIndex = 1 end
    if this.info and this.info.shakerBall and this.info.shakerBall[this.extraBallIndex] then
        this.coin.text = fun.NumInsertComma(this.info.shakerBall[this.extraBallIndex].spendCoin)
    end
end

function ChristmasSynthesisExtraBallView:on_btn_extraBall_click()
    if not this.finishTranstion  then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，过场未完成")
        return
    end

    if not this.finishShowBonus then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，奖励事件未完成")
        return
    end

    if this.isWildBallShowing then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，isWildBallShowing")
        return
    end

    if this.isWaitingEnd then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，isWaitingEnd = true")
        return
    end

    ---正在播放命中效果,还未盖章
    if this:IsWaitSign() then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，IsWaitSign() = true")
        return
    end

    --设定2s一次
    if not this.clickTime then
        this.clickTime = 0 
    end

    if os.time() - this.clickTime < 2 then
        log.log("ChristmasSynthesisExtraBallView:on_btn_extraBall_click() 未响应，点击过于频繁")
        return 
    end

    this.clickTime = os.time()

    if this.HadSettle then
        --- 已经有结算数据，直接跳转结算界面
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.ChristmasSynthesisExtraBallView)
        --ViewList.ChristmasSynthesisExtraBallView = nil
        return
    end

    if not this.extraBallIndex then this.extraBallIndex = 1 end
    if this.info and this.info.shakerBall then
        if this.extraBallIndex > #this.info.shakerBall then
            this:SetWaitState(true)
            this.reqExit = true
            ModelList.ChristmasSynthesisModel:ReqExtraBall(-1)
        else
            ---检查金币是否足够
            if this.info.shakerBall[this.extraBallIndex].spendCoin > ModelList.ItemModel.get_coin() then
                Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable, 8008, Resource.coin,
                    this.info.shakerBall[this.extraBallIndex].spendCoin, 
                    function ()
                        this.isOpenShop = false
                    end,
                    function ()
                        this.isOpenShop = false
                    end,
                    function()
                        this.isOpenShop = true
                    end,
                SHOP_TYPE.SHOP_TYPE_CHIP)
                return
            end
            this:SetWaitState(true)
            ModelList.ChristmasSynthesisModel:ReqExtraBall(this.extraBallIndex)
        end
    end
end

function ChristmasSynthesisExtraBallView:on_btn_end_click()
    if not this.finishTranstion  then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，过场未完成")
        return
    end

    if not this.finishShowBonus then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，奖励事件未完成")
        return
    end

    if this.isWildBallShowing then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，isWildBallShowing")
        return
    end

    if this.isWaitingEnd then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，isWaitingEnd = true")
        return
    end

    ---正在播放命中效果,还未盖章
    if this:IsWaitSign() then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，IsWaitSign() = true")
        return
    end
    if not this:IsPlayingBingoEffect() then
        log.log("ChristmasSynthesisExtraBallView:on_btn_end_click() 未响应，还在播bingo effect")
        return 
    end
    if this.HadSettle then
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.ChristmasSynthesisExtraBallView)
        --ViewList.ChristmasSynthesisExtraBallView = nil
    else
        this.reqExit = true
        ModelList.ChristmasSynthesisModel:ReqExtraBall(-1)
    end
end

--- 进入等待摇奖结束的状态
function ChristmasSynthesisExtraBallView:SetWaitState(isWait)
    this.isWaitingEnd = isWait
    if isWait then
        ---设定超时5s就自动放开
        this.autoEndWaitTimer = LuaTimer:SetDelayFunction(5, function ()
            this:SetWaitState(false)
        end)
    else
        if this.autoEndWaitTimer then
            LuaTimer:Remove(this.autoEndWaitTimer)
            this.autoEndWaitTimer = nil
        end
    end
    Util.SetUIImageGray(self.btn_end, isWait)
    Util.SetUIImageGray(self.btn_extraBall, isWait)
end

--- 所有球摇完，展示继续按钮
function ChristmasSynthesisExtraBallView:CheckOver()
    if this.info and this.info.shakerBall and not this.info.shakerBall[this.extraBallIndex] then
        fun.set_active(this.btn_continue, true)
        fun.set_active(this.btn_end, false)
        fun.set_active(this.btn_extraBall, false)
    end
end

--- 检查是否等待数据时间过长
function ChristmasSynthesisExtraBallView:GetSettleData()
    this.HadSettle = true
end

---游戏不存在的处理
function ChristmasSynthesisExtraBallView:GameNotExist()
    if this.HadSettle then
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.ChristmasSynthesisExtraBallView)
        --ViewList.ChristmasSynthesisExtraBallView = nil
    else
        Facade.SendNotification(NotifyName.HideUI, ViewList.ChristmasSynthesisExtraBallView)
        Event.Brocast(Notes.QUIT_BATTLE)

        local loadingView = ViewList.SceneLoadingGameView
        LoadScene("SceneHome", loadingView, true)
        --UnityEngine.Resources.UnloadUnusedAssets()
    end
end

---游戏不存在的处理
function ChristmasSynthesisExtraBallView:OnCoinChange()
    if this.isOpenShop then
        this:UpdateGoldValue(false)
    end
end

function ChristmasSynthesisExtraBallView:RegisterEvent()
    Event.AddListener(EventName.Event_Receive_Game_Settle_Data, this.GetSettleData)
    Event.AddListener(EventName.Player_Bingo_Reduce_Bingoleft, this.ReduceBingoleftTick)
    Event.AddListener(EventName.Game_Not_Exist_Msg, this.GameNotExist)
    Event.AddListener(EventName.Event_coin_change, this.OnCoinChange)
end

---
function ChristmasSynthesisExtraBallView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Receive_Game_Settle_Data, this.GetSettleData)
    Event.RemoveListener(EventName.Player_Bingo_Reduce_Bingoleft, this.ReduceBingoleftTick)
    Event.RemoveListener(EventName.Game_Not_Exist_Msg, this.GameNotExist)
    Event.RemoveListener(EventName.Event_coin_change, this.OnCoinChange)
end

function ChristmasSynthesisExtraBallView:ReduceBingoleftTick(bingoData)
    local next = 0
    local bingoleftData = {
        gameId = 0,
        bingoLeft = 0,
        bingoChange = 0,
        cardId = 0,
        next = 0,
        bingoId = 0,
        robots = {},
        bingo =
            bingoData
    }
    local count = #bingoData
    bingoleftData.bingoLeft = count
    bingoleftData.bingoChange = count
    bingoleftData.next = next
    ModelList.ChristmasSynthesisModel:SaveBingoLeftInfo(bingoleftData)
    ModelList.ChristmasSynthesisModel:RefreshBingoInfo()
    --Facade.SendNotification(NotifyName.Bingo.Sync_Bingos)
end

--玩家在该界面停留5分钟没有进行操作时，弹出弹窗询问玩家是否继续小游戏
function ChristmasSynthesisExtraBallView:OnTimeOut()
    if this.extraBallIndex and this.extraBallIndex > 15 then return end
    this.CheckViewOpenTimer = LuaTimer:SetDelayFunction(300, function ()
        UIUtil.show_common_error_popup(85018, false, function ()

        end)
    end)
end

---每次摇奖后，重置时间
function ChristmasSynthesisExtraBallView:ResetTimeOut()
    if this.CheckViewOpenTimer then
        LuaTimer:Remove(this.CheckViewOpenTimer)
        this.CheckViewOpenTimer = nil
    end
    this:OnTimeOut()
end

function ChristmasSynthesisExtraBallView:on_btn_continue_click()
    if this.isWildBallShowing then
        log.log("ChristmasSynthesisExtraBallView:on_btn_continue_click() 未响应，isWildBallShowing")
        return
    end

    if this:IsWaitSign() then 
        log.log("ChristmasSynthesisExtraBallView:on_btn_continue_click() 未响应，IsWaitSign = true")
        return 
    end
    if not this:IsPlayingBingoEffect() then 
        log.log("ChristmasSynthesisExtraBallView:on_btn_continue_click() 未响应，还在播bingo effect")
        return 
    end
    ViewList.GameSettleView:JumpNextView()
    Facade.SendNotification(NotifyName.HideUI, ViewList.ChristmasSynthesisExtraBallView)
    --ViewList.ChristmasSynthesisExtraBallView = nil
end

---是否正在等待盖章
function ChristmasSynthesisExtraBallView:IsWaitSign()
    --return ((this.hitCount and #this.hitCount > 0) or this.WaitSignTimer) and true or false
    if this.hitCount and #this.hitCount > 0 then
        log.log("ChristmasSynthesisExtraBallView:IsWaitSign true 1 ", this.hitCount)
        return true
    end

    if this.WaitSignTimer then
        log.log("ChristmasSynthesisExtraBallView:IsWaitSign true 2 ")
        return true
    end

    return false
end

---是否正在等待盖章
function ChristmasSynthesisExtraBallView:IsPlayingBingoEffect()
    return BattleTool.CheckEffectPlayOver()
end

---进度增长的时候,播放单独音效,设定播放有1.5s间隔
function ChristmasSynthesisExtraBallView:OnProgressGrowAudio()
    if not this.PlayProgressAudioTime or os.time() - this.PlayProgressAudioTime > 1.5 then
        UISound.play("scratchwinneradd")
        this.PlayProgressAudioTime = os.time()
    end
end

--- 回放时候,开始播放摇号
function ChristmasSynthesisExtraBallView:ReplayShowExtraBall()
    local index = {}
    for i = 1, this.extraBallIndex do
        table.insert(index, i)
    end
    this:ShowExtraBall(index)
end

---清理数据里的小丑相关
function ChristmasSynthesisExtraBallView:ClearAllJokerData()
    this.cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount()
    if this.cardCount then
        for i = 1, this.cardCount do
            for j = 1, 25 do
                local cell = ModelList.ChristmasSynthesisModel:GetRoundData(i, j)
                log.r("ClearAllJokerData  "..i.."    "..j)
                if cell and cell.jokerChange then
                    cell.jokerChange = {}
                    log.r("ClearAllJokerData succes  "..i.."    "..j)
                    --cell:ClearJokerChange()
                end
            end
        end
    end
end

function ChristmasSynthesisExtraBallView:UpdateGoldValue(isInit)
    local num = ModelList.ItemModel.get_coin()
    if isInit then
        self.GoldValueText:SetValue(num)
    else
        self.GoldValueText:SetValue(num)
        --self.GoldValueText:RollByTime(num, 1, function() end)
    end
end


function ChristmasSynthesisExtraBallView:UpdateTotalWin(isInit)
    local num = self:CalculateTotalWin()
    if isInit then
        self.TotalWinText:SetValue(num)
    else
        self.TotalWinText:SetValue(num)
        --self.TotalWinText:RollByTime(num, 1, function() end)
    end
end

function ChristmasSynthesisExtraBallView:CalculateTotalWin()
    local sum = 0
    for i = 1, this.cardCount do
        local currentBingoType = 0
        local curBingoInfo = ModelList.ChristmasSynthesisModel:GetCurrentBingoType(i)
        if curBingoInfo and curBingoInfo.weight then
            currentBingoType = ModelList.ChristmasSynthesisModel:Area2BingoIdx(curBingoInfo.weight)
            local x1, x2 = ModelList.ChristmasSynthesisModel:GetBingoReward(currentBingoType, false)
            sum = sum + x2
        end

    end

    return sum
end

return this