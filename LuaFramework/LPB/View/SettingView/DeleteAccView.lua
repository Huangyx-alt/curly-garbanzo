local DeleteAccView = BaseView:New("DeleteAccView","SettingAtlas")

local this = DeleteAccView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "main",
    "DeleteAccPoup",
    "btn_delete",
    "btn_cancel",
    "btn_close",
    "btn_cancel2",
    "btn_delete2",
    "btn_close2",
}


function DeleteAccView:Awake()
    self:on_init()
end


function DeleteAccView:OnEnable()
    fun.set_active(self.main,true);
    fun.set_active(self.DeleteAccPoup,false);
end

function DeleteAccView:OnDisable()
    Facade.RemoveView(self)
end

function DeleteAccView:on_btn_delete_click()
    fun.set_active(self.main,false);
    fun.set_active(self.DeleteAccPoup,true);
end

function DeleteAccView:on_btn_cancel_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function DeleteAccView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function DeleteAccView:on_btn_cancel2_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function DeleteAccView:on_btn_delete2_click()
    ModelList.PlayerInfoModel.C2S_DeleteAccount()
end

function DeleteAccView:on_btn_close2_click()
    Facade.SendNotification(NotifyName.CloseUI, this)
end



function DeleteAccView:OnDestroy()

end



return this

