local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconMailView = FunctionIconBaseView:New()
local this = FunctionIconMailView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_mail",
    "red_dot",
}

function FunctionIconMailView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end


function FunctionIconMailView:Awake()
    self:on_init()
end

function FunctionIconMailView:OnEnable()
     self:RegisterRedDotNode()
     self:RegisterEvent()
 
end


function FunctionIconMailView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
end


function FunctionIconMailView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.mail_reddot_event,"function_Mail",self.red_dot)
    ModelList.MailModel.checkHaveNew()
end

function FunctionIconMailView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.mail_reddot_event,"function_Mail")
end



function FunctionIconMailView:RegisterEvent()
end

function FunctionIconMailView:UnRegisterEvent()
end

function FunctionIconMailView:on_btn_mail_click()
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "MailView", false) --不必隐藏
end

return this