
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"

local FunctionIconMagnifyLensView = FunctionIconBaseView:New()
local this = FunctionIconMagnifyLensView
this.viewType = CanvasSortingOrderManager.LayerType.None

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
    "btn_cuisines",
    "text_countdown"
}

function FunctionIconMagnifyLensView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconMagnifyLensView:Awake()
    self:on_init()
end

function FunctionIconMagnifyLensView:OnEnable()
    remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.ItemModel:get_hintTime(),self.text_countdown,function()
        self:Hide()
    end)
    Event.AddListener(EventName.Event_Update_MagnifyLens_Time_On_Function, self.UpdataShow, self)
end

function FunctionIconMagnifyLensView:OnApplicationFocus(focus)
    if focus then
        --self:UpdataShow()
    end
end

function FunctionIconMagnifyLensView:IsFunctionOpen()
    local hintTime = ModelList.ItemModel:get_hintTime()
    if hintTime and hintTime > 1 then
        return true
    end
end

--是否过期
function FunctionIconMagnifyLensView:IsExpired()
    local hintTime = ModelList.ItemModel:get_hintTime()
    if hintTime and hintTime <= 1 then
        return true
    end
end

function FunctionIconMagnifyLensView:UpdataShow()
    remainTimeCountDown:UpdateRemainTime(ModelList.ItemModel:get_hintTime())
end

function FunctionIconMagnifyLensView:on_btn_cuisines_click()
    
end

function FunctionIconMagnifyLensView:OnDisable()
    remainTimeCountDown:StopCountDown()
    Event.RemoveListener(EventName.Event_Update_MagnifyLens_Time_On_Function, self.UpdataShow, self)
end

function FunctionIconMagnifyLensView:on_close()
end

function FunctionIconMagnifyLensView:OnDestroy()
    self:Close()
end

return this