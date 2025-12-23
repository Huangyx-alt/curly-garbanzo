local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"
local FunctionIconSuperMatchView = FunctionIconBaseView:New()
local this = FunctionIconSuperMatchView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown",
    "FunctionIconSuperMatch",
    "rightIcon",
    "text_icon",
}

this.shwoTipTime = -5

function FunctionIconSuperMatchView:New()
    local o = {}
    self.__index = self
    o.remainTimeCountDown = RemainTimeCountDown:New()
    setmetatable(o,self)
    return o
end

function FunctionIconSuperMatchView:Awake()
    self:on_init()
end

function FunctionIconSuperMatchView:OnEnable()
    --self:RegisterEvent()
    self:ShowTime()
    fun.set_active(self.text_countdown, false)
    fun.set_active(self.text_icon, true)
end

function FunctionIconSuperMatchView:OnDisable()
    self.remainTimeCountDown:StopCountDown()
    --self:RemoveEvent()
end

function FunctionIconSuperMatchView:on_btn_icon_click()
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SuperMatchPosterView", false)
end

--undo 待实现
function FunctionIconSuperMatchView:IsFunctionOpen()
    -- local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    -- local needLevel = Csv.GetLevelOpenByType(10,0)
    -- return nowLevel >= needLevel

    return ModelList.SuperMatchModel:IsActivityAvailable()
end

--undo 待实现
--是否过期
function FunctionIconSuperMatchView:IsExpired()
    return ModelList.SuperMatchModel:GetActivityRemainTime() <= 0
end

function FunctionIconSuperMatchView:ShowTime()
    local leftTime = ModelList.SuperMatchModel:GetActivityRemainTime()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2, leftTime, self.text_countdown)
end

function FunctionIconSuperMatchView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.bingopass_reddot_event)
end

function FunctionIconSuperMatchView:OnCityResourceChange()
    log.w("FunctionIconSuperMatchView =>OnCityResourceChange")
    --self:RefreshRedDot()
end

return this