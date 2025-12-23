local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
local FunctionIconCouponChildView = require "View/CommonView/FunctionIconCouponChildView"
local FunctionIconCuisinesView = require "View/CommonView/FunctionIconCuisinesView"

local FunctionIconCouponView = FunctionIconCuisinesView:New()
local this = FunctionIconCouponView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "content",
    "function_icon",
    "anim",
}

function FunctionIconCouponView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconCouponView:on_close()
    self.couponActiveItems = nil
    self.childCount = nil
end

function FunctionIconCouponView:RegisterRedDotNode()
    
end

function FunctionIconCouponView:UnRegisterRedDotNode()
    
end


function FunctionIconCouponView:RegisterEvent()
    
end

function FunctionIconCouponView:RemoveEvent()
    
end

function FunctionIconCouponView:OnApplicationFocus(focus)
    if focus then
        --self:UpdataShow()
    end
end

function FunctionIconCouponView:IsFunctionOpen()
    local coupon = ModelList.CouponModel.get_couponAllActive()
    if #coupon > 0 then
        return true
    end
end

--是否过期
function FunctionIconCouponView:IsExpired()
    local coupon = ModelList.CouponModel.get_couponAllActive()
    if #coupon <= 0 then
        return true
    end
end

function FunctionIconCouponView:SetProgress()
    self:UpdataShow()
end

function FunctionIconCouponView:UpdataShow()
    self.childCount = 0
    self:UpdataShowChildFun(CouponActiveType.buyCard)
    self:UpdataShowChildFun(CouponActiveType.powerup)
    self:UpdataShowChildFun(CouponActiveType.jackpot)
end

function FunctionIconCouponView:UpdataShowChildFun(couponActiveType)
    local coupon = ModelList.CouponModel.get_currentCouponByActive(couponActiveType)
    if coupon then
        local coupon_data = Csv.GetData("coupon",coupon.id,"application")
        local gameMode = ModelList.CityModel:GetEnterGameMode()
        if gameMode ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET and coupon_data == 2 then
            self:RemoveChildIcon(couponActiveType)
        elseif gameMode == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET and coupon_data == 1 then
            self:RemoveChildIcon(couponActiveType)
        elseif self.couponActiveItems and self.couponActiveItems[couponActiveType] then
            self.couponActiveItems[couponActiveType]:UpdataShow(coupon)
        else    
            local compo = FunctionIconCouponChildView:New(coupon,couponActiveType)
            local go = nil
            if self.childCount == 0 then
                go = fun.get_instance(self.function_icon,self.content)   
            else
                go = fun.get_instance(self.function_icon,self.content)    
            end
            compo:SkipLoadShow(go,true,nil,true)
            if not self.couponActiveItems then
                self.couponActiveItems = {}
            end
            self.couponActiveItems[couponActiveType] = compo
            self.childCount = self.childCount + 1
        end
    else
        self:RemoveChildIcon(couponActiveType)
    end
end

function FunctionIconCouponView:RemoveChildIcon(couponActiveType)
    if self.couponActiveItems and self.couponActiveItems[couponActiveType] then
        self.couponActiveItems[couponActiveType]:RemoveFunctionIcon()
        self.couponActiveItems[couponActiveType] = nil
    end
end

return this