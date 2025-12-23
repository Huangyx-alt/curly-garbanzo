local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"
local FunctionIconSmallGameView = FunctionIconBaseView:New()
local this = FunctionIconSmallGameView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown",
    "img_reddot",
    "ChildParent",
}

this.shwoTipTime = -5
this.currSmallView = nil

function FunctionIconSmallGameView:New()
    local o = {}
    self.__index = self
    o.remainTimeCountDown = RemainTimeCountDown:New()
    setmetatable(o,self)
    return o
end

function FunctionIconSmallGameView:Awake()
    self:on_init()
end

function FunctionIconSmallGameView:OnEnable()
    --self:RegisterEvent()
    self:ShowTime()
    fun.set_active(self.text_countdown, false)
    fun.set_active(self.text_icon, true)
end

function FunctionIconSmallGameView:OnDisable()
    self.remainTimeCountDown:StopCountDown()
    --self:RemoveEvent()
end

function FunctionIconSmallGameView:GetCurrView()
    local id = ModelList.SmallGameModel.GetCurrentGameId()
    if id == 0 then
        this.currSmallView = "SuperMatchPosterView"
        elseif id == 2 then
            this.currSmallView = "SuperMatchPosterView"
    end

end

function FunctionIconSmallGameView:on_btn_icon_click()



    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SuperMatchPosterView", false)
end

--undo 待实现
function FunctionIconSmallGameView:IsFunctionOpen()
    -- local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    -- local needLevel = Csv.GetLevelOpenByType(10,0)
    -- return nowLevel >= needLevel

    return ModelList.SuperMatchModel:IsActivityAvailable()
end

--undo 待实现
--是否过期
function FunctionIconSmallGameView:IsExpired()
    return ModelList.SuperMatchModel:GetActivityRemainTime() <= 0
end

function FunctionIconSmallGameView:ShowTime()
    local leftTime = ModelList.SuperMatchModel:GetActivityRemainTime()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2, leftTime, self.text_countdown)
end

function FunctionIconSmallGameView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.bingopass_reddot_event)
end

function FunctionIconSmallGameView:OnCityResourceChange()
    log.w("FunctionIconSmallGameView =>OnCityResourceChange")
    --self:RefreshRedDot()
end

return this
