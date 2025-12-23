local ShopPromotionPosterView = BaseView:New('ShopPromotionPosterView')
local this = ShopPromotionPosterView

function ShopPromotionPosterView:New(view)
    local o = {}
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_play",
    "background",
    "SafeArea",
    "left_time_txt",
}

function ShopPromotionPosterView:Awake(obj, obj2)
    self:on_init()
end

function ShopPromotionPosterView:OnEnable()
    self:SaveToday()
    self:SetLeftTime()
    Facade.RegisterViewEnhance(self)
    self.isWaitingShopViewClose = false
end

function ShopPromotionPosterView:OnDisable()
    Facade.RemoveViewEnhance(self)
    Event.Brocast(EventName.Event_Popup_Shop_Promotion_Finish)
    self:ClearCountdownTimer()
    self.endTime = 0
end

function ShopPromotionPosterView:on_btn_close_click()
    --Facade.SendNotification(NotifyName.CloseUI,self)
    self:closeWithAnimation()
end


function ShopPromotionPosterView:on_btn_play_click()
    --Facade.SendNotification(NotifyName.CloseUI,self)
    --self:closeWithAnimation()
    log.log("ShopPromotionPosterView:on_btn_play_click()")
    local cb = function()
        fun.set_active(self.background, false)
        fun.set_active(self.SafeArea, false)
    end
    self.isWaitingShopViewClose = true
    Facade.SendNotification(NotifyName.ShopView.PopupShop, PopupViewType.show, nil, SHOP_TYPE.SHOP_TYPE_CHIPS, cb)
end

function ShopPromotionPosterView:SaveToday()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local today = os.date("%Y%m%d", os.time()) .. playerInfo.uid
    fun.save_value("ShopPromotionPosterView", today)
end

function ShopPromotionPosterView:_close()
    Facade.SendNotification(NotifyName.CloseUI, self)
    self.__index:_close(self)
end

function ShopPromotionPosterView:SetLeftTime()
    self:ClearCountdownTimer()
    self.endTime = ModelList.MainShopModel:GetPromotionRemainTime()
    if self.endTime > 0 then
        self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
        self.countdownTimer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.left_time_txt then
                self.left_time_txt.text = fun.SecondToStrFormat(self.endTime)
                self.endTime = self.endTime - 1
                if self.endTime < 0 then
                    self:ClearCountdownTimer()
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    else
        self.left_time_txt.text = fun.SecondToStrFormat(0)
    end
end

function ShopPromotionPosterView:ClearCountdownTimer()
    if self.countdownTimer  then
        LuaTimer:Remove(self.countdownTimer)
        self.countdownTimer = nil
    end
end

function ShopPromotionPosterView:OnShopViewClose()
    log.log("ShopPromotionPosterView:OnShopViewClose")
    if self.isWaitingShopViewClose then
        fun.set_active(self.background, true)
        fun.set_active(self.SafeArea, true)
        self.isWaitingShopViewClose = false
        self:on_btn_close_click()
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.ShopView.OnCloseViewFinish, func = this.OnShopViewClose},
}

return this