local setmetatable = setmetatable
---@class GamePowerUpView : BaseChildView
local GamePowerUpView = BaseChildView:New()
local this = GamePowerUpView;
GamePowerUpView.__index = GamePowerUpView

this.auto_bind_ui_items = {
    "Slider",
    "animator",
    "btn_auto",
    "PuImage",
    "btn_close_auto",
    "zuanshi",
    "Icon",
    "Count",
    "Count2",
    "BtnPower",
    "UseTip",
}

this.ignore_auto_disable = false        --需求，如果玩家收集了LuckyBang，就不会禁用自动使用PU
this.auto_state = true                  --当前是否会自动使用pu，受到多种情况的影响
this.play_control_auto_state = true     --玩家操作自动使用开关时，记录状态
this.curr_power = 0
this.max_power = 0
this.allPuData = {} --powerup 卡牌
this.totalUsedCount = 0

local moduleList = require("View.Bingo.BattleModuleList")

function GamePowerUpView:New(name)
    local o = { name = name }
    setmetatable(o, { __index = GamePowerUpView })
    return o
end

function GamePowerUpView:Init(obj, parent_ref)
    self:on_init(obj, parent_ref)
    self.model = ModelList.BattleModel:GetCurrModel()
    self:InitData()
    self:SetAutoState()
    self:RegisterEvent()
    moduleList.LoadPowerModule(self)
end

--开始
function GamePowerUpView:Enable(cb)
    fun.set_active(self.go, true)
    
    fun.set_active(self.UseTip, false)
    fun.set_gameobject_scale(self.UseTip, 0, 0, 0)
    
    if GetTableLength(self.allPuData) == 0 then
        self.have_power_use = false
        self.animator:Play("over")
    else
        self:SetCardDetail(self.allPuData[1])
        self.have_power_use = true
        self:ResetCharge()
    end

    if self.model:GetGameType() ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        ModelList.ApplicationGuideModel:LoadGuide("GameBingoView")
    end

    fun.SafeCall(cb)
end

function GamePowerUpView:OnDisable()
    self:UnRegisterEvent()

    self.curr_power = 0
    self.max_power = 0
    self.totalUsedCount = 0
    self.allPuData = {} --powerup 卡牌
    self.curShowPuData = nil
    self.isCloseAutoOnLowBingoCount = false
    self.isInChargeSlider = false
    self.auto_state = true
    self.play_control_auto_state = true
    
    moduleList.UnLoadPowerModule()
    self:Close()
    Event.Brocast(EventName.ApplicationGuide_PowerUp, false)
    ModelList.ApplicationGuideModel:UnloadGuide("GameBingoView")
end

function GamePowerUpView:OnDestroy()
    self:Destroy()

    if self.sliderAnim then
        self.sliderAnim:Kill()
        self.sliderAnim = nil
    end
end

function GamePowerUpView:RegisterEvent()
    Event.AddListener(Notes.START_POWERUP_ENABLE, self.Enable, self)
    Event.AddListener(Notes.SYNC_SIGN, self.AddCharge, self)
    Event.AddListener(EventName.Bingo_Refresh_BingoCount, self.OnRefreshBingoCount, self)
    Event.AddListener(NotifyName.RewardCollect.SignCollectReward, self.SignCollectReward, self)
    --Event.AddListener(EventName.Sign_LastStar_Trigger_AutoUse,self.TryAutoUseCard,self)
end

function GamePowerUpView:UnRegisterEvent()
    Event.RemoveListener(Notes.START_POWERUP_ENABLE, self.Enable, self)
    Event.RemoveListener(Notes.SYNC_SIGN, self.AddCharge, self)
    Event.RemoveListener(EventName.Bingo_Refresh_BingoCount, self.OnRefreshBingoCount, self)
    Event.RemoveListener(NotifyName.RewardCollect.SignCollectReward, self.SignCollectReward, self)
    --Event.RemoveListener(EventName.Sign_LastStar_Trigger_AutoUse,self.TryAutoUseCard,self)
end

function GamePowerUpView:InitData()
    self.curr_power = 0
    self.max_power = 0
    self.totalUsedCount = 0
    self.allPuData = {} --powerup 卡牌
    self.curShowPuData = nil
    self.isCloseAutoOnLowBingoCount = false
    self.isInChargeSlider = false
    self.auto_state = true
    self.play_control_auto_state = true
    
    local powerUpData = self.model:GetPowerUps()
    self.allPuData = deep_copy(powerUpData.powerUpList)
    table.sort(self.allPuData, function(a, b) 
        return a.pIndex < b.pIndex 
    end)
    table.walk(self.allPuData, function(v, k)
        v.is_use = false
    end)
end

function GamePowerUpView:SetAutoState()
    --if GetTableLength(self.allPuData) > 0 then
        self.auto_state = true
    --else
    --    self.auto_state = false
    --end

    if ModelList.GuideModel:IsFirstBattle() then
        self.auto_state = false
        self.play_control_auto_state = false
    end
    
    fun.set_active(self.btn_auto, self.auto_state)
    fun.set_active(self.btn_close_auto, not self.auto_state)
    --fun.set_active(self.BtnPower, not self.auto_state)
    fun.set_active(self.zuanshi, false)
end

function GamePowerUpView:SetCardDetail(puData)
    self.curShowPuData = puData
    self.max_power = puData.powerUpAcc
    
    local puCfg = Csv.GetData("new_powerup", puData.powerUpId)
    local iconName = puCfg.icon
    --local puItemCfg = Csv.GetData("new_item", puCfg.item_id)
    --if puItemCfg and puItemCfg.result[1] == 4 then
    --    --箱子Pu
    --    local boxID = ModelList.BattleModel:GetBattleBoxID()
    --    if boxID then
    --        iconName = Csv.GetData("new_item", boxID, "icon")
    --    end
    --end
    self.PuImage.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", iconName)

    if puData.diamondUse > 0 then 
        self.auto_state = false
        fun.set_active(self.btn_auto, false)
        fun.set_active(self.btn_close_auto, false)
        --fun.set_active(self.BtnPower, true)
        fun.set_active(self.zuanshi, true)

        self.Count.text = puData.diamondUse
        self.Count2.text = puData.diamondUse
        local diamond = ModelList.ItemModel.get_diamond()
        local isEnoughDiamond = diamond >= puData.diamondUse
        fun.set_active(self.Count, isEnoughDiamond)
        fun.set_active(self.Count2, not isEnoughDiamond)
    else
        self.auto_state = self.play_control_auto_state
        fun.set_active(self.btn_auto, self.play_control_auto_state)
        fun.set_active(self.btn_close_auto, not self.play_control_auto_state)
        --fun.set_active(self.BtnPower, not self.play_control_auto_state)
        fun.set_active(self.zuanshi, false)
    end
end

--使用powerup 卡片
function GamePowerUpView:CheckUsePowerUpCard()
    if BingoBangEntry.IsInBattleSettle then
        log.r("[GamePowerUpView] CheckUsePowerUpCard, IsInBattleSettle return")
        return
    end    
    
    if not this.curShowPuData then
        log.r("[GamePowerUpView] CheckUsePowerUpCard, no power to use")
        return
    end

    this.model.ReqUsePowerUp(this.curShowPuData.pIndex, this.curShowPuData.powerUpId, function(success)
        if success then
            this:UsePowerUpCard()
        else
            if this.UseTipTimer then
                LuaTimer:Remove(this.UseTipTimer)
                this.UseTipTimer = nil
            end
            
            fun.set_gameobject_scale(this.UseTip, 0, 0, 0)
            fun.set_active(this.UseTip, true)
            Anim.scale_to_xy(this.UseTip, 1, 1, 0.2, function() end)
            this.UseTipTimer = LuaTimer:SetDelayFunction(3, function()
                fun.set_active(this.UseTip, false)
                fun.set_gameobject_scale(this.UseTip, 0, 0, 0)
            end)
        end
    end)
end

--使用pu后
function GamePowerUpView:UsePowerUpCard()
    self.totalUsedCount = self.totalUsedCount + 1
    self.animator:Play("fullend")
    Event.Brocast(EventName.CardPower_Use_Power_Card, this.curShowPuData.powerUpId, this.curShowPuData.pIndex)
    self:HideUsedPowerCard()

    self:ResetCharge()
    ModelList.GuideModel.RechargeOver(false)
end

--使用pu后
function GamePowerUpView:HideUsedPowerCard()
    this.curShowPuData.is_use = true
    
    local is_all_used = true
    for i = 1, #this.allPuData do
        if this.allPuData[i].is_use ~= true then
            is_all_used = false
            self:SetCardDetail(this.allPuData[i])
            break
        end
    end

    if is_all_used then
        this.have_power_use = false
        self.animator:Play("over")
    end
end

--足够充能
function GamePowerUpView:IsEnoughCharge()
    return this.curr_power >= this.max_power
end

--重置充能
function GamePowerUpView:ResetCharge()
    self.curr_power = 0
    self.Slider.fillAmount = 0
end

function GamePowerUpView:AddCharge()
    if not self.have_power_use then
        log.r("[GamePowerUpView] have no power to use.")
        return
    end
    
    if self.curr_power < self.max_power then
        self.curr_power = self.curr_power + 1
        UISound.play("powerup_charge")

        self:ChargeSlider(function()
            if self:IsEnoughCharge() then
                self.animator:Play("full")
                ModelList.GuideModel.RechargeOver(true)
                self:AutoUsePower()
            end
        end)
    end
end

--充能经验条增长动效
function GamePowerUpView:ChargeSlider(cb)
    self.isInChargeSlider = true
    
    local target_value = this.curr_power / this.max_power
    if self.sliderAnim then
        self.sliderAnim:Kill()

        ----上次动画没播放完成
        --if self.lastTargetValue and self.lastTargetValue > target_value then
        --    self.animator:Play("act")
        --    self.sliderAnim = Anim.slide_to(self.Slider, nil, 1 * 100, MCT.power_card_slider_time, function()
        --        self.animator:Play("full")
        --        self.sliderAnim = Anim.slide_to(self.Slider, nil, target_value * 100, MCT.power_card_slider_time, function()
        --            fun.SafeCall(cb)
        --        end)
        --    end)
        --    self.lastTargetValue = target_value
        --    return
        --end
    end

    self.lastTargetValue = target_value
    self.animator:Play("act")
    
    local currentValue = self.Slider.fillAmount
    self.sliderAnim = Anim.do_smooth_float_update(currentValue,target_value,MCT.power_card_slider_time,function(num)
        self.Slider.fillAmount = num
    end,function()
        self.isInChargeSlider = false
        fun.SafeCall(cb)
    end)--:SetEase(DG.Tweening.Ease.InOutSine)
end

--点击使用powerup
function GamePowerUpView:ClickPowerUp()
    --if not self.auto_state and self.have_power_use and self:IsEnoughCharge() then
    if self.have_power_use and self:IsEnoughCharge() then
        self:CheckUsePowerUpCard()
    end
end

function GamePowerUpView:on_btn_close_auto_click()
    if ModelList.GuideModel:IsFirstBattle() then
        return
    end
    
    if not self.auto_state then
        self.auto_state = true
        self.play_control_auto_state = true

        fun.set_active(self.btn_auto, self.auto_state)
        fun.set_active(self.btn_close_auto, not self.auto_state)
        --fun.set_active(self.BtnPower, not self.auto_state)

        if self:IsEnoughCharge() then
            self:AutoUsePower()
        end
    end

    Event.Brocast(EventName.PowerUpAutoStateChange, self.auto_state)
end

function GamePowerUpView:on_btn_auto_click()
    if ModelList.GuideModel:IsFirstBattle() then
        return
    end
    
    if self.auto_state then
        self.auto_state = false
        self.play_control_auto_state = false

        fun.set_active(self.btn_auto, self.auto_state)
        fun.set_active(self.btn_close_auto, not self.auto_state)
        --fun.set_active(self.BtnPower, not self.auto_state)
    end

    Event.Brocast(EventName.PowerUpAutoStateChange, self.auto_state)
end

function GamePowerUpView:AutoUsePower()
    if self.auto_state and self.have_power_use then
        self:CheckUsePowerUpCard()
    end
end

function GamePowerUpView:IsAuto()
    return self.auto_state == true
end

function GamePowerUpView:GetUsedUpCount()
    local count = 0
    for k, v in pairs(this.allPuData) do
        if v.is_use then
            count = count + 1
        end
    end
    return count
end

function GamePowerUpView:OnRefreshBingoCount(curCount)
    if curCount <= 3 and not self.isCloseAutoOnLowBingoCount and not self.ignore_auto_disable then
        self.isCloseAutoOnLowBingoCount = true
        
        self.auto_state = false
        --fun.set_active(self.btn_auto, self.auto_state)
        --fun.set_active(self.btn_close_auto, not self.auto_state)
        --fun.set_active(self.BtnPower, not self.auto_state)
        Event.Brocast(EventName.PowerUpAutoStateChange, self.auto_state)
    end
end

function GamePowerUpView:SignCollectReward(cardId, cellIndex, rewards)
    table.walk(rewards, function(rewardItemID)
        --收集到LuckyBang道具
        if rewardItemID == 817 or rewardItemID == 910811 then
            self.ignore_auto_disable = true
            
            --在禁用后收集到LuckyBang，则禁用失效。自动使用PU功能恢复
            if self.auto_state == false and self.play_control_auto_state then
                self.auto_state = true
            end
        end
    end)
end

function GamePowerUpView:IsOpenAutoUse()
    return self.auto_state
end

function GamePowerUpView:GetReportData()
    --本局下发的 PU 数量、本局已使用 PU 数量
    local pudeliver, puused = GetTableLength(self.allPuData), self.totalUsedCount
    --卡在第几个 PU、被卡住的 PU 名称 / ID、PU 的钻石兑换价
    local publockindex, publockname, pudiamondcost
    table.walk(self.allPuData, function(v, k)
        if not v.is_use and not publockindex then
            publockindex = v.pIndex
            publockname = v.powerUpId
            pudiamondcost = v.diamondUse
        end
    end)
    --是否已充能完毕
    local puischarged = self:IsEnoughCharge()
    return pudeliver, puused, publockindex, publockname, pudiamondcost, puischarged
end

return this