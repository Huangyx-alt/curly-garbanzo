
local PiggySlotsGameView = TopBarControllerView:New('PiggySlotsGameView', "PiggySlotsGameAtlas")
local this = PiggySlotsGameView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local piggySlotsGameReel = require "View/PiggySlots/PiggySlotsGameReel"
local piggySlotsGameWheel = require "View/PiggySlots/PiggySlotsGameWheel"


require "State/PiggySlotsGame/BasePiggySlotsGameState"
require "State/PiggySlotsGame/PiggySlotsGameTableInitState"
require "State/PiggySlotsGame/PiggySlotsGameWaitDoFreeSpinState"
require "State/PiggySlotsGame/PiggySlotsGameSpinState"
require "State/PiggySlotsGame/PiggySlotsGameElementMergeState"
require "State/PiggySlotsGame/PiggySlotsGameWaitChoosePaySpinOrTakeAwayState"
require "State/PiggySlotsGame/PiggySlotsGameFinishOneBingoCardState"

require "State/PiggySlotsGame/PiggySlotsGameResetGameState"
require "State/PiggySlotsGame/PiggySlotsGameWaitClickBigPiggyState"
require "State/PiggySlotsGame/PiggySlotsGameWaitSpinBigPiggyWheelState"
require "State/PiggySlotsGame/PiggySlotsGameFinishSpinBigPiggyWheelState"
require "State/PiggySlotsGame/PiggySlotsGameCheckNextCardState"
require "State/PiggySlotsGame/PiggySlotsGameChooseExitState"
require "State/PiggySlotsGame/PiggySlotsGameErrorTipExitState"


this.auto_bind_ui_items = {
    "btn_free_spin",
    "anima",
    "reel1",
    "reel2",
    "reel3",
    "reel4",
    "reel5",
    "bigReel",
    "textBigWin",
    "btn_take_away",
    "btn_pay_get_extra_spin",
    "textDiamondCost",
    "mergeEffectNormal",
    "effectParent",
    "mergeEffectWheel",
    "parentTop",
    "btn_piggy_wheel_spin",
    "panelBg",
    "cardNum",
    "collectCoinParent",
    "rellMoveParent",
    "textPaySpinNum",
    "effectParentMask",
    "effectPrentNoMask",
    "cardItem",
    "textWinList1",
    "textWinList2",
    "textWinList3",
    "textWinList4",
    "zhuBackParent",
    "btn_use_ticket",
    "textTicketCost",
    "textFreeSpinNum"
}

local creatPiggyEffect = {} --生成的小猪特效

--滚动参数
local colNum = 5
local rowNum = 3 
local reelList = {}
local bigReel = nil
local stopDelayTime = 0.2
local startDelayTime = 0.2
local startRollToStopTime = 2 --转轴滚动时间
local delayStopTime = 0.5 --每个转轴停下间隔时间
local rellStopToNextState = 3 --全部转轴停下到下个状态延迟时间
--滚动参数

local isUseTicketContinue = false

--动画延迟参数
local smallPiggyShowHidePlayBigPiggy = 0.5
local openRewardDelayTime = 1
--动画延迟参数
local bigPiggyWheelCodeList = {}

local lastBgmName = nil
local lastTimeScale = 1
this.update_x_enabled = true --开启独立刷新

local freeSpinNum = 3 --免费spin3次

function PiggySlotsGameView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function PiggySlotsGameView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("PiggySlotsGameView",self,{
        PiggySlotsGameTableInitState:New(),
        PiggySlotsGameWaitDoFreeSpinState:New(),   --等待操作
        PiggySlotsGameSpinState:New(),   --PiggySlotsGameWaitDoFreeSpinState 点击spin
        PiggySlotsGameElementMergeState:New(),  -- PiggySlotsGameSpinState 停下后 合并中奖图标
        PiggySlotsGameWaitChoosePaySpinOrTakeAwayState:New(),  --免费spin结束 等待选择付费spin或带走现有牌面奖励 

        PiggySlotsGameResetGameState:New(), --用完一次锤子后 重新初始化
        PiggySlotsGameWaitClickBigPiggyState:New(), --等待点击小猪转盘 
        PiggySlotsGameFinishOneBingoCardState:New(), --完成了一张锤子领奖
        PiggySlotsGameWaitSpinBigPiggyWheelState:New(),
        PiggySlotsGameFinishSpinBigPiggyWheelState:New(),
        PiggySlotsGameCheckNextCardState:New(),
        PiggySlotsGameChooseExitState:New(),
        PiggySlotsGameErrorTipExitState:New()

    })
    self._fsm:StartFsm("PiggySlotsGameTableInitState")
end

function PiggySlotsGameView:Awake()
    self:on_init()
end

function PiggySlotsGameView:OnEnable(params)
    Facade.RegisterView(self)
    lastTimeScale = UnityEngine.Time.timeScale
    UnityEngine.Time.timeScale = 1
    if params then
        self._exit_callback = params
    end
    AddLockCountOneStep(true)
    UISound.stop_loop("chips")
    --UISound.stop_loop("settlement_bgm")
    --UISound.play_loop("piggyslot")
    UISound.play_bgm("piggyslot")
end

function PiggySlotsGameView:ChangeCardBg(breakNum)
    local cardBg = nil
    if breakNum > 1 then
        cardBg = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", "GoldenPigCardIcon0" .. breakNum)
    else
        cardBg = AtlasManager:GetSpriteByName("PiggySlotsGameAtlas", "GoldenPigCardIcon01")
    end
    fun.set_ctrl_sprite(self.cardItem, cardBg)
end

function PiggySlotsGameView:InitTicketNum()
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots) + 1
    self.cardNum.text = "X" .. ticketNum
    self:ChangeCardBg(ticketNum)
end

function PiggySlotsGameView:RefreshTicketNum()
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
    self.cardNum.text = "X" .. ticketNum
    self:ChangeCardBg(ticketNum)
end

function PiggySlotsGameView:RefreshFakeTicketNum()
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
    self.cardNum.text = "X" .. ticketNum - 1
    self:ChangeCardBg(ticketNum - 1)
end

function PiggySlotsGameView:on_after_bind_ref()
    self:BuildFsm()
    self:InitReel()
    self:InitView()
    --self:RefreshTicketNum()
    self:InitTicketNum()
    AnimatorPlayHelper.Play(self.anima, {"enter", "PiggySlotsGameViewenter"}, false, function() 
        self._fsm:GetCurState():DoEnter(self._fsm) 
    end)
end

function PiggySlotsGameView:ShowViewEnd()
    UnityEngine.Time.timeScale = lastTimeScale
    UISound.stop_bgm("piggyslot")
    UISound.play_bgm("city")
    --UISound.play_loop("settlement_bgm")
    Event.Brocast(EventName.ExitPiggySlotsMiniGameRefresh)
    AnimatorPlayHelper.Play(self.anima, {"end", "PiggySlotsGameViewend"}, false, function()
        if self._exit_callback then
            self._exit_callback()
            self._exit_callback = nil
        end
        Facade.SendNotification(NotifyName.CloseUI, self)
    end)
end

function PiggySlotsGameView:UpdateDiamondCost()
    local costDiamond = ModelList.PiggySloltsGameModel.GetDiamondSpinCost()
    self.textDiamondCost.text = fun.format_money(costDiamond)
end

function PiggySlotsGameView:UpdateSpinTip()
    local tip = ModelList.PiggySloltsGameModel.GetSpinNumTip()
    self.textPaySpinNum.text = tip
    self.textFreeSpinNum.text = tip
end

function PiggySlotsGameView:InitView()
    local bigWinNum = ModelList.PiggySloltsGameModel.GetBigWinNum()
    self.textBigWin.text = fun.format_money(bigWinNum)
    fun.set_active(self.btn_free_spin,true)
    fun.set_active(self.btn_take_away,true)
    fun.set_active(self.btn_pay_get_extra_spin,false)

    -- textWinList1
    local winListData = ModelList.PiggySloltsGameModel.GetWinListData()
    for k , v in pairs(winListData) do
        local textUi = self["textWinList" .. v.pigType]
        textUi.text = fun.format_money(v.winCoin)
    end
end

function PiggySlotsGameView:AnimFreeButton()
    AnimatorPlayHelper.Play(self.panelBg, {"enter", "panelBgenter"}, false, function()
    end)
end

function PiggySlotsGameView:AnimShowPaySpinOrTake()
    AnimatorPlayHelper.Play(self.panelBg, {"green_redblue", "panelBgidlelv_redblue"}, false, function()
    end)
end

function PiggySlotsGameView:ShowReelInit()
    if isUseTicketContinue then
        self:RefreshFakeTicketNum()
    else
        self:RefreshTicketNum()
    end
    self:UpdateSpinTip()
    UISound.play("piggygamestart")
    AnimatorPlayHelper.Play(self.panelBg, {"hui_green", "panelBgidlehui_lv"}, false, function() 
        Anim.move_ease(self.rellMoveParent,0,0,0,0.6,true,DG.Tweening.Ease.InFlash,function()
        end)
    
        self:ClearShowBreakNumToNext()
        self.delayShowBreakNumToNextFunc = LuaTimer:SetDelayFunction(2, function()
            if self._fsm then
                self._fsm:GetCurState():DoFinishGameInit(self._fsm)
            end
        end)
    end)
    isUseTicketContinue = true
end

function PiggySlotsGameView:OnDisable()
    AddLockCountOneStep(false)
    isUseTicketContinue = false
    creatPiggyEffect = {}    
    self:ClearRefreshCoin()
    self:DestroyEffect()
    self:ClearDelayStartRoll()
    self:ClearDelayStopRoll()
    self:ClearStartRollToEndRoll()
    self:ClearElementMergeFunc()
    self:ClearMergeToNextState()
    self:ClearCollectRewardToNextCardFunc()
    self:ClearDelayCreatBigPiggy()
    self:ClearDelayCreatThreePiggy()
    self:ClearDelayCreatTwoPiggy()
    self:ClearShowBreakNumToNext()
    self:ClearDelayOpenReward()
    self:ClearCollectCoinNextState()
    self:ClearEnterNextCrad()
    self._exit_callback = nil
    ModelList.PiggySloltsGameModel.ClearGameData()
    Facade.RemoveView(self)
end

function PiggySlotsGameView:CloseSelfWithExitFunc()
    UnityEngine.Time.timeScale = lastTimeScale
    UISound.stop_bgm("piggyslot")
    UISound.play_bgm("city")
    --UISound.play_loop("settlement_bgm")
    Event.Brocast(EventName.ExitPiggySlotsMiniGameRefresh)
    AnimatorPlayHelper.Play(self.anima, {"end", "PiggySlotsGameViewend"}, false, function()
        if self._exit_callback then
            self._exit_callback()
            self._exit_callback = nil
        end
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function PiggySlotsGameView:onStartRoll()
    self:StartRoll()
    self:ClearStartRollToEndRoll()
    self.startRollToEndRollFunc = LuaTimer:SetDelayFunction(startRollToStopTime, function()
        self:StopRoll()
    end)

    local elementMergeStateTime = (colNum -1) * delayStopTime + rellStopToNextState
    self.enterElementMergeFunc = LuaTimer:SetDelayFunction(elementMergeStateTime, function()
        self:EnterElementMergeState()
    end)
    
end

--上次完成的免费spin，进入选择付费或者带走奖励状态
function PiggySlotsGameView:OnFinishFreeSpin()
    self._fsm:GetCurState():EnterPayOrFinishGameState(self._fsm)
end

--上次完成的付费spin，进入等待下次付费spin，一次付费可以使用5次付费spin
function PiggySlotsGameView:OnFinishPaySpin()
    local hasFinishAllPyaSpin = ModelList.PiggySloltsGameModel.CheckCardSpinMax() --完成了这张bingo卡的全部付费spin
    if hasFinishAllPyaSpin then
        self:FinishPayOneBingoCardUpdateUI()
        log.log("错误 需要进入结算状态")
    else
        self._fsm:GetCurState():EnterPayOrFinishGameState(self._fsm)
    end
end

function PiggySlotsGameView:onCollectReward()
    local isHasBigReel = false

end

function PiggySlotsGameView:EnterElementMergeState()
    if self._fsm then
        self._fsm:GetCurState():DoStopRoll(self._fsm) 
    end
end

function PiggySlotsGameView:EnterCollectResultState()
    if self._fsm then
        self._fsm:GetCurState():DoCollectReward(self._fsm) 
    end
end

function PiggySlotsGameView:on_btn_take_away_click()
    self._fsm:GetCurState():DoTakeAway(self._fsm)
end

function PiggySlotsGameView:on_btn_piggy_wheel_spin_click()
    self._fsm:GetCurState():DoSpinPiggyWheel(self._fsm)
end

function PiggySlotsGameView:MergeSpinTaskeUpdateUI(isDisableButton)
    Util.SetUIImageGray(self.btn_take_away.gameObject, isDisableButton)
end

function PiggySlotsGameView:WheelSpinUpdateUI(isDisableButton)
    Util.SetUIImageGray(self.btn_take_away.gameObject, isDisableButton)
end

function PiggySlotsGameView:ChooseTakeOrPaySpinUpdateUI(isDisableButton)
    Util.SetUIImageGray(self.btn_take_away.gameObject, isDisableButton)
    Util.SetUIImageGray(self.btn_pay_get_extra_spin.gameObject, isDisableButton)
end

function PiggySlotsGameView:on_btn_pay_get_extra_spin_click()
    --这里需要钻石付费流程
    self._fsm:GetCurState():DoBuyExtraUseSpin(self._fsm)
    -- self:FinishPayResult()
end

function PiggySlotsGameView:OnBuyExtraSpin()
    local costDiamond = ModelList.PiggySloltsGameModel.GetDiamondSpinCost()
    log.log("小猪机台 钻石消耗" , costDiamond)

    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable,8018,Resource.diamon,costDiamond,function()
        --点击时资源够
        log.log("点击分支 spin")
        -- if ModelList.PiggySloltsGameModel.CheckIsTest() then
            -- ModelList.PiggySloltsGameModel.SetTestSpinData()
        -- else
            self:ReqPiggySlotsSpin()
        -- end
    end,function()
        --资源不够点击取消去商店
        log.log("点击分支 取消")
        self._fsm:GetCurState():DoPayFailGetExtraSpin(self._fsm)
    end,function()
        log.log("点击分支 进入商店")
        self._fsm:GetCurState():ResetChooseType(self._fsm)
        
    end,SHOP_TYPE.SHOP_TYPE_DIAMONDS)
end

function PiggySlotsGameView:on_btn_free_spin_click()
    self._fsm:GetCurState():DoClickSpinRoll(self._fsm)
end

function PiggySlotsGameView:on_btn_use_ticket_click()
    self._fsm:GetCurState():ReqUseTicketContinueGame(self._fsm)
end

function PiggySlotsGameView:FreeSpinUpdateUI(isDisableButton)
    Util.SetUIImageGray(self.btn_free_spin.gameObject, isDisableButton)
end

function PiggySlotsGameView:ReqPiggySlotsSpin()
    ModelList.PiggySloltsGameModel.ReqPiggySlotsSpin()
end

function PiggySlotsGameView:ReqPiggyBreak(isGoAway)
    ModelList.PiggySloltsGameModel.ReqPiggyBreak(isGoAway)
end

function PiggySlotsGameView:on_x_update()
    local deltaTime = Time.deltaTime
    self:ReelRoll(deltaTime)
end

function PiggySlotsGameView:InitReel()
    reelList = {}
    for i =  1, colNum do
        local code = piggySlotsGameReel:New()
        local reel = self["reel" .. i]
        local reelElementData = ModelList.PiggySloltsGameModel.GetInitSpinResult(i)
        code:SkipLoadShow(reel)
        code:SetReelData(i, self ,self.mergeEffectNormal, self.effectParent , reelElementData)
        reelList[i] = code
    end
end

function PiggySlotsGameView:ReelRoll(deltaTime)
    for i = 1 , colNum do
        if reelList[i] then
            reelList[i]:ReelRoll(deltaTime)
        end
    end
end

function PiggySlotsGameView:NewCarcInitElement()
    for i = 1 , colNum do
        if reelList[i] then
            local reelElementData = ModelList.PiggySloltsGameModel.GetInitSpinResult(i)
            reelList[i]:NewCardInitElement(reelElementData)
        end
    end
end

function PiggySlotsGameView:StartRoll(isInitSpin)
    local startTime = 0 
    for i = 1 , colNum do
        startTime = (i-1) * startDelayTime 
        if reelList[i] then
            if startTime > 0 then
                self:CreatDelayStartRoll(i, startTime, isInitSpin)
            else
                reelList[i]:StartRoll(isInitSpin)
            end
        end
    end
    UISound.play("piggyslotspin")
end

function PiggySlotsGameView:StopRoll()
    for i = 1 , colNum do
        local stopTime = (i - 1) * delayStopTime
        if reelList[i] then
            if stopTime > 0 then
                self:CreatDelayStopRoll(i,stopTime)
            else
                reelList[i]:StopRoll()
            end
        end
    end
end

function PiggySlotsGameView:CreatDelayStartRoll(cellIndex, delayTime,isInitSpin)
    self.delayStartRollFuncList = self.delayStartRollFuncList or {}
    -- self.delayStartRollFuncList[cellIndex] = LuaTimer:SetDelayFunction(delayTime, function()
        reelList[cellIndex]:StartRoll(isInitSpin)
    -- end)
end

function PiggySlotsGameView:CreatDelayStopRoll(cellIndex, delayTime)
    self.delayStopRollFuncList = self.delayStopRollFuncList or {}
    self.delayStopRollFuncList[cellIndex] = LuaTimer:SetDelayFunction(delayTime, function()
        reelList[cellIndex]:StopRoll()
    end)
end


function PiggySlotsGameView:MerageReel()
    local mergeData = ModelList.PiggySloltsGameModel.GetMerageData()
    local mergeToNextStateTime = 3
    self:ClearMergeToNextState()
    self.delaMergeToNextStateFunc = LuaTimer:SetDelayFunction(mergeToNextStateTime, function()
        --如果是这次spin是freespin
        local isFreeSpin = true
        if isFreeSpin then
        else
        end
        self._fsm:GetCurState():DoFinishSpin(self._fsm)
    end)
end

--初始化牌面后更新UI
function PiggySlotsGameView:FinishInitSpinUpdateUI()
    fun.enable_button(self.btn_take_away,false)
    Util.SetUIImageGray(self.btn_take_away.gameObject, true)
end

function PiggySlotsGameView:ContinueFreeSpin()
    fun.set_active(self.btn_free_spin,true)

end

--完成一次freespin 更新UI
function PiggySlotsGameView:FinishFreeSpinUpdateUI()
    fun.set_active(self.btn_free_spin,false)

    fun.set_active(self.btn_take_away,true)
    fun.enable_button(self.btn_take_away , true)
    Util.SetUIImageGray(self.btn_take_away.gameObject, false)

    fun.set_active(self.btn_pay_get_extra_spin,true)
    fun.enable_button(self.btn_pay_get_extra_spin,true)
end

--完成一次付费spin 更新UI
function PiggySlotsGameView:FinsihPaySpinUpdateUI()
    fun.set_active(self.btn_free_spin,false)

    fun.set_active(self.btn_take_away,true)
    fun.enable_button(self.btn_take_away , true)
    Util.SetUIImageGray(self.btn_take_away.gameObject, false)

    fun.set_active(self.btn_pay_get_extra_spin,true)
end

--付费 完成全部spin进入bingo卡结算 更新UI
function PiggySlotsGameView:FinishPayOneBingoCardUpdateUI()

    fun.enable_button(self.btn_take_away,false)
    fun.enable_button(self.btn_pay_get_extra_spin,false)
    AnimatorPlayHelper.Play(self.panelBg, {"redblue_blue", "panelBgidleredblue_blue"}, false, function()
        fun.enable_button(self.btn_take_away,true)
    end)
end

--付费成功 更新UI
function PiggySlotsGameView:PayGetSpinSuccessUpdateUI()
    fun.set_active(self.btn_free_spin,false)
    fun.set_active(self.btn_take_away,false)
    fun.set_active(self.btn_pay_get_extra_spin,false)
end

--付费失败 更新UI
function PiggySlotsGameView:PayGetSpinFailUpdateUI()
    fun.set_active(self.btn_free_spin,false)
    fun.set_active(self.btn_take_away,true)
    fun.set_active(self.btn_pay_get_extra_spin,true)
end

--使用门票更新UI
function PiggySlotsGameView:ShowUseNextTicketUpdateUI()
    AnimatorPlayHelper.Play(self.panelBg, {"piao", "panelBgenterpiao"}, false, function()
    end)
    fun.enable_button(self.btn_use_ticket, true)
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
    self.textTicketCost.text = ticketNum    
    --fun.set_active(self.btn_free_spin,false)
    --fun.set_active(self.btn_take_away,false)
    --fun.enable_button(self.btn_take_away , false)
    --Util.SetUIImageGray(self.btn_take_away.gameObject, false)
    --fun.set_active(self.btn_pay_get_extra_spin,false)
end


--点击break后
function PiggySlotsGameView:OnCollectOneBingoCardReward()
    local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
    self:ClearDelayOpenReward()
    local rewardNum = GetTableLength(rewardData)
    local bigPiggyWheelIndex = nil
    local delayTime = 0
    for k ,v in pairs(reelList) do
        if v then
            v:ClearPiggyBreakDelay()
        end
    end

    for i = 1 , rewardNum do
        if rewardData[i].pigType == PiggySlotsEffectType.Piggy2x3 then
            --大奖需要点击开启
            if not bigPiggyWheelIndex then
                bigPiggyWheelIndex = i
            end
        else
            local func = LuaTimer:SetDelayFunction(delayTime, function()
                self:ReelOpenReward(rewardData[i].col , rewardData[i].row , rewardData[i].pigType , rewardData[i].winCoin)
            end)
            delayTime = delayTime + openRewardDelayTime
            self.delayOpenRewardList = self.delayOpenRewardList or {}
            table.insert(self.delayOpenRewardList , func)
        end
    end
    local funcNextState = LuaTimer:SetDelayFunction(delayTime + 1, function()
        if bigPiggyWheelIndex then
            --有转盘奖励
            if this._fsm then
                this._fsm:GetCurState():DoBigPiggyWheel(this._fsm , bigPiggyWheelIndex)
            end
        else
            if this._fsm then
                this._fsm:GetCurState():DoCollectBreakRewardFinish(this._fsm)
            end
        end
    end)

    self.delayOpenRewardList = self.delayOpenRewardList or {}
    table.insert(self.delayOpenRewardList , funcNextState)
end

function PiggySlotsGameView:ShowBigPiggyUI(bigPiggyWheelIndex , col,row)
    local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
    local wheelData = rewardData[bigPiggyWheelIndex]
    local startParent = self:GetEffectParent(wheelData.col , 1)
    local finishParent = self:GetEffectParent(wheelData.col + 1 , 3)
    fun.set_active(self.btn_piggy_wheel_spin,true)
    self.btn_piggy_wheel_spin.transform.position = Vector2.New(0.5*(startParent.transform.position.x + finishParent.transform.position.x) ,0.5*(startParent.transform.position.y + finishParent.transform.position.y))
end

function PiggySlotsGameView:HideBigPiggyUI()
    fun.set_active(self.btn_piggy_wheel_spin,false)
end

function PiggySlotsGameView:ReelOpenReward(col,row,piggyType,winCoin)
    if piggyType == PiggySlotsEffectType.Piggy2x3 then
        UISound.play("piggypropigbreak")
    else
        UISound.play("piggynormalpigbreak")
    end
    local reel = reelList[col]
    reel:ShowOpenReward(row,piggyType,winCoin)
end

function PiggySlotsGameView:ShowBigPiggyWheel(bigPiggyWheelIndex)
    local code = piggySlotsGameWheel:New()
    local rewardData = ModelList.PiggySloltsGameModel.GetBreakRewardData()
    local wheelData = rewardData[bigPiggyWheelIndex]
    local parent = self:GetEffectParent(wheelData.col , wheelData.row)
    local effect = fun.get_instance(self.mergeEffectWheel,parent)
    local startParent = self:GetEffectParent(wheelData.col , 1)
    local finishParent = self:GetEffectParent(wheelData.col + 1 , 3)
    effect.transform.position = Vector2.New(0.5*(startParent.transform.position.x + finishParent.transform.position.x) ,0.5*(startParent.transform.position.y + finishParent.transform.position.y))
    code:SkipLoadShow(effect)
    code:SetWheelData(self , wheelData , bigPiggyWheelIndex)
    bigPiggyWheelCodeList[bigPiggyWheelIndex] = code
end

function PiggySlotsGameView.PiggySlotsFinishBigWheel(bigPiggyWheelIndex)
    this._fsm:GetCurState():DoFinishBigWheel(this._fsm , bigPiggyWheelIndex)
end

function PiggySlotsGameView:GetPiggyNormalEffect()
    return self.mergeEffectNorma
end

function PiggySlotsGameView.OnReqSpinSuccess(code)
    if this._fsm then
        if code == RET.RET_SUCCESS then
            this._fsm:GetCurState():ReqSpinSuccess(this._fsm)
        else
            this._fsm:GetCurState():DoError(this._fsm,code)
        end
    else
        log.log("错误状态丢失")
    end
end

function PiggySlotsGameView.PiggySlotsReqBreakSuccess(code)
    if this._fsm then
        if code == RET.RET_SUCCESS then
            this._fsm:GetCurState():DoOneBingoCardReward(this._fsm)
        else
            this._fsm:GetCurState():DoError(this._fsm,code)
        end
    else
        log.log("错误状态丢失")
    end
end

--打碎重组
function PiggySlotsGameView:ShowResetPiggy(col , effectType)
    local reel = reelList[col]
    reel:ShowResetPiggy(col)
end

function PiggySlotsGameView:ShowClear2x3Effect(startCol,finishCol)
    local reelStart = reelList[startCol]
    local reelFinish = reelList[finishCol]
    reelStart:ShowResetPiggy()
    reelFinish:ShowResetPiggy()
end

function PiggySlotsGameView:ShowClear1x3Effect(col)
    local reel = reelList[col]
    reel:ShowAllLowLevelEffectHide(PiggySlotsEffectType.Piggy2x3)
end

function PiggySlotsGameView:ShowClear1x2Effect(col)
    local reel = reelList[col]
    reel:ShowAllLowLevelEffectHide(PiggySlotsEffectType.Piggy1X3)
end

function PiggySlotsGameView:ShowClear1x1Effect(col,row)
    local reel = reelList[col]
    reel:ShowRowLowLevelEffectHide(row,PiggySlotsEffectType.Piggy1X2)
end

function PiggySlotsGameView:ShowMerge2x3Effect(startCol,finishCol)
    local reelStart = reelList[startCol]
    local reelFinish = reelList[finishCol]
    --隐藏特效
    if not reelStart:CheckCreatTypeEffect(1,PiggySlotsEffectType.Piggy2x3) then
        log.log("错误已经存在特效了 2x3" , startCol  , finishCol)
        return
    end
    --创建2X3特效
    local startReelParent = self:GetEffectParent(startCol , 3)
    local finishReelParent = self:GetEffectParent(finishCol , 1)
    local targetPos = Vector2.New(0.5*(startReelParent.transform.position.x + finishReelParent.transform.position.x),0.5*(startReelParent.transform.position.y + finishReelParent.transform.position.y))
    reelStart:Creat2X3Effect(1 , targetPos)
    -- for row = 1 , 3 do
    --     reelFinish:SignReelEffectData(row ,PiggySlotsEffectType.Piggy2x3)
    -- end
    reelFinish:SignReelEffectData(1 ,PiggySlotsEffectType.Piggy2x3)
    reelFinish:SignReelEffectData(2 ,PiggySlotsEffectType.Piggy2x3)
    reelFinish:SignReelEffectData(3 ,PiggySlotsEffectType.Piggy2x3)

    reelStart:SignReelEffectData(2 , PiggySlotsEffectType.Piggy2x3)
    reelStart:SignReelEffectData(3 , PiggySlotsEffectType.Piggy2x3)
end


function PiggySlotsGameView:ShowMerge1x3Effect(col)
    local reel = reelList[col]
    if not reel:CheckCreatTypeEffect(2,PiggySlotsEffectType.Piggy1X3) then
        log.log("错误已经存在特效了 1x3" , col)
        return
    end
    reel:Creat1X3Effect()
end

function PiggySlotsGameView:ShowMerge1x2Effect(col, startRow,finishRow)
    local reel = reelList[col]
    if not reel:CheckCreatTypeEffect(startRow , PiggySlotsEffectType.Piggy1X2) then
        log.log("已经存在特效了 1x2" , startRow)
        return
    end
    local startReelParent = self:GetEffectParent(col , startRow)
    local finishReelParent = self:GetEffectParent(col , finishRow)
    local targetPos = Vector2.New(startReelParent.transform.position.x,0.5*(startReelParent.transform.position.y + finishReelParent.transform.position.y))
    reel:Creat1X2Effect(startRow,finishRow,targetPos)
end

function PiggySlotsGameView:FlyCollectReward()
    local allEffectData = {}
    for i = 1 , colNum do
        if reelList[i] then
            local effectData = reelList[i]:GetEffectList()
            if effectData then
                for row ,v in pairs(effectData) do
                    for effectType , w in pairs(v) do
                        table.insert(allEffectData , {col = i , row = row , pigType = effectType})
                    end
                end
            end
        end
    end
    table.sort(allEffectData , function(a,b)
        if a.col > b.col then
            return false
        elseif a.col < b.col then
            return true
        else
            return a.row > b.row
        end
        -- end
    end)

    log.log("元素奖励收集 排序后" , allEffectData)

    local resetBreakReward = ModelList.PiggySloltsGameModel.GetColRowBreakRewardData()
    log.log("重置打碎奖励数据" , resetBreakReward)
    local rewardList = {}
    self:ClearDelayCollectReward()
    local everyDelayTime = 0.3
    local totalDelayTime = 0
    AddLockCountOneStep(false)
    self.delayCollectRewardList = self.delayCollectRewardList or {}
    for i = 1 , GetTableLength(resetBreakReward) do
        local funcNextState = LuaTimer:SetDelayFunction(totalDelayTime, function()
            local text = reelList[resetBreakReward[i].col]:GetCollectCoinText(resetBreakReward[i].row,resetBreakReward[i].pigType)            
            if not text or fun.is_null(text) then
                log.log("错误 小猪数据异常" , i ,resetBreakReward)
            else
                local flyEffectPos = text.transform.position
                local flyitem = Resource.coin
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,flyEffectPos,Resource.coin,function()
                    Event.Brocast(EventName.Event_currency_change)
                end)
            end
        end)
        totalDelayTime = totalDelayTime + everyDelayTime
        table.insert(self.delayCollectRewardList , funcNextState)
    end

    self:ClearRefreshCoin()
    self.delayRefreshCoin = LuaTimer:SetDelayFunction(totalDelayTime + 0.5, function()
        Event.Brocast(EventName.Event_currency_change)
        AddLockCountOneStep(true)
    end)
    
    fun.set_parent(self.effectParent , self.effectParentMask)
    self:SetReelTopElementActive(false)
    self:ElementMoveDown(totalDelayTime + 1)
    self:EnterNextCard(totalDelayTime + 2)
end

function PiggySlotsGameView:ElementMoveDown(delayTime)
    self:ClearCollectCoinNextState()
    self.delayCollectCoinNext = LuaTimer:SetDelayFunction(delayTime, function()
        Anim.move_ease(self.rellMoveParent,0,-1000,0,0.6,true,DG.Tweening.Ease.InFlash,function()
            self.rellMoveParent.transform.localPosition = Vector3.New(0,1000,0)
        end)
        
        Anim.move_ease(self.effectParent,0,-1000,0,0.6,true,DG.Tweening.Ease.InFlash,function()
            self:ClearEffect()
            self:SetReelTopElementActive(true)    
            fun.set_parent(self.effectParent , self.effectPrentNoMask)
            self.effectParent.transform.localPosition = Vector3.New(0,0,0)
        end)
    end)
end

function PiggySlotsGameView:EnterNextCard(delayTime)
    self:ClearEnterNextCrad()
    self.delayEnterNextCard = LuaTimer:SetDelayFunction(delayTime, function()
        this._fsm:GetCurState():DoEnterNextCard(this._fsm)
    end)
end

function PiggySlotsGameView:SetReelTopElementActive(isShow)
    for k ,v in pairs(reelList) do
        v:SetTopElementActive(isShow)
    end
end

function PiggySlotsGameView:ClearEffect()
    for k,v in pairs(reelList) do
        v:ClearAllEffect()
    end

    for k,v in pairs(bigPiggyWheelCodeList) do
        v:Close()
    end
end

function PiggySlotsGameView:DestroyEffect()
    for k,v in pairs(reelList) do
        v:DestroyAllEffect()
    end

    for k,v in pairs(bigPiggyWheelCodeList) do
        v:Close()
    end
end

function PiggySlotsGameView.PiggySlotsFinishReqInfo(code)
    if this._fsm then
        if code == RET.RET_SUCCESS then
            this._fsm:GetCurState():DoFinishReqNextCard(this._fsm)
        else
            this._fsm:GetCurState():DoError(this._fsm,code)
        end
    else
        log.log("错误状态丢失")
    end
end

function PiggySlotsGameView:ShowErrorTipExit()
    local tip = Csv.GetDescription(191165)
    UIUtil.show_common_popup_with_options(
        {
            okType = 3,
            contentText = tip,
            sureCb = function()
                self:CloseSelfWithExitFunc()
            end,
        }
    )
end


this.NotifyList = {
    {notifyName = NotifyName.PiggySlots.PiggySlotsReqSpin,func = this.OnReqSpinSuccess},
    {notifyName = NotifyName.PiggySlots.PiggySlotsReqBreakSuccess,func = this.PiggySlotsReqBreakSuccess},
    {notifyName = NotifyName.PiggySlots.PiggySlotsFinishBigWheel,func = this.PiggySlotsFinishBigWheel},
    {notifyName = NotifyName.PiggySlots.PiggySlotsFinishReqInfo,func = this.PiggySlotsFinishReqInfo}
}


---下面是延迟方法清理
function PiggySlotsGameView:ClearRefreshCoin()
    if self.delayRefreshCoin then
        LuaTimer:Remove(self.delayRefreshCoin)
        self.delayRefreshCoin = nil
    end
end

function PiggySlotsGameView:ClearEnterNextCrad()
    if self.delayEnterNextCard then
        LuaTimer:Remove(self.delayEnterNextCard)
        self.delayEnterNextCard = nil
    end
end

function PiggySlotsGameView:ClearCollectCoinNextState()
    if self.delayCollectCoinNext then
        LuaTimer:Remove(self.delayCollectCoinNext)
        self.delayCollectCoinNext = nil
    end
end


function PiggySlotsGameView:ClearShowBreakNumToNext()
    if self.delayShowBreakNumToNextFunc then
        LuaTimer:Remove(self.delayShowBreakNumToNextFunc)
        self.delayShowBreakNumToNextFunc = nil
    end
end

function PiggySlotsGameView:ClearDelayShowBreakNum()
    if self.delayShowBreakNumFunc then
        LuaTimer:Remove(self.delayShowBreakNumFunc)
        self.delayShowBreakNumFunc = nil
    end
end

function PiggySlotsGameView:ClearElementMergeFunc()
    if self.enterElementMergeFunc then
        LuaTimer:Remove(self.enterElementMergeFunc)
        self.enterElementMergeFunc = nil
    end
end

function PiggySlotsGameView:ClearCollectRewardToNextCardFunc()
    if self.collectRewardDelayNextCardFunc then
        LuaTimer:Remove(self.collectRewardDelayNextCardFunc)
        self.collectRewardDelayNextCardFunc = nil
    end
end

function PiggySlotsGameView:ClearStartRollToEndRoll()
    if self.startRollToEndRollFunc then
        LuaTimer:Remove(self.startRollToEndRollFunc)
        self.startRollToEndRollFunc = nil
    end
end

function PiggySlotsGameView:ClearDelayCreatTwoPiggy()
    if self.delayCreatTwoPiggy and GetTableLength(self.delayCreatTwoPiggy) > 0 then
        for k ,v in pairs(self.delayCreatTwoPiggy) do
            if v then
                LuaTimer:Remove(v)
            end
        end
    end
    self.delayCreatTwoPiggy = nil
end

function PiggySlotsGameView:ClearDelayOpenReward()
    if self.delayOpenRewardList and GetTableLength(self.delayOpenRewardList) > 0 then
        for k ,v in pairs(self.delayOpenRewardList) do
            if v then
                LuaTimer:Remove(v)
            end
        end
    end
    self.delayOpenRewardList = nil
end

function PiggySlotsGameView:ClearDelayCollectReward()
    if self.delayCollectRewardList and GetTableLength(self.delayCollectRewardList) > 0 then
        for k ,v in pairs(self.delayCollectRewardList) do
            if v then
                LuaTimer:Remove(v)
            end
        end
    end
    self.delayCollectRewardList = nil
end

function PiggySlotsGameView:ClearDelayCreatBigPiggy()
    if self.delayCreatBigPiggy and GetTableLength(self.delayCreatBigPiggy) > 0 then
        for k ,v in pairs(self.delayCreatBigPiggy) do
            if v then
                LuaTimer:Remove(v)
            end
        end
    end
    self.delayCreatBigPiggy = nil
end

function PiggySlotsGameView:ClearDelayCreatThreePiggy()
    if self.delayCreatThreePiggy and GetTableLength(self.delayCreatThreePiggy) > 0 then
        for k ,v in pairs(self.delayCreatThreePiggy) do
            if v then
                LuaTimer:Remove(v)
            end
        end
    end
    self.delayCreatThreePiggy = nil
end

function PiggySlotsGameView:ClearDelayStartRoll()
    self.delayStartRollFuncList = self.delayStartRollFuncList or {}
    for k , v in pairs(self.delayStartRollFuncList) do
        LuaTimer:Remove(v)
    end
    self.delayStartRollFuncList = {}
end

function PiggySlotsGameView:ClearMergeToNextState()
    if self.delaMergeToNextStateFunc then
        LuaTimer:Remove(self.delaMergeToNextStateFunc)
        self.delaMergeToNextStateFunc = nil
    end
end

function PiggySlotsGameView:ClearDelayStopRoll()
    self.delayStopRollFuncList = self.delayStopRollFuncList or {}
    for k , v in pairs(self.delayStopRollFuncList) do
        LuaTimer:Remove(v)
    end
    self.delayStopRollFuncList = {}
end

function PiggySlotsGameView:GetEffectParent(col,row)
    local ref = fun.get_component(self.effectParent, fun.REFER)
    local parentName = string.format("%s%s%s%s","parent" , col ,"x", row)
    local parent = ref:Get(parentName)
    return parent
end


function PiggySlotsGameView:GetParentTop()
    return self.parentTop
end

function PiggySlotsGameView:GetPiggyEffect(effectParent,effectName)
    if creatPiggyEffect and creatPiggyEffect[1] and fun.is_not_null(creatPiggyEffect[1]) then
        local effect = table.remove(creatPiggyEffect, 1)
        fun.set_parent(effect,effectParent)
        effect.transform.name = effectName
        return effect
    else
        local effect = fun.get_instance(self.mergeEffectNormal, effectParent)
        effect.transform.name = effectName
        return effect
    end
end

function PiggySlotsGameView:BackPiggyEffect(effect)
    table.insert(creatPiggyEffect, effect)
    fun.set_parent(effect,self.zhuBackParent)
end

function PiggySlotsGameView:CloseTopBarParent()
    log.log("点击中途退出 piggy")
    if self and self._fsm then
        self._fsm:GetCurState():Goback(self._fsm)
    end
end





return this