local BingoPassPosterView = BaseDialogView:New('BingoPassPosterView')
local this = BingoPassPosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "btn_play",
    "btn_activate",
    "txt_description1",
    "txt_description2",
    "anima",
}

this.CloseMethod = {
    normal = 1,
    enterMain = 2,
}

function BingoPassPosterView:Awake()
end

function BingoPassPosterView:OnEnable()
    Facade.RegisterView(this)
    this:ClearMutualTask()
end

function BingoPassPosterView:on_after_bind_ref()
    self:FillData()
    local task = function()
        UISound.play("bingopass_pay_open")
        AnimatorPlayHelper.Play(self.anima, {"start", "BingoPassPosterView_start"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)
end

function BingoPassPosterView:FillData()
    local desc1 = Csv.GetDescription(511)
    local desc2 = Csv.GetDescription(509)
    self.txt_description1.text = desc1
    self.txt_description2.text = desc2
end

function BingoPassPosterView.OnDisable()
    Facade.RemoveView(this)
end

function BingoPassPosterView:CloseSelf(closeMethod)
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "BingoPassPosterView_end"}, false, function()
            if closeMethod == self.CloseMethod.normal then
                Event.Brocast(EventName.Event_Popup_BingoPass_ClosePoster)
            elseif closeMethod == self.CloseMethod.enterMain then
                Event.Brocast(EventName.Event_Popup_BingoPass_EnterMain)
            end
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, this)
        end)
    end

    self:DoMutualTask(task)
end

function BingoPassPosterView:on_btn_close_click()
    self:CloseSelf(self.CloseMethod.normal)
end

function BingoPassPosterView:on_btn_help_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BingoPassHelperView)
end

function BingoPassPosterView:on_btn_play_click()
    self:CloseSelf(self.CloseMethod.enterMain)
end

function BingoPassPosterView:on_btn_activate_click()
    self:CloseSelf(self.CloseMethod.normal)
end

return this