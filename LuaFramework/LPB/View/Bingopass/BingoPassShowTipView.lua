
local BingoPassShowTipView = BaseView:New("BingoPassShowTipView","BingoPassAtlas")
local this = BingoPassShowTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "root",
    "text_level",
    "text_unlock",
    "anima"
}

--local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

function BingoPassShowTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function BingoPassShowTipView:OnEnable(params)
    self:Promote(params)
end

function BingoPassShowTipView:OnDisable()

end

function BingoPassShowTipView:Promote(params)
    if params then
        self.root.position = params[1]
        self.root.localPosition = self.root.localPosition + Vector3.New(0,130,0)
        self.text_level.text = params[2]
        self.anima:Play("in",0,0)
    end
end

function BingoPassShowTipView:on_x_update()
    if input.GetKeyDown(keyCode.Mouse0) then
        Facade.SendNotification(NotifyName.CloseUI,self)
    end
end

return this