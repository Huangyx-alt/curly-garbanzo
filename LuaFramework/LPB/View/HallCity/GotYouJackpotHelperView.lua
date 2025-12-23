local GotYouJackpotHelperView = BaseView:New("GotYouJackpotHelperView", "GotYouJackpotHelperAtlas")
local this = GotYouJackpotHelperView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.auto_bind_ui_items = {
    "btn_play",
    "btn_close",
    "lbl1",
    "lbl2",
    "lbl3",
}

function GotYouJackpotHelperView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function GotYouJackpotHelperView:Awake()
    self:on_init()

    self.lbl1.text = Csv.GetDescription(191053) 
    self.lbl2.text = Csv.GetDescription(191054) 
    self.lbl3.text = Csv.GetDescription(191055)
end

function GotYouJackpotHelperView:OnEnable(params)
    self.closeType = params
end

function GotYouJackpotHelperView:on_btn_play_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function GotYouJackpotHelperView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

return this