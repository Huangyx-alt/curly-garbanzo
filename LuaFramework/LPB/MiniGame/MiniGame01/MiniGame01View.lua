MiniGame01View = BaseMiniGame01:New("MiniGame01View","MiniGame01Atlas","luaprefab_minigame_minigame01")
local this = MiniGame01View
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local propertyView1 = nil
local propertyView2 = nil
local propertyView3 = nil
local propertyView4 = nil

local click_index = nil
local layer_index = nil

local isMeetThief = nil
local isFreeExpelThief = nil

local collectRewardItemList = nil
local layerItemList = nil

local toplayerItemPos = nil

local flyReward = nil
local reward_miss = nil
local reward_hit = nil

local original_pos = nil

local boxes_cache_list = nil

local enterNoTip = true  --进入游戏 不展示提示框


local mainAnimClipList = 
{
    start = "start",
    idle = "idle",
    doubleenter = "doubleenter",
    doubleend = "doubleend",
    endOut = "end",
}

this.auto_bind_ui_items = {
    "anima",
    "btn_property1",
    "btn_property2",
    "btn_property3",
    "btn_property4",
    "btn_collect",
    "content1",
    "content2",
    "boxLevel",
    "rewards",
    "prize",
    "text_prize",
    "text_level",
    "top_layer",
    "mask",
    "cursor",
    "top_layer2",
    "scrollview1",
    "scrollview2",
    "spineWeimu",
    "extra_reward",
    "btn_buy",
    "btn_help",
    "text_pick",
    "grandPrizeAnima",
    "maleAnima",
    "btn_remainTime",
    "double",
    "text_remainTime",
    "btn_box",
    "hatLayer",
    "show",
    "icon_double",
}

local lastBgmName

function MiniGame01View:on_btn_remainTime_click()
    self:on_btn_buy_click()
end

function MiniGame01View:on_btn_box_click()
    self:on_btn_buy_click()
end

function MiniGame01View:GetExtraReward()
    local extra_reward = fun.get_instance(self.extra_reward,self.extra_reward.transform.parent)
    fun.set_active(extra_reward.transform,true)
    return extra_reward
end

function MiniGame01View:SetDoubleReward()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    fun.set_active(self.double.transform,doubleReward > 1)
    fun.set_active(self.btn_remainTime.transform,doubleReward > 1)
    fun.set_active(self.btn_buy.transform,not (doubleReward > 1))
    if doubleReward > 1 then
        if self.remainTimeCountDown == nil then
            self.remainTimeCountDown = RemainTimeCountDown:New()
        end
        self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,doubleReward,self.text_remainTime,function()
            self:UpdateCollectRewardShowDouble()
            self:UpdateGrandPrize()
            self:SetDoubleReward()
            Event.Brocast(NotifyName.MiniGame01.DoubleRewardUpdateAction)
        end)
    end
end

function MiniGame01View:OnDoubleRewardChange()
    self:SetDoubleReward()
    self:UpdateCollectRewardShowDouble()
    self:UpdateGrandPrize()
end

function MiniGame01View:Awake(obj)
    self:on_init()
end

function MiniGame01View.ReqMiniGameData()
    this.ClearDelayReturnState()
    this.CreatDelayReqData()
end

function MiniGame01View.ReqMiniGameDataOnly()
    this.ReqMiniGameData()
end

function MiniGame01View.ClearDelayReturnState()
    if this.Timer then
        this.Timer:Stop()
        this.Timer = nil
    end
end

function MiniGame01View.CreatDelayReqData()
    this.Timer = Invoke(function()
        UIUtil.show_common_popup(8011,true , function()
            ModelList.MiniGameModel:RequestMiniGameLayerInfo()
            this.ReqMiniGameDataOnly()
        end)
    end, 5)
end

function MiniGame01View:MiniGamePrepareEnable(state)
    if state == false then
        this.ReqMiniGameDataOnly() 
        return
    end
    this.ClearDelayReturnState()
    Event.RemoveListener(NotifyName.MiniGame01.MiniGamePrepareEnable,self.MiniGamePrepareEnable,self)
    self:SetDoubleReward()
end


function MiniGame01View:OnEnable(params)
    Facade.RegisterView(self)
    enterNoTip = true
    Event.AddListener(NotifyName.MiniGame01.DataErrorForceClose,self.DataErrorForceClose,self)
    Event.AddListener(NotifyName.MiniGame01.MiniGamePrepareEnable,self.MiniGamePrepareEnable,self)
    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)
    EnterGameSequence:Start(nil,function()
        self._fsm:GetCurState():OpenBoxSequenceFinish(self._fsm)
    end)
    --UISound.load_res({"luaprefab_minigame_sound01"})
    self:AddPurchaseEvent()
    ModelList.MiniGameModel:RequestMiniGameLayerInfo()
    this.ReqMiniGameDataOnly()
    LuaTimer:SetDelayFunction(0.5, function()
        UISound.play("hat_game_start")
    end)
    self:RebindSprite()
end

function MiniGame01View:OnDisable()
    AddLockCountOneStep(false)
    Facade.RemoveView(self)
    self:DisposeFsm()
    this.ClearDelayReturnState()
    enterNoTip = false
    propertyView1 = nil
    propertyView2 = nil
    propertyView3 = nil
    propertyView4 = nil

    boxes_cache_list = nil

    click_index = nil
    layer_index = nil

    isMeetThief = nil
    isFreeExpelThief = nil

    collectRewardItemList = nil
    layerItemList = nil

    toplayerItemPos = nil

    flyReward = nil
    reward_miss = nil
    reward_hit = nil

    original_pos = nil

    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameCollectError,self.MiniGameCollectError,self)
    Event.RemoveListener(NotifyName.MiniGame01.DataErrorForceClose,self.DataErrorForceClose,self)
    Event.RemoveListener(NotifyName.MiniGame01.DoubleRewardUpdateAction,self.CheckPlayDoubleRewardAction,self)
    self:RemovePurchaseEvent()

    UISound.stop_bgm()
    UISound.play_bgm(lastBgmName)
    Event.Brocast(EventName.Event_popup_order_step_finish)
end

function MiniGame01View:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01View",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01PlayState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01View:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end


function MiniGame01View:PlayEnterRewardAction(mainAnimClp)
    AnimatorPlayHelper.Play(self.anima,{mainAnimClp,"MiniGame01View_start"},false,function()
    end)
end

function MiniGame01View:PlayEnterAction()
    self.spineWeimu:SetAnimation("start",nil,false,0)
    lastBgmName = UISound.get_playing_bgm() or "city"
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGame01View_start"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        UISound.play_bgm("hat_bgm")
    end)
end


function MiniGame01View:CheckPlayDoubleRewardAction(isEnter)
    local doubleReward = ModelList.ItemModel:get_doublehatReward()
    if doubleReward > 0 then
        self:PlayEnterRewardAction(mainAnimClipList.doubleenter)
        self:RebindChildSprite("SafeArea/top_layer2/MiniDi01/kuang_d","MiniDRR02")
        self:RebindChildSprite("SafeArea/top_layer2/MiniDi02/kuang_d","MiniDRR02")
        fun.set_active(self.icon_double , true)
        fun.play_animator(self.grandPrizeAnima ,"doublein" , true )
    else
        if  not isEnter  then
            self:PlayEnterRewardAction(mainAnimClipList.doubleend)
            fun.set_active(self.icon_double , false)
        end
    end
end

function MiniGame01View:PlayStageEnterAction()
    local bg_name = "MiniHatG01"
    local layer = ModelList.MiniGameModel:GetLayerInfo()
    if layer and layer.background ~= self.hat_background then
        self.hat_background = layer.background
        if 0 == self.hat_background then
            bg_name = "MiniHatY01"
        elseif 1 == self.hat_background then
            bg_name = "MiniHatG01"
        elseif 2 == self.hat_background then
            bg_name = "MiniHatB01"   
        elseif 3 == self.hat_background then
            bg_name = "MiniHatP01"  
        end
    end
    Cache.load_prefabs("luaprefab_minigame_minigame01","hat",function(obj)
        if obj then
            local go = fun.get_instance(obj,self.btn_property1.transform.parent)
            Cache.GetSpriteByName("MiniGame01Atlas",bg_name,function(sprite)
                local imgs = fun.get_components_in_child(go,UnityEngine.UI.Image)
                for i = 0, imgs.Length - 1 do
                    imgs[i].sprite = sprite
                end
            end)
            LuaTimer:SetDelayFunction(self:GetDelayShowCollect(), function()
                local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
                self:SetCollectBtnAvaliable(curLayerNum > 1)
            end)

            LuaTimer:SetDelayFunction(self:GetDelayShowDouble(), function()
                self:CheckPlayDoubleRewardAction(true)
                Event.AddListener(NotifyName.MiniGame01.DoubleRewardUpdateAction,self.CheckPlayDoubleRewardAction,self)
            end)

            local animator = fun.get_component(go,fun.ANIMATOR)
            AnimatorPlayHelper.Play(animator,{"hat","hat"},false,function()
                propertyView1 = MiniGame01StageProperty:New(1)
                propertyView1:SkipLoadShow(self.btn_property1)
                propertyView2 = MiniGame01StageProperty:New(2)
                propertyView2:SkipLoadShow(self.btn_property2)
                propertyView3 = MiniGame01StageProperty:New(3)
                propertyView3:SkipLoadShow(self.btn_property3)
                propertyView4 = MiniGame01StageProperty:New(4)
                propertyView4:SkipLoadShow(self.btn_property4)
                click_index = 2
                boxes_cache_list = {propertyView1,propertyView2,propertyView3,propertyView4}
                Destroy(go)
                reward_miss,reward_hit = ModelList.MiniGameModel:GetOpenBoxReward()
                if #reward_miss == 2 then
                    propertyView2:SetReward({id = 2004,value = 1})
                    self:PlayOpenBoxGetReward(propertyView2,true)
                    LuaTimer:SetDelayFunction(1.67, function()
                        propertyView2:PlayHidePropertyBox()
                        propertyView2:SetLock(true)
                        self:DelayReadyToClick()
                    end)
                else
                    self:DelayReadyToClick()
                end
                local etyep,value = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.free)
                if etyep then
                    self:on_btn_help_click()
                end
            end)
        end
    end)
end

function MiniGame01View:GetDelayShowCollect()
    if self:CheckHasDoubleReward() then
        return 0.8
    else
        return 0.5
    end
end

function MiniGame01View:GetDelayShowDouble()
    if self:CheckHasDoubleReward() then
        return 1.3
    else
        return 1.2
    end
end

function MiniGame01View:DelayReadyToClick()
    local delayTime = self:GetDelayReadyToClickTime()
    LuaTimer:SetDelayFunction(delayTime, function()
        self._fsm:GetCurState():GetReady(self._fsm)
    end)
end

function MiniGame01View:GetDelayReadyToClickTime()
    if self:CheckHasDoubleReward() then
        return 1.5
    else
        return 0.3
    end
end

function MiniGame01View:PlayQuitAction()
    self.spineWeimu:SetAnimation("out",nil,false,0)
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01View_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
        Facade.SendNotification(NotifyName.CloseUI,MiniGame01PopupView)
    end)
end

function MiniGame01View.OnResphoneLayerInfo(error)
    if not error then
        this._fsm:GetCurState():ResphoneLayerInfo(this._fsm)
    else
        this.ReqMiniGameDataOnly()
    end 
end

function MiniGame01View:CheckEncounterThief()
    return self._fsm:GetCurState():CheckEncounterThief(self._fsm)
end

function MiniGame01View:AddCollectRewardItem(reward,isTween)
    local pos = 0
    if collectRewardItemList then
        for index, value in ipairs(collectRewardItemList) do
            pos = value:SetLocalPositionOffset(Vector2.New(-100,0),isTween)
        end
    end
    self:CreateCollectRewardItem(reward,pos,200)
end

function MiniGame01View:CreateCollectRewardItem(reward,pos,offset)
    local go = fun.get_instance(this.rewards.transform,this.content2.transform)
    fun.set_active(go.transform,true)
    local view = MiniGame01CollectRewardItem:New(reward,MiniGame01CollectRewardType.collectreward)
    view:SkipLoadShow(go)
    if 0 == pos then
        fun.set_rect_anchored_position(go,0,0)
    else
        fun.set_rect_anchored_position(go,pos.x + offset,0)
    end
    if not collectRewardItemList then
        collectRewardItemList = {}
    end
    table.insert(collectRewardItemList,view)
end

function MiniGame01View:SetLayerInfo()
    local layerList = ModelList.MiniGameModel:GetLayerInfoList()
    if layerList and #layerList > 0 then
        local pos = 0
        local childs = 0
        local move2Pos = 0
        local gap = 57
        local visible_top_index = 10  --可见范围顶部格子下标
        local visible_center_index = 6 --可见范围中间格子下标
        local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
        for index, value in ipairs(layerList) do
            childs = childs + 1
            local go = fun.get_instance(self.boxLevel.transform,self.content1.transform)
            fun.set_active(go.transform,true)
            local view = MiniGame01LayerItem:New(index)
            view:SkipLoadShow(go)
            if layerItemList == nil then
                layerItemList = {}
            end
            table.insert(layerItemList,view)
            fun.set_rect_anchored_position(go,0,pos)
            local layerData = ModelList.MiniGameModel:GetLayerInfo(index)
            if layerData and layerData.layNo == curLayerNum then
                fun.set_rect_anchored_position(self.cursor.gameObject,0,pos)
                move2Pos = pos
            end
            pos = pos + gap
        end
        self.cursor.transform:SetAsLastSibling()
        self.cursor:Play("show")
        self.content1.transform.sizeDelta = Vector2.New(0,math.abs(pos))
        toplayerItemPos = layerItemList[visible_top_index]:GetGlobalPosition()
        original_pos = self.content1.transform.localPosition
        self.content1.transform.localPosition = Vector3.New(original_pos.x,original_pos.y - math.max(math.min(move2Pos - gap * (visible_center_index - 1),pos - gap * (visible_top_index - 1)),0),original_pos.z)
        --Anim.move_ease(self.content1,content1Pos.x,content1Pos.y - math.max(math.min(move2Pos - gap * 5,pos - gap * 9),0),content1Pos.z,0.5,true,DG.Tweening.Ease.InOutSine,nil)
        self:UpdateGrandPrize()
        self.text_level.text = string.format("<color=#fedd29><size=36>LEVEL</size></color> <color=#ffffff>%s</color><color=#fedd29>/%s</color>",curLayerNum,#layerItemList)
    
    end
    local rewards = ModelList.MiniGameModel:GetAllAcquiredReward()
    for index, value in pairs(rewards) do
        log.r("======================================>>rewards " .. value.id .. "   " .. value.value)
        self:AddCollectRewardItem(value)
    end
end

function MiniGame01View:SetCollectBtnAvaliable(avaliable)
    if avaliable == nil then
        local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
        avaliable = curLayerNum > 1
    end


    if avaliable == true then
        self:ShowBtnCollect()
        self:HideNoRewardTip()
    else
        self:HideBtnCollect()
        self:UpdateBtnCollectEnableState(false)
        self:ShowNoRewardTip()
    end
end

function MiniGame01View:ShowBtnCollect()
    if fun.get_active_self(self.btn_collect) then
        return
    end
    fun.set_active(self.btn_collect.transform,true)
    local anim = fun.get_component(self.btn_collect , fun.ANIMATOR)
    AnimatorPlayHelper.Play(anim,{"start","btn_start"},false,nil)
end

function MiniGame01View:HideBtnCollect()
    local anim = fun.get_component(self.btn_collect , fun.ANIMATOR)
    if anim then
        AnimatorPlayHelper.Play(anim,{"end","btn_end"},false,function()
            fun.set_active(self.btn_collect.transform, false)
        end)
    end
end

function MiniGame01View:ShowNoRewardTip()
    fun.set_active(self.text_pick, true)
    local anim = fun.get_component(self.text_pick , fun.ANIMATOR)
    AnimatorPlayHelper.Play(anim,{"start","Text_pick_start"},false,nil)
end

function MiniGame01View:HideNoRewardTip()
    local anim = fun.get_component(self.text_pick , fun.ANIMATOR)
    AnimatorPlayHelper.Play(anim,{"end","Text_pick_end"},false,function()
        fun.set_active(self.text_pick, false)
    end)
end

function MiniGame01View:UpdateLayerInfo()
    if layerItemList then
        for index, value in ipairs(layerItemList) do
            value:SetLayerInfo()
        end
    end
end

function MiniGame01View:GetCollectRewardItem(rewardId)
    if collectRewardItemList then
        for index, value in ipairs(collectRewardItemList) do
            --log.r("==========================================>>pos  " .. value.transform.position.x)
            if value:IsTheSameReward(rewardId) then
                return value,true
            end
        end
        return collectRewardItemList[#collectRewardItemList],false
    end
    return nil
end

function MiniGame01View.OnSubmitLayerResphone(data)
    log.r("==================================================>>OnSubmitLayerResphone3410 " .. this._fsm:GetCurName())
    if not data then
        --没有正常数据 切换到最开始的状态
        this:OnResetState()
        return
    end
    this._fsm:GetCurState():ServerRespone()
    this._fsm:GetCurState():OnSubmitLayerResphone(this._fsm,data)
end

function MiniGame01View:UpdateBtnCollectEnableState(enableState)
    fun.enable_button(self.btn_collect, enableState)
    Util.SetImageColorGray(self.btn_collect, not enableState)
end

function MiniGame01View:DoOpenBoxAction(data)
    if data then
        self:UpdateBtnCollectEnableState(false)
        isMeetThief = ModelList.MiniGameModel:IsMeetThief()
        isFreeExpelThief = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.free)
        OpenBoxSequence:Start(isMeetThief,function()
            local nowLayer = ModelList.MiniGameModel:GetHatNowLayer()
            if nowLayer ~= 1 then
                self:UpdateBtnCollectEnableState(true)
            end
            self._fsm:GetCurState():OpenBoxSequenceFinish(self._fsm)
        end)
        -- UISound.play("hat_game_start")
    else
        UIUtil.show_common_popup(8011,true,function()
            self:ExitOrRestartMiniGame()
        end,function()
            
        end,nil,nil) 
    end
end

function MiniGame01View:SetBoxInfoBeforOpen()
    click_index = click_index or 2
    if not reward_miss or not reward_hit then
        reward_miss,reward_hit = ModelList.MiniGameModel:GetOpenBoxReward()
    end
    if reward_miss and reward_hit then
        log.r("==================================>>reward_hit " .. reward_hit.id .. "    " .. reward_hit.value)
        local reward_miss_index = 1
        for index, value in ipairs(boxes_cache_list) do
            if click_index == value:GetIndexNum() then
                value:SetParent(self.top_layer,false)
                value:SetReward(reward_hit)
                flyReward = value
                self:UpdateHatBtnEnableState(index, false)
            elseif not value:IsLock() then
                --if reward_miss[reward_miss_index] then
                    value:SetReward(reward_miss[reward_miss_index])
                --else
                --    value:PlayHidePropertyBox()
                --    value:SetLock(true)
                --end
                reward_miss_index = reward_miss_index + 1
            end
        end
        self:SetMaskColor(true)
    end
end

function MiniGame01View:OnSubmitLayerResphoneNotify(data)
    Event.Brocast(NotifyName.MiniGame01.SubmitLayerResphone,data)
end

function MiniGame01View:OpenBoxShowStolenByThief()
    --log.r("===============>>3410OpenBoxShowStolenByThief " .. self._fsm:GetCurName())
    self._fsm:GetCurState():DoAction2StiffPlay(self._fsm,MiniGame01Stiffparams.openBoxShowStolenByThief)
end

function MiniGame01View:OnOpenBoxShowStolenByThief()
    self:SetBoxInfoBeforOpen()
    self:PlayOpenBoxGetReward(flyReward,true)
    LuaTimer:SetDelayFunction(1.2, function()
        log.r("===============>>3410MiniGameStealthView")
        Facade.SendNotification(NotifyName.ShowUI,MiniGameStealthView)
    end)
end

function MiniGame01View:EnterGameShowStolenByThief()
    self._fsm:GetCurState():DoAction2StiffStiff(self._fsm,MiniGame01Stiffparams.EnterGameShowStolenByThief)
end

function MiniGame01View:OnEnterGameShowStolenByThief()
    self:SetBoxInfoBeforOpen()
    self:PlayOpenBoxGetReward(flyReward,true)
    LuaTimer:SetDelayFunction(1.2, function()
        Facade.SendNotification(NotifyName.ShowUI,MiniGameStealthView)
    end)
end

function MiniGame01View:FlyLayerReward()
    self:SetStageInfoBeforOpen()
    LuaTimer:SetDelayFunction(1.2, function()
        if flyReward then
            -- if 2 == ModelList.MiniGameModel:GetCurrentLayerNum() then
            	self:HideNoRewardTip()
            -- end
            local rewardItem,gotit = self:GetCollectRewardItem(reward_hit.id)
            local offset = (gotit and {0} or {0.52})[1]
            if rewardItem then
                if offset ~= 0 then
                    local localPos = rewardItem:GetLocalPosition()
                    local pos = rewardItem:GetPosition()
                    if collectRewardItemList then
                        for index, value in ipairs(collectRewardItemList) do
                            value:Tween2MoveHalfUnit(-offset)
                        end
                    end
                    flyReward:FlyReward(pos + Vector3.New(offset,0,0),function()
                        self:CreateCollectRewardItem(reward_hit,localPos,100)
                        local refreshItem,gotit = self:GetCollectRewardItem(reward_hit.id)
                        refreshItem:UpdateCollectRewardShowDouble()
                        Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
                    end)
                else
                    flyReward:FlyReward(rewardItem:GetPosition(),function()
                        local refreshItem,gotit = self:GetCollectRewardItem(reward_hit.id)
                        refreshItem:PlayResphoneAddReward()
                        Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
                    end)     
                end
            else
                flyReward:FlyReward(self.rewards.transform.position,function()
                    self:CreateCollectRewardItem(reward_hit,0,0)
                    Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
                end)
            end
        end
    end)
end

function MiniGame01View:CheckNextLayer()
    for index, value in ipairs(boxes_cache_list) do
        value:PlayHidePropertyBox()
    end
    LuaTimer:SetDelayFunction(0.5, function()
        self:SetLayerInfoUi()
    end)
end

function MiniGame01View:SetLayerInfoUi()
    local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
    if layerItemList == nil then return end
    local topPos = layerItemList[#layerItemList]:GetGlobalPosition()
    if layer_index then
        layerItemList[layer_index]:SetLayerInfo()
    end
    local cursor_pos = self.cursor.transform.localPosition
    local target_pos = layerItemList[curLayerNum]:GetLocalPosition()
    local content1Pos = self.content1.transform.localPosition
    local layer1Pos = layerItemList[1]:GetLocalPosition()
    local layer2Pos = layerItemList[2]:GetLocalPosition()
    local precision = 5
    local centerIndex = 6
    local gap = math.abs(layer2Pos.y - layer1Pos.y)
    local offset =  original_pos.y - math.max(0,curLayerNum - centerIndex) * gap
    local func = function()
        content1Pos = self.content1.transform.localPosition
        if curLayerNum > centerIndex and topPos.y > (toplayerItemPos.y + precision) then
            fun.set_parent(self.cursor,self.content1.transform.parent.gameObject,false)
            Anim.move_ease(self.content1,content1Pos.x,content1Pos.y - math.abs(target_pos.y - cursor_pos.y),content1Pos.z,0.5,true,DG.Tweening.Ease.InOutSine,function()
                fun.set_parent(self.cursor,self.content1.transform.gameObject,false)
                self:UpdateLayerInfo()
            end)
        else
            Anim.move_ease(self.cursor.gameObject,cursor_pos.x,target_pos.y,cursor_pos.z,0.5,true,DG.Tweening.Ease.InOutSine,function()
                fun.set_parent(self.cursor,self.content1.transform.gameObject,false)
                self:UpdateLayerInfo()
            end)
            if 1 == curLayerNum and collectRewardItemList then
                fun.set_rect_anchored_position(self.content1,0,0)
                for index, value in ipairs(collectRewardItemList) do
                    value:Close()
                end
                collectRewardItemList = {}
            end
        end
        LuaTimer:SetDelayFunction(0.3, function()
            Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
        end)
        self:UpdateGrandPrize()
        self.text_level.text = string.format("<color=#fedd29><size=36>LEVEL</size></color> <color=#ffffff>%s</color><color=#fedd29>/%s</color>",curLayerNum,#layerItemList)
    end
    if math.abs(offset - content1Pos.y) > precision then
        local visible_top_index = 10  --可见范围顶部格子下标
        local maxCount = #layerItemList
        local max_content_y = original_pos.y - (maxCount - visible_top_index) * gap
        local target_y = content1Pos.y + (offset - content1Pos.y)
        Anim.move_ease(self.content1,content1Pos.x,math.max(max_content_y,target_y),content1Pos.z,0.2,true,DG.Tweening.Ease.InOutSine,function()
            func()
        end)
    else
        func()
    end
end

function MiniGame01View:OpenBoxShowJackpot()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.openBoxShowJackpot)
end

function MiniGame01View:PlayOpenBoxGetReward(boxProperty,isGetReward)
    if isGetReward then
        boxProperty:PlayOpenBoxGetReward()
        self.maleAnima:Play("miniman_get",0,0)
    else
        boxProperty:PlayOpenBoxMissReward()
    end
end

function MiniGame01View:SetStageInfoBeforOpen()
    self:SetBoxInfoBeforOpen()
    for index, value in ipairs(boxes_cache_list) do
        if click_index == value:GetIndexNum() then
            self:PlayOpenBoxGetReward(value,true)
        else
            self:PlayOpenBoxGetReward(value,false)
        end
    end
end

function MiniGame01View:ResetGrandPrizeAnima()
    self.grandPrizeAnima:Play("idle",0,0)
end

function MiniGame01View:GrandPrizeObtainAnima()
    self.grandPrizeAnima:Play("get",0,0)
end

function MiniGame01View:OnOpenBoxShowJackpot()
    self:GrandPrizeObtainAnima()
    LuaTimer:SetDelayFunction(1.2, function()
        Facade.SendNotification(NotifyName.ShowUI,MiniGame01BigRewardView)
        self:UpdateBLimitBtnEnableState(false)
    end)
end

function MiniGame01View:EnterGameShowJackpot()
    self._fsm:GetCurState():DoAction2StiffStiff(self._fsm,MiniGame01Stiffparams.enterGameShowJackpot)
end

function MiniGame01View:OnEnterGameShowJackpot()
    self:SetStageInfoBeforOpen()
    LuaTimer:SetDelayFunction(1, function()
        self:GrandPrizeObtainAnima()
    end)
    LuaTimer:SetDelayFunction(1.4, function()
        Facade.SendNotification(NotifyName.ShowUI,MiniGame01BigRewardView)
    end)
end

function MiniGame01View:EnterGameShowClaimTopReward(params)
    --log.r("======================================>>EnterGameShowClaimTopReward " .. self._fsm:GetCurName())
    self._fsm:GetCurState():DoAction2StiffStiff(self._fsm,MiniGame01Stiffparams.enterGameShowClaimTopReward,params)
end

function MiniGame01View:OnEnterGameShowClaimTopReward(params)
    if params then
        self:SetBoxInfoBeforOpen()
    else
        self:SetStageInfoBeforOpen()
    end
    self:UpdateBtnCollectEnableState(false)
    LuaTimer:SetDelayFunction(1, function()
        self:OnOpenBoxShowClaimTopReward()
    end)
end

function MiniGame01View:OpenBoxShowClaimTopReward()
    --log.r("======================================>>OpenBoxShowClaimTopReward " .. self._fsm:GetCurName())
    self._fsm:GetCurState():DoAction2StiffPlay(self._fsm,MiniGame01Stiffparams.openBoxShowClaimTopReward)
end

function MiniGame01View:GetShowRewardData()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    local showRewardList = ModelList.MiniGameModel:GetAllAcquiredReward() --{{id = 2,value = 100000}}
    local grandPrizeRewardNum = ModelList.MiniGameModel:GetBoxLayerInfoById(nil,"grandPrize")

    if showRewardList and showRewardList[Resource.coin] then
        showRewardList[Resource.coin].value = showRewardList[Resource.coin].value + grandPrizeRewardNum
    else
        showRewardList[Resource.coin] = 
        {
            id = Resource.coin,
            value = grandPrizeRewardNum
        } 
    end

    if doubleReward > 0 then
        local doubleReward = {}
        for k , value in pairs(showRewardList) do
            table.insert(doubleReward,{id = value.id,value = value.value * 2})
        end
        showRewardList = doubleReward
    end
    return showRewardList

end

function MiniGame01View:OnOpenBoxShowClaimTopReward()
    self:UpdateBtnCollectEnableState(false)
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    local showRewardList = self:GetShowRewardData()
    AddLockCountOneStep(true)
    Event.AddListener(NotifyName.MiniGame01.MiniGameCollectError,self.MiniGameCollectError,self)
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,showRewardList,function()
        AddLockCountOneStep(true)
        -- Event.Brocast(EventName.Event_currency_change)
        Event.AddListener(NotifyName.MiniGame01.SubmitLayerResphone,self.HideClaimTopReward,self)
        local id = ModelList.MiniGameModel:GetActivateMiniGameId()
        local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
        ModelList.MiniGameModel:RequestSubmitInfo(id,1,0,fullUnix)
    end,nil,nil,true)
end

function MiniGame01View:MiniGameCollectError()
    Event.RemoveListener(NotifyName.MiniGame01.MiniGameCollectError,self.MiniGameCollectError,self)
    UIUtil.show_common_popup(1088,true,function()
        Facade.SendNotification(NotifyName.CloseUI, ViewList.CollectRewardsView)
        Facade.SendNotification(NotifyName.CloseUI, self)
    end,nil,nil,nil)     
end

function MiniGame01View:HideClaimTopReward(data)
    Event.RemoveListener(NotifyName.MiniGame01.SubmitLayerResphone,self.HideClaimTopReward,self)
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.hide,ClaimRewardViewType.CollectReward,nil,function()
        self:ExitOrRestartMiniGame()
        AddLockCountOneStep(false)
        Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
        if not data then
            UIUtil.show_common_popup(8011,true,nil,nil,nil,nil) 
        end
    end)
end

function MiniGame01View:EnterShowLayerTips()
    if self:ShowLayerTips() then
        -- for index, value in ipairs(boxes_cache_list) do
            -- value:PlayHidePropertyBox() --使用会造成帽子消失
        -- end
        return true
    end
    return false
end

function MiniGame01View:ShowLayerTips()
    local showTip = nil
    local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
    ---MiniGame/MiniGame01/MiniGame01View:877: attempt to index upvalue 'layerItemList' (a nil value)  收集的bug修改
    if not curLayerNum or not layerItemList or not layerItemList[curLayerNum] then
        return nil
    end
    if layerItemList[curLayerNum]:IsShowlayerTips() then
        showTip = 1
    elseif layerItemList[curLayerNum]:IsShowStageTips() then
        showTip = 2
    end
    if showTip then
        if self:CheckEnterGameNoTipState() then
            Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
        else
            LuaTimer:SetDelayFunction(0.5, function()
                Cache.load_prefabs("luaprefab_minigame_minigame01","text",function(obj)
                    if obj then
                        local go = fun.get_instance(obj,self.mask.transform.parent)
                        local refer = fun.get_component(go,fun.REFER)
                        local child_go = nil
                        self:RebindTextChildSprite(go,"root/TextBg","MiniTipsDi2")
                        self:RebindTextChildSprite(go,"root/intoBetterRewards/MiniTipsDi","MiniTipsDi")
                        self:RebindTextChildSprite(go,"root/TextBg","MiniTipsDi2")
                        if 1 == showTip then
                            child_go = refer:Get("betterReward")
                            local textLine1 = refer:Get("textLine1")
                            local textLine2 = refer:Get("textLine2")
                            local textLine3 = refer:Get("textLine3")
                            textLine1.text = Csv.GetDescription(985)
                            textLine2.text = Csv.GetDescription(994)
                            textLine3.text = Csv.GetDescription(995)
                        elseif 2 == showTip then
                            child_go = refer:Get("noThief")
                        end
                        if child_go then
                            fun.set_active(child_go,false)
                        end
                        local animator = refer:Get("anima")
                        animator:Play("text_start",0,0)
                        LuaTimer:SetDelayFunction(1.4, function()
                            animator:Play("text_end",0,0)
                        end)
                        LuaTimer:SetDelayFunction(1.8, function()
                            Destroy(go)
                            Event.Brocast(NotifyName.MiniGame01.MiniGameSequenceStepFinish)
                        end)
                    end
                end)
            end)
        end
    elseif isMeetThief and isFreeExpelThief then
        self:CheckEnterGameNoTipState()
        Facade.SendNotification(NotifyName.ShowUI,MiniGame01DodgeView)
    end
    self:CheckEnterGameNoTipState()
    return showTip
end

function MiniGame01View:ExitOrRestartMiniGame()
    log.r("=============================>>3410ExitOrRestartMiniGame " .. self._fsm:GetCurName())
    self._fsm:GetCurState():ExitOrRestartMiniGame(self._fsm)
end

function MiniGame01View:SetMaskColor(isShow)
    if isShow then
        self.mask.color = Color.New(0.282,0.063,0.035,0.392)
        fun.set_active(self.mask.transform,true)
    else
        Anim.image_color_loop(self.mask,Color.New(0.282,0.063,0.035,0),0.35,1,function()
            fun.set_active(self.mask.transform,false)
        end)
    end
end

function MiniGame01View:OnExitOrRestartMiniGame()
    local minigame = ModelList.MiniGameModel:CheckMiniGameAvailable()
    --log.log("检查下次回合 OnExitOrRestartMiniGame"   , minigame)
    if minigame and minigame.progress >= minigame.target  then
        self:UpdateBLimitBtnEnableState(true)
        self:SetMaskColor(false)
        flyReward = flyReward or propertyView2
        for index,value in  ipairs(boxes_cache_list) do
            value:ResetPalyRound()
            value:SetParent(self.hatLayer,false)
            self:UpdateHatBtnEnableState(index , true)
        end
        self.mask.transform:SetAsLastSibling()
        self:SetLayerInfoUi()
        self:SetCollectBtnAvaliable()
        fun.enable_component(self.scrollview1, true)
        fun.enable_component(self.scrollview2,true)
    else
        self:PlayQuitAction()
    end
end

function MiniGame01View:ExpelTheThief()
    self:SetMaskColor(false)
    flyReward:PlayHidePropertyBox()
    flyReward:SetLock(true)
end

function MiniGame01View:OnCollectAndQuit()
    Event.AddListener(NotifyName.MiniGame01.CollectAndQuitResult,self.OnCollectAndQuitResult,self)
    Facade.SendNotification(NotifyName.ShowUI,MiniGame01QuitView)
end

function MiniGame01View:OnCollectAndQuitResult(isQuit)
    Event.RemoveListener(NotifyName.MiniGame01.CollectAndQuitResult,self.OnCollectAndQuitResult,self)
    if isQuit then
        local minigame = ModelList.MiniGameModel:CheckMiniGameAvailable()
        --log.log("检查下次回合 OnCollectAndQuitResult"   , minigame)
        if minigame and minigame.progress >= minigame.target then
            self._fsm:GetCurState():StiffOver(self._fsm)
            self:ExitOrRestartMiniGame()
        else
            self:PlayQuitAction()
        end

    else
        self._fsm:GetCurState():StiffOver(self._fsm)
    end
end

function MiniGame01View:on_btn_property1_click()
    --log.r("=============================>>on_btn_property1_click " .. self._fsm:GetCurName())
    self._fsm:GetCurState():StartPlay(self._fsm,1)
end

function MiniGame01View:on_btn_property2_click()
    --log.r("=============================>>on_btn_property2_click " .. self._fsm:GetCurName())
    self._fsm:GetCurState():StartPlay(self._fsm,2)
end

function MiniGame01View:on_btn_property3_click()
    --log.r("=============================>>on_btn_property3_click " .. self._fsm:GetCurName())
    self._fsm:GetCurState():StartPlay(self._fsm,3)
end

function MiniGame01View:on_btn_property4_click()
    --log.r("=============================>>on_btn_property4_click " .. self._fsm:GetCurName())
    self._fsm:GetCurState():StartPlay(self._fsm,4)
end

function MiniGame01View:on_btn_collect_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.collectAndQuit)
end

function MiniGame01View:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI,MiniGame01PlayHelperView)
end

function MiniGame01View:on_btn_buy_click()
    Facade.SendNotification(NotifyName.ShowUI,MiniGame01PopupView , nil,false , {showCollectTopView = false , isLobbyOpen = false})
end

function MiniGame01View:OpenBox(index)
    fun.enable_component(self.scrollview1,false)
    fun.enable_component(self.scrollview2,false)
    click_index = index
    reward_miss,reward_hit = ModelList.MiniGameModel:GetOpenBoxReward()
    log.log("===============================>>3410OpenBox " , reward_hit)
    --isMeetThief = ModelList.MiniGameModel:IsMeetThief()
    --isFreeExpelThief = ModelList.MiniGameModel:CheckExpelThiefMethod(ExpelThief.free)
    layer_index = ModelList.MiniGameModel:GetCurrentLayerNum()
    local id = ModelList.MiniGameModel:GetActivateMiniGameId()
    local fullUnix = ModelList.MiniGameModel:GetTicketsInfoById(id,"fullUnix")
    ModelList.MiniGameModel:RequestSubmitInfo(id,0,0,fullUnix)
end

function MiniGame01View.OnForceResetMiniGame()
    this:ExitOrRestartMiniGame()
end

--按钮状态修改
function MiniGame01View:UpdateHatBtnEnableState(buttonIndex,enableState)
    local button = self["btn_property" .. buttonIndex]
    fun.enable_button(button , enableState)
end

function MiniGame01View:CheckEnterGameNoTipState()
    local state = enterNoTip == true
    enterNoTip = false
    return state
end

function MiniGame01View:OnResetState()
    Event.Brocast(NotifyName.MiniGame01.ErrorNetDataAction)
end


function MiniGame01View:AddPurchaseEvent()
    Event.AddListener(NotifyName.MiniGame01.PurchaseFlyHatIcon,self.OnFlyHatIcon,self)
    Event.AddListener(NotifyName.MiniGame01.PurchaseFlyDoubleRewardIcon,self.OnFlyDoubleRewardIcon,self)
end

function MiniGame01View:RemovePurchaseEvent()
    Event.RemoveListener(NotifyName.MiniGame01.PurchaseFlyHatIcon,self.OnFlyHatIcon,self)
    Event.RemoveListener(NotifyName.MiniGame01.PurchaseFlyDoubleRewardIcon,self.OnFlyDoubleRewardIcon,self)
end

local scaleFirstValue = 0.9
local scaleFirstTime = 0.1

local scaleSecondValue = 0.5
local scaleSecondTime = 0.4

local scaleThirdValue = 0.1
local scaleThirdTime = 0.3

local bezierUseTime = 0.8

function MiniGame01View:OnFlyHatIcon(flyObj, callBack)
    self:CommonFlyPurchaseIcon(flyObj , callBack, nil)
end

function MiniGame01View:OnFlyDoubleRewardIcon(flyObj, callBack)
    self:CommonFlyPurchaseIcon(flyObj , callBack , function()
        if not self:CheckLastPurchaseState() then
            self:CheckPlayDoubleRewardAction()
        end
        self:OnDoubleRewardChange()
    end)
end

function  MiniGame01View:CommonFlyPurchaseIcon(flyObj, callBack, myCallBack)
    local endPos = self.show.transform.position
    local scale = scaleFirstValue
    Anim.scale_to_xy(flyObj,scale,scale, scaleFirstTime , function()
        scale = scaleSecondValue
        Anim.scale_to_xy(flyObj,scale,scale, scaleSecondTime , function()
            scale = scaleThirdValue
            Anim.scale_to_xy(flyObj,scale,scale, scaleThirdTime)
        end)
    end)

    local path = {}
    local startPosition = flyObj.transform.position
    path[1] = fun.calc_new_position_between(startPosition, endPos, 0, 1, 0)
    path[2] = endPos
    fun.set_active(self.show, false)
    Anim.bezier_move(flyObj,path, bezierUseTime,0,1,2,function()
        if callBack then
            callBack()
        end
        if myCallBack then
            myCallBack()
        end
        fun.set_active(self.show, true)
    end)
end

function MiniGame01View:UpdateGrandPrize()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    local rewardNum = ModelList.MiniGameModel:GetBoxLayerInfoById(nil,"grandPrize")
    if doubleReward > 0 then
        self.text_prize.text = fun.format_money(rewardNum * 2)
    else
        self.text_prize.text = fun.format_money(rewardNum)
    end
end

function MiniGame01View:CheckLastPurchaseState()
    if fun.get_active_self(self.icon_double) then
        return true
    end
    return false
end

function MiniGame01View:UpdateCollectRewardShowDouble()
    if  collectRewardItemList == nil then
        log.log("翻帽子没有道具就购买了双倍buff")
        return
    end
    for k , v in pairs(collectRewardItemList) do
        v:UpdateCollectRewardShowDouble()
    end
end

function MiniGame01View:CheckHasDoubleReward()
    local doubleReward = ModelList.ItemModel.get_doublehatReward()
    if doubleReward > 0 then
        return true
    else
        return false
    end
end



--- 此处会有一个丢资源白图问题，重新绑定一次
function MiniGame01View:RebindSprite()
    if self.go then
        --log.r("MiniGame01View:RebindSprite1")
        local child = fun.find_child(self.go,"SafeArea/top_layer2/Minibg2")
        if child then
            --local img = child:GetComponent(typeof(UnityEngine.UI.Image))
            --log.r("MiniGame01View:RebindSprite2")
            local img = fun.get_component(child,fun.IMAGE)
            if img then
                --log.r("MiniGame01View:RebindSprite3")
                if true then
                    --log.r("MiniGame01View:RebindSprite4")
                    img.sprite = AtlasManager:GetSpriteByName("MiniGame01Atlas","Minibg2")

                    --self:RebindChildSprite("background/Image","minibg2")
                    --self:RebindChildSprite("SafeArea/top_layer2/Minibg2","Minibg2")
                    self:RebindChildSprite("SafeArea/top_layer2/Minibg3","Minibg3")
                    self:RebindChildSprite("SafeArea/top_layer2/btn_help","Minixi")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/Qi01","MiniQiq01")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/QiNr/btn_box","MiniQiq01Nr01")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/QiNr/nao","MiniQiq01Nr02")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/QiNr/tittle","MiniQiq01Nr04")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/btn_buy","MiniBuy01")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/btn_buy/Image","MiniBuy03")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/Qi03","MiniQiq03")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/Qi02","MiniQiq02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand3/hand2","hand203")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand3/hand1","hand204")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand2/hand2","hand202")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand2/hand1","hand201")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/body","body")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat","hat")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/body","r01")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/body/r01s1","r01s1")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/body/r01s2","r01s2")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r02","r02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r03","r03")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04","r04")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye1/r06","r06")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye1/r07","r07")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye2/r05","r05")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye2/r07","r07")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/r041","r041")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rlj","rlj")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand1/hand1","hand103")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hand1/hand2","hand102")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head","head")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye1/eye1","eye1")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye1/eye101","eye101")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye1/eye103","eye103")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye1/eye102","eye102")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye1/eye102_b","eye102_b")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye2/eye2","eye2")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye2/eye201","eye201")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye2/eye203","eye203")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye2/eye202","eye202")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/eye2/eye202_b","eye202_b")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/head/hair1","hair1")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi01","MiniDi")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi01/MiniDi02","MiniDi02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi01/Bg01","MiniDoubleBg01")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi01/kuang","MiniDRR")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi01/kuang_d","MiniDRR02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi02","MiniDi")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi02/MiniDi02","MiniDi02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi02/Bg02","MiniDoubleBg02")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi02/kuang","MiniDRR")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniDi02/kuang_d","MiniDRR02")
                    self:RebindChildSprite("SafeArea/top_layer2/kuang_light","kuang_light")
                    self:RebindChildSprite("SafeArea/top_layer2/double","MiniDoubleBg03")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniDiTitleDi","MiniDiTitleDi")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniQi01","MiniQi01")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniQi02","MiniQi02")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniQi03","MiniQi01")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniQi04","MiniQi02")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniLight01","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniLight02","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniLight03","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/flag01/MiniLight04","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/flag02/MiniQi01","MiniQi02")
                    self:RebindChildSprite("SafeArea/top_layer1/flag02/MiniLight01","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/flag02/MiniLight02","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight01","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight02","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight03","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight04","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight05","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight06","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight07","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light01/MiniLight08","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight01","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight02","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight03","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight04","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight05","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight06","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight07","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light02/MiniLight08","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight01","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight02","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight03","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight04","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight05","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight06","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight07","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight08","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/light03/MiniLight09","MiniLight")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniTitle","MiniTitle")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi","MiniJinduDi")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1","Background")
                    --self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport","UIMask")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/BoxLevel/root/circle1","MiniJinduSZ01")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/BoxLevel/root/circle2","MiniJinduSZ03")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/BoxLevel/root/circle3","MiniJinduSZ02")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/extra_reward/bg","MiniJinduTipsDi")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/Cursor/root/mask","MiniJinduBlue")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/Cursor/root/arrow1","MiniJinduJT")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/Scroll View1/Viewport/Content/Cursor/root/arrow1/arrow2","MiniJinduJT")
                    self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/MiniJinduRewardDi","MiniJinduRewardDi")
                    --self:RebindChildSprite("SafeArea/top_layer1/MiniJinduDi/MiniJinduRewardDi/root/prize","powerup_icon_004")
                    self:RebindChildSprite("SafeArea/top_layer1/Scroll View2","Background")
                    --self:RebindChildSprite("SafeArea/top_layer1/Scroll View2/Viewport","UIMask")
                    self:RebindChildSprite("SafeArea/weimu/weimu_up","miniWeiMu03")

                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/buy/QiNr/btn_box/double","MiniQiq01Nr03")
                    self:RebindChildSprite("SafeArea/top_layer2/Qiq/Qi03","MiniQiq03")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye1/r062","r062")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye1/r07","r07")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye2/r051","r051")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/eye2/r052","r052")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/r042","r042")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rhead/r04/r043","r043")
                    self:RebindChildSprite("SafeArea/top_layer2/MiniMan/root/Man/hat/r/rlj","rlj")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty1/root/hat/hat01","MiniHatG01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty1/root/rewards/lucky/MiniLucky02","MiniLucky02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty1/root/rewards/lucky/MiniLucky01","MiniLucky01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty2/root/hat/hat02","MiniHatG02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty2/root/hat/hat01","MiniHatG01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty2/root/rewards/lucky/MiniLucky02","MiniLucky02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty2/root/rewards/lucky/MiniLucky01","MiniLucky01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty3/root/hat/hat02","MiniHatG02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty3/root/hat/hat01","MiniHatG01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty3/root/rewards/lucky/MiniLucky02","MiniLucky02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty3/root/rewards/lucky/MiniLucky01","MiniLucky01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty4/root/hat/hat02","MiniHatG02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty4/root/hat/hat01","MiniHatG01")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty4/root/rewards/lucky/MiniLucky02","MiniLucky02")
                    self:RebindChildSprite("SafeArea/top_layer2/hatLayer/stageProperty4/root/rewards/lucky/MiniLucky01","MiniLucky01")
                end
            end
        end
        --self:RebindChildSprite("SafeArea/bg/light01","miniTKLight2")
    end
end

function MiniGame01View:RebindChildSprite(path, spriteName)
    local child = fun.find_child(self.go,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            img.sprite = AtlasManager:GetSpriteByName("MiniGame01Atlas",spriteName)
        end
    end
end

function MiniGame01View:RebindTextChildSprite(obj, path, spriteName)
    local child = fun.find_child(obj,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            img.sprite = AtlasManager:GetSpriteByName("MiniGame01Atlas",spriteName)
        end
    end
end


function MiniGame01View:UpdateBLimitBtnEnableState(enableState)
    fun.enable_button(self.btn_buy ,enableState )
    fun.enable_button(self.btn_help , enableState)
end

function MiniGame01View:DataErrorForceClose()
    UIUtil.show_common_popup(8011)
    Facade.SendNotification(NotifyName.CloseUI,MiniGame01PopupView)
    Facade.SendNotification(NotifyName.CloseUI,MiniGameStealthView)
    Facade.SendNotification(NotifyName.CloseUI,MiniGame01BigRewardView)
    Facade.SendNotification(NotifyName.CloseUI,MiniGame01QuitView)
    Facade.SendNotification(NotifyName.CloseUI,MiniGame01PlayHelperView)
    Facade.SendNotification(NotifyName.CloseUI,self)
end

this.NotifyList = {
    {notifyName = NotifyName.MiniGame01.ResphoneLayerInfo,func = this.OnResphoneLayerInfo},
    {notifyName = NotifyName.MiniGame01.MiniGameSubmitResult,func = this.OnSubmitLayerResphone},
    {notifyName = NotifyName.MiniGame01.ForceResetMiniGame,func = this.OnForceResetMiniGame}
}

return this