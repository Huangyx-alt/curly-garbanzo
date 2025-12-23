
local RouletteFree = require("View/Roulette/RouletteFree")
local  RouletteFee = RouletteFree:New("RouletteFee")
local this = RouletteFee
this.viewType = CanvasSortingOrderManager.LayerType.None

local cache_pointer = nil
local use_pointer = nil
local rouletteConfigId = nil
local cache_rewardIndex = nil
local cache_winLight = nil

local AnimationCurve = nil
local Keyframe = nil

local orientation = nil

local spinButton = nil

this.auto_bind_ui_items = {
    "btn_spin_speed",
    "btn_spin_speed2",
    "vip_content",
    "toggle_vip1",
    "toggle_vip2",
    "toggle_vip3",
    "toggle_vip4",
    "toggle_vip5",
    "toggle_vip6",
    "toggle_vip0",
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
    "spin1Anima",
    "spin2Anima",
    "btn_close",
    "aniam_pointer",
    "text_spin1",
    "text_cost1",
    "text_spin2",
    "text_cost2",
    "win_light"
}

function RouletteFee:InitRoulette()
    AnimationCurve = UnityEngine.AnimationCurve 
    Keyframe = UnityEngine.Keyframe 
    orientation = {{0,0,0},{232.5,-55,-30},{402.5,-224.5,-60},{465,-457,-90},{402.5,-689.5,-120},{232.5,-859.5,-150},
        {0,-922,180},{-232.5,-859.5,150},{-402.5,-689.5,120},{-465,-457,90},{-402.5,-224.5,60},{-232.5,-54.5,30},{0,0,0}}
end

function RouletteFee:DisposeRoulette()
    cache_pointer = nil 
    use_pointer = nil 
    rouletteConfigId = nil
    cache_rewardIndex = nil
    orientation = nil
    cache_winLight = nil
    AnimationCurve = nil
    Keyframe = nil
    spinButton = nil
end

function RouletteFee:PlayRouletteEnter()
    if self.superView then
        if self.isFromFree then
            self.superView:PlayChange2Vip(function()
                if not self:ShowPreviousRewards() then
                    self._fsm:GetCurState():Complete(self._fsm)
                end
            end)
        else
            self.superView:PlayVipEnter(function()
                if not self:ShowPreviousRewards() then
                    self._fsm:GetCurState():Complete(self._fsm)
                end
            end)
        end
    end
end

function RouletteFee:PlayShowReward()
    if self.superView then
        self.superView:PlayFeeShowReward()
    end
    if cache_winLight == nil then
        cache_winLight = {}
    end
    for key, value in pairs(self.reward_items) do
        value:SetMask()
    end
    if cache_rewardIndex then
        local cacheIndex = 0
        for key, value in pairs(cache_rewardIndex) do
            cacheIndex = cacheIndex + 1
            --if cache_winLight[cacheIndex] == nil then
            --    cache_winLight[cacheIndex] = fun.get_instance(self.win_light,self.win_light.parent.gameObject.transform)
            --end
            --fun.set_gameobject_rot(cache_winLight[cacheIndex],0,0,orientation[value][3])
            --fun.set_active(cache_winLight[cacheIndex].transform,true)
        end
    end
end

function RouletteFee:ClearWinLight()
    if cache_winLight then
        for key, value in pairs(cache_winLight) do
            fun.set_active(value.transform,false)
        end
    end
    for key, value in pairs(self.reward_items) do
        value:SetMaskTag(false)
        value:SetMask()
    end
end

function RouletteFee:SetSpinButton()
    local configId = ModelList.RouletteModel:GetCurConfigId(2)
    if configId then
        fun.set_gameobject_pos(self.spin1Anima.transform.parent.gameObject,-280,173,0,true)
        fun.set_active(self.spin2Anima.transform,true)
        local roulette = Csv.GetData("roulette",configId)
        self.text_spin2.text = string.format("SPIN x%s",roulette.roulette_sign)
        self.text_cost2.text = string.format("$%s",roulette.price)

        configId = ModelList.RouletteModel:GetCurConfigId(1)
        roulette = Csv.GetData("roulette",configId)
        self.text_spin1.text = string.format("SPIN x%s",roulette.roulette_sign)
        self.text_cost1.text = string.format("$%s",roulette.price)

        self.spin1Anima:Play("start")
        self.spin2Anima:Play("start")
    else
        configId = ModelList.RouletteModel:GetCurConfigId(1)
        roulette = Csv.GetData("roulette",configId)
        --self.text_spin1.text = string.format("SPIN x%s",roulette.roulette_sign)
        --self.text_cost1.text = string.format("$%s",roulette.price)
        AnimatorPlayHelper.Play(self.spin2Anima,{"end","btn_spin2_end"},false,function()
            fun.set_active(self.spin2Anima.transform,false)
            fun.set_gameobject_pos(self.spin1Anima.transform.parent.gameObject,0,173,0,true)
        end)
    end
end

function RouletteFee:SetPointer()
    if cache_pointer == nil then
        cache_pointer = {}
        cache_pointer[1] = self.aniam_pointer
    end
    if use_pointer then
        for key, value in pairs(use_pointer) do
            if value ~= self.aniam_pointer then
                fun.set_active(value,false) 
            end   
        end
    end
    use_pointer = {self.aniam_pointer}
    local minRewardIndex = 1000
    local rewardIndexList = ModelList.RouletteModel:GetRewardList()
    for key, value in pairs(rewardIndexList) do
        if value < minRewardIndex then
            minRewardIndex = value
        end
    end
    for key, value in pairs(self.reward_items) do
        value:SetMaskTag(true)
    end
    cache_rewardIndex = {}
    for i = 1, 12 do
        local rewardIndex = ModelList.RouletteModel:GetRewardIndex(i)
        if rewardIndex then
            self.reward_items[rewardIndex]:SetMaskTag(false)
            rewardIndex = rewardIndex - minRewardIndex + 1
            table.insert(cache_rewardIndex,rewardIndex)
            --if cache_pointer[rewardIndex] == nil then
            --    local go = fun.get_instance(self.aniam_pointer,self.aniam_pointer.transform.parent.gameObject)
            --    local anima = fun.get_component(go,fun.ANIMATOR)
            --    cache_pointer[rewardIndex] = anima
            --else
            --    fun.set_active(cache_pointer[rewardIndex],true)    
            --end
            --table.insert(use_pointer,cache_pointer[rewardIndex])
            --fun.set_gameobject_pos(cache_pointer[rewardIndex].gameObject,orientation[rewardIndex][1],orientation[rewardIndex][2],0,true)
            --fun.set_gameobject_rot(cache_pointer[rewardIndex].gameObject,0,0,orientation[rewardIndex][3])

            UISound.play("turntable_pointer")
        end
    end
    for key, value in pairs(use_pointer) do
        value:Play("start")
    end

    return minRewardIndex
end

function RouletteFee:on_btn_spin_speed_click()
    spinButton = 1
    rouletteConfigId = ModelList.RouletteModel:GetCurConfigId(1)
    self._fsm:GetCurState():Spin(self._fsm)
end

function RouletteFee:on_btn_spin_speed2_click()
    spinButton = 2
    rouletteConfigId = ModelList.RouletteModel:GetCurConfigId(2)
    self._fsm:GetCurState():Spin(self._fsm)
end

function RouletteFee:on_btn_close_click()
    self._fsm:GetCurState():Close(self._fsm)
end

--[[
function RouletteFee:CloseWarning()
    UIUtil.show_common_popup(8008,false,function()
        self._fsm:GetCurState():ForceClose(self._fsm)
    end,function()

    end,nil,nil)
end
--]]

function RouletteFee:RequestSpinRoulette()
    ModelList.RouletteModel.C2S_RequestSpinRouletteFee(rouletteConfigId)
end

function RouletteFee:Purchasing_success()
   self:ShowSpinAnimation() 
end

function RouletteFee:Purchasing_failure()
    self._fsm:GetCurState():Complete(self._fsm)    
end

function RouletteFee:Purchasing_failure_editor()
    UIUtil.show_common_popup(9036,true,function()
        self._fsm:GetCurState():Complete(self._fsm)    
    end,function()

    end,nil,nil)
end

function RouletteFee:PlayButtonSpin()
    if spinButton == 1 then
        self.spin1Anima:Play("spin")
        self.spin2Anima:Play("idle1")
    else
        self.spin1Anima:Play("idle1")
        self.spin2Anima:Play("spin")
    end
end

function RouletteFee:PlayButtonIdle()
    self.spin1Anima:Play("idle2")
    self.spin2Anima:Play("idle2")
end

function RouletteFee:PlayButtonExit()
    self.spin1Anima:Play("end")
    self.spin2Anima:Play("end")
end

function RouletteFee:DoRouletteSpinReward()
    self._fsm:GetCurState():ServerReshone()
    self:SetRouletteInfo(rouletteConfigId)
    local payData = ModelList.MainShopModel:GetPayData()
    if PurchaseHelper.IsEditorPurchase() then
        local productId = Csv.GetData("roulette",rouletteConfigId,"product_id")
        if not payData.pid or tostring(payData.pid) =="" or tostring(payData.pid) =="0" then
            self:ShowSpinAnimation()
        else
            ModelList.MainShopModel.C2S_NotifyServerIAPSuccess(nil,productId,payData.pid,nil,nil,nil,function()
                self:ShowSpinAnimation()
            end,function()
                self:Purchasing_failure_editor()
            end)
        end
    else
        if  payData == nil or fun.is_null(payData.pid) then
            UIUtil.show_common_popup(9025,true,nil)
            return
        end
        if not rouletteConfigId then 
            log.r("配表问题rouletteConfigId == >"..tostring(rouletteConfigId))

            return 
        end

        local productId = Csv.GetData("roulette",rouletteConfigId,"product_id")
        local product_name = Csv.GetData("appstorepurchaseconfig",productId,"product_name")
        productId = Csv.GetData("appstorepurchaseconfig",productId,"product_id")
        if not payData.pid or tostring(payData.pid) == "" then 
            if  self.Purchasing_failure then 
                self:Purchasing_failure()
            end 
        else
            PurchaseHelper.PurchasingType(6,product_name)
            PurchaseHelper.DoPurchasing(deep_copy(payData),nil,productId,payData.pid,function()
                self:Purchasing_success()
                end,function() 
                   self:Purchasing_failure()
               end)
        end 

        
    end
end

function RouletteFee:ShowSpinAnimation()
    self.reward_index = self:SetPointer()
    self._invokeTimer = Invoke(function()
        if fun.is_not_null(self.rotation) then
            local z = self.rotation.transform.localRotation.eulerAngles.z
            local ac = self:GetAnimationCurve()
            self.superView:PlayFeeSpin()

            for key, value in pairs(use_pointer) do
                if fun.is_not_null(value) then
                    AnimatorPlayHelper.Play(value,{"spin","pointer_spin"},false,nil)
                end
            end

            Anim.rotate(self.rotation,0,0, z - (360 * 3 + self.reward_items[self.reward_index]:GetRotate2Pos(z)),4,true,function()
                UISound.play("turntable_bigwin")
                UISound.play("turntable_bigwin_bgm")
                self:ShowRouletteReward()
            end,ac)

            UISound.play("turntable_spin")
        end

    end,0.5)
end

function RouletteFee:ShowRouletteReward()    
    self:PlayShowReward()
    if not self.reward_index  then
        self.reward_index = self:SetPointer()
    end
    self:DelayShowReward()
end

function RouletteFee:PopupRouletteReward(isSpinJeckpot,spinjackpotItem,spinRewardList,watchAd)
    Http.report_event("activity_spin_finish",{ispurchasewheeljackpot = isSpinJeckpot})
    if isSpinJeckpot then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.RouletteJackpotView,nil,nil,{value = spinjackpotItem[2],callback = function()
            ModelList.RouletteModel:C2S_RequestClaimRouletteReward()
        end})
    else
        --- 有转盘奖励，断线重连后会重新弹窗，故添加判断，有现成的奖励界面就不需要弹
        if ViewList.CollectRewardsAdView and ViewList.CollectRewardsAdView.isInit then
            ViewList.CollectRewardsAdView:Finish()
            --log.r("已经有CollectRewardsAdView 弹窗，先关掉奖励弹窗")
        end
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,spinRewardList,function()
            ModelList.RouletteModel:C2S_RequestClaimRouletteReward()
        end,nil,nil,nil,watchAd)
    end
end

function RouletteFee:SetClaimRewardResult()
    if self:IsJackpot() then
        Facade.SendNotification(NotifyName.Roulette.RouletteJackpotClose,self:GetJackpotItem()[1], function()
            self:SetRouletteInfo()
            self:SetSpinButton()
            self:ClearWinLight()
            self._fsm:GetCurState():Complete(self._fsm)
        end)
    else
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward)
        self:SetRouletteInfo()
        self:SetSpinButton()
        self:ClearWinLight()
        self._fsm:GetCurState():Complete(self._fsm)
    end
    self:RefreshVipAddition()
    self:SetVip()
end

return this