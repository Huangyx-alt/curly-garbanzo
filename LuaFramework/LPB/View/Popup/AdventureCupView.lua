require "View/CommonView/RemainTimeCountDown"

AdventureCupView = BaseView:New("AdventureCupView")
local this = AdventureCupView
this.viewType = CanvasSortingOrderManager.LayerType.None

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
    "icon_item",
    "text_num",
    "btn_cup",
    "left_time_txt",
    "img_ribbon_font"
}

function AdventureCupView:New(cup,reward,icon,target,num)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._cup = cup
    o._reward = reward
    o._icon = icon
    o._target = target
    o._targetNum = num
    return o
end

function AdventureCupView:Awake()
    self:on_init()
end

function AdventureCupView:OnEnable()
    Cache.SetImageSprite("AdventureAtlas",self._icon,self.icon_item)
    self.icon_item:SetNativeSize()
    self.text_num.text = string.format("x%s",self._reward[2])
end

function AdventureCupView:OnDisable()
    remainTimeCountDown:StopCountDown()
end

function AdventureCupView:OnApplicationFocus(focus)
    if focus and self then
        --self:SetTimer()
    end
end

function AdventureCupView:on_btn_cup_click()
    Facade.SendNotification(NotifyName.AdventureView.Pick_a_dice_box,self._cup)
end

function AdventureCupView:ChangeIcon()
    local icon = Csv.GetData("coupon",self._target,"icon")
    if icon then
        Cache.SetImageSprite("AdventureAtlas",icon,self.icon_item)
        self.icon_item:SetNativeSize()
        self.text_num.text =string.format("x%s",self._targetNum) 
    end
    self:SetTimer()
end

function AdventureCupView:SetTimer()
    local coupon = ModelList.CouponModel.get_theLatestCoupon()
    if coupon then
        remainTimeCountDown:StartCountDown(CountDownType.cdt4,math.max(0,coupon.cTime - os.time()),self.left_time_txt,nil,nil)
    else
        remainTimeCountDown:UpdateRemainTime(nil)    
    end
end

function AdventureCupView:GetPosition()
    if self.icon_item then
        return self.icon_item.transform.position
    end
    return Vector3.New(0,0,0)
end

function AdventureCupView:GetItemGameObject()
    if self.icon_item then
        return self.icon_item.gameObject
    end
    return nil
end

function AdventureCupView:GetItemParent()
    if self.icon_item then
        return self.icon_item.transform.parent
    end
end

function AdventureCupView:HideNumText()
    if self.text_num then
        fun.set_active(self.text_num,false,false)
    end
end

function AdventureCupView:ShowRibbon(show)
    if self._reward and self._reward[1] == self._target then
        fun.set_active(self.img_ribbon_font.transform.parent,show,false)
        if show then
            local slogan = Csv.GetData("coupon",self._target,"slogan")
            Cache.SetImageSprite("AdventureAtlas",slogan,self.img_ribbon_font)
        end
    end
end

return this