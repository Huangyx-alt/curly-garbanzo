MiniGame01BigRewardView = BaseMiniGame01:New("MiniGame01BigRewardView","MiniGame01PopupAtlas","luaprefab_minigame_minigame01")
local this = MiniGame01BigRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "text_reward",
    "btn_collect",
    "maleAnima",
    "flyDouble"
}

function MiniGame01BigRewardView:Awake(obj)
    self:on_init()
end

function MiniGame01BigRewardView:OnEnable(params)
    Facade.RegisterView(self)
    UISound.play("hat_prize_coin")
    UISound.play("hat_prize_bgm")

    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)

    Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnSubmitLayerResphone,self)

    local reward_value = ModelList.MiniGameModel:GetBoxLayerInfoById(nil,"grandPrize")
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 then
        self:AnimRewardNum(0,reward_value , 1.9)
        fun.set_active(self.flyDouble,true)
        LuaTimer:SetDelayFunction(2.5, function()
            self:AnimRewardNum(reward_value , reward_value * 2 , 0.6)
        end)
    else
        self:AnimRewardNum(0,reward_value , 2)
    end
    self:RebindSprite()
end

function MiniGame01BigRewardView:AnimRewardNum( startNum,targetNum, rollTime)
    if self.text_reward then
        Anim.do_smooth_int2(self.text_reward,startNum,targetNum,rollTime,DG.Tweening.Ease.Unset,nil,nil)
    end
end

function MiniGame01BigRewardView:OnDisable()
    Facade.RemoveView(self)
    self:DisposeFsm()
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnSubmitLayerResphone,self)
    Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
end

function MiniGame01BigRewardView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01BigRewardView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01BigRewardView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGame01BigRewardView:PlayEnterAction()
    self.maleAnima:Play("miniman_win",0,0)
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGamejackpot_start"},false,function()
        fun.enable_button(self.btn_collect,true)
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
    end)
end

function MiniGame01BigRewardView:on_btn_collect_click()
    fun.enable_button(self.btn_collect,false)
    self:OnClaimJackpotReward()
end

function MiniGame01BigRewardView:OnClaimJackpotReward()
    ModelList.MiniGameModel:IgnoreBigRewardCollect()
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnSubmitLayerResphone,self)
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGamejackpot_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function MiniGame01BigRewardView:OnSubmitLayerResphone(data)
    if data then
        Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.OnSubmitLayerResphone,self)
        Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,Vector3.New(0,0,0),2,function()
            Event.Brocast(EventName.Event_currency_change)
            AnimatorPlayHelper.Play(self.anima,{"end","MiniGamejackpot_end"},false,function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end,nil,true)
    else
        UIUtil.show_common_popup(8011,true,function()
            Facade.SendNotification(NotifyName.MiniGame01.ForceResetMiniGame)
            AnimatorPlayHelper.Play(self.anima,{"end","MiniGamejackpot_end"},false,function()
                Facade.SendNotification(NotifyName.CloseUI,self)
            end)
        end,function()
            
        end,nil,nil)     
    end
end

--- 此处会有一个丢资源白图问题，重新绑定一次
function MiniGame01BigRewardView:RebindSprite()
    if self.go then
        local child = fun.find_child(self.go,"root/tittle")
        if child then
            --self:RebindChildSprite("root/tittle","miniTCTitle")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand3/hand2","hand203")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand3/hand1","hand204")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand2/hand2","hand202")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand2/hand1","hand201")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/body","body")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat","hat")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/body","r01")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/body/r01s1","r01s1")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/body/r01s2","r01s2")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r02","r02")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r03","r03")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04","r04")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye1/r06","r06")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye1/r061","r051")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye1/r062","r062")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye1/r07","r07")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye2/r05","r05")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye2/r051","r051")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye2/r052","r052")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/eye2/r07","r07")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/r041","r041")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/r042","r042")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/r043","r043")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rhead/r04/r044","r044")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hat/r/rlj","rlj")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand1/hand1","hand103")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/hand1/hand2","hand102")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head","head")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye1/eye1","eye1")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye1/eye101","eye101")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye1/eye103","eye103")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye1/eye102","eye102")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye1/eye102_b","eye102_b")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye2/eye2","eye2")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye2/eye201","eye201")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye2/eye203","eye203")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye2/eye202","eye202")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/eye2/eye202_b","eye202_b")
            self:RebindChildSprite("root/bg/MiniMan/root/Man/head/hair1","hair1")
            --self:RebindChildSprite("root/nub_kuang","MiniConDi")
            self:RebindChildSprite("root/fly/double","MiniQiq01Nr03")
        end
    end
end

function MiniGame01BigRewardView:RebindChildSprite(path, spriteName)
    local child = fun.find_child(self.go,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            img.sprite = AtlasManager:GetSpriteByName("MiniGame01Atlas",spriteName)
        end
    end
end

return this