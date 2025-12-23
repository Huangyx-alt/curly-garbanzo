MiniGameStealthView = BaseMiniGame01:New("MiniGameStealthView","MiniGame01Atlas","luaprefab_minigame_minigame01")
local this = MiniGameStealthView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local collectRewardItemList = nil
local expelThiefType = nil
local expelThiefState = nil
local expelThiefCost = nil

local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_BANISH_THIEF)

this.auto_bind_ui_items = {
    "anima",
    "content",
    "property",
    "btn_keepPlay",
    "btn_giveup",
    "btn_freetokeep",
    "extraFree",
    "text_warn",
    "text_cost",
    "rabbit",
    "rabbitAnima"
}

function MiniGameStealthView:Awake(obj)
    self:on_init()
end

function MiniGameStealthView:OnEnable(params)
    Facade.RegisterView(self)
    local rewards = ModelList.MiniGameModel:GetAllAcquiredReward()
    for index, value in pairs(rewards) do
        local go = fun.get_instance(self.property.transform,self.content.transform)
        fun.set_active(go.transform,true)
        local view = MiniGame01CollectRewardItem:New(value,MiniGame01CollectRewardType.expelthief)
        view:SkipLoadShow(go)
        if not collectRewardItemList then
            collectRewardItemList = {}
        end
        table.insert(collectRewardItemList,view)
    end
    local etyep,value = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.free)
    if etyep then
        fun.set_active(self.extraFree.transform,true)
        fun.set_active(self.btn_freetokeep.transform,false)
        expelThiefCost = 0
        expelThiefType = ExpelThief.free
        self.text_cost.text = "0"
    else
        etyep,value = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.ad)
        if etyep and _watchADUtility:IsAbleWatchAd() then
            fun.set_active(self.btn_freetokeep.transform,true)
        end
        etyep,value = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.diamond)
        if expelThiefType == nil and not etyep then
            fun.set_active(self.btn_keepPlay.transform,false)
        elseif value then
            expelThiefCost = value
            expelThiefType = expelThiefType or ExpelThief.diamond
            self.text_cost.text = tostring(value)
        end
    end
    
    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)
end

function MiniGameStealthView:OnDisable()
    self:RemoveAdResultEvent()
    Facade.RemoveView(self)
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoKeepPlayingResphone,self)
    Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish,expelThiefState)

    expelThiefType = nil
    collectRewardItemList = nil
    expelThiefState = nil
    expelThiefCost = nil
    --self.showTips = nil
    self.update_x_enabled = nil
end

function MiniGameStealthView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGameStealthView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGameStealthView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGameStealthView:PlayEnterAction()
    self.rabbitAnima:Play("rabbit_show",0,0)
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGameStealthView_start"},false,function()
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
    end)
end

function MiniGameStealthView:on_btn_keepPlay_click()
    self:RemoveAdResultEvent()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.keepPlaying, true, true)
end

function MiniGameStealthView:DoKeepPlaying()
    --if expelThiefType == ExpelThief.free and not self.showTips then
    --    self.showTips = true
        --Facade.SendNotification(NotifyName.ShowUI,MiniGame01DodgeView)
        --Event.AddListener(NotifyName.MiniGame01.DogeFreeShowTips,self.OnDogeFreeShowTips,self)
    --end
    Facade.SendNotification(NotifyName.ShopView.CheckCurrencyAvailable,8008,Resource.diamon,expelThiefCost,function()
        log.r("====================================>>34103411赶走小偷")
        Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoKeepPlayingResphone,self)
        local id = ModelList.MiniGameModel:GetActivateMiniGameId()
        local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
        if expelThiefCost > 0 then
            expelThiefType = ExpelThief.diamond
        else
            expelThiefType = ExpelThief.free
        end
        ModelList.MiniGameModel:RequestSubmitInfo(id,3,expelThiefType,fullUnix)
    end,function()
        self._fsm:GetCurState():StiffOver(self._fsm)
    end,function()
        self._fsm:GetCurState():StiffOver(self._fsm)
    end,SHOP_TYPE.SHOP_TYPE_DIAMONDS,nil,CanvasSortingOrderManager.LayerType.TopConsole)
end

function MiniGameStealthView:OnDogeFreeShowTips()
    Event.RemoveListener(NotifyName.MiniGame01.DogeFreeShowTips,self.OnDogeFreeShowTips,self)
    self._fsm:GetCurState():StiffOver(self._fsm)
end

function MiniGameStealthView:OnDoKeepPlayingResphone(data)
    expelThiefState = 1
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoKeepPlayingResphone,self)
    self._fsm:GetCurState():ExpelThiefResult(self._fsm,data)
end

function MiniGameStealthView:on_btn_freetokeep_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.free2keep, true, true)
    -- self:DoFree2KeepPlaying()
end

function MiniGameStealthView:DoFree2KeepPlaying()
    expelThiefType = ExpelThief.ad
    local id = ModelList.MiniGameModel:GetActivateMiniGameId()
    _watchADUtility:WatchVideo(self,self.WatchVideoCallback,"banish_thief",{miniGameId = id})
end

function MiniGameStealthView:WatchVideoCallback(isBreak)
    if isBreak then
        self._fsm:GetCurState():StiffOver(self._fsm)
    else
        self:AddAdResultEvent()
    end
end

function MiniGameStealthView:AddAdResultEvent()
    Event.AddListener(EventName.Event_GetTaskRewardSucceed,self.WatchRewardAdSuccess,self)
    Event.AddListener(EventName.Event_GetTaskRewardFail,self.WatchRewardAdFail,self)
end

function MiniGameStealthView:RemoveAdResultEvent()
    Event.RemoveListener(EventName.Event_GetTaskRewardSucceed,self.WatchRewardAdSuccess,self)
    Event.RemoveListener(EventName.Event_GetTaskRewardFail,self.WatchRewardAdFail,self)
end


function MiniGameStealthView:WatchRewardAdSuccess()
    self:RemoveAdResultEvent()
    Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoKeepPlayingResphone,self)
    local id = ModelList.MiniGameModel:GetActivateMiniGameId()
    local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
    ModelList.MiniGameModel:RequestSubmitInfo(id,3,expelThiefType,fullUnix)
end

function MiniGameStealthView:WatchRewardAdFail()
    self:RemoveAdResultEvent()
    fun.set_active(self.btn_freetokeep.transform,false)
    self._fsm:GetCurState():StiffOver(self._fsm)
end

function MiniGameStealthView:on_btn_giveup_click()
    self:RemoveAdResultEvent()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.giveUpExpelThief, true, true)
end

function MiniGameStealthView:DoGiveUpExpelThief()
    log.r("====================================>>34103411放弃驱赶小偷")
    LuaTimer:SetDelayFunction(0.3, function()
        UISound.play("hat_giveup")
    end)
    Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoGiveUpExpelThiefResphone,self)
    local id = ModelList.MiniGameModel:GetActivateMiniGameId()
    local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
    ModelList.MiniGameModel:RequestSubmitInfo(id,2,0,fullUnix)
end

function MiniGameStealthView:on_x_update()
    if collectRewardItemList then
        local rabbitPos = self.rabbit.transform.position
        local loseCount = 0
        local rewardCount = 0
        for index, value in ipairs(collectRewardItemList) do
            rewardCount = rewardCount + 1
            if not value.isLose then
                local rewardPos = value:GetPosition()
                if rabbitPos.x >= rewardPos.x then
                    value.isLose = true
                    value:PlayRewardsLose(nil)
                end
            else
                loseCount = loseCount + 1    
            end
        end
        if loseCount == rewardCount then
            collectRewardItemList = nil
            LuaTimer:SetDelayFunction(0.25, function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end
    end
end

function MiniGameStealthView:OnDoGiveUpExpelThiefResphone(data)
    if data then
        expelThiefState = 2
        Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnDoGiveUpExpelThiefResphone,self)
        self.rabbitAnima:Play("rabbit_win",0,0)
        AnimatorPlayHelper.Play(self.anima,{"giveupend","MiniGameStealthView_giveupend"},false,function()
            self.update_x_enabled = true
            self:start_x_update()
        end,0.833)
    else
        UIUtil.show_common_popup(8011,true,function()
            Facade.SendNotification(NotifyName.MiniGame01.ForceResetMiniGame)
            self:ExpelThiefResult()
        end,function()
            
        end,nil,nil)     
    end
end

function MiniGameStealthView:ExpelThiefResult(data)
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGameStealthView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

---没什么用，触发热更的
function MiniGameStealthView:TriggerHot()

end