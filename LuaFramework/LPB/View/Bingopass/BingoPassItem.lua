
--local BingoPassItemBaseState =  require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemOriginalState =  require "View/Bingopass/states/BingoPassItemOriginalState"
local BingoPassItemLockState =  require "View/Bingopass/states/BingoPassItemLockState"
local BingoPassItemMatureState =  require "View/Bingopass/states/BingoPassItemMatureState"
local BingoPassItemAchieveState =  require "View/Bingopass/states/BingoPassItemAchieveState"
local BingoPassItemLockMarkState =  require "View/Bingopass/states/BingoPassItemLockMarkState"
--local BingoPassItemLockNopayState =  require "View/Bingopass/states/BingoPassItemLockNopayState"

--local BingoPassView = require "View/Bingopass/BingoPassView"

local BingoPassItem = BaseView:New("BingoPassItem")
local this = BingoPassItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_SEASON_UP)

local params_pass_click = nil

this.auto_bind_ui_items = {
    "img_icon",
    "img_icon2",
    "img_lock",
    "img_lock2",
    "img_hook",
    "img_hook2",
    "btn_collect",
    "btn_collect2",
    "text_value",
    "text_value2",
    "btn_gem",
    "btn_video",
    "text_level",
    "animna_free",
    "anima_fee",
    "anima_circle",
    "anima_gem",
    "anima_video",
    "text_cost",
    "btn_free",
    "btn_fee"
}

function BingoPassItem:New(id)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    self._bingoPassId = id
    return o
end

function BingoPassItem:BuildFsm()
    self:DisposeFsm()
    self._fsmFree = Fsm.CreateFsm("BingoPassItemFree",self,{
        BingoPassItemOriginalState:New(),
        BingoPassItemLockState:New(),
        BingoPassItemMatureState:New(),
        BingoPassItemAchieveState:New(),
        BingoPassItemLockMarkState:New()
    })
    self._fsmFree:StartFsm("BingoPassItemOriginalState")

    self._fsmFee = Fsm.CreateFsm("BingoPassItemFee",self,{
        BingoPassItemOriginalState:New(),
        BingoPassItemLockState:New(),
        BingoPassItemMatureState:New(),
        BingoPassItemAchieveState:New(),
        BingoPassItemLockMarkState:New()
    })
    self._fsmFee:StartFsm("BingoPassItemOriginalState")
end

function BingoPassItem:DisposeFsm()
    if self._fsmFree then
        self._fsmFree:Dispose()
        self._fsmFree = nil
    end
    if self._fsmFee then
        self._fsmFee:Dispose()
        self._fsmFee = nil
    end
end

function BingoPassItem:Awake()
    self:on_init()
end

function BingoPassItem:OnEnable()
    self:BuildFsm()
    self._isInit = true
    self:SetBingoPassInfo(self._bingoPassId)
end

function BingoPassItem:OnDisable()
    self:StopTimer()
    self:DisposeFsm()
    self._isInit = nil
    params_pass_click = nil
end

function BingoPassItem:GetPosY()
    if self.go then
        return self.go.transform.localPosition.y
    end
end

function BingoPassItem:IsShowGemBtn()
    return ModelList.BingopassModel:GetLevel() + 1 == self._bingoPassId
end

function BingoPassItem:IsTopLockItem()
    return ModelList.BingopassModel:GetLevel() + 1 == self._bingoPassId
end

function BingoPassItem:SetActive(active)
    if self.go then
        fun.set_active(self.go.transform,active)
    end
end

function BingoPassItem:PlayRestAnima(skip)
    local passLevel = ModelList.BingopassModel:GetLevel()
    if passLevel + 1 == self._bingoPassId then
        if skip then
            self.anima_gem:Play("start",0,1)
        else
            self.anima_gem:Play("start",0,0)    
        end
        local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
        if isBigR then
            self.anima_video:Play("end",0,1)
        elseif _watchADUtility:IsAbleWatchAd() then
            if skip then
                self.anima_video:Play("start",0,1)
            else
                self.anima_video:Play("start",0,0)
            end
        else
            self.anima_video:Play("end",0,1)
            if _watchADUtility:IsAdCountAvailable() then
                self:StartTimer()
            end 
        end
    else
        self.anima_gem:Play("end",0,1)
        self.anima_video:Play("end",0,1)
    end
end

function BingoPassItem:PlayCircleAnima(skip)
    local passLevel = ModelList.BingopassModel:GetLevel()
    if self._bingoPassId > passLevel then
        self.anima_circle:Play("lock_idle",0,1)
    else
        if skip then
            self.anima_circle:Play("show_idle",0,1)    
        else
            self.anima_circle:Play("show",0,0)
        end
    end
end

function BingoPassItem:PlayFreeLockAnima(skip)
    self.animna_free:Play("lock_idle",0,1)
end

function BingoPassItem:PlayFreeMatureAnima(skip)
    if skip then
        self.animna_free:Play("collect_idle",0,1)
    else
        self.animna_free:Play("lock_collect",0,0)
        UISound.play("bingopass_unlock")
    end
end

function BingoPassItem:PlayFreeAchieveAnima(skip)
    if skip then
        self.animna_free:Play("finish_idle",0,1)
    else
        self.animna_free:Play("collect_finish",0,0)
    end
end

function BingoPassItem:PlayFeeLockAnima(skip)
    local passLevel = ModelList.BingopassModel:GetLevel()
    if self._bingoPassId == passLevel then
        if skip then
            self.anima_fee:Play("Willopen_idle",0,1)
        else
            self.anima_fee:Play("Willopen",0,0)
        end
    else
        self.anima_fee:Play("lock_idle",0,1)
    end
end

function BingoPassItem:PlayFeeMatureAnima(skip)
    if skip then
        self.anima_fee:Play("collect_idle",0,1)
    else
        self.anima_fee:Play("lock_collect",0,0)
        UISound.play("bingopass_unlock")
    end
end

function BingoPassItem:PlayFeeAchieveAnima(skip)
    if skip then
        self.anima_fee:Play("finish_idle",0,1)
    else
        self.anima_fee:Play("collect_finish",0,0)
    end
end

function BingoPassItem:PlayBottomLockAnima(skip)
end

function BingoPassItem:PlayBottomAchieveAnima(skip)
end

function BingoPassItem:PlayBottomMatureAnima(skip)
end

function BingoPassItem:SetBingoPassInfo(id)
    self.clickType = nil
    self._bingoPassId = id
    if self._isInit and self._bingoPassId then
        self:StopTimer()
        local data = Csv.GetData("season_pass",self._bingoPassId)
        fun.set_active(self.animna_free,data.free_reward[1] ~= 0)

        self._fsmFree:GetCurState():ResetState(self._fsmFree)
        if ModelList.BingopassModel:IsFreeReceived(self._bingoPassId) then
            self._fsmFree:GetCurState():Change2Achieve(self._fsmFree,1,true)
        elseif ModelList.BingopassModel:IsFreeNoClaim(self._bingoPassId) then 
            self._fsmFree:GetCurState():Change2Mature(self._fsmFree,1,true)
        else
            self._fsmFree:GetCurState():Change2Lock(self._fsmFree,1,true)
        end

        self._fsmFee:GetCurState():ResetState(self._fsmFee)
        if ModelList.BingopassModel:IsPayReceived(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Achieve(self._fsmFee,2,true)
        elseif ModelList.BingopassModel:IsPayNoClaim(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Mature(self._fsmFee,2,true)
        else
            self._fsmFee:GetCurState():Change2Lock(self._fsmFee,2,true)
        end

        if data.free_reward_icon and data.free_reward_icon ~= "0" then
            self.img_icon.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", data.free_reward_icon)
            --self.img_icon:SetNativeSize()
        end
        if data.pay_reward_icon and data.pay_reward_icon ~= "0" then
            self.img_icon2.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", data.pay_reward_icon)
            --self.img_icon2:SetNativeSize()
        end
        if data.free_reward_description then
            self.text_value.text = fun.NumInsertComma(data.free_reward_description[2])
        end
        if data.pay_reward_description then
            self.text_value2.text = fun.NumInsertComma(data.pay_reward_description[1][2])
        end
        self.text_level.text = tostring(self._bingoPassId)
        self.text_cost.text = tostring(data.unlock_diamond)
    end
end

function BingoPassItem:StartTimer()
    self:StopTimer()
    self._timer = Timer.New(function()
        if _watchADUtility:IsAbleWatchAd() then
            self:StopTimer()
            local isBigR = ModelList.regularlyAwardModel:CheckUserTypes()
            if not isBigR then
                self.anima_video:Play("start",0,0)
            end
        end
    end,1,-1)
    self._timer:Start()
end

function BingoPassItem:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function BingoPassItem:RefreshInfo()
    if self._isInit then
        if ModelList.BingopassModel:IsFreeReceived(self._bingoPassId) then
            self._fsmFree:GetCurState():Change2Achieve(self._fsmFree,1,false)
        elseif ModelList.BingopassModel:IsFreeNoClaim(self._bingoPassId) then 
            self._fsmFree:GetCurState():Change2Mature(self._fsmFree,1,false)
        else
            self._fsmFree:GetCurState():Change2Lock(self._fsmFree,1,false)
        end
    
        if ModelList.BingopassModel:IsPayReceived(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Achieve(self._fsmFee,2,false)
        elseif ModelList.BingopassModel:IsPayNoClaim(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Mature(self._fsmFee,2,false)
        else
            self._fsmFee:GetCurState():Change2Lock(self._fsmFee,2,false)
        end
    end
end

function BingoPassItem:on_btn_collect_click()
    if not self.clickType then
        self.clickType = PassRewardType.Free
    end
    Facade.SendNotification(NotifyName.BingoPass.ClaimReward,self)
end

function BingoPassItem:on_btn_collect2_click()
    AddLockCountOneStep()
    if not self.clickType then
        self.clickType = PassRewardType.Purchase
    end
    Facade.SendNotification(NotifyName.BingoPass.ClaimReward,self)
end

function BingoPassItem:DoClaimReward()
    AddLockCountOneStep()
    ModelList.BingopassModel:C2S_RequestClaimReward(self._bingoPassId,self.clickType)
end

function BingoPassItem:on_btn_gem_click()
    local data = Csv.GetData("season_pass",self._bingoPassId)
    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable,8008,Resource.diamon,data.unlock_diamond,function()
        Facade.SendNotification(NotifyName.BingoPass.GemUnlockLevel,self)
    end,nil,nil,SHOP_TYPE.SHOP_TYPE_DIAMONDS,nil,CanvasSortingOrderManager.LayerType.TopConsole)
end

function BingoPassItem:DoGemUnlockLevel()
    ModelList.BingopassModel:C2S_RequestDiamondUplevel()
end

function BingoPassItem:on_btn_video_click()
    if _watchADUtility:IsAbleWatchAd() then
        Facade.SendNotification(NotifyName.BingoPass.WatchAd,self)
    end
end

function BingoPassItem:WatchAdUnlockLevel()
    _watchADUtility:WatchVideo(self,self.WatchVideoCallback,"BingoPass_skiptime")
end

function BingoPassItem:WatchVideoCallback(isBreak)
    if isBreak then
        --self._fsmFee:GetCurState():Complete(self._fsmFee)
    else
          
    end
end

function BingoPassItem:ShowBingoPassTips()
    --local level = ModelList.BingopassModel:GetLevel()
    --if level < self._bingoPassId then
    --    local tipView = require "View/Bingopass/BingoPassShowTipView"
    --    Facade.SendNotification(NotifyName.ShowUI,tipView,nil,nil,params_pass_click)
    --else
    --    Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)
    --end
end

function BingoPassItem:on_btn_free_click()
    params_pass_click = {self.btn_free.transform.position,self._bingoPassId}
    self.clickType = PassRewardType.Free
    self._fsmFree:GetCurState():ClickPassItem(self._fsmFree)
end

function BingoPassItem:on_btn_fee_click()
    params_pass_click = {self.btn_fee.transform.position,self._bingoPassId}
    self.clickType = PassRewardType.Purchase
    self._fsmFee:GetCurState():ClickPassItem(self._fsmFee) 
end

return this