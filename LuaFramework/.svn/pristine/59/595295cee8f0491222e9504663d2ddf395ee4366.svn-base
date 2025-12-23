MiniGame01PopupView = BaseMiniGame01:New("MiniGame01PopupView","MiniGame01PopupAtlas","luaprefab_minigame_minigame01popup")
local this = MiniGame01PopupView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "btn_close",
    "btn_buy1",
    "btn_buy2",
    "text_exp1",
    "text_exp2",
    "text_day1",
    "text_day2",
    "text_cost1",
    "text_cost2",
    "text_tips1",
    "text_tips2",
    "flyLayer",
    "icon1",
    "icon2",
}
this.isCleanRes = true
this._cleanImmediately = true
local showCollectTopView = false --发放道具 展示上面的UI
local isLobbyOpen = false   --是否是点击了 大厅里面的icon进入的
function MiniGame01PopupView:GetDoubleTime(seconds)
    if seconds >= 24 * 60 * 60 then
        return string.format("%sDay",math.floor(seconds/60/60/24))
    elseif seconds >= 60 * 60 then
        return string.format("%sHour",math.floor(seconds/60/60))
    elseif seconds >= 60 then
        return string.format("%sMin",math.floor(seconds/60))
    else
        return string.format("%sSec",seconds)
    end
end

function MiniGame01PopupView:Awake(obj)
    self:on_init()
end

function MiniGame01PopupView:OnEnable(enableParams)
    Facade.RegisterView(self)
    enableParams = enableParams or {}
    showCollectTopView = enableParams.showCollectTopView or false
    isLobbyOpen = enableParams.isLobbyOpen or false
    local grocery =  Csv.GetData("grocery",2)
    self.text_exp1.text = tostring(grocery.item[2][2])
    self.text_day1.text = self:GetDoubleTime(grocery.item[1][2])
    self.text_cost1.text = string.format("$%s",grocery.price)
    grocery =  Csv.GetData("grocery",3)
    self.text_exp2.text = tostring(grocery.item[2][2])
    self.text_day2.text = self:GetDoubleTime(grocery.item[1][2])
    self.text_cost2.text = string.format("$%s",grocery.price)
    self.text_tips1.text = Csv.GetDescription(987)
    self.text_tips2.text = Csv.GetDescription(988)
    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)
    self:RebindSprite()
end

function MiniGame01PopupView:OnDisable()
    self:RemnoveClickHatEvent()
    self:RemnoveClickDoubleRewardEvent()
    Facade.RemoveView(self)
    self:DisposeFsm()
end

function MiniGame01PopupView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01DodgeView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01PopupView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGame01PopupView:PlayEnterAction()
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGame01PopupView_start"},false,function()
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
    end)
end

function MiniGame01PopupView:on_btn_close_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.hatBoost)
end

function MiniGame01PopupView:OnHatBoostExit()
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01PopupView_end"},false,function()
        Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function MiniGame01PopupView:OnHatBoostPurchse(params)
    ModelList.MainShopModel.C2S_RequestBuyGrocery(params)
end

function MiniGame01PopupView.OnGroceryBuyFailure()
    this:RemnoveClickHatEvent()
    this:RemnoveClickDoubleRewardEvent()
end

function MiniGame01PopupView:RemnoveClickHatEvent()
    Event.RemoveListener(NotifyName.MiniGame01.PurchaseHatUpdateItem,self.PurchaseHatEvent,self)
end

function MiniGame01PopupView:RemnoveClickDoubleRewardEvent()
    Event.RemoveListener(NotifyName.MiniGame01.PurchaseDoubleRewardUpdateItem,self.PurchaseDoubleRewardEvent,self)
end

function MiniGame01PopupView.OnGroceryBuySuccess(buyId)
    log.log("minigame 购买成功准备动画")
    Event.Brocast(NotifyName.MiniGame01.PurchaseHatUpdateItem, buyId)
    Event.Brocast(NotifyName.MiniGame01.PurchaseDoubleRewardUpdateItem , buyId)
end

function MiniGame01PopupView:OnCollectItem(buyId, flyStartPos)
    local items = Csv.GetData("grocery",buyId,"item")
    for key, value in pairs(items) do
        local flyitem = value[1]
        if flyitem ~= Resource.doublehat_reward and flyitem ~= Resource.double_hat then
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,flyStartPos,flyitem, nil, nil, showCollectTopView)
        end
    end
end

--购买帽子
function MiniGame01PopupView:on_btn_buy1_click()
    Event.AddListener(NotifyName.MiniGame01.PurchaseHatUpdateItem,self.PurchaseHatEvent,self)
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.hatBoostPurchse,2,true)
end

function MiniGame01PopupView:PurchaseHatEvent(buyId)
    self:RemnoveClickHatEvent()
    local flyStartPos = self.btn_buy1.transform.position
    self:OnCollectItem(buyId, flyStartPos)
    fun.set_parent(self.icon1 , self.flyLayer)
    AnimatorPlayHelper.Play(this.anima,{"end","MiniGame01PopupView_end"},false,function()
        if isLobbyOpen then
            Event.Brocast(NotifyName.MiniGame01.LobbyPurchaseFlyHatIconToLobby , self.icon1 , function()
                self:BackState()
                Facade.SendNotification(NotifyName.CloseUI,this)
            end)
        else
            Event.Brocast(NotifyName.MiniGame01.PurchaseFlyHatIcon , self.icon1 , function()
                self:BackState()
                Facade.SendNotification(NotifyName.CloseUI,this)
            end)
        end
    end)
end
--购买帽子

--购买双倍奖励
function MiniGame01PopupView:on_btn_buy2_click()
    Event.AddListener(NotifyName.MiniGame01.PurchaseDoubleRewardUpdateItem,self.PurchaseDoubleRewardEvent,self)
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.hatBoostPurchse,3,true)
end

function MiniGame01PopupView:PurchaseDoubleRewardEvent(buyId)
    self:RemnoveClickDoubleRewardEvent()
    local flyStartPos = self.btn_buy2.transform.position
    self:OnCollectItem(buyId, flyStartPos)
    fun.set_parent(self.icon2 , self.flyLayer)
    AnimatorPlayHelper.Play(this.anima,{"end","MiniGame01PopupView_end"},false,function()
        if isLobbyOpen then
            Event.Brocast(NotifyName.MiniGame01.LobbyPurchaseFlyDoubleRewardIcon , self.icon2 , function()
                self:BackState()
                Facade.SendNotification(NotifyName.CloseUI,this)
            end)
        else
            Event.Brocast(NotifyName.MiniGame01.PurchaseFlyDoubleRewardIcon , self.icon2 , function()
                self:BackState()
                Facade.SendNotification(NotifyName.CloseUI,this)
            end)
        end
       

       
    end)
end
--购买双倍奖励

--- 此处会有一个丢资源白图问题，重新绑定一次
function MiniGame01PopupView:RebindSprite()
    --log.r("RebindSprite  1")
    if self.go then
        --log.r("RebindSprite  2")
        local child = fun.find_child(self.go,"SafeArea/bg/light01")
        if child then
            --local img = child:GetComponent(typeof(UnityEngine.UI.Image))
            local img = fun.get_component(child,fun.IMAGE)
            if img then
                if true then
                    img.sprite = AtlasManager:GetSpriteByName("MiniGame01PopupAtlas","miniTKLight2")
                    self:RebindChildSprite("SafeArea/bg/light01/Light1","miniTKLight")
                    self:RebindChildSprite("SafeArea/bg/light02","miniTKLight2")
                    self:RebindChildSprite("SafeArea/bg/light03","miniTKLight2")
                    self:RebindChildSprite("SafeArea/bg/light04","miniTKLight2")
                    self:RebindChildSprite("SafeArea/bg/light05","miniTKLight2")
                    self:RebindChildSprite("SafeArea/bg/light02/Light2","miniTKLight")
                    self:RebindChildSprite("SafeArea/bg/light03/Light3","miniTKLight")
                    self:RebindChildSprite("SafeArea/bg/light04/Light4","miniTKLight")
                    self:RebindChildSprite("SafeArea/bg/light05/Light5","miniTKLight")
                    self:RebindChildSprite("SafeArea/tittle/tbg01","miniTKDiBt")
                    self:RebindChildSprite("SafeArea/tittle/tbg01 (1)","miniTKDiBt")
                    self:RebindChildSprite("SafeArea/tittle/tbg01 (2)","miniTKTitle")
                    self:RebindChildSprite("SafeArea/miniTKT01","miniTKT01")
                    self:RebindChildSprite("SafeArea/miniTKT01/minitittle_bg","miniTKTfontDi01")
                    self:RebindChildSprite("SafeArea/miniTKT01/minitittle_bg/minitittle","miniTKTfont01")
                    self:RebindChildSprite("SafeArea/miniTKT01/icon/miniTKhat","miniTKhat")
                    self:RebindChildSprite("SafeArea/miniTKT01/icon/miniTKsz","miniTKsz")
                    self:RebindChildSprite("SafeArea/miniTKT01/icon/miniTKhatDi01","miniTKhatDi01")
                    self:RebindChildSprite("SafeArea/miniTKT01/icon/miniTKBs","miniTKBs")
                    self:RebindChildSprite("SafeArea/miniTKT02","miniTKT02")
                    self:RebindChildSprite("SafeArea/miniTKT02/minitittle_bg","miniTKTfontDi02")
                    self:RebindChildSprite("SafeArea/miniTKT02/minitittle_bg/minitittle","miniTKTfont02")
                    self:RebindChildSprite("SafeArea/miniTKT02/icon/miniTKhat","miniTKBox")
                    self:RebindChildSprite("SafeArea/miniTKT02/icon/miniTKsz","miniTKsz")
                    self:RebindChildSprite("SafeArea/miniTKT02/icon/miniTKhatDi01","miniTKhatDi01")
                    self:RebindChildSprite("SafeArea/miniTKT02/icon/miniTKBs","miniTKBs")
                    self:RebindChildSprite("SafeArea/miniTKT02/icon/miniTKhatDi01","miniTKhatDi01")
                end
            end
        end
        --self:RebindChildSprite("SafeArea/bg/light01","miniTKLight2")
    end
end

function MiniGame01PopupView:RebindChildSprite(path, spriteName)
    local child = fun.find_child(self.go,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            --log.r("spriteName = "..spriteName )

            img.sprite = AtlasManager:GetSpriteByName("MiniGame01PopupAtlas",spriteName)
        end
    end
end


--购买双倍奖励

function MiniGame01PopupView:BackState()
    if self._fsm and self._fsm:GetCurState() then
        self._fsm:GetCurState():StiffOver(self._fsm)
    end
end

this.NotifyList = {
    {notifyName = NotifyName.Grocery.GroceryBuySuccess,func = this.OnGroceryBuySuccess},
    {notifyName = NotifyName.Grocery.GroceryBuyFailure,func = this.OnGroceryBuyFailure}
}