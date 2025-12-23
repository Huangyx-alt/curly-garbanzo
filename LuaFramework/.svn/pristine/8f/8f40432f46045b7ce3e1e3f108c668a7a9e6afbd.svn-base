

local BingoPassItemOriginalState =  require "View/Bingopass/states/BingoPassItemOriginalState"
local BingoPassItemLockState =  require "View/Bingopass/states/BingoPassItemLockState"
local BingoPassItemMatureState =  require "View/Bingopass/states/BingoPassItemMatureState"
local BingoPassItemAchieveState =  require "View/Bingopass/states/BingoPassItemAchieveState"
local BingoPassItemLockNopayState =  require "View/Bingopass/states/BingoPassItemLockNopayState"

local BingoPassItem = require "View/Bingopass/BingoPassItem"

local BingoPassBottomItem = BingoPassItem:New("BingoPassBottomItem")
local this = BingoPassBottomItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local max_level = nil

this.auto_bind_ui_items = {
    "btn_collect",
    "text_activate",
    "anima",
    "btn_bigowin"
}

function BingoPassBottomItem:OnDisable()
    self:DisposeFsm()
    self._isInit = nil
    max_level = nil
end

function BingoPassBottomItem:SetMaxLevel(level)
    max_level = level
end

function BingoPassBottomItem:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BingoPassBottomItem",self,{
        BingoPassItemOriginalState:New(),
        BingoPassItemLockState:New(),
        BingoPassItemMatureState:New(),
        BingoPassItemAchieveState:New(),
        BingoPassItemLockNopayState:New()
    })
    self._fsm:StartFsm("BingoPassItemOriginalState")
end

function BingoPassBottomItem:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BingoPassBottomItem:SetBingoPassInfo(id)
    self._bingoPassId = id
    local rewardIndex = nil
    if max_level then
        rewardIndex = max_level + 1
    else
        rewardIndex = 101
    end
    if self._isInit and self._bingoPassId then
        self._fsm:GetCurState():ResetState(self._fsm)
        if ModelList.BingopassModel:GetLevel() < (max_level or 100) then
            if not ModelList.BingopassModel:IsAnyPayment() then
                self._fsm:GetCurState():Change2Lock(self._fsm,3,true)
            else
                self._fsm:GetCurState():Change2LockNopay(self._fsm,3,true)
            end
        elseif ModelList.BingopassModel:IsPayReceived(rewardIndex) then
            self._fsm:GetCurState():Change2Achieve(self._fsm,3,true)
        elseif not ModelList.BingopassModel:IsAnyPayment() then
            self._fsm:GetCurState():Change2LockNopay(self._fsm,3,false)
        else
            self._fsm:GetCurState():Change2Mature(self._fsm,3,true)
        end
    end
end

function BingoPassBottomItem:RefreshInfo()
    local rewardIndex = nil
    if max_level then
        rewardIndex = max_level + 1
    else
        rewardIndex = 101
    end
    if self._isInit then
        if ModelList.BingopassModel:GetLevel() < (max_level or 100) then
            if not ModelList.BingopassModel:IsAnyPayment() then
                self._fsm:GetCurState():Change2Lock(self._fsm,3,false)
            else
                self._fsm:GetCurState():Change2LockNopay(self._fsm,3,false)
            end
        elseif ModelList.BingopassModel:IsPayReceived(rewardIndex) then
            self._fsm:GetCurState():Change2Achieve(self._fsm,3,false)
        elseif not ModelList.BingopassModel:IsAnyPayment() then
            self._fsm:GetCurState():Change2LockNopay(self._fsm,3,false)
        else    
            self._fsm:GetCurState():Change2Mature(self._fsm,3,false)
        end
    end
end

function BingoPassBottomItem:on_btn_collect_click()
    self.clickType = PassRewardType.Purchase
    Facade.SendNotification(NotifyName.BingoPass.ClaimReward,self)
end

function BingoPassBottomItem:on_btn_bigowin_click()
    if not self._fsm:GetCurState():IsAchieve() then
        local rewards = Csv.GetData("season_pass",self._bingoPassId,"pay_reward")
        local params = {
            rewards = rewards, 
            pos = self.btn_bigowin.transform.position, 
            dir = RewardShowTipOrientation.down, 
            offset = Vector3.New(0,340,0),
            exclude = {self.btn_bigowin},
            --item2 = true
        }
        table.each(rewards, function(v)
            if not v.id then v.id = v[1] end
            if not v.value then v.value = v[2] end
        end)
        Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
    end
end

function BingoPassBottomItem:PlayBottomLockAnima(skip)
    if skip then
        self.anima:Play("lock",0,1)
    else
        self.anima:Play("lock",0,0)
    end
end

function BingoPassBottomItem:PlayBottomLockNopayAnima(skip)
    if skip then
        self.anima:Play("get",0,1)
    else
        self.anima:Play("lock_get",0,1)
    end
end

function BingoPassBottomItem:PlayBottomAchieveAnima(skip)
    if skip then
        self.anima:Play("finish",0,1)
    else
        self.anima:Play("collect_finish",0,0)
    end
end

function BingoPassBottomItem:PlayBottomMatureAnima(skip)
    if skip then
        self.anima:Play("collect",0,1)
    else
        self.anima:Play("get_collect",0,0)
    end
end

return this