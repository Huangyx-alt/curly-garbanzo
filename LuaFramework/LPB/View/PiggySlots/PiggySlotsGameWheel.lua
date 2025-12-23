
local PiggySlotsGameWheel = BaseView:New("PiggySlotsGameWheel")
local this = PiggySlotsGameWheel
this.viewType = CanvasSortingOrderManager.LayerType.none
this.auto_bind_ui_items = {
   "controlBigReel",
   "item2",
   "item1"
}

function PiggySlotsGameWheel:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PiggySlotsGameWheel:Awake()
end

function PiggySlotsGameWheel:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:SetWheelData(self.mainCode, self.wheelData , self.bigPiggyWheelIndex)
end

function PiggySlotsGameWheel:on_after_bind_ref()
end

function PiggySlotsGameWheel:SetWheelData(mainCode,wheelData , bigPiggyWheelIndex)
    self.mainCode = mainCode or self.mainCode
    self.wheelData = wheelData or self.wheelData
    self.bigPiggyWheelIndex = bigPiggyWheelIndex or self.bigPiggyWheelIndex
    if self.wheelData then
        self:InitView()
        self:StartWheelSpin()
    end
end

function PiggySlotsGameWheel:OnDisable()
    self.isRoll = false
    self:ClearDelayStopWheel()
    Facade.RemoveViewEnhance(self)
end

function PiggySlotsGameWheel:InitView()
end

function PiggySlotsGameWheel:StartWheelSpin()
    if self.isRoll then
        log.log("已经启动了 rolling")
        return
    end
    if not self.controlBigReel or fun.is_null(self.controlBigReel) then
        log.log("已经启动了 null")
        return
    end
    self:ClearDelayStopWheel()
    self.isRoll = true
    local wheelItemInfo = self.wheelData.wheelItems
    self:UIpdateGrid(self.item2,4,wheelItemInfo[4])
    self:UIpdateGrid(self.item1,5,wheelItemInfo[5])
    self.controlBigReel.objectTickHandler = function (refer,index)
        local data = wheelItemInfo[index]
        self:UIpdateGrid(refer,index , data)
    end
    local dataLenth = GetTableLength(wheelItemInfo)
    self.controlBigReel:Spin(dataLenth, 1) --2 是格子数量-1 

    self.delayShowBreakNumFunc = LuaTimer:SetDelayFunction(3, function()
        self.controlBigReel:StopMove(self.wheelData.wheelIndex, function()
            log.log("完成转盘")
            Facade.SendNotification(NotifyName.PiggySlots.PiggySlotsFinishBigWheel , self.bigPiggyWheelIndex)
		end)
    end)
end

function PiggySlotsGameWheel:UIpdateGrid(ref, index, data)
    local textReward = ref:Get("textReward")
    local itemIconJackpot = ref:Get("itemIconJackpot")
    local itemIconCoin = ref:Get("itemIconCoin")
    if data.isJackpot == true then
        --jackpot
        fun.set_active(itemIconJackpot, true)
        fun.set_active(itemIconCoin, false)
    else
        --普通倍数
        fun.set_active(itemIconJackpot, false)
        fun.set_active(itemIconCoin, true)
    end
    textReward.text = fun.format_money(data.winCoin)
end

function PiggySlotsGameWheel:ClearDelayStopWheel()
    if self.delayStopWheel then
        LuaTimer:Remove(self.delayStopWheel)
        self.delayStopWheel = nil
    end
end


return this