
 
-- "GamePlayShortPass/Base/States/BaseGamePassBaseRewardsOriginalState"

                                                                            -- BaseGamePassBaseItemOriginalState
local BaseGamePassBaseItemOriginalState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemOriginalState"
local BaseGamePassBaseItemLockState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemLockState"
local BaseGamePassBaseItemMatureState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemMatureState"
local BaseGamePassBaseItemAchieveState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemAchieveState"
local BaseGamePassBaseItemLockMarkState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemLockMarkState"
--local BaseGamePassBaseItemLockNopayState =  require "GamePlayShortPass/Base/States/BaseGamePassBaseItemLockNopayState"

--local BingoPassView = require "View/Bingopass/BingoPassView"

local BasePassItem = class("BasePassItem",BaseViewEx)  --BaseView:New("BasePassItem")
local this = BasePassItem
this.viewType = CanvasSortingOrderManager.LayerType.None
local csv_data_name = "task_pass"
local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_TASK_PASS_UP)

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

 

function BasePassItem:ctor(id,model)
    self._bingoPassId = id
    self:SetModel(model)
end


function BasePassItem:BuildFsm()
    self:DisposeFsm()
    self._fsmFree = Fsm.CreateFsm("BaseGamePassBaseItemFree",self,{
        BaseGamePassBaseItemOriginalState:New(),
        BaseGamePassBaseItemLockState:New(),
        BaseGamePassBaseItemMatureState:New(),
        BaseGamePassBaseItemAchieveState:New(),
        BaseGamePassBaseItemLockMarkState:New()
    })
    self._fsmFree:StartFsm("BaseGamePassBaseItemOriginalState")

    self._fsmFee = Fsm.CreateFsm("BaseGamePassBaseItemFee",self,{
        BaseGamePassBaseItemOriginalState:New(),
        BaseGamePassBaseItemLockState:New(),
        BaseGamePassBaseItemMatureState:New(),
        BaseGamePassBaseItemAchieveState:New(),
        BaseGamePassBaseItemLockMarkState:New()
    })
    self._fsmFee:StartFsm("BaseGamePassBaseItemOriginalState")
end

function BasePassItem:DisposeFsm()
    if self._fsmFree then
        self._fsmFree:Dispose()
        self._fsmFree = nil
    end
    if self._fsmFee then
        self._fsmFee:Dispose()
        self._fsmFee = nil
    end
end

function BasePassItem:Awake()
    self:on_init()
end

function BasePassItem:OnEnable()
    self:BuildFsm()
    self._isInit = true
    self:SetBingoPassInfo(self._bingoPassId)
end

function BasePassItem:OnDisable()
    self:StopTimer()
    self:DisposeFsm()
    self._isInit = nil
    params_pass_click = nil
end

function BasePassItem:GetPosY()
    if self.go then
        return self.go.transform.localPosition.y
    end
end


function BasePassItem:SetModel(model)
    self.model = model
end

function BasePassItem:GetModel()
    return self.model
end



function BasePassItem:IsShowGemBtn()
    return self:GetModel():GetLevel() + 1 == self._bingoPassId
end

function BasePassItem:IsTopLockItem()
    return self:GetModel():GetLevel() + 1 == self._bingoPassId
end

function BasePassItem:SetActive(active)
    if self.go then
        fun.set_active(self.go.transform,active)
    end
end

function BasePassItem:PlayRestAnima(skip)
    local passLevel = self:GetModel():GetLevel()
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

function BasePassItem:PlayCircleAnima(skip)
    local passLevel = self:GetModel():GetLevel()
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

function BasePassItem:PlayFreeLockAnima(skip)
    self.animna_free:Play("lock_idle",0,1)
end

function BasePassItem:PlayFreeMatureAnima(skip)
    if skip then
        self.animna_free:Play("collect_idle",0,1)
    else
        self.animna_free:Play("lock_collect",0,0)
        UISound.play("bingopass_unlock")
    end
end

function BasePassItem:PlayFreeAchieveAnima(skip)
    if skip then
        self.animna_free:Play("finish_idle",0,1)
    else
        self.animna_free:Play("collect_finish",0,0)
    end
end

function BasePassItem:PlayFeeLockAnima(skip)
    local passLevel = self:GetModel():GetLevel()
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

function BasePassItem:PlayFeeMatureAnima(skip)
    if skip then
        self.anima_fee:Play("collect_idle",0,1)
    else
        self.anima_fee:Play("lock_collect",0,0)
        UISound.play("bingopass_unlock")
    end
end

function BasePassItem:PlayFeeAchieveAnima(skip)
    if skip then
        self.anima_fee:Play("finish_idle",0,1)
    else
        self.anima_fee:Play("collect_finish",0,0)
    end
end

function BasePassItem:PlayBottomLockAnima(skip)
end

function BasePassItem:PlayBottomAchieveAnima(skip)
end

function BasePassItem:PlayBottomMatureAnima(skip)
end

function BasePassItem:SetBingoPassInfo(id)
    self._bingoPassId = id
    if self._isInit and self._bingoPassId then
        self:StopTimer()
        local data =  self:GetModel():GetRewardDataById(self._bingoPassId) --.GetData(csv_data_name,self._bingoPassId)

        if(data==nil)then 
            log.e(" data is nil "..tostring(self._bingoPassId))
        end

        if(data.free_reward==nil)then 
            fun.set_active(self.animna_free,false)
        else
            fun.set_active(self.animna_free,true)
        end
        

        self._fsmFree:GetCurState():ResetState(self._fsmFree)
        if self:GetModel():IsFreeReceived(self._bingoPassId) then
            self._fsmFree:GetCurState():Change2Achieve(self._fsmFree,1,true)
        elseif self:GetModel():IsFreeNoClaim(self._bingoPassId) then 
            self._fsmFree:GetCurState():Change2Mature(self._fsmFree,1,true)
        else
            self._fsmFree:GetCurState():Change2Lock(self._fsmFree,1,true)
        end

        self._fsmFee:GetCurState():ResetState(self._fsmFee)
        if self:GetModel():IsPayReceived(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Achieve(self._fsmFee,2,true)
        elseif self:GetModel():IsPayNoClaim(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Mature(self._fsmFee,2,true)
        else
            self._fsmFee:GetCurState():Change2Lock(self._fsmFee,2,true)
        end

        if data.free_reward_icon and data.free_reward_icon ~= "0" then
            Cache.GetSpriteByName("ItemAtlas",data.free_reward_icon,function(img)
                if img then
                    self.img_icon.sprite = img
                    self.img_icon:SetNativeSize()
                else
                    log.r("========================>>missing icon: " .. data.free_reward_icon)    
                end
            end)
        end
        if data.pay_reward_icon and data.pay_reward_icon ~= "0" then
            Cache.GetSpriteByName("ItemAtlas",data.pay_reward_icon,function(img)
                if img then
                    self.img_icon2.sprite = img
                    self.img_icon2:SetNativeSize()
                else
                    log.r("========================>>missing icon: " .. data.pay_reward_icon)    
                end
            end)
        end
        if data.free_reward then
            self.text_value.text = fun.FormatText({id =  data.free_reward[1],value = data.free_reward[2] or 0})
            
            -- fun.NumInsertComma(data.free_reward[2])
        end
        if data.pay_reward then
            self.text_value2.text = fun.FormatText({id =  data.pay_reward[1][1],value = data.pay_reward[1][2] or 0})
            -- self.text_value2.text = fun.NumInsertComma(data.pay_reward[1][2])
        end
        self.text_level.text = tostring(self._bingoPassId)
        self.text_cost.text = tostring(data.unlock_diamond)
    end
end

function BasePassItem:StartTimer()
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

function BasePassItem:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function BasePassItem:RefreshInfo()
    if self._isInit then
        if self:GetModel():IsFreeReceived(self._bingoPassId) then
            self._fsmFree:GetCurState():Change2Achieve(self._fsmFree,1,false)
        elseif self:GetModel():IsFreeNoClaim(self._bingoPassId) then 
            self._fsmFree:GetCurState():Change2Mature(self._fsmFree,1,false)
        else
            self._fsmFree:GetCurState():Change2Lock(self._fsmFree,1,false)
        end
    
        if self:GetModel():IsPayReceived(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Achieve(self._fsmFee,2,false)
        elseif self:GetModel():IsPayNoClaim(self._bingoPassId) then
            self._fsmFee:GetCurState():Change2Mature(self._fsmFee,2,false)
        else
            self._fsmFee:GetCurState():Change2Lock(self._fsmFee,2,false)
        end
    end
end

function BasePassItem:on_btn_collect_click()
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ClaimReward,self)
end

function BasePassItem:on_btn_collect2_click()
    AddLockCountOneStep()
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ClaimReward,self)
end

function BasePassItem:DoClaimReward()
    AddLockCountOneStep()
    self:GetModel():C2S_RequestClaimReward()
end

function BasePassItem:on_btn_gem_click()
    local data = self:GetModel():GetRewardDataById(self._bingoPassId)--Csv.GetData(csv_data_name,self._bingoPassId)
    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable,8008,Resource.diamon,data.unlock_diamond,function()
        Facade.SendNotification(NotifyName.GamePlayShortPassView.GemUnlockLevel,self)
    end,nil,nil,SHOP_TYPE.SHOP_TYPE_DIAMONDS,nil,CanvasSortingOrderManager.LayerType.TopConsole)
end

function BasePassItem:DoGemUnlockLevel()
    self:GetModel():C2S_RequestDiamondUplevel()
end

function BasePassItem:on_btn_video_click()
    if _watchADUtility:IsAbleWatchAd() then
        Facade.SendNotification(NotifyName.GamePlayShortPassView.WatchAd,self)
    end
end

function BasePassItem:WatchAdUnlockLevel()
    local playId = ModelList.GameActivityPassModel.GetCurrentId()
    _watchADUtility:WatchVideo(self,self.WatchVideoCallback,"taskPass_skiptime",{playId=playId})
end

function BasePassItem:WatchVideoCallback(isBreak)
    if isBreak then
        --self._fsmFee:GetCurState():Complete(self._fsmFee)
    else
          
    end
end

function BasePassItem:ShowBingoPassTips()
    local level = self:GetModel():GetLevel()
    if level < self._bingoPassId then
        -- local tipView = require "View/Bingopass/BingoPassShowTipView"
        -- Facade.SendNotification(NotifyName.ShowUI,tipView,nil,nil,params_pass_click)  --TODO  暂时屏蔽endy
    -- else
    --     Facade.SendNotification(NotifyName.ShowUI,ViewList.BingoPassPurchaseView)

    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView, "PassShowTipView",params_pass_click)
    end
end

function BasePassItem:on_btn_free_click()
    params_pass_click = {self.btn_free.transform.position,self._bingoPassId}
    self._fsmFree:GetCurState():ClickPassItem(self._fsmFree)
end

function BasePassItem:on_btn_fee_click()
    params_pass_click = {self.btn_fee.transform.position,self._bingoPassId}
    self._fsmFee:GetCurState():ClickPassItem(self._fsmFee) 
end

return this