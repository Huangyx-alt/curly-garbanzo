
local CollectRewardsAdBaseState = require "View/CollectRewardsView/CollectRewardsAdBaseState"
local CollectRewardsAdOriginalState = require "View/CollectRewardsView/CollectRewardsAdOriginalState"
local CollectRewardsAdStiffState = require "View/CollectRewardsView/CollectRewardsAdStiffState"
local CollectRewardsAdExtraState = require "View/CollectRewardsView/CollectRewardsAdExtraState"

local RouletteJackpotView = BaseView:New("SpinRewardjacpot","RouletteAtlas")
local this = RouletteJackpotView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "text_reward",
    "btn_collect1",
    "btn_collect2",
    "btn_collect3",
}

local Input = nil
local KeyCode = nil

local _watchADUtility = nil
local click_callback = nil
local _cacheBtnPos = nil

function RouletteJackpotView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("CollectRewardsView",self,{
        CollectRewardsAdOriginalState:New(),
        CollectRewardsAdStiffState:New(),
        CollectRewardsAdExtraState:New()
    })
    self._fsm:StartFsm("CollectRewardsAdOriginalState")
end

function RouletteJackpotView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function RouletteJackpotView:OnAdForbiden()
    _cacheBtnPos = fun.get_rect_anchored_position(self.btn_collect1)
    fun.set_active(self.btn_collect1,true)
    fun.set_active(self.btn_collect2,false)
    fun.set_active(self.btn_collect3,false)
    fun.set_rect_anchored_position_x(self.btn_collect1,0)
end

function RouletteJackpotView:OnAdAvailable()
    if _cacheBtnPos then
        fun.set_active(self.btn_collect1,false)
        fun.set_active(self.btn_collect2,true)
        fun.set_active(self.btn_collect3,true)
        fun.set_rect_anchored_position_x(self.btn_collect1,_cacheBtnPos.x)
    end
end

function RouletteJackpotView:Awake(obj)
    self:on_init()
end

function RouletteJackpotView:OnEnable(params)
    Facade.RegisterView(self)

    Input = UnityEngine.Input
    KeyCode = UnityEngine.KeyCode

    _watchADUtility = params.adWatch
    local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
    if isBigR or not _watchADUtility then
        self:OnAdForbiden()
    elseif not _watchADUtility:IsAbleWatchAd() then
        self:OnAdForbiden()
        self._adTimer = Timer.New(function()
            if not self:IsLifeStateDisable()
                    and _watchADUtility
                    and _watchADUtility:IsAbleWatchAd() then
                self:OnAdAvailable()
                self:StopAdTimer()
            end
        end,1,-1)
        self._adTimer:Start()
    end

    click_callback = params.callback
    Anim.do_smooth_int2(self.text_reward,0,params.value,2.5,DG.Tweening.Ease.Unset,nil,nil)

    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm,function()
        AnimatorPlayHelper.Play(self.anima,{"start","jackpot_start"},false,function()
            self._fsm:GetCurState():Change2Original(self._fsm)
        end)
    end)

    UISound.play("turntable_jackpot_coin")
    UISound.play("turntable_jackpot_bgm")

    --self.update_x_enabled = true
    --self:start_x_update()
end

function RouletteJackpotView:StopAdTimer()
    if self._adTimer then
        self._adTimer:Stop()
        self._adTimer = nil
    end
end

function RouletteJackpotView:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function RouletteJackpotView:OnDisable()
    Facade.RemoveView(self)
    self:DisposeFsm()
    Input = nil
    KeyCode = nil
    click_callback = nil
    _watchADUtility = nil
    _cacheBtnPos = nil
    self:StopTimer()
    self:StopAdTimer()
    UISound.stop("turntable_jackpot_coin")
    UISound.stop("turntable_jackpot_bgm")
end

--[[
function RouletteJackpotView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
            if callback then
                callback()
            end
        end)
    end
end
--]]

function RouletteJackpotView.OnRouletteJackpotClose(params,callback)
    if this._timer then
        this._timer:Stop()
        this._timer = nil
    end
    click_callback = callback
    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,Vector3.New(0,0,0),params,function()
        Event.Brocast(EventName.Event_currency_change)
        AnimatorPlayHelper.Play(this.anima,{"end","jackpot_end"},false,function()
            this._fsm:GetCurState():Complete(this._fsm)
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function RouletteJackpotView:on_btn_collect1_click()
    self._fsm:GetCurState():CollectReward(self._fsm)
end

function RouletteJackpotView:on_btn_collect3_click()
    self._fsm:GetCurState():CollectReward(self._fsm)
end

function RouletteJackpotView:on_btn_collect2_click()
    self._fsm:GetCurState():ExtraSpin(self._fsm)
end

function RouletteJackpotView:OnCollectReward()
    if click_callback then
        click_callback()
        self._timer = Invoke(function()
            --if self and fun.is_not_null(self.btn_collect1) then
                --Util.SetImageColorGray(self.btn_collect1,false)
            --end
            if self and self._fsm then
                self._fsm:GetCurState():Change2Original(self._fsm)
            end
        end,3)
        --Util.SetImageColorGray(self.btn_collect1,true)
    end
end

function RouletteJackpotView:OnExtraSpin()
    --Util.SetImageColorGray(self.btn_collect2,true)
    self:OnCollectReward()
end

function RouletteJackpotView:Finish()
    if click_callback then
        click_callback(false)
    end
end

function RouletteJackpotView:FinishNeedExtraSpin()
    local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
    if not isBigR and _watchADUtility and _watchADUtility:IsAbleWatchAd() then
        if click_callback then
            click_callback(true)
        end
    else
        if click_callback then
            click_callback(false)
        end
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Roulette.RouletteJackpotClose,func = this.OnRouletteJackpotClose}
}

return this