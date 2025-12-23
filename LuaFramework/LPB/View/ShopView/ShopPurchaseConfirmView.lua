require "State/Common/CommonState"

local ShopPurchaseConfirmView = BaseView:New("ShopPurchaseConfirmView","CommonAtlas")
local this = ShopPurchaseConfirmView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local item_cache_list = nil

this.auto_bind_ui_items = {
    "btn_sure",
    "btn_close",
    "content",
    "purchase_item",
    "text_title",
    "text_tip",
    "anima",
    "loading"
}

function ShopPurchaseConfirmView:Awake()
    self:on_init()
end

function ShopPurchaseConfirmView:OnEnable(params)
    Facade.RegisterView(self)
    if params then
        self.sure_callBack = params.sure_callBack
        self.close_callback = params.close_callback
        local view = require "View/ShopView/ShopPurchaseConfirmItem"
        item_cache_list = {}
        for index, value2 in ipairs(params.shopItems.detail_icon) do
            for key, value in pairs(params.shopItems.item_description) do
                if tonumber(value[1]) == tonumber(value2[1]) then
                    local go = fun.get_instance(self.purchase_item.transform,self.content)
                    fun.set_active(go.transform,true,false)
                    local itemView = view:New()
                    itemView:SkipLoadShow(go)
                    itemView:SetReward({id = tonumber(value[1]),num = value[2],icon = value2[2]})
                    table.insert(item_cache_list,itemView)
                end
            end
        end
        self.text_title.text = tostring(params.shopItems.title)
        local tip = Csv.GetData("description",params.shopItems.description_2,"description")
        self.text_tip.text = tostring(tip)
    end

    CommonState.BuildFsm(self,"CollectRewardsView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"ShopPurchaseConfirmenter","ShopPurchaseConfirmViewenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function ShopPurchaseConfirmView:OnDisable()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
    self.sure_callBack = nil
    item_cache_list = nil
    if self.close_callback then
        self.close_callback()
        self.close_callback = nil
    end
end

function ShopPurchaseConfirmView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"ShopPurchaseConfirmexit","ShopPurchaseConfirmViewexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function ShopPurchaseConfirmView:on_btn_sure_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        if self.sure_callBack then
            self.sure_callBack()
        end
        fun.set_active(self.loading.transform,true,false)
    end)
end

function ShopPurchaseConfirmView.BuySucceedReshpone(shopItemId)
    local delay = 0
    local coroutine_fun = nil
    for key, value in pairs(item_cache_list) do
        local itemId = value:GetRewardItemId()
        coroutine_fun = function()
            delay = delay + 0.2
            coroutine.wait(delay)
            Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,value:GetPosition(),value:GetRewardItemId(),function()
                Event.Brocast(EventName.Event_currency_change)
                if ModelList.SeasonCardModel:IsCardPackage(itemId) then
                    ModelList.SeasonCardModel:OpenCardPackage({bagIds = {itemId}})
                end
            end)
        end
        coroutine.resume(coroutine.create(coroutine_fun))
    end
    coroutine_fun = function()
        delay = delay + 0.5
        coroutine.wait(delay)
        this._fsm:GetCurState():DoCommonState1Action(this._fsm,"CommonOriginalState")
        fun.set_active(this.loading.transform,false,false)
        this:on_btn_close_click()
    end
    coroutine.resume(coroutine.create(coroutine_fun))
end

function ShopPurchaseConfirmView.BuyFailureReshone(shopItemId)
    fun.set_active(this.loading.transform,false,false)
    this._fsm:GetCurState():DoCommonState1Action(this._fsm,"CommonOriginalState")
end

this.NotifyList = {
    {notifyName = NotifyName.ShopView.BuySucceedReshpone,func = this.BuySucceedReshpone},
    {notifyName = NotifyName.ShopView.BuyFailureReshone,func = this.BuyFailureReshone}
}

return this