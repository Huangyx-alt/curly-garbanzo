HangUpQuitView = BaseDialogView:New('HangUpQuitView')
local this = HangUpQuitView
this.viewType = CanvasSortingOrderManager.LayerType.Tips

local this = HangUpQuitView;
this.auto_bind_ui_items = {
    "btn_sure",
    "btn_cancle",
    "content"
}

function HangUpQuitView.Awake(obj)
    --this.update_x_enabled = true
    this:on_init()

end

function HangUpQuitView.OnEnable()
    --Facade.RegisterView(this)

end

--function HangUpQuitView:on_x_update()
--end

function HangUpQuitView.OnDisable()
    --Facade.RemoveView(this)
end


function HangUpQuitView.OnDestroy()
    this:Destroy()
end

function HangUpQuitView:on_close()

end


function HangUpQuitView:CloseFunc()
    --this.main_effect:Play("end")
    Facade.SendNotification(NotifyName.CloseUI, ViewList.HangUpQuitView)

end


function HangUpQuitView:ShowTip(tipName)

end



function HangUpQuitView:InitTip()

end

function HangUpQuitView:CutDonwTarget()
    this:CloseFunc()
    this.main_effect:Play("end")
end






function HangUpQuitView:on_btn_sure_click()
    ModelList.BattleModel.ReqQuitBingoGame()
    ModelList.HangUpModel:Clear()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.HangUpQuitView)
end
function HangUpQuitView:on_btn_cancle_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.HangUpQuitView)
end
return this

