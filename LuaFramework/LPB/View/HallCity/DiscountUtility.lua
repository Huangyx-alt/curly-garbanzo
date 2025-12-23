require "View/HallCity/DiscountView"

DiscountUtility = {}
local this = DiscountUtility

function DiscountUtility:New(isPowerUp,couponAvtiveType)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._isPowerUp = isPowerUp
    o._couponAvtiveType = couponAvtiveType or CouponActiveType.allActive
    return o
end

local function ReBindSprite(obj)
    if obj then
        local obj1 = fun.find_child(obj,"tTJQYBiao")
        if obj1 then
            local img =  fun.get_component(obj1,fun.IMAGE)
            if img then
                img.sprite = AtlasManager:GetSpriteByName("CommonAtlas","tTJQYBiao")
            end
        end
        local obj2 = fun.find_child(obj,"di")
        if obj2 then
            local img =  fun.get_component(obj2,fun.IMAGE)
            if img then
                img.sprite = AtlasManager:GetSpriteByName("CommonAtlas","tTJQYSale")
            end
        end
    end
end


function DiscountUtility:SetCoupon(discount,root,reset_pos)
    self.discount = ModelList.CouponModel.get_currentCoupon(discount)
    if self.discount then
        self.discount_remain_time = math.max(0,self.discount.cTime - os.time())
        if self.invokeTime == nil then

            print("self.discount.id==>"..self.discount.id)

            self.invokeTime = Timer.New(function()
                self.discount_remain_time = math.max(self.discount_remain_time - 2,0)
                if self.discount_remain_time <= 0 then
                    Event.Brocast(EventName.Event_coupon_change)
                end
             end,2,-1)
             self.invokeTime:Start()
        end
    else
        self.discount_remain_time = nil
    end
    if (self.discount_remain_time or 0) > 0 then
        if self.discount_view == nil then
            Cache.Load_Atlas(AssetList["CommonAtlas"],"CommonAtlas",function()
                Cache.load_prefabs(AssetList["off"],"off",function(obj)
                    if obj then
                        local go = fun.get_instance(obj,root)
                        if go then
                            if reset_pos then
                                fun.set_gameobject_pos(go,0,0,0,true)
                            end
                            ReBindSprite(go)
                            self.discount_view = DiscountView:New(discount,self.discount,self._isPowerUp,self.delay_callback)
                            self.discount_view:SkipLoadShow(go)
                        end
                    end
                end)
            end)
        else
            self.discount_view:Refresh()    
        end
    else
        self:Close_discount_view()
    end
end

function DiscountUtility:Close_discount_view(isDisable)
    if self.discount_view then
        self.discount_view:CloseDiscount(not isDisable)
        if isDisable then
            self.discount_view = nil
        end
    end
    if self.invokeTime then
        self.invokeTime:Stop()
        self.invokeTime = nil
    end
    self.discount = nil
    self.discount_remain_time = nil
end

function DiscountUtility:OnDisable()
    self:Close_discount_view(true)
end

function DiscountUtility:GetDiscountId()
    if self.discount then
        return self.discount.id
    end
    return nil
end

function DiscountUtility:GetDiscountUseId()
    if self.discount then
        return self.discount.useId
    end
    return nil
end

function DiscountUtility:IsHaveCoupon()
    return self.discount ~= nil
end

function DiscountUtility:SetVisible(show)
    if self.discount_view then
        self.discount_view:SetVisible(show)
    end
end

function DiscountUtility:IsFree()
    if self.discount_view then
        return self.discount_view:IsFree()
    end
    return false
end

function DiscountUtility:PlayIdle()
    if self.discount_view then
        self.discount_view:PlayIdle()
    end
end

function DiscountUtility:PlayEnter()
    if self.discount_view then
        self.discount_view:PlayEnter()
    end
end

function DiscountUtility:PlayExit()
    if self.discount_view then
        self.discount_view:PlayExit()
    end
end

function DiscountUtility:PlayFreeTip(callback)
    if self.discount_view then
        self.discount_view:PlayFreeTip(callback)
    else
        self.delay_callback = callback     
    end
end

function DiscountUtility:PlayNumChange()
    if self.discount_view then
        self.discount_view:PlayNumChange()
    end
end