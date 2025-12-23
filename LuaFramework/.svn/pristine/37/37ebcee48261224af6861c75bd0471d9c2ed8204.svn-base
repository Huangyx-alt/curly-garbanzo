local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"

local FunctionIconVolcanoMissionView = FunctionIconBaseView:New()
local this = FunctionIconVolcanoMissionView
this.viewType = CanvasSortingOrderManager.LayerType.None

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown"
}

function FunctionIconVolcanoMissionView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function FunctionIconVolcanoMissionView:Awake()
    self:on_init()
end

function FunctionIconVolcanoMissionView:OnEnable()
    local activityRemainTime = ModelList.VolcanoMissionModel:GetRemainTime()
    remainTimeCountDown:StartCountDown(CountDownType.cdt2, activityRemainTime, self.text_countdown, function()
        self:Hide()
    end)
end

function FunctionIconVolcanoMissionView:IsFunctionOpen()
    local activityRemainTime = ModelList.VolcanoMissionModel:GetRemainTime()
    if activityRemainTime and activityRemainTime > 1 then
        return true
    end
end

--是否过期
function FunctionIconVolcanoMissionView:IsExpired()
 
    return not ModelList.VolcanoMissionModel:IsOpenActivity()
end

function FunctionIconVolcanoMissionView:UpdataShow()
    local activityRemainTime = ModelList.VolcanoMissionModel:GetRemainTime()
    remainTimeCountDown:UpdateRemainTime(activityRemainTime)
end

function FunctionIconVolcanoMissionView:on_btn_icon_click()
    -- local PopupVolcanoMissionOrder = require "PopupOrder/PopupVolcanoMissionOrder"
    -- PopupVolcanoMissionOrder.Execute()

    local params = {
        level = ModelList.PlayerInfoModel:GetLv(),
    }
    SDK.BI_Event_Tracker("click_volcanomission", params)
    log.log("FunctionIconVolcanoMissionView:on_btn_icon_click 上报参数", params)

    local isInit = ModelList.VolcanoMissionModel.IsInit()

    if(isInit==true)then
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"VolcanoMissionMainView")
        --Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionMainView)
    else
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"VolcanoMissionStartView")
        --Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionStartView)
    end
end

function FunctionIconVolcanoMissionView:OnDisable()
    remainTimeCountDown:StopCountDown()
end

function FunctionIconVolcanoMissionView:on_close()
end

function FunctionIconVolcanoMissionView:OnDestroy()
    self:Close()
end

return this