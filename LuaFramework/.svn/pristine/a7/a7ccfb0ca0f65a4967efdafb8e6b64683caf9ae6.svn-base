

local RouletteVipBenefit = BaseView:New()
local this = RouletteVipBenefit
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "text_vip",
    "text_addition",
    "toggle_vip",
    "iconVip",
    "point",
}

function RouletteVipBenefit:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function RouletteVipBenefit:Awake()
    self:on_init()
end

function RouletteVipBenefit:OnEnable()
    self._isInit = true
    self:Refresh()
end

function RouletteVipBenefit:OnDisable()
    self._level = nil
    self._benefit = nil
    self._isInit = nil
end

function RouletteVipBenefit:Refresh()
    self:SetData(self._level,self._benefit)
end

function RouletteVipBenefit:SetData(level,benefit)
    self._level = level
    self._benefit = benefit
    if self._isInit and fun.is_not_null(self._level)  and fun.is_not_null(self._benefit)  then
        fun.set_active(self.point, false)
        self.text_vip.text = string.format("VIP%s",self._level)
        self.text_addition.text = string.format("+%s%s",self._benefit,"%")
        local myVip = ModelList.PlayerInfoModel:GetVIP()
        self.iconVip.sprite = AtlasManager:GetSpriteByName("VipAtlas", "VIP" .. self._level)
        if myVip == self._level then
            self.toggle_vip.isOn = true
            fun.set_active(self.point, true)
        else
            self.toggle_vip.isOn = false
        end
    end
end

return this