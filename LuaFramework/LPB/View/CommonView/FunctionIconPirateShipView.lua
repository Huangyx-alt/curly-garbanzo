local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"

local FunctionIconPirateShipView = FunctionIconBaseView:New()
local this = FunctionIconPirateShipView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "img_reddot",
    "anima",
    "text_countdown",
    "text_progress", 
}

function FunctionIconPirateShipView:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end


function FunctionIconPirateShipView:Awake()
    self:on_init()
end

function FunctionIconPirateShipView:OnEnable()
     self:RegisterRedDotNode()
     self:RegisterEvent()
 
end


function FunctionIconPirateShipView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
end


function FunctionIconPirateShipView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.mail_reddot_event,"function_Mail",self.red_dot)
    ModelList.MailModel.checkHaveNew()
end

function FunctionIconPirateShipView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.mail_reddot_event,"function_Mail")
end



function FunctionIconPirateShipView:RegisterEvent()
end

function FunctionIconPirateShipView:UnRegisterEvent()
end

function FunctionIconPirateShipView:on_btn_icon_click()
     
 
    Facade.SendNotification(NotifyName.GamePlayShortPassView.ShowGamePlayShortPassView,"PassTaskView")
end

return this