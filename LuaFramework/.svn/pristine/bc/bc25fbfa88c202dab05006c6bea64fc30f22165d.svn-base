local ClubLeaveView = BaseView:New("ClubLeaveView","ClubAtlas")

local this = ClubLeaveView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "Text", --文本
    "btn_cancel",
    "btn_leave",
    "btn_close"
}

function ClubLeaveView:Awake()
    self:on_init()
end

function ClubLeaveView:OnEnable(params)
    this.params = params or {}
    if this.params.leaveTip then
        self.Text.text = this.params.leaveTip
    end
    fun.set_active(self.btn_cancel, not this.params.onlyTip)
    
    Facade.RegisterView(self)
end

function ClubLeaveView:OnDisable()
    Facade.RemoveView(self)
end

function ClubLeaveView:OnDestroy()

end

function ClubLeaveView:on_btn_leave_click()
    if this.params.onlyTip then
        Facade.SendNotification(NotifyName.CloseUI, this)
    else
        --发送离开的协议
        ModelList.ClubModel.C2S_ClubQuit()
    end
end

function ClubLeaveView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function ClubLeaveView:on_btn_cancel_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function ClubLeaveView:OnLeaveClub()
    Facade.SendNotification(NotifyName.CloseUI, this)
    if this.params and this.params.onLeaveClub then
        this.params.onLeaveClub()
    end
end

--function ClubLeaveView:_close()
--    self.__index.closeWithAnimation(self)
--end

this.NotifyList = {
    {notifyName = NotifyName.Club.LeaveClub, func = this.OnLeaveClub},
}

return this