local ballEffectItem = require("View.Bingo.SettleModule.UIView.SmallGame.Normal.SGExtraBallEffect")
local ballItem = require("View.Bingo.SettleModule.UIView.SmallGame.Normal.SGExtraBallItem")

local SGExtraBallMainView = BaseView:New('SGExtraBallMainView', 'SGExtraBallMainAtlas');

local this = SGExtraBallMainView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
this.auto_bind_ui_items = {
    "root",
    "btn_extraBall",
    "coin",
    "btn_end",
    "RewardText1",
    "RewardText2",
    "RewardText5",
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
    "jGeZi",
    "jGeZi2",
    "dish",
}

local card_list = {}

function SGExtraBallMainView:Awake()
    self:on_init()

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

function SGExtraBallMainView:OnEnable()
    this.info = ModelList.GameModel:GetSmallGameData()
    this.oriTotalWin = this.info.totalWin or 0
    this.totalWin = nil
    this:ReadyForCurrentView()
    this:ShowCoins()
    this:TryCalculateCardCollects()
    this:ShowCurrentRoundCost()
    this:RegisterEvent()
    this:OnTimeOut()
    this:SetJackpotInfo()
    ModelList.BattleModel:GetCurrBattleView():SetContainerForOtherView(self.go)
    UISound.stop_loop("chips")
    UISound.stop_loop("settlement_bgm")
    UISound.play_loop("extraball")
    this:ClearAllJokerData()

    this.hitCount = nil
    this.isWaitingEnd = false
end

function SGExtraBallMainView:GetCards()
    return ModelList.BattleModel:GetCurrModel():GetCards()
end

function SGExtraBallMainView:OnDisable()
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

    UISound.stop_loop("extraball")
    UISound.play_loop("settlement_bgm")
end

function SGExtraBallMainView:OnDestroy()
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

function SGExtraBallMainView:GetNodeList()
    return { self.Node1, self.Node2, self.Node3, self.Node4 }
end

---当某个中奖组合仅剩余1个图案需要收集时，显示改图案所在位置
function SGExtraBallMainView:TryCalculateCardCollects()
    ---当当前卡牌入场动画播放完之后，切换到idle状态，再加载图案效果
    --if this.root then
    --    local stateInfo = self.root:GetCurrentAnimatorStateInfo(0)
    --    if stateInfo and not stateInfo:IsName("idle") then
    --        LuaTimer:SetDelayFunction(0.2, function ()
    --            this:TryCalculateCardCollects()
    --        end)
    --        log.e("return TryCalculateCardCollects")
    --        return
    --    end
    --else
    --    return
    --end
    --
    --if not this.collectEffects then this.collectEffects = {} end
    --this.cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount()
    --for i = 1, this.cardCount do
    --    ---获取仅剩1个需要收集时的座标列表
    --    local card_collects = ModelList.ScratchWinnerModel:GetWishCellIdxList(i)
    --    if not this.collectEffects[i] then this.collectEffects[i] = {} end
    --    local model = ModelList.ScratchWinnerModel
    --    if card_collects then
    --        local first = true
    --        for k = 1, #card_collects do
    --            --log.e("GetWishCellIdxList  cardId == " .. i .. "  index  " .. card_collects[k])
    --            if card_collects[k] ~= 0 and this:LossCollectEffects(i, card_collects[k]) then
    --                local collect = nil
    --                local ballEffect = nil
    --                ---先从this.collectEffectsCache中查找，如果找不到，则instinateate一个新的
    --                if this.collectEffectsCache and #this.collectEffectsCache > 0 then
    --                    ballEffect = this.collectEffectsCache[1]
    --                    collect = ballEffect.go
    --                    table.remove(this.collectEffectsCache, 1)
    --                    fun.set_active(collect, true)
    --                else
    --                    collect = fun.get_instance(this.CollectPrefab, this.CardWishNode)
    --                    ballEffect = ballEffectItem:New()
    --                    ballEffect:SkipLoadShow(collect, true, this)
    --                end
    --                table.insert(this.collectEffects[i], { effect = ballEffect, cellIndex = card_collects[k] })
    --                local cell = model:GetRoundData(i, card_collects[k])
    --                ballEffect:SetType(i, card_collects[k], k, cell:GetNumber(), first)
    --                first = false
    --                fun.set_same_position_with(collect, cell:GetCellObj())
    --            end
    --        end
    --    end
    --end
    --if not this.changeIdleAnimaLoop then
    --    ---4秒换一个去变大
    --    this.changeIdleAnimaLoop = LuaTimer:SetDelayLoopFunction(4, 4, -1, function ()
    --        this:ChangeCollectSize()
    --    end)
    --else
    --    LuaTimer:Remove(this.changeIdleAnimaLoop)
    --    this.changeIdleAnimaLoop = LuaTimer:SetDelayLoopFunction(4, 4, -1, function ()
    --        this:ChangeCollectSize()
    --    end)
    --end
end

--- 检查collectEffects是否已经有对应cardId和cellIndex的元素，如果没有则添加
function SGExtraBallMainView:LossCollectEffects(cardId, cellIndex)
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
function SGExtraBallMainView:ChangeCollectSize()
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

---随机播放collectEffects里的动画
function SGExtraBallMainView:PlayAnima()
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
function SGExtraBallMainView:ReadyForCurrentView()
    local count = ModelList.GameModel:GetCardCount()
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
function SGExtraBallMainView:ShowCoins()
    --this["RewardText1"].text = fun.NumInsertComma(ModelList.ItemModel.get_coin())
    this["RewardText2"].text = fun.NumInsertComma(this.totalWin or (this.oriTotalWin or 0))
end

function SGExtraBallMainView:on_x_update()
    self:CheckAnima()
end

function SGExtraBallMainView:Exit()
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
function SGExtraBallMainView:ShowExtraBall(index)
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
            this.totalWin = this.info.shakerBall[currIndex].totalWin
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
            this.smallBallIndex = currIndex
            log.r("ShowExtraBall " .. this.smallBallIndex)
            UISound.play("extraballspin")
            AnimatorPlayHelper.Play(self.ExtraBallAnima, { "act", "ScratchJSBallact" }, false, function ()
                this:PlaySmallBallEnterAnima()
            end)
        end
    end

    this:ResetTimeOut()
end

--- 播放小球出现动画
function SGExtraBallMainView:PlaySmallBallEnterAnima()
    if this.smallBallIndex and this.smallBallIndex > 0 then
        local collect = fun.get_instance(this.BallPrefab, this.BallsParent)
        local ball = ballItem:New()
        ball:SkipLoadShow(collect, true, this)
        ball:SetType(this.info.shakerBall[this.smallBallIndex].number)
        local isEffect = this:CheckTakeEffect(this.info.shakerBall[this.smallBallIndex].number)
        ball:SetNumEffect(isEffect)
        fun.set_same_position_with(collect, this["BallPos" .. this.smallBallIndex])
    end
    UISound.play("extraballspinstop")
    this:ShowCurrentRoundCost()
    this:TrySignCard(this.info.shakerBall[this.smallBallIndex].number)
    this:TryCalculateCardCollects()
    this:SetWaitState(false)
    this:CheckOver()
end

--- 根据叫号盖章
function SGExtraBallMainView:CheckTakeEffect(callNumber)
    for i = 1, this.cardCount do
        local data = ModelList.GameModel:GetRoundDataByNum(i, callNumber)
        if data and data.index > 0 then
            --local isSigned = ModelList.GameModel:GetRoundData(i, data.index).sign
            local isSigned = data.sign
            if isSigned == 0 then
                return true
            end
        end
    end

    return false
end

--- 根据叫号盖章
function SGExtraBallMainView:TrySignCard(callNumber)
    --local view = ModelList.BattleModel:GetCurrBattleView().cardView
    this.hitCount = {}
    for i = 1, this.cardCount do
        local data = ModelList.GameModel:GetRoundDataByNum(i, callNumber)
        if data and data.index > 0 then
            local isSigned = ModelList.GameModel:GetRoundData(i, data.index).sign
            if isSigned == 0 then
                if not this:PlayHitEffect(i, data.index) then
                    this:LoadHitEffect(i, data.index)
                end
                table.insert(this.hitCount, { cardId = i, cellIndex = data.index })
            end
        end
    end
    if #this.hitCount > 0 then
        this.WaitSignTimer = LuaTimer:SetDelayFunction(1.5, function ()
            local view = ModelList.BattleModel:GetCurrBattleView().cardView
            if view then
                for i = 1, #this.hitCount do
                    if view then
                        view:ExtraBallClickCard(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                        --this:CheckCollectsCellEffect(this.hitCount[i].cardId, this.hitCount[i].cellIndex)
                    end
                end
            end
            this:TryCalculateCardCollects()
            this.hitCount = nil
            LuaTimer:Remove(this.WaitSignTimer)
            this.WaitSignTimer = nil
        end)
    end
end

--- 加载命中特效
function SGExtraBallMainView:LoadHitEffect(cardId, cellIndex)
    local hitEffectObj = nil
    ---先从this.hitEffectsCache中查找，如果找不到，则instinateate一个新的
    if this.hitEffectsCache and #this.hitEffectsCache > 0 then
        hitEffectObj = this.hitEffectsCache[1]
        table.remove(this.hitEffectsCache, 1)
    else
        hitEffectObj = fun.get_instance(this.HitEffect, this.CardWishNode)
    end
    local cell = ModelList.GameModel:GetRoundData(cardId, cellIndex)
    fun.set_same_position_with(hitEffectObj, cell:GetCellObj())
    fun.set_active(hitEffectObj, true)

    LuaTimer:SetDelayFunction(1.5, function ()
        if this and this.hitEffectsCache and fun.is_not_null(hitEffectObj) then
            fun.set_active(hitEffectObj, false)
            table.insert(this.hitEffectsCache, hitEffectObj)
        end
    end)
end

---检查是否是collectEffects里的,有则移除对应效果
function SGExtraBallMainView:PlayHitEffect(cardId, cellIndex)
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

---检查是否是collectEffects里的,有则移除对应效果
function SGExtraBallMainView:CheckCollectsCellEffect(cardId, cellIndex)
    if this.collectEffects and this.collectEffects[cardId] then
        for i = 1, #this.collectEffects[cardId] do
            if this.collectEffects[cardId][i].cellIndex == cellIndex then
                if this.collectEffects[cardId][i].effect then
                    this.collectEffects[cardId][i].effect:SetActive(false)
                end
                if not this.collectEffectsCache then this.collectEffectsCache = {} end
                table.insert(this.collectEffectsCache, this.collectEffects[cardId][i].effect)
                table.remove(this.collectEffects[cardId], i)
                return
            end
        end
    end
end

--- 展示当前回合的开销
function SGExtraBallMainView:ShowCurrentRoundCost()
    if not this.extraBallIndex then this.extraBallIndex = 1 end
    if this.info and this.info.shakerBall and this.info.shakerBall[this.extraBallIndex] then
        this.coin.text = fun.NumInsertComma(this.info.shakerBall[this.extraBallIndex].spendCoin)
    end
end

function SGExtraBallMainView:on_btn_extraBall_click()
    if this.isWaitingEnd then return end
    ---正在播放命中效果,还未盖章
    if this:IsWaitSign() then return end

    --设定2s一次
    if not this.clickTime then this.clickTime = 0 end
    if os.time() - this.clickTime < 2 then return end
    this.clickTime = os.time()

    if this.HadSettle then
        --- 已经有结算数据，直接跳转结算界面
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.SGExtraBallMainView)
        --ViewList.SGExtraBallMainView = nil
        return
    end


    if not this.extraBallIndex then this.extraBallIndex = 1 end
    if this.info and this.info.shakerBall then
        if this.extraBallIndex > #this.info.shakerBall then
            this:SetWaitState(true)
            this.reqExit = true
            ModelList.GameModel:ReqExtraBall(-1)
        else
            ---检查金币是否足够
            if this.info.shakerBall[this.extraBallIndex].spendCoin > ModelList.ItemModel.get_coin() then
                Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable, 8008, Resource.coin,
                    this.info.shakerBall[this.extraBallIndex].spendCoin, function ()

                    end, function ()

                    end, nil, SHOP_TYPE.SHOP_TYPE_CHIP)
                return
            end
            this:SetWaitState(true)
            ModelList.GameModel:ReqExtraBall(this.extraBallIndex)
        end
    end
end

function SGExtraBallMainView:on_btn_end_click()
    if this.isWaitingEnd then return end
    if this:IsWaitSign() then return end
    if not this:IsPlayingBingoEffect() then return end
    if this.HadSettle then
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.SGExtraBallMainView)
        --ViewList.SGExtraBallMainView = nil
    else
        this.reqExit = true
        ModelList.GameModel:ReqExtraBall(-1)
    end
end

--- 进入等待摇奖结束的状态
function SGExtraBallMainView:SetWaitState(isWait)
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
        this:ShowCoins()
    end
    Util.SetUIImageGray(self.btn_end, isWait)
    Util.SetUIImageGray(self.btn_extraBall, isWait)
end

--- 所有球摇完，展示继续按钮
function SGExtraBallMainView:CheckOver()
    if this.info and this.info.shakerBall and not this.info.shakerBall[this.extraBallIndex] then
        fun.set_active(this.btn_continue, true)
        fun.set_active(this.btn_end, false)
        fun.set_active(this.btn_extraBall, false)
    end
end

--- 检查是否等待数据时间过长
function SGExtraBallMainView:GetSettleData()
    this.HadSettle = true
end

---游戏不存在的处理
function SGExtraBallMainView:GameNotExist()
    if this.HadSettle then
        ViewList.GameSettleView:JumpNextView()
        Facade.SendNotification(NotifyName.HideUI, ViewList.SGExtraBallMainView)
        --ViewList.SGExtraBallMainView = nil
    else
        Facade.SendNotification(NotifyName.HideUI, ViewList.SGExtraBallMainView)
        Event.Brocast(Notes.QUIT_BATTLE)

        local loadingView = ViewList.SceneLoadingGameView
        LoadScene("SceneHome", loadingView, true)
        --UnityEngine.Resources.UnloadUnusedAssets()
    end
end

function SGExtraBallMainView:RegisterEvent()
    Event.AddListener(EventName.Event_Receive_Real_Game_Settle_Data, this.GetSettleData)
    Event.AddListener(EventName.Player_Bingo_Reduce_Bingoleft, this.ReduceBingoleftTick)
    Event.AddListener(EventName.Game_Not_Exist_Msg, this.GameNotExist)
end

---
function SGExtraBallMainView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Receive_Real_Game_Settle_Data, this.GetSettleData)
    Event.RemoveListener(EventName.Player_Bingo_Reduce_Bingoleft, this.ReduceBingoleftTick)
    Event.RemoveListener(EventName.Game_Not_Exist_Msg, this.GameNotExist)
end

function SGExtraBallMainView:ReduceBingoleftTick(bingoData)
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
    ModelList.GameModel:SaveBingoLeftInfo(bingoleftData)
    ModelList.GameModel:RefreshBingoInfo()
    --Facade.SendNotification(NotifyName.Bingo.Sync_Bingos)
end

--玩家在该界面停留5分钟没有进行操作时，弹出弹窗询问玩家是否继续小游戏
function SGExtraBallMainView:OnTimeOut()
    if this.extraBallIndex and this.extraBallIndex > 15 then return end
    this.CheckViewOpenTimer = LuaTimer:SetDelayFunction(300, function ()
        UIUtil.show_common_error_popup(85018, false, function ()

        end)
    end)
end

---每次摇奖后，重置时间
function SGExtraBallMainView:ResetTimeOut()
    if this.CheckViewOpenTimer then
        LuaTimer:Remove(this.CheckViewOpenTimer)
        this.CheckViewOpenTimer = nil
    end
    this:OnTimeOut()
end

function SGExtraBallMainView:on_btn_continue_click()
    if this:IsWaitSign() then return end
    if not this:IsPlayingBingoEffect() then return end
    ViewList.GameSettleView:JumpNextView()
    Facade.SendNotification(NotifyName.HideUI, ViewList.SGExtraBallMainView)
    --ViewList.SGExtraBallMainView = nil
end

---是否正在等待盖章
function SGExtraBallMainView:IsWaitSign()
    return ((this.hitCount and #this.hitCount > 0) or this.WaitSignTimer) and true or false
end

---是否正在等待盖章
function SGExtraBallMainView:IsPlayingBingoEffect()
    return BattleTool.CheckEffectPlayOver()
end

---进度增长的时候,播放单独音效,设定播放有1.5s间隔
function SGExtraBallMainView:OnProgressGrowAudio()
    if not this.PlayProgressAudioTime or os.time() - this.PlayProgressAudioTime > 1.5 then
        UISound.play("scratchwinneradd")
        this.PlayProgressAudioTime = os.time()
    end
end

--- 回放时候,开始播放摇号
function SGExtraBallMainView:ReplayShowExtraBall()
    local index = {}
    for i = 1, this.extraBallIndex do
        table.insert(index, i)
    end
    this:ShowExtraBall(index)
end

---清理数据里的小丑相关
function SGExtraBallMainView:ClearAllJokerData()
    this.cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount()
    --
    CalculateBingoMachine:CancelAllBingoCell()
    if this.cardCount then
        for i = 1, this.cardCount do
            for j = 1, 25 do
                local cell = ModelList.GameModel:GetRoundData(i, j)
                --log.r("ClearAllJokerData  " .. i .. "    " .. j)
                if cell and cell.ReadySGame then
                    cell:ReadySGame()
                end
            end
        end
    end
end

function SGExtraBallMainView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
    if reward then
        --单卡价格
        local playCardCost = ModelList.CityModel:GetCostCoin(1)
        local BingoReward = Csv.GetBingoRewardOfPlayid(playId, 1)     -- 只取单bingo
        BingoReward = BingoReward / 100 or 0
        local rewardValue = BingoReward * reward * playCardCost / 100 --做分层
        this["RewardText5"].text = fun.NumInsertComma(rewardValue)
        this["RewardText1"].text = fun.NumInsertComma(rewardValue / 4)
    end
    local jackpotId = this.info.jackpotRuleId
    if not jackpotId or jackpotId == 0 then
        jackpotId = Csv.GetData("city_play", ModelList.CityModel.GetPlayIdByCity(), "jackpot_rule_id")
    end
    local jackpotData = nil
    if jackpotId then
        jackpotData = Csv.GetData("jackpot", jackpotId, "coordinate")
    end
    if jackpotData and fun.is_not_null(self.jGeZi) then
        local img1 = self.jGeZi.sprite
        local img2 = self.jGeZi2.sprite
        local img_list = {}
        for i = 1, 25 do
            local tran = fun.get_child(self.dish, i - 1)
            local img = nil
            if tran then
                img = fun.get_component(tran, fun.IMAGE)
                img_list[i - 1] = img
            end
            if img then
                --img.sprite = img1
                this:SetSprite(img, img2)
            end
        end
        for key, value in pairs(jackpotData) do
            if img_list[value - 1] then
                this:SetSprite(img_list[value - 1], img1)
                --img_list[value - 1].sprite = img2
            end
        end
    end
end

function SGExtraBallMainView:SetSprite(sprite, sprite2)
    if sprite.sprite.name ~= sprite2.name then
        sprite.sprite = sprite2
    end
end

return this
