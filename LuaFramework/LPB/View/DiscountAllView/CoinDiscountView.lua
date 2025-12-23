local CoinDiscountView = BaseView:New("CoinDiscountView")

local this = CoinDiscountView
this.viewType = CanvasSortingOrderManager.LayerType.None


this.auto_bind_ui_items = {
   "CountText",
   "Count",
   "Free",  
} 

function CoinDiscountView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CoinDiscountView:Awake()
    self:on_init()
end

function CoinDiscountView:OnDisable()
    this:StopCountdown()
end


function CoinDiscountView:OnEnable()
    this:StopCountdown()
    self:BuildFsm()
end

function CoinDiscountView:BuildFsm()
    self:DisposeFsm()
    -- 有限状态机
end

function CoinDiscountView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function CoinDiscountView:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--[[
    count:次数
    time: 时间
]]--
function CoinDiscountView:UpdateData(count,time) 
    if(count == 100) then 
        fun.set_active(self.Free,true)
        fun.set_active(self.Count,false)
    else 
        fun.set_active(self.Free,false)
        fun.set_active(self.Count,true)
        self.CountText.text = count;
    end 
    this:StopCountdown()
    self.TimeOut = LuaTimer:SetDelayFunction(time,function()
        Event.Brocast(EventName.Event_coupon_change)
        self:CloseView()
    end)
   
end 


function CoinDiscountView:StopCountdown()
    if self.TimeOut then
        LuaTimer:Remove(self.TimeOut)
        self.TimeOut = nil
    end
end 

return this 