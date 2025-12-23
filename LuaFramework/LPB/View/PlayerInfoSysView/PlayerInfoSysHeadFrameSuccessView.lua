local PlayerInfoSysHeadFrameSuccessView = BaseView:New("PlayerInfoSysHeadFrameSuccessView","PlayerInfoSysAtlas")
local this = PlayerInfoSysHeadFrameSuccessView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "success",
}

function PlayerInfoSysHeadFrameSuccessView:Awake(obj)
    self:on_init()
end

function PlayerInfoSysHeadFrameSuccessView:OnEnable()
    fun.set_active(self.success , true)
    AnimatorPlayHelper.Play(self.success,"PlayerInfoSysHeadsuccess",false,function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

return this
