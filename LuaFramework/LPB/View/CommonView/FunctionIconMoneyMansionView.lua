local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconMoneyMansion = FunctionIconBaseView:New()
local this = FunctionIconMoneyMansion
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",}

function FunctionIconMoneyMansion:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end


function FunctionIconMoneyMansion:Awake()
    self:on_init()
end

function FunctionIconMoneyMansion:on_btn_icon_click()
    local betRate = ModelList.CityModel:GetBetRate()
    ModelList.GotYouModel:ReqMansionInfo(nil,betRate)
end

return this
