require "View/CommonView/RemainTimeCountDown"

local FunctionIconCouponChildView = BaseView:New("FunctionIconCouponChildView")
local this = FunctionIconCouponChildView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_coupon",
    "text_countdown",
    "img_reddot",
    "text_num",
    "img_icon"
}

function FunctionIconCouponChildView:New(coupon,couponActiveType)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._coupon = coupon
    o._couponActiveType = couponActiveType
    o.remainTimeCountDown = RemainTimeCountDown:New()
    return o
end

function FunctionIconCouponChildView:Awake()
    self:on_init()
end

function FunctionIconCouponChildView:OnEnable()
    self._init = true
    self:UpdataShow()
    self.showTipDelay = 10
end

function FunctionIconCouponChildView:OnDisable()
    self.shwoTipTime = nil
    self.showTipDelay = nil
    self._init = nil
    self.remainTimeCountDown:StopCountDown()
end

function FunctionIconCouponChildView:on_close()
    self._coupon = nil
    self._couponActiveType = nil
end

function FunctionIconCouponChildView:UpdataShow(coupon)
    if coupon then
        self._coupon = coupon
    end
    if self._init and self._coupon then
        self.text_num.text = tostring(string.format("x%s",ModelList.CouponModel.get_couponCountByActive(self._couponActiveType)))
        if self._coupon then
            local icon = Csv.GetData("coupon",self._coupon.id,"icon_function")
            Cache.GetSpriteByName("AdventureAtlas",icon,function(tex)
                self.img_icon.sprite = tex
            end)
            self.remainTimeCountDown:StopCountDown()
            self.remainTimeCountDown:StartCountDown(CountDownType.cdt3,math.max(0,self._coupon.cTime - os.time()),self.text_countdown,function()
                Event.Brocast(EventName.Event_coupon_change)
            end,function()
                self:Bubble()
            end)
        else
            self.remainTimeCountDown:UpdateRemainTime(nil)
        end
    end
end

function FunctionIconCouponChildView:RemoveFunctionIcon()
    self:Close()
end

function FunctionIconCouponChildView:on_btn_coupon_click()
    if self._coupon then
        local des_id = Csv.GetData("coupon",self._coupon.id,"description_icon")
        local des_text = Csv.GetData("description",des_id,"description")
        local params = {
            pos = self.btn_coupon.transform.position, 
            dir = TipArrowDirection.right,
            text = des_text,
            offset = Vector3.New(-400,0,0),
            exclude = {self.btn_coupon}
        }
        Facade.SendNotification(NotifyName.ShowUI,ViewList.FunctionShowTipView,nil,false,params)
        self.shwoTipTime = 5
    end
end

function FunctionIconCouponChildView:Bubble()
    if self.showTipDelay then
        self.showTipDelay = self.showTipDelay - 1
        if self.showTipDelay < 0 then
            self.showTipDelay = math.random(60,120)
            local camera = ProcedureManager:GetCamera()
            if Util.IsTopGraphic(camera,self.img_icon.transform.position,self.img_icon.gameObject) then
                self:on_btn_coupon_click()
            end  
        end
    end    
    if self.shwoTipTime then
        self.shwoTipTime = self.shwoTipTime - 1
        if self.shwoTipTime < 0 then
            self.shwoTipTime = nil
            Facade.SendNotification(NotifyName.CloseUI,ViewList.FunctionShowTipView)
        end
    end
end

return this