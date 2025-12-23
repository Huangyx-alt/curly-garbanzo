local WinZoneHelperView = BaseView:New("WinZoneHelperView","WinZoneHelperAtlas")

local this = WinZoneHelperView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items = {
    "btn_play",
    "btn_later",
    "text1",
    "text2",
    "text3",
    "text4",
}

function WinZoneHelperView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function WinZoneHelperView:Awake()
    self:on_init()
    UISound.play("winzoneEntrance")
end


function WinZoneHelperView:OnEnable(params)
    self.closeType = params
end

function WinZoneHelperView:on_btn_play_click()
    self:CloseView()
    ModelList.WinZoneModel:EnterSystem()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function WinZoneHelperView:on_btn_later_click()
    self:CloseView()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function WinZoneHelperView:CloseView()
    if self.closeType then
        if self.closeType == "hallofFamePosterView" then
            Event.Brocast(EventName.Event_HallofFame_PopEnd)
        end
    end
end

return this