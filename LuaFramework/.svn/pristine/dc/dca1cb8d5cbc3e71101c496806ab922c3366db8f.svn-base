--require "View/CommonView/TopCurrencyVipView"
require "View/ShopView/ShopTopItemView"
require "View/ShopView/ShopChildItemBaseView"
require "View/ShopView/ShopTopItemChildView"
require "View/ShopView/ShopNormalItemView"
require "View/ShopView/TopVipView"

local ShopBaseState = require "State/ShopView/ShopBaseState"
local ShopOriginalState = require "State/ShopView/ShopOriginalState"
local ShopEnterState = require "State/ShopView/ShopEnterState"
local ShopStiffState = require "State/ShopView/ShopStiffState"

ShopView = TopBarControllerView:New("ShopView", "ShopAtlas") --BaseView:New("ShopView","ShopAtlas")

local this = ShopView
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog

--local _currency = TopCurrencyVipView:New(nil,nil,nil,true,RedDotNode.shop_top_shop)
local _shopIndex = SHOP_TYPE.SHOP_TYPE_CHIPS
local _previousIndex = nil
local _currentToggle = nil
local _previousToggle = nil

local shopItemEntity = nil
local itemViewList = nil

local m_TopVipView = TopVipView:New()

local m_purchasing_shopData = nil
local flyEffectPos = nil

this.auto_bind_ui_items = {
    "anima",
    "Toggle_Coins",
    "Toggle_Gems",
    "Toggle_Offers",
    "Toggle_Items",
    "Toggle_Cherry",
    "content",
    "viewport",
    "loading",
    "img_reddot_coin",
    "img_reddot_gems",
    "img_reddot_offers",
    "img_reddot_items",
    "img_reddot_cherry",
    "topvip",
    "musicNotePanel",
    "imgNote",
    "text_note_value",
}

function ShopView:OpenView(callback, previousView, tab)
    Facade.SendNotification(NotifyName.ShopView.PopupShop, PopupViewType.show, previousView, tab, callback)
end

function ShopView:CloseView(callback)
    Event.Brocast(EventName.Event_Open_Shop_View, false)
    Facade.SendNotification(NotifyName.ShopView.PopupShop, PopupViewType.hide, nil, nil, nil)
end

function ShopView:HideCoverageEntity()
    self:NotifyHideCoverageEntity()
end

function ShopView:ShowCoverageEntity()
    self:NotifyShowCoverageEntity()
end

function ShopView:Awake(obj)
    self:on_init()
end

function ShopView:OnEnable()
    Facade.RegisterView(self)

    m_TopVipView:SkipLoadShow(self.topvip)
    --_currency:SkipLoadShow(self.topCurrency)

    self:SetToggleCallBack()
    self:SetShopIndex()

    self:BuildFsm()
    Event.Brocast(EventName.Event_topbar_change, false, TopBarChange.buyDgbA)
    self._fsm:GetCurState():PlayEnter(self._fsm)

    local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
    if buyshopitem then
        buyshopitem.ClearCurrentShopItem()
    end
    ModelList.GuideModel:OpenUI("ShopView")

    self:UpdateMusicNoteNum()
    self:ShowMusicNotePanel()
end

function ShopView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_coin", self.img_reddot_coin,
        RedDotParam.shop_coin)
    RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_gem", self.img_reddot_gems,
        RedDotParam.shop_gem)
    RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_offers", self.img_reddot_offers,
        RedDotParam.shop_offers)
    RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_items", self.img_reddot_items,
        RedDotParam.shop_items)
    RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_cherry", self.img_reddot_cherry,
        RedDotParam.shop_cherry)
end

function ShopView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_coin")
    RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_gem")
    RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_offers")
    RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_items")
    RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event, "shop_tab_cherry")
end

function ShopView:SetShowTab(tab)
    self.shopIndex = tab
end

function ShopView:SetShopIndex()
    _shopIndex = self.shopIndex or self:GetFreeRewardIndex() or SHOP_TYPE.SHOP_TYPE_CHIPS
    self.shopIndex = nil
    if _shopIndex == SHOP_TYPE.SHOP_TYPE_CHIPS then
        self.Toggle_Coins.isOn = true
        _currentToggle = self.Toggle_Coins.gameObject
    elseif _shopIndex == SHOP_TYPE.SHOP_TYPE_DIAMONDS then
        self.Toggle_Gems.isOn = true
        _currentToggle = self.Toggle_Gems.gameObject
    elseif _shopIndex == SHOP_TYPE.SHOP_TYPE_OFFERS then
        self.Toggle_Offers.isOn = true
        _currentToggle = self.Toggle_Offers.gameObject
    elseif _shopIndex == SHOP_TYPE.SHOP_TYPE_ITEMS then
        self.Toggle_Items.isOn = true
        _currentToggle = self.Toggle_Items.gameObject
    elseif _shopIndex == SHOP_TYPE.SHOP_TYPE_PRIZES then
        self.Toggle_Cherry.isOn = true
        _currentToggle = self.Toggle_Cherry.gameObject
    end
end

function ShopView:CheckShopTabIndex(tabIndex)
    return _shopIndex == tabIndex
end

function ShopView:GetFreeRewardIndex()
    if ModelList.MainShopModel:CheckFreeRewardAvailable() then
        return SHOP_TYPE.SHOP_TYPE_ITEMS
    end
    return nil
end

function ShopView:SetToggleCallBack()
    local toggles = { self.Toggle_Coins, self.Toggle_Gems, self.Toggle_Offers, self.Toggle_Items, self.Toggle_Cherry }
    for index, value in ipairs(toggles) do
        self.luabehaviour:AddToggleChange(value.gameObject, function(go, check)
            self:ToggleChange(go, check)
        end)
    end
end

function ShopView:ToggleChange(go, check)
    if check then
        _previousToggle = _currentToggle
        _currentToggle = go
        _previousIndex = _shopIndex
        if go == self.Toggle_Coins.gameObject then
            _shopIndex = SHOP_TYPE.SHOP_TYPE_CHIPS
        elseif go == self.Toggle_Gems.gameObject then
            _shopIndex = SHOP_TYPE.SHOP_TYPE_DIAMONDS
        elseif go == self.Toggle_Offers.gameObject then
            _shopIndex = SHOP_TYPE.SHOP_TYPE_OFFERS
        elseif go == self.Toggle_Items.gameObject then
            _shopIndex = SHOP_TYPE.SHOP_TYPE_ITEMS
        elseif go == self.Toggle_Cherry.gameObject then
            _shopIndex = SHOP_TYPE.SHOP_TYPE_PRIZES
        end
        if _previousIndex ~= _shopIndex then
            self:FetchShopInfo()
        end
        UISound.play("shop_exchange")
    end
    self:SetBackgroundEffect()
    local anima = fun.get_component(go.transform, fun.ANIMATOR)
    if anima then
        if check then
            anima:SetTrigger("Selected")
        else
            anima:SetTrigger("Normal")
        end
    end
    if _shopIndex == SHOP_TYPE.SHOP_TYPE_ITEMS then
        ModelList.GuideModel:OpenUI("ShopView")
    end
end

function ShopView:FetchShopInfo()
    self._fsm:GetCurState():FetchShopInfo(self._fsm)
end

function ShopView:OnFetchShopInfo()
    self:ShowLoadinCircle(true)
    self:SetToggleStiff(false)
    ModelList.MainShopModel.C2S_FetchShopInfo(_shopIndex)
end

function ShopView:SetToggleStiff(stiff)
    local toggles = { self.Toggle_Coins, self.Toggle_Gems, self.Toggle_Offers, self.Toggle_Items, self.Toggle_Cherry }
    for key, value in pairs(toggles) do
        if value then
            value.interactable = stiff
        end
    end
end

function ShopView:SetBackgroundEffect()
    --[[
    if self._fsm then
        local clip_name = nil
        if _shopIndex == SHOP_TYPE.SHOP_TYPE_CHIPS then
            clip_name = "efShopBgPurple"
        elseif _shopIndex == SHOP_TYPE.SHOP_TYPE_PRIZES then
            clip_name = "efShopBgGreen"
        else
            clip_name = "efShopBgBlue"
        end
        AnimatorPlayHelper.Play(self.anima,clip_name,false,nil)
    end
    --]]
end

function ShopView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima, "ShopView_enter", false, function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        self:ShowLoadinCircle(true)
        self:FetchShopInfo()
        UISound.play("shop_open")
        self:SetBackgroundEffect()
    end)
    self:RegisterRedDotNode()
end

function ShopView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("ShopView", self, {
        ShopOriginalState:New(),
        ShopEnterState:New(),
        ShopStiffState:New()
    })
    self._fsm:StartFsm("ShopOriginalState")
end

function ShopView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function ShopView:OnDisable()
    Facade.RemoveView(self)
    self:DisposeFsm()
    self:UnRegisterRedDotNode()
    Event.Brocast(EventName.Event_topbar_change, true, TopBarChange.buy, true)
    self.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog --有可能会动态设置这个值，关闭时还原回默认值
    m_purchasing_shopData = nil
    flyEffectPos = nil

    self.isInIdleState = false
    self.whetherNeedRefresh = false
    self.isWaittingRefresh = false

    Facade.SendNotification(NotifyName.ShopView.OnCloseViewFinish)
    --Event.Brocast(EventName.Event_Refresh_Rocket_Icon,false)

    self:ClearPromptionLoopTimer()
    self.promotionRemainTime = nil
end

function ShopView:on_close()
    shopItemEntity = nil
    itemViewList = nil
end

function ShopView:OnDestroy()
    self:Close()
    ModelList.MainShopModel:ClearShopData()
end

function ShopView:ShowLoadinCircle(active)
    fun.set_active(self.loading, active)
end

function ShopView:CloseTopBarParent()
    this._fsm:GetCurState():BtnGobackClick(this._fsm)
end

function ShopView:DoGoback()
    self:CloseView()
end

function ShopView.OnFetchShopDataResu()
    this:ShowLoadinCircle(false)
    if not itemViewList then
        itemViewList = {}
    end
    if not shopItemEntity then
        shopItemEntity = {}
    end
    --fun.set_rect_local_pos_y(this.viewport,-1844)
    if _previousIndex and shopItemEntity[_previousIndex] ~= nil then
        for key, value in pairs(shopItemEntity[_previousIndex]) do
            if value then
                value:Hide()
            end
        end
    end
    --Event.Brocast(EventName.Event_Refresh_Rocket_Icon,_shopIndex==3)
    if shopItemEntity[_shopIndex] == nil or #shopItemEntity[_shopIndex] == 0 then
        shopItemEntity[_shopIndex] = {}
        local shopData = ModelList.MainShopModel:GetShopData(_shopIndex)
        if shopData then
            local top = shopData["top"]
            local shopItem = nil
            local waitLoadCount = 1
            if top and fun.table_len(top) > 0 then
                waitLoadCount = waitLoadCount + 1
                Cache.load_prefabs(AssetList["ShopItemTop"], "ShopItemTop", function(objs)
                    if objs then
                        local go = fun.get_instance(objs)
                        if go then
                            fun.set_parent(go, this.content, true)
                            shopItem = ShopTopItemView:New()
                            shopItem:SkipLoadShow(go)
                            shopItem:SetChildItemInfo(top)
                            table.insert(shopItemEntity[_shopIndex], shopItem)
                            table.insert(itemViewList, shopItem)
                        end
                    end
                    waitLoadCount = waitLoadCount - 1
                    if waitLoadCount == 0 then
                        this:ScrollItems()
                    end
                end)
            end
            Cache.load_prefabs(AssetList["ShopItemNormal"], "ShopItemNormal", function(objs)
                if objs then
                    local normal = shopData["main"]
                    for i = 1, #normal, 2 do
                        local go = fun.get_instance(objs)
                        if go then
                            fun.set_parent(go, this.content, true)
                            shopItem = ShopNormalItemView:New(normal[i], normal[i + 1])
                            shopItem:SkipLoadShow(go)
                            table.insert(shopItemEntity[_shopIndex], shopItem)
                            table.insert(itemViewList, shopItem)
                        end
                    end
                end
                waitLoadCount = waitLoadCount - 1
                if waitLoadCount == 0 then
                    this:ScrollItems()
                end
            end)
        end
    else
        if _shopIndex and shopItemEntity[_shopIndex] ~= nil then
            for key, value in pairs(shopItemEntity[_shopIndex]) do
                if value then
                    value:Show()
                end
            end
        end
        this:ScrollItems()
    end

    this:UpdatePromptionLoopTimer()
end

function ShopView:UpdatePromptionLoopTimer()
    self:ClearPromptionLoopTimer()
    if ModelList.MainShopModel:IsPromotionValid() then
        self.promotionRemainTime = ModelList.MainShopModel:GetPromotionRemainTime()
        self.promotionLoopTimer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.promotionRemainTime then
                self.promotionRemainTime = self.promotionRemainTime - 1
                if self.promotionRemainTime <= 0 and ModelList.MainShopModel:GetPromotionRemainTime() <= 0 then
                    self.promotionRemainTime = nil
                    ModelList.MainShopModel.C2S_RefreshShopInfo()
                end
            end
        end, nil, nil, LuaTimer.TimerType.UI)
    end
end

function ShopView:ClearPromptionLoopTimer()
    if self.promotionLoopTimer then
        LuaTimer:Remove(self.promotionLoopTimer)
        self.promotionLoopTimer = nil
    end
end

function ShopView:ScrollItems()
    --Anim.scroll_to_y(this.viewport.transform,178.5,0.5,function()
    self:SetToggleStiff(true)
    self._fsm:GetCurState():FetchInfoFinish(self._fsm)
    --end)
end

function ShopView:UpdateMusicNoteNum(num)
    num = num or ModelList.ItemModel.get_musicalnoteCount()
    if fun.is_not_null(self.imgNote) then
        --self.imgNote.sprite = resMgr:GetSpriteByName("ItemAtlas", "iconWinzoneYf01")
    end

    if fun.is_not_null(self.text_note_value) then
        self.text_note_value:SetValue(num)
    end
end

function ShopView:ShowMusicNotePanel()
    fun.set_active(self.text_note_value, true)
end

function ShopView:HideMusicNotePanel()
    fun.set_active(self.text_note_value, false)
end

function ShopView.OnRequestBuyShopItem(shopData)
    local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
    if buyshopitem then
        m_purchasing_shopData = shopData
        flyEffectPos = buyshopitem.go.transform.position
        this._fsm:GetCurState():DoPurchasing(this._fsm)
    end
end

function ShopView:OnDoPurchasing()
    if m_purchasing_shopData then
        this:SetToggleStiff(false)
        this:ShowLoadinCircle(true)
        SDK.purchase_click({
            itemPos = m_purchasing_shopData.id,
            itemType = m_purchasing_shopData.item,
            price = m_purchasing_shopData.price,
            count = -1,
            balance = { ModelList.ItemModel.get_coin(), ModelList.ItemModel.get_diamond() }
        })
        AddLockCountOneStep()
        ModelList.MainShopModel.C2S_RequestBuyItem(m_purchasing_shopData.id)
    end
end

function ShopView.BuySucceedReshpone(shopItemId)
    --如果状态机中已被销毁，则不展示
    if not this._fsm then
        log.g("not this._fsm BuySucceedReshpone")
        return
    end

    this:ShowLoadinCircle(false)
    local items = Csv.GetData("shop", shopItemId, "item")
    --local flyType = {}
    local delay = 0
    local count = 0
    log.log("show shopItemId" .. "shopItemId")
    for key, value in pairs(items) do
        --table.insert(flyType,value[1])
        count = count + 1
        local coroutine_fun = function()
            local temDelay = delay
            delay = delay + 0.5
            local flyitem = value[1]
            coroutine.wait(temDelay)
            local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
            if buyshopitem then
                count = count - 1
                if 0 == count then
                    buyshopitem.ClearCurrentShopItem()
                    this:SetToggleStiff(true)
                    this._fsm:GetCurState():DoPurchasingFinish(this._fsm)
                end
                Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, flyEffectPos, flyitem, function()
                    Event.Brocast(EventName.Event_currency_change)
                    if ModelList.SeasonCardModel:IsCardPackage(flyitem) then
                        ModelList.SeasonCardModel:OpenCardPackage({ bagIds = { flyitem } })
                    end
                end)
            end
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    ModelList.MainShopModel.C2S_RefreshShopInfo() --SHOP_TYPE.SHOP_TYPE_ITEMS之前为什么固定为这个？
end

function ShopView.BuyFailureReshone(shopItemId)
    this:SetToggleStiff(true)
    this:ShowLoadinCircle(false)
    local buyshopitem = ShopChildItemBaseView.GetBuyShopItem()
    if buyshopitem then
        buyshopitem.ClearCurrentShopItem()
    end
    this._fsm:GetCurState():DoPurchasingFinish(this._fsm)
end

function ShopView.UpdateCountdown()
    if itemViewList then
        for key, value in pairs(itemViewList) do
            value:UpdateCountdown()
        end
    end
end

function ShopView.OnGroupPrefixRefresh()
    this.whetherNeedRefresh = false
    if this.isInIdleState then
        this:SimulateToggleChange()
    else
        this.whetherNeedRefresh = true
    end
end

function ShopView:SimulateToggleChange()
    _shopIndex = nil
    self:ClearAllShopItem()
    self.isWaittingRefresh = true
    self:ToggleChange(_currentToggle, true)
end

function ShopView:ClearAllShopItem()
    if itemViewList then
        for i, v in ipairs(itemViewList) do
            v:Close()
        end
    end
    itemViewList = nil
    shopItemEntity = nil
end

function ShopView.OnEnterIdle()
    this.isInIdleState = true
    if this.whetherNeedRefresh then
        this:SimulateToggleChange()
    end
    this.whetherNeedRefresh = false
end

function ShopView.OnLeaveIdle()
    this.isInIdleState = false
end

function ShopView.OMusicNoteNumChange(params)
    log.log("ShopView.OMusicNoteNumChange(params)", params)
    if params and params.newValue then
        this:UpdateMusicNoteNum(params.newValue.value)
    else
        this:UpdateMusicNoteNum()
    end
end

function ShopView.OnCloseLoadingView()
    this:ShowLoadinCircle(false)
end
--
--this.NotifyList = {
--    { notifyName = NotifyName.ShopView.FetchShopDataResut,   func = this.OnFetchShopDataResu },
--    { notifyName = NotifyName.ShopView.ShopItemRequestBuy,   func = this.OnRequestBuyShopItem },
--    { notifyName = NotifyName.ShopView.BuySucceedReshpone,   func = this.BuySucceedReshpone },
--    { notifyName = NotifyName.ShopView.BuyFailureReshone,    func = this.BuyFailureReshone },
--
--    { notifyName = NotifyName.PlayerInfo.RefreshGroupPrefix, func = this.OnGroupPrefixRefresh },
--    { notifyName = NotifyName.ShopView.EnterIdleState,       func = this.OnEnterIdle },
--    { notifyName = NotifyName.ShopView.LeaveIdleState,       func = this.OnLeaveIdle },
--    { notifyName = NotifyName.ShopView.MusicNoteNumChange,   func = this.OMusicNoteNumChange },
--    { notifyName = NotifyName.ShopView.CloseLoadingView,     func = this.OnCloseLoadingView },
--}

return this
