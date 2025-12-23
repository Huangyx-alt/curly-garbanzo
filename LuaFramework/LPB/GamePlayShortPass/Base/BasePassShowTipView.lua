

local BasePassShowTipView = class("BasePassShowTipView",BaseViewEx)   
local this = BasePassShowTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog
this._cleanImmediately = true 
this.auto_bind_ui_items = {
    "root",
    "text_level",
    "text_unlock",
    "anima"
}

--local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode
local _params = nil 
function BasePassShowTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function BasePassShowTipView:OnEnable(params)
    self:Promote(_params)
end

function BasePassShowTipView:OnDisable()

end
function BasePassShowTipView:SetParam(params)
    _params = params
end
function BasePassShowTipView:Promote(params)

    if params then
        self.root.position = params[1]
        self.root.localPosition = self.root.localPosition + Vector3.New(0,130,0)
        self.text_level.text = params[2]
        self.anima:Play("in",0,0)
    end
end

function BasePassShowTipView:on_x_update()
    if input.GetKeyDown(keyCode.Mouse0) then
        Facade.SendNotification(NotifyName.CloseUI,self)
    end
end

return this