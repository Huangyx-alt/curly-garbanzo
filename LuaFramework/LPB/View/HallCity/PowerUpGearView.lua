
require "View/HallCity/DiscountView"
require "View/HallCity/DiscountUtility"

PowerUpGearView = BaseView:New("PowerUpGearView")
local this = PowerUpGearView
this.viewType = CanvasSortingOrderManager.LayerType.None


this.auto_bind_ui_items = {
    "anima",
    "btn_card",
    "btn_cost",
    "text_cost",
    "idle",
    "btn_PuAd",
    "card",
}

this.PUAdRES ={
    ["on"] = "ADTVIcon",
    ["off"] = "ADTVIconPU2",
}

function PowerUpGearView:New(gear,puLevel)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._gear = gear
    o._PuLevel = puLevel
    return o
end

function PowerUpGearView:Awake()
    self:on_init()
    self._DiscountUtility = DiscountUtility:New(true)
    self._watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_PU_POWER_UP)
end

function PowerUpGearView:OnEnable(params)
    self._isFall = not params
    self:AddEventListener()
    self._init = true
    self._isWatchAd = false
	self._canClick = false;
    self:SetPowerCost()
end

function PowerUpGearView:OnDisable()
    self._DiscountUtility:OnDisable()
    self:RemoveEventListener()

    self._isFall = nil
    self._init = nil
    self._powerup_cost = nil
	self._canClick = false;
    self:CancelPlayCardFlipDelayHandle()
end

function PowerUpGearView:OnApplicationPause(focus)
    if not focus and self then
        self:OnCouponChange()
    end
end

function PowerUpGearView:AddEventListener()
    Event.AddListener(EventName.Event_coupon_change,self.OnCouponChange,self)
end

function PowerUpGearView:RemoveEventListener()
    Event.RemoveListener(EventName.Event_coupon_change,self.OnCouponChange,self)
end

function PowerUpGearView:OnCouponChange()
    if self._DiscountUtility:IsHaveCoupon() then
        self:CheckCoupon()
    end

    --检测是否
    if self._isWatchAd == false then 
        return 
    end     
    
    self:CheckCoupon()
    self._isWatchAd = false
    fun.set_active(self.btn_PuAd,false)  --关闭
    Facade.SendNotification(NotifyName.PowerUps.PowerUpGearClick,self._gear)
end

function PowerUpGearView:on_btn_card_click(falg)
    if self.grayTrue ~= nil and self.grayTrue == true then 
        return
    end 
	
	if not self._canClick then
		return;
	end
	
    if falg then      
		Facade.SendNotification(NotifyName.PowerUps.PowerUpGearClick,self._gear)
        return
    end 

    if self._watchADUtility:IsAbleWatchAd() == false then 
        fun.set_active(self.btn_PuAd,false)
    end 

    --如果可以看广告，就看广告
    if self._watchADUtility:IsAbleWatchAd() and self.btn_PuAd and self.btn_PuAd.gameObject.activeSelf == true then
        local playid = ModelList.CityModel.GetPlayIdByCity()
        --检查是否处于CD时间内
        self._watchADUtility:WatchVideo(self,self.WatchAdCallback,"powerupBuyAd",{playId=playid}) 
    else   
        Facade.SendNotification(NotifyName.PowerUps.PowerUpGearClick,self._gear)
    end

end

function PowerUpGearView:on_btn_cost_click()

    if self.grayTrue ~= nil and self.grayTrue == true then 
        return
    end 

    self:on_btn_card_click(true)
end

function PowerUpGearView:on_btn_PuAd_click()
    if self.grayTrue ~= nil and self.grayTrue == true then 
        return
    end 

    self:on_btn_card_click(false)
end

function PowerUpGearView:SetPowerCost(flag)
    if self._init then
        local cost = ModelList.CityModel:GetPowerupCost(self._gear)
        if cost then
            local discount_id = self:GetDiscountId()
            if discount_id then
                local saleoff = Csv.GetData("coupon",discount_id,"saleoff")
                cost = math.max(0,cost - cost * (saleoff / 100))
            end
            self._powerup_cost = cost
            if self.text_cost then
                self.text_cost.text = tostring(cost)
            end
        end
    end

    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    local data = Csv.GetData("advertise",15,"user_type")
    local level = ModelList.PlayerInfoModel:GetLevel()
    local taLevel = Csv.GetData("advertise",15,"level")
    local showAd = false 
    if data ~=nil then 
        for _,v in pairs(data) do 
            if myLabel == v then 
                showAd = true 
            end 
        end 
    end 
    showAd = true 

    --设置广告是否显示
    if self._gear == BuyPowerCardGenre.onegear and  
       self._watchADUtility:IsAbleWatchAd() and 
       self:IsDiscountFree() == false and  
       showAd and 
       level >= taLevel and
       self._PuLevel ~= nil and
       self._PuLevel ~= 4 then 
        
        local nowTime =  ModelList.PlayerInfoModel.get_cur_server_time()
        local cdTime =  ModelList.AdModel:GetMagnifyingTime("PUAD"..self._gear)
        local interval = Csv.GetData("advertise",15,"frequency_cd")

        if nowTime - cdTime > interval then 
            fun.set_active(self.btn_PuAd,true)
        else 
            fun.set_active(self.btn_PuAd,false)
        end 

    else 
        fun.set_active(self.btn_PuAd,false)
    end 

end

--- time: 2024-04-10 12:23 暂时修复打开PU界面后无法点击的问题
function PowerUpGearView:PlayCardFlipDelayHandle()
    if self then
        self._PlayCardFlipDelayHandle = LuaTimer:SetDelayFunction(8,function()
            if self then
                self:CheckCoupon()
                self._canClick = true;
            end
        end)
    end
end

--- 取消打开PU界面后无法点击的问题的延迟处理
function PowerUpGearView:CancelPlayCardFlipDelayHandle()
    if self and self._PlayCardFlipDelayHandle then
        LuaTimer:Remove(self._PlayCardFlipDelayHandle)
        self._PlayCardFlipDelayHandle = nil
    end
end


function PowerUpGearView:PlayCardFlip()
    if self.anima then
        self:PlayCardFlipDelayHandle()
        local animName = "card_flip"
        --[[undo 可能需要动画
        if ModelList.CityModel:CanCurPlayUsePuBuff() and ModelList.CityModel:GetPuBuffRemainTime() > 0 then
            animName = "card_flip_xx"
        else
            animName = "card_flip"
        end
        --]]
        AnimatorPlayHelper.Play(self.anima, animName, false, function()
            self:CheckCoupon()
            self._canClick = true;
            self:CancelPlayCardFlipDelayHandle()
        end)
    else
        log.e("PowerUpGearView:PlayCardFlip() self.anima is nil")
        self._canClick = true;
    end
end

function PowerUpGearView:PlayShake()
    if self.anima then
        self.anima:Play("show",0,0)
    end
end

function PowerUpGearView:GetGearCardPos()
    if self.go then
        return self.go.transform.position
    end
    return Vector3.New(0,0,0)
end

function PowerUpGearView:GetGearCardGo()
    if self.go then
        return self.go
    end
    return nil
end

function PowerUpGearView:CheckCoupon(isFall)
    if isFall then
        self._isFall = isFall
    end
    if self._isFall then
        if self._gear == BuyPowerCardGenre.onegear then
          --  self:SetCoupon(CouponType.discount_1gear)
            if self._PuLevel and self._PuLevel == 4 then
                self:SetCoupon(CouponType.discount_2gear)
            else 
                self:SetCoupon(CouponType.discount_1gear)
            end 
        elseif self._gear == BuyPowerCardGenre.twogear then
            -- self:SetCoupon(CouponType.discount_2gear)
            if self._PuLevel and self._PuLevel == 4 then
                self:SetCoupon(CouponType.discount_3gear)
            else 
                self:SetCoupon(CouponType.discount_2gear)
            end 
        elseif self._gear == BuyPowerCardGenre.threegear then
            if self._PuLevel and self._PuLevel == 4 then
                self:SetCoupon(CouponType.discount_4gear)
            else 
                self:SetCoupon(CouponType.discount_3gear)
            end 
        elseif self._gear == BuyPowerCardGenre.threegearplus then
            self:SetCoupon(CouponType.discount_4gear)
        end 
    end
end

function PowerUpGearView:SetCoupon(discount)
    self._DiscountUtility:SetCoupon(discount,self.idle)
    self:SetPowerCost()
end

function PowerUpGearView:GetDiscountId()
    return self._DiscountUtility:GetDiscountId()
end

function PowerUpGearView:GetDiscountUseId()
    return self._DiscountUtility:GetDiscountUseId()
end

function PowerUpGearView:GetPowerupCost()
    if self._powerup_cost then
        return self._powerup_cost
    end
    return 0
end

function PowerUpGearView:SetVisible(show)
    self._DiscountUtility:SetVisible(show)
end

function PowerUpGearView:IsDiscountFree()
    return self._DiscountUtility:IsFree()
end

function PowerUpGearView:PlayFreeTip()
    self._DiscountUtility:PlayFreeTip(function()
        self:on_btn_card_click()
    end)
end

function PowerUpGearView:PlayCouponIdle()
    self._DiscountUtility:PlayIdle()
end

function PowerUpGearView:WatchAdCallback(isBreak)
    if isBreak then
        --清掉cdtime
        ModelList.AdModel:SetMagnifyingTime("PUAD"..self._gear,0)
    else
       --记录cd
       --转为cdtime 的模式
       
       --[[如果还能看广告就显示广告cd
       不能看就直接关闭
       --]]

       local nowTime = ModelList.PlayerInfoModel.get_cur_server_time()
       ModelList.AdModel:SetMagnifyingTime("PUAD"..self._gear,nowTime)
      
       self._isWatchAd = true
     -- 
    end
end

function PowerUpGearView:GetPuAdState()
    return self.btn_PuAd and self.btn_PuAd.gameObject.activeSelf == true
end

--等待广告时间
function PowerUpGearView:OnWaitCdState() 
    if not  self.btn_PuAd and self.btn_PuAd.gameObject.activeSelf == false then 
        return 
    end 
    fun.set_active(self.btn_PuAd,false)
end

function PowerUpGearView:OnNormalPuAd()
    fun.set_active(self.btn_PuAd,true)
end
--

function PowerUpGearView:DrawCardDisableBtn(disable)
    Util.SetImageColorGray(self.btn_cost, disable)
    self.grayTrue = disable
    log.y("DrawCardDisableBtn  ".. tostring(disable) )
end

function PowerUpGearView:ResetOnDisable()
    self.grayTrue = false
end

function PowerUpGearView:ShowCardSpriteByIndex(imgIndex)
    imgIndex = imgIndex or 0
    if fun.is_not_null(self.card) then
        local imgContainer = fun.get_component(self.card, fun.IMAGESPRITESCONTAINER)
        if fun.is_not_null(imgContainer) then
            imgContainer:ShowSpriteByIndex(imgIndex)
        end
    end
end