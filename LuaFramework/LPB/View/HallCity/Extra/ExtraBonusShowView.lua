local ExtraBonusShowView = BaseDialogView:New("JackpotEnableView","JackpotEnableAtlas")
local this = ExtraBonusShowView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

this.auto_bind_ui_items = {
    
}
function ExtraBonusShowView:Awake(obj)
    self:on_init()
end 


function ExtraBonusShowView:on_close()

end

function ExtraBonusShowView:OnDisable()
  
end

function ExtraBonusShowView:OnDestroy()
    this:Close()
end

this.NotifyList = {

}

return this
