MiniGame01QuitView = BaseMiniGame01:New("MiniGame01QuitView","MiniGame01PopupAtlas","luaprefab_minigame_minigame01")
local this = MiniGame01QuitView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local rewardItemsCache = nil

this.auto_bind_ui_items = {
    "anima",
    "content",
    "rewards",
    "btn_collect",
    "btn_stay",
    "bg1",
    "bg2",
    "double",
    "text_step1",
    "text_step2"
}

function MiniGame01QuitView:Awake(obj)
    self:on_init()
end

function MiniGame01QuitView:OnEnable(params)
    rewardItemsCache = {}
    local rewards = ModelList.MiniGameModel:GetAllAcquiredReward()
    --local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if this.rewards and this.content then
        for key, value in pairs(rewards) do
            local go = fun.get_instance(this.rewards,this.content)
            if go then
                fun.set_active(go.transform,true)
                local view = MiniGame01CollectRewardItem:New(value)
                view:SkipLoadShow(go)
                table.insert(rewardItemsCache,view)
            end
        end
    end

    local doubleReward = ModelList.ItemModel:get_doublehatReward()
    if doubleReward > 0 then
        fun.set_active(self.double,true)
        Cache.GetSpriteByName("MiniGame01PopupAtlas","MiniDRR02",function(sprite)
            if fun.is_not_null(self.bg1) then
                self.bg1.sprite = sprite
            end
            if fun.is_not_null(self.bg2) then
                self.bg2.sprite = sprite
            end
        end)
    end

    self.text_step2.text = Csv.GetDescription(986)

    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)

    Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnConfireCollectAndQuitResult,self)
    Event.AddListener(NotifyName.MiniGame01.ErrorNetDataAction,self.ResetStateEvent,self)
end

function MiniGame01QuitView:OnDisable()
    rewardItemsCache = nil
    self:DisposeFsm()
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnConfireCollectAndQuitResult,self)
    Event.RemoveListener(NotifyName.MiniGame01.ErrorNetDataAction,self.ResetStateEvent,self)
end

function MiniGame01QuitView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01BigRewardView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01QuitView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGame01QuitView:PlayEnterAction()
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGame01QuitView_start"},false,function()
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
    end)
end

function MiniGame01QuitView:OnStayWinMore()
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
        Event.Brocast(NotifyName.MiniGame01.CollectAndQuitResult)
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function MiniGame01QuitView:OnConfireCollectAndQuit()
    local id = ModelList.MiniGameModel:GetActivateMiniGameId()
    local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
    ModelList.MiniGameModel:RequestSubmitInfo(id,1,0,fullUnix)
end

function MiniGame01QuitView:OnConfireCollectAndQuitResult(data)
    if data then
        Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnConfireCollectAndQuitResult,self)
        self:FlyRewardAndExit(function()
            AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
                Event.Brocast(NotifyName.MiniGame01.CollectAndQuitResult,true)
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end)
    else
        UIUtil.show_common_popup(8011,true,function()
            --self:FlyRewardAndExit(function()
            --    Facade.SendNotification(NotifyName.MiniGame01.ForceResetMiniGame)
            --    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
            --        Facade.SendNotification(NotifyName.CloseUI,self)
            --    end)
            --end)
            Facade.SendNotification(NotifyName.MiniGame01.ForceResetMiniGame)
            AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end,function()
            
        end,nil,nil) 
    end
end

function MiniGame01QuitView:FlyRewardAndExit(callback)
    local delay = 0
    local coroutine_fun = nil
    local count = 0
    for key, value in pairs(rewardItemsCache) do
        coroutine_fun = function()
            delay = delay + 0.2
            count = count + 1
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                count = math.max(0,count - 1)
                Event.Brocast(EventName.Event_currency_change)
                if 0 == count and self.anima then
                    if callback then
                        callback()
                    end
                end
            end,nil,true)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    UISound.play("gift_box_open")
end

function MiniGame01QuitView:on_btn_collect_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.confireCollectAndQuit,nil,true)
end

function MiniGame01QuitView:on_btn_stay_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.stayWinMore)
end

function MiniGame01QuitView:ResetStateEvent()
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
        Event.Brocast(NotifyName.MiniGame01.CollectAndQuitResult, false)
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

return this