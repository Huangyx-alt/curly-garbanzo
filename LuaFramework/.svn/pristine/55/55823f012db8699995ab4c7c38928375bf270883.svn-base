--require "View/Roulette/states/RouletteBaseState"
local RouletteOriginalState = require "View/Roulette/states/RouletteOriginalState"
local RouletteEnterState = require "View/Roulette/states/RouletteEnterState"
local RouletteSpinState = require "View/Roulette/states/RouletteSpinState"
local RouletteExitState = require "View/Roulette/states/RouletteExitState"

local RouletteRewardItem = require "View/Roulette/RouletteRewardItem"
local RouletteVipBenefit = require "View/Roulette/RouletteVipBenefit"

local RouletteFree = BaseView:New("RouletteFree","RouletteConfirmAtlas")
local this = RouletteFree
this.viewType = CanvasSortingOrderManager.LayerType.None

local AnimationCurve = UnityEngine.AnimationCurve
local Keyframe = UnityEngine.Keyframe

local jackpotItemId = nil

local isJeckpot = nil
local jackpotItem = nil

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_ACTIVITY_CD)

local _extraSpinCount = nil

local instance = nil
function RouletteFree.GetInstance()
    return instance
end

this.auto_bind_ui_items = {
    "btn_spin_speed",
    "vip_content",
    "toggle_vip0",
    "toggle_vip1",
    "toggle_vip2",
    "toggle_vip3",
    "toggle_vip4",
    "toggle_vip5",
    "toggle_vip6",
    "toggle_vopMax",
    "rotated_reward_item1",
    "rotated_reward_item2",
    "rotated_reward_item3",
    "rotated_reward_item4",
    "rotated_reward_item5",
    "rotated_reward_item6",
    "rotated_reward_item7",
    "rotated_reward_item8",
    "rotated_reward_item9",
    "rotated_reward_item10",
    "rotated_reward_item11",
    "rotated_reward_item12",
    "text_nextBonus",
    "text_jackpot",
    "rotation",
    "aniam_pointer"
}

function RouletteFree:IsJackpot()
    return isJeckpot
end

function RouletteFree:GetJackpotItem()
    return jackpotItem
end

function RouletteFree:Awake()
    self:on_init()
end

function RouletteFree:OnEnable(params)
    if not params then
        log.log("异常：转盘初始化 param")
        return
    end
    if self.superView then
        log.log("异常：转盘初始化 super")
        return
    end
    instance = self
    Facade.RegisterView(self)
    self.superView = params.super
    self.isFromFree = params.isFromFree
    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm)
    self:SetRouletteInfo()
    self:SetSpinButton()
    self:SetVip()
    self:InitRoulette()

    _extraSpinCount = nil

    if self.isFromFree then
        UISound.play("turntable_upgrade")
    else
        UISound.play("turntable_open")
    end
end

function RouletteFree:OnDisable()
    Facade.RemoveView(self)
    self:DisposeFsm()
    self.reward_items = nil
    self.vip_items = nil
    if self._invokeTimer then
        self._invokeTimer:Stop()
        self._invokeTimer = nil
    end
    jackpotItemId = nil
    self.reward_index = nil
    isJeckpot = nil
    jackpotItem = nil
    _extraSpinCount = nil
    self:DisposeRoulette()
end

function RouletteFree:OnClose()
    self:OnExitRoulette(true)
end

function RouletteFree:InitRoulette()
end

function RouletteFree:DisposeRoulette()
end

function RouletteFree:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("RouletteFree",self,{
        RouletteOriginalState:New(),
        RouletteEnterState:New(),
        RouletteSpinState:New(),
        RouletteExitState:New()
    })
    self._fsm:StartFsm("RouletteOriginalState")
end

function RouletteFree:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function RouletteFree:PlayRouletteEnter()
    if self.superView then
        self.superView:PlayFreeEnter(function()
            if not self:ShowPreviousRewards() then
                self._fsm:GetCurState():Complete(self._fsm)
            end
        end)
    end
end

function RouletteFree:SetSpinButton()
end

function RouletteFree:SetVip()
    if self.vip_items == nil then
        self.vip_items = {}
        local myVip = ModelList.PlayerInfoModel:GetVIP()
        local vip_index = 0
        local vip_count = #Csv.new_vip
        myVip = math.min(myVip, vip_count - 10) --至少也要显示8个
        local temList = {}
        
        for index = 0, vip_count do
            local value = Csv.new_vip[index]
            --if value.level >= myVip then
                local go = self[string.format("toggle_vip%s",vip_index)]
                if go == nil then
                    if index < vip_count then
                      
                        go = fun.get_instance(self.toggle_vip6, self.vip_content)
                        table.insert(temList,{go,value})
                    else
                        table.insert(temList,{self.toggle_vopMax,value})
                    end
                else
                    table.insert(temList,{go,value})
                end
                vip_index = vip_index + 1
            --end
        end
        for key, value in pairs(temList) do
            --log.g("self.toggle_vopMax"..tostring(value[1].name))
            local view = RouletteVipBenefit:New()
            view:SkipLoadShow(value[1],true)
            view:SetData(value[2].level,value[2].roulette)
            table.insert(self.vip_items,view)
        end
    else
        for key, value in pairs(self.vip_items) do
            value:Refresh()
        end
    end
end

function RouletteFree:SetRouletteInfo(configIndex)
    local configId = ModelList.RouletteModel:GetCurConfigId(configIndex)
    --log.r("=======================================>>RouletteFree:SetRouletteInfo " .. tostring(configId))
    if configId then
        if self.reward_items == nil then
            self.reward_items = {}
        end
        local myVip = ModelList.PlayerInfoModel:GetVIP()
        local rewards = Csv.GetData("roulette",configId,"item")
        for key, value in pairs(rewards) do
            local view = self.reward_items[value[1]]
            if nil == view then
                view = RouletteRewardItem:New()
                self.reward_items[value[1]] = view
                view:SetRewardData({value[2],value[3],value[1]})
                view:SkipLoadShow(self[string.format("rotated_reward_item%s",value[1])],true,nil)
            else
                view:SetRewardData({value[2],value[3],value[1]})
            end
        end
        local vipInfo = Csv.GetData("vip",myVip,"roulette")
        --self.text_jackpot.text = fun.NumInsertComma(math.floor(rewards[1][3] * (vipInfo / 100)))
        local bonus = Csv.GetData("roulette",configId,"bonus_boost")
        if bonus > 0 then
            self.text_nextBonus.text = string.format("Next Bonus Boost: %s%s",bonus,"%")
        else
            self.text_nextBonus.text = Csv.GetDescription(Csv.GetData("roulette",configId,"description"))
        end
    end
end

function RouletteFree:RefreshVipAddition()
    if self.reward_items then
        for key, value in pairs(self.reward_items) do
            value:RefreshVipAddition()
        end
    end
end

function RouletteFree:ShowPreviousRewards()
    if ModelList.RouletteModel:IsRouletteRewardAvailable() then
        self:ShowRouletteReward()
        return true
    end
end

function RouletteFree:on_btn_spin_speed_click()    
    self._fsm:GetCurState():Spin(self._fsm)
    --self:OnSpinRouletteResult()
end

function RouletteFree:RequestSpinRoulette()
    ModelList.RouletteModel.C2S_RequestSpinRoulette(ModelList.RouletteModel:GetCurConfigId())
end

function RouletteFree:OnSpinRouletteResult()
    self:DoRouletteSpinReward()
end

function RouletteFree:OnRoulettePayResult()
    self:DoRouletteSpinReward()
end

function RouletteFree:DoRouletteSpinReward()
    self._fsm:GetCurState():ServerReshone()
    self:ShowSpinAnimation()
end

function RouletteFree:PlayButtonSpin()
    
end

function RouletteFree:PlayButtonIdle()
    
end

function RouletteFree:PlayButtonExit()

end

function RouletteFree:GetAnimationCurve()
    local kf1 = Keyframe.New(0,0)
    kf1.inTangent = -0.2527652
    kf1.outTangent = -0.2527652

    local kf2 = Keyframe.New(0.2609288,   0.04376742 )
    kf2.inTangent = 1.103823
    kf2.outTangent = 1.103823

    local kf3 = Keyframe.New(0.4584515, 0.8132824)
    kf3.inTangent = 1.39236
    kf3.outTangent = 1.39236

    local kf4 = Keyframe.New( 0.8328564, 1.017954)
    kf4.inTangent =  0.04524461
    kf4.outTangent =  0.04524461

    local kf5 = Keyframe.New(1, 1)
    kf5.inTangent = -0.2016013
    kf5.outTangent = -0.2016013

    return AnimationCurve.New(kf1,kf2,kf3,kf4,kf5)
end

function RouletteFree:ShowSpinAnimation()
    local z = instance.rotation.transform.localRotation.eulerAngles.z
    local ac = instance:GetAnimationCurve()
    instance.superView:PlayFreeSpin()
    AnimatorPlayHelper.Play(instance.aniam_pointer,{"spin","pointer_spin"},false,nil)

    self.reward_index = ModelList.RouletteModel:GetRewardIndex() --math.random(1,12) --
    Anim.rotate(instance.rotation,0,0, z - (360 * 3 + instance.reward_items[self.reward_index]:GetRotate2Pos(z)),4,true,function()
        instance:ShowRouletteReward()
        
    end,ac)

    UISound.play("turntable_spin")
end

function RouletteFree:ShowRoulettePreviousReward()
    self:PlayShowReward()
    --self._invokeTimer = Invoke(function()
    --    local configId = ModelList.RouletteModel:GetPreviousConfigId()
    --    local items = Csv.GetData("roulette",configId,"item")
    --end,1.5)
end

function RouletteFree:ShowRouletteReward()
    self:PlayShowReward()
    if not self.reward_index then
        self.reward_index = ModelList.RouletteModel:GetRewardIndex()
    end
    self:DelayShowReward()
end

function RouletteFree:DelayShowReward()
    self._invokeTimer = Invoke(function()
        local showRewardList = {}
        isJeckpot = false
        local rewardIndexList = ModelList.RouletteModel:GetRewardList() or {}
        for key, value in pairs(rewardIndexList) do
            local reward = ModelList.RouletteModel:GetRewardData(key)
            if reward then
                table.insert(showRewardList,{id = reward.id,value = reward.value})
                if value == 1 then
                    jackpotItem = {reward.id,reward.value}
                    isJeckpot = true
                end
            end
        end
        if self then
            self:PopupRouletteReward(isJeckpot,jackpotItem,showRewardList,_watchADUtility)
        end
    end,1.5)
end

function RouletteFree:PopupRouletteReward(isSpinJeckpot,spinjackpotItem,spinRewardList,watchAd)
    Http.report_event("activity_spin_finish",{ispurchasewheeljackpot = isSpinJeckpot})
    if isSpinJeckpot then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.RouletteJackpotView,nil,nil,{value = spinjackpotItem[2]
        , adWatch = (((_extraSpinCount or 0) == 0) and {watchAd} or {nil})[1]
        , callback = function()
            ModelList.RouletteModel:C2S_RequestClaimRouletteReward()
        end})
    else
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectRewardAd,spinRewardList,function()
            ModelList.RouletteModel:C2S_RequestClaimRouletteReward()
        end,nil,nil,nil,(((_extraSpinCount or 0) == 0) and {watchAd} or {nil})[1])
    end
    _extraSpinCount = ((_extraSpinCount or 0) + 1)
end

function RouletteFree:PlayShowReward()

    self.superView:PlayFreeShowReward()
end

function RouletteFree:OnExitRoulette(isExit)
    if isExit then
        self.superView:PlayVipExit(function()
            Facade.SendNotification(NotifyName.CloseUI,ViewList.RouletteView)
        end)
    else
        self._fsm:GetCurState():GoBack(self._fsm)
    end
end

function RouletteFree:OnClaimRewardResult()
    self:SetClaimRewardResult()
end

function RouletteFree:SetClaimRewardResult()
    if isJeckpot then
        Facade.SendNotification(NotifyName.Roulette.RouletteJackpotClose,jackpotItem[1],function(isWatchAd)
            if isWatchAd then
                _watchADUtility:WatchVideo(self,self.WatchVideoCallback,"spin_skiptime","free")
            else
                local isFee = ModelList.RouletteModel:IsFeeAvailable()
                if isFee then
                    instance.superView:SetFeeStyle(true)
                end
                self._fsm:GetCurState():Complete(self._fsm)        
            end
        end)
    else
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectRewardAd,nil,function(isWatchAd)
            if isWatchAd then
                _watchADUtility:WatchVideo(self,self.WatchVideoCallback,"spin_skiptime","free")
            else
                local isFee = ModelList.RouletteModel:IsFeeAvailable()
                if isFee then
                    instance.superView:SetFeeStyle(true)
                else
                    log.r("=======================================>>出错，下个id不是付费转盘id号为：" .. ModelList.RouletteModel:GetCurConfigId() .. ",没看过广告下个转盘应为付费转盘！")    
                end
                if self and self._fsm then
                    self._fsm:GetCurState():Complete(self._fsm)
                end
            end
        end)
    end
end

function RouletteFree:Purchasing_failure()

end

function RouletteFree:WatchVideoCallback(isBreak)
    if isBreak then
        local isFee = ModelList.RouletteModel:IsFeeAvailable()
        if isFee then
            instance.superView:SetFeeStyle(true)
        end
        self._fsm:GetCurState():Complete(self._fsm)
    end
end

function RouletteFree:OnRefreshRoulette()
    local isFee = ModelList.RouletteModel:IsFeeAvailable()
    if isFee then
        instance.superView:SetFeeStyle(true)
    else
        self.superView:PlayRouletteIdle()
        self:SetRouletteInfo()
    end
    self._fsm:GetCurState():Complete(self._fsm)
end

local OnSpinRouletteResult = function()
    instance:OnSpinRouletteResult()
end

local OnClaimRewardResult = function()
    instance:OnClaimRewardResult()
end

local OnExitRoulette = function(isExit)
    instance:OnExitRoulette(isExit)
end

local OnRoulettePayResult = function(code)
    if 0 == code then
        instance:OnRoulettePayResult()
    else
        instance:Purchasing_failure()    
    end
end

local OnRefreshRoulette = function()
    instance:OnRefreshRoulette()
end

this.NotifyList = {
    {notifyName = NotifyName.Roulette.SpinRouletteResult,func = OnSpinRouletteResult},
    {notifyName = NotifyName.Roulette.ClaimRewardResult,func = OnClaimRewardResult},
    {notifyName = NotifyName.Roulette.ExitRoulette,func = OnExitRoulette},
    {notifyName = NotifyName.ShopView.ActivityPayResult,func = OnRoulettePayResult},
    {notifyName = NotifyName.Roulette.RefreshRoulette,func = OnRefreshRoulette},
}

return this