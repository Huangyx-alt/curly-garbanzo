
DiscountView = BaseView:New("off")
local this = DiscountView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima",
    "text_num1",
    "text_num2",
    "text_num3",
    "text_num4",
    "text_num5"
}

function DiscountView:New(couponType,coupon,isPowerUp,delay_callback)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._couponType = couponType
    o._coupon = coupon
    o._isPowerUp = isPowerUp
    o._delay_callback = delay_callback
    return o
end

function DiscountView:Awake()
    self:on_init()
end

function DiscountView:OnEnable()
    self:PlayEnter()
    self:Refresh()
    self:CheckDelayCallback()
end

function DiscountView:CheckDelayCallback()
    if self._delay_callback then
        self:PlayFreeTip(self._delay_callback)
        self._delay_callback = nil
    end
end

function DiscountView:Refresh()
    self._coupon = ModelList.CouponModel.get_currentCoupon(self._couponType)
    if self._coupon and (self._isRefresh == nil or self._isRefresh) then
        self._isRefresh = false
        local saleoff = Csv.GetData("coupon",self._coupon.id,"saleoff")
        if saleoff < 100 then
            fun.set_active(self.text_num1,true,false)
            fun.set_active(self.text_num2,true,false)  
            fun.set_active(self.text_num3,true,false)  
            fun.set_active(self.text_num4,false,false)
            self.text_num1.text = tostring(saleoff or 0)
        else
            fun.set_active(self.text_num1,false,false)
            fun.set_active(self.text_num2,false,false)  
            fun.set_active(self.text_num3,false,false)  
            fun.set_active(self.text_num4,true,false)  
            self.text_num1.text = "Free"
            self._isFree = true
        end
        if self._isPowerUp then
            fun.set_active(self.text_num5.transform.parent,true,false)
            --local num = Csv.GetDataNoAbTest(self._coupon.table or "reward_sky",self._coupon.tableId,"quantity")
            --self.text_num5.text = string.format("%s/%s", ModelList.CouponModel.get_couponCount(self._couponType), num)
            self.text_num5.text = tostring(ModelList.CouponModel.get_couponCount(self._couponType))
        else
            fun.set_active(self.text_num5.transform.parent,false,false)
        end
    end
end

function DiscountView:OnDisable()

end

function DiscountView:on_close()
    self._coupon = nil
    self._isPowerUp = nil
    self._isFree = nil
    self._isRefresh = nil
    self._couponType = nil
end

function DiscountView:PlayIdle()
    if self._coupon then
        --AnimatorPlayHelper.Play(self.anima,"offin",false,nil)
        self.anima:Play("offin",0,1)
    end
end

function DiscountView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,"offin",false,nil)
end

function DiscountView:PlayExit(callback)
    AnimatorPlayHelper.Play(self.anima,"offout",false,callback)
end

function DiscountView:PlayFreeTip(callback)
    AnimatorPlayHelper.Play(self.anima,"offtips",false,callback)
end

function DiscountView:PlayNumChange(callback)
    AnimatorPlayHelper.Play(self.anima,"offchange",false,callback)
end

function DiscountView:IsFree()
    return self._isFree or false
end

function DiscountView:SetVisible(show)
    if self.go then
        fun.set_active(self.go.transform,show,false)
        if not show then
            self._isRefresh = false
        else
            if self._isCloseDiscount then
                self:CloseDiscount(true)
            else
                self:PlayNumChange(function()
                    self._isRefresh = true
                    self:Refresh()
                end)
            end
        end
    end
end

function DiscountView:CloseDiscount(playExit)
    self._isCloseDiscount = true
    if playExit then
        self:PlayExit(function()
            self:Close()
        end)
    else
        self:Close()
    end
end