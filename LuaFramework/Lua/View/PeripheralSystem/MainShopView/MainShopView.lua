require "State/Common/CommonState"

local MainShopView = BaseView:New("MainShopView","MainShopAtlas")

local this = MainShopView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "toggleItem1",
    "toggleItem2",
    "toggleItem3",
    "toggleItem4",
    "textResourceNum",
    "shopTypeParent",
    "loading",
    "btn_cur_vip",
    "btn_shop_vip",
    "currVipIcon",
    "textCurrentAttr",
}

local shopTypeRequireName =
{
    [1] = "ChipsShopTypeView",
    [2] = "GemsShopTypeView",
    [3] = "PowerUpShopTypeView",
    [4] = "ItemShopTypeView",
}

local MainShopEnterState = require "View/PeripheralSystem/MainShopView/State/MainShopEnterState"
local MainShopRequestState = require "View/PeripheralSystem/MainShopView/State/MainShopRequestState"
local MainShopShowTypeState = require "View/PeripheralSystem/MainShopView/State/MainShopShowTypeState"
local MainShopIdleState = require "View/PeripheralSystem/MainShopView/State/MainShopIdleState"
local MainShopPurchaseState = require "View/PeripheralSystem/MainShopView/State/MainShopPurchaseState"
local MainShopDailyRewardState = require "View/PeripheralSystem/MainShopView/State/MainShopDailyRewardState"

local showShopToggleType = 1
local purchaseItemView = nil
local isCreatShopView = false

function MainShopView:GetSelectCardNum()
    return selectCardNumData[self.selectCardIndex]
end

function MainShopView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MainShopView", self, {
        MainShopEnterState:New(),
        MainShopIdleState:New(),
        MainShopRequestState:New(),
        MainShopShowTypeState:New(),
        MainShopPurchaseState:New(),
        MainShopDailyRewardState:New(),
    })
    self._fsm:StartFsm("MainShopEnterState")
end

function MainShopView:SwitchToTab(tab)
    showShopToggleType = tab
    self:ClickUpdateToggle()
end

function MainShopView:SetShowTab(tab)
    showShopToggleType = tab
end

function MainShopView:RefreshVip()
    local currVipLv = ModelList.PlayerInfoModel:GetVIP()
    self.currVipIcon.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. currVipLv)
    local addValue = ModelList.PlayerInfoModel.GetTotalAddValue()
    self.textCurrentAttr.text = string.format("%s%s%s","+", addValue , "%")
end

function MainShopView:PlayEnter()
    log.log("商店进入效果 ")
    self._fsm:GetCurState():EnterFinish(self._fsm,showShopToggleType)
end

function MainShopView:Awake()
    self:on_init()
end

function MainShopView:OnEnable()
    Facade.RegisterView(self)
    isCreatShopView = false
    self:RegEventFunc()
    showShopToggleType = showShopToggleType or BingoBangEntry.mainShopToggleType.Chips
    self.allShopTypeView = {}
    self:BuildFsm()
    self:InitToggle()
    self:RefreshVip()
    
    UISound.play("shopopen")
end

function MainShopView:ShopTypeView()
    if self.allShopTypeView[showShopToggleType] then
        self.allShopTypeView[showShopToggleType]:SetShopTypeActivity(true)
        self._fsm:GetCurState():OnShopTypeFinish(self._fsm,true)
    else
        self:CreatShopType(showShopToggleType)
    end
end

function MainShopView:InitToggle()
    for i  =1 , 4 do
        local toggleItem = self["toggleItem" .. i]
        self.luabehaviour:AddToggleChange(toggleItem.gameObject, function(go,check)
            self:UpdateToggle(i , check, false)     
        end)
        self:UpdateToggle(i, i == showShopToggleType,true)
    end
end

function MainShopView:UpdateToggle(toggleType,check,isInit)
    if isInit then
        self:OnChangeShopType(toggleType,check)
        return
    end
    if not check then
        return
    end
    log.log("刷新选项 UpdateToggle" , toggleType , check)
    if not self._fsm or not self._fsm:GetCurState() then
        log.log("状态错误检查 " )
        return
    end
    
    showShopToggleType = toggleType
    if  ModelList.MainShopModel.CheckMainShopDataExist(showShopToggleType) then
        self._fsm:GetCurState():OnClickShopType(self._fsm,true)
    else
        self._fsm:GetCurState():OnClickShopType(self._fsm,false)
    end

end

function MainShopView:ClickUpdateToggle()
    UISound.play("shopexchange")
    for i =1 , 4 do
        self:OnChangeShopType(i, i == showShopToggleType)
    end
end

function MainShopView:OnChangeShopType(toggleType,check)
    log.log("刷新选项 OnChangeShopType" , toggleType , check)

    local toggleItem = self["toggleItem" .. toggleType]
    fun.set_active(toggleItem.graphic, check)
    if check then
        showShopToggleType = toggleType
        self:ShopTypeView()
    else
        log.log("隐藏使用的" , toggleType)
        if self.allShopTypeView[toggleType] then
            self.allShopTypeView[toggleType]:SetShopTypeActivity(false)
        end
    end
end

function MainShopView:CreatShopType(currentShopType)
    log.log("商店修改内容 更换商店" ,currentShopType)
    if not ModelList.MainShopModel.CheckMainShopDataExist(currentShopType) then
        log.log("缺少商店类型数据", currentShopType)
        return
    end
    if isCreatShopView then
        log.log("正在创建 " , currentShopType)
        return
    end
    if shopTypeRequireName[currentShopType] then
        local requireData = self:GetRequireData(currentShopType)
        local shopTypeCode = require(requireData.requireCodePath)
        isCreatShopView = true
        Cache.load_prefabs(requireData.requirePrefabPath,requireData.shopTypeRequireName,function(ret)
            isCreatShopView = false
            if ret then
                local go = fun.get_instance(ret)
                fun.set_parent(go,self.shopTypeParent,true)
                local code = shopTypeCode:New()
                code:SkipLoadShow(go,true,nil,true)
                self.allShopTypeView[currentShopType] = code
                self._fsm:GetCurState():OnShopTypeFinish(self._fsm,true)
            else
                log.log("错误 商店UI引用" , currentShopType)
                self._fsm:GetCurState():OnShopTypeFinish(self._fsm,false)
            end
        end)
    else
        log.e("错误 缺少商店类型" , currentShopType)
        self._fsm:GetCurState():OnShopTypeFinish(self._fsm,false)
    end
end

function MainShopView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MainShopView:OnDisable()
    for k ,v in pairs(self.allShopTypeView) do
        v:Close()
    end
    self.allShopTypeView = {}
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function MainShopView:on_close()
end

function MainShopView:OnDestroy()
    purchaseItemView = nil
    self:UnRegEventFunc()
end

function MainShopView:on_btn_cur_vip_click()
    self._fsm:GetCurState():OnClickCurVip(self._fsm)
end

function MainShopView:OnClickClose()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function MainShopView:on_btn_close_click()
    self._fsm:GetCurState():BtnGobackClick(self._fsm)
end

function MainShopView:on_btn_shop_vip_click()
    self._fsm:GetCurState():OnClickShopVip(self._fsm)
end


function MainShopView:OnErrorClose()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function MainShopView:GetRequireData(currentShopType)
    local shopTypeRequireName = shopTypeRequireName[currentShopType]
    local data = 
    {
        shopTypeRequireName = shopTypeRequireName,
        requireCodePath = "View/PeripheralSystem/MainShopView/" .. shopTypeRequireName,
        requirePrefabPath = AssetList[shopTypeRequireName],
    }
    log.log("商店修改内容 加载的数据基础 " , data)
    return data
end 

function MainShopView:GetRequirePrefab(currentShopType)
    local requirePath = "View/PeripheralSystem/MainShopView/" .. shopTypeRequireName[currentShopType]
    log.log("加载商店脚本 "  ,requirePath)
end

function MainShopView:ReqCurrentShopData()
    self:ShowLoadinCircle(true)
    Event.AddListener(BingoBangEntry.mainShopViewEvent.ReqShopData,self.OnFetchShopDataResult,self)
    ModelList.MainShopModel.C2S_RefreshShopInfo(showShopToggleType)
end

function MainShopView:OnFetchShopDataResult()
    self:ShowLoadinCircle(false)
    Event.RemoveListener(BingoBangEntry.mainShopViewEvent.ReqShopData,self.OnFetchShopDataResult,self)
    self._fsm:GetCurState():FetchInfoFinish(self._fsm)
end

function MainShopView:RegEventFunc()
    Event.AddListener(BingoBangEntry.mainShopViewEvent.ClickButtonPurchase,self.OnClickButtonPurchase,self)
    Event.AddListener(BingoBangEntry.mainShopViewEvent.RefreshShopTypeView,self.RefreshShopTypeView,self)
    Event.AddListener(BingoBangEntry.mainShopViewEvent.ClickReqShopDailyFreeReward,self.ClickReqShopDailyFreeReward,self)
end

function MainShopView:UnRegEventFunc()
    Event.RemoveListener(BingoBangEntry.mainShopViewEvent.ClickButtonPurchase,self.OnClickButtonPurchase,self)
    Event.RemoveListener(BingoBangEntry.mainShopViewEvent.RefreshShopTypeView,self.RefreshShopTypeView,self)
    Event.RemoveListener(BingoBangEntry.mainShopViewEvent.ClickReqShopDailyFreeReward,self.ClickReqShopDailyFreeReward,self)
end

function MainShopView:ClickReqShopDailyFreeReward(dailyReward)
    self._fsm:GetCurState():OnClickDailyFreeReward(self._fsm,dailyReward)
end

function MainShopView:RefreshShopTypeView()
    if self.allShopTypeView[showShopToggleType] then
        self.allShopTypeView[showShopToggleType]:RefreshView()
    end
end

function MainShopView:OnClickButtonPurchase(itemId,purchaseItem)
    log.log("点击购买数据 " , itemId)
    purchaseItemView = purchaseItem
    self._fsm:GetCurState():DoPurchasing(self._fsm,itemId)
end

function MainShopView:RefreshShopType()
    if self.allShopTypeView[showShopToggleType] then
        self.allShopTypeView[showShopToggleType]:RefreshScrollItem()
        self.allShopTypeView[showShopToggleType]:RefreshView()
    end
end

function MainShopView.BuySucceedReshpone(shopItemId)
    --如果状态机中已被销毁，则不展示
    if not this._fsm then
        log.g("not this._fsm BuySucceedReshpone")
        return
    end

    this:ShowLoadinCircle(false)
    local items = Csv.GetData("new_shop", shopItemId, "item")
    local delay = 0
    local count = 0
    for key, value in pairs(items) do
        count = count + 1
        local coroutine_fun = function()
            local temDelay = delay
            delay = delay + 0.5
            local flyitem = value[1]
            coroutine.wait(temDelay)
            --local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
            --if buyshopitem then
                count = count - 1
                if 0 == count then
                --    buyshopitem.ClearCurrentShopItem()
                --    this:SetToggleStiff(true)
                    this:RefreshVip()
                    this:RefreshShopType()
                    this._fsm:GetCurState():DoPurchasingFinish(this._fsm,true)
                end
                local pos = purchaseItemView:GetViewPosition()
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, pos, flyitem, function()
                    Event.Brocast(EventName.Event_currency_change)
                end)
            --end
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    ModelList.shopModel.C2S_RefreshShopInfo() --SHOP_TYPE.SHOP_TYPE_ITEMS之前为什么固定为这个？
end

function MainShopView.BuyFailureReshone(shopItemId)
    this:ShowLoadinCircle(false)
    this._fsm:GetCurState():DoPurchasingFinish(this._fsm,false)
end

function MainShopView:ShowLoadinCircle(active)
    fun.set_active(this.loading, active)
    log.log("遮挡状态 " , active)
end

function MainShopView.OnDailyRewardRespone()
    if this._fsm ~= nil then
        this._fsm:GetCurState():OnClickDailyFreeRewardRespone(this._fsm, true)
    end
end

function MainShopView:SendDailyReward()
    if self.allShopTypeView[BingoBangEntry.mainShopToggleType.Chips] and self.allShopTypeView[BingoBangEntry.mainShopToggleType.Chips]:IsShopActivity() then
        self.allShopTypeView[BingoBangEntry.mainShopToggleType.Chips]:OnClaimReward()
    else
        log.log("奖励错误")
    end
end

this.NotifyList = {
    { notifyName = NotifyName.ShopView.BuySucceedReshpone,   func = this.BuySucceedReshpone },
    { notifyName = NotifyName.ShopView.BuyFailureReshone,    func = this.BuyFailureReshone },
    { notifyName = NotifyName.DailyRewardView.DailyRewardespone, func = this.OnDailyRewardRespone }

}

return this

