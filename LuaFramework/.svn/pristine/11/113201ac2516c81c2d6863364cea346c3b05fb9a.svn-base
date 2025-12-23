local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconNewLeetoleManView = FunctionIconBaseView:New()
local this = FunctionIconNewLeetoleManView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "img_reddot",
    "anima",
    "text_countdown",
    "text_progress", 
}

function FunctionIconNewLeetoleManView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end


function FunctionIconNewLeetoleManView:Awake()
    self:on_init()
end

function FunctionIconNewLeetoleManView:OnEnable()
     self:RegisterRedDotNode()
     self:RegisterEvent()
 
end


function FunctionIconNewLeetoleManView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
end


function FunctionIconNewLeetoleManView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.mail_reddot_event,"function_Mail",self.red_dot)
    ModelList.MailModel.checkHaveNew()
end

function FunctionIconNewLeetoleManView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.mail_reddot_event,"function_Mail")
end



function FunctionIconNewLeetoleManView:RegisterEvent()
end

function FunctionIconNewLeetoleManView:UnRegisterEvent()
end

function FunctionIconNewLeetoleManView:on_btn_icon_click()
     
 
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassTaskView")
end

return this