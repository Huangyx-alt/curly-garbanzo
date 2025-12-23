local EvaluateUsIOSView = BaseView:New("EvaluateUsIOSView","EvaluateUsAtlas")
local this = EvaluateUsIOSView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

this.auto_bind_ui_items = {
    "main",
    "btn_rate",
    "btn_feedBack",
    "btn_later",
    "InputField",

    "btn_suggest",
    "btn_suggest_close",
    "suggestContent",
    "InputField"
}


function EvaluateUsIOSView:Awake(obj)
    self:on_init()
end

function EvaluateUsIOSView:OnEnable()
    fun.set_active(self.suggestContent,false)
    fun.set_active(self.main,true)
end


function EvaluateUsIOSView:ChangeView()
    fun.set_active(self.suggestContent,true)
    fun.set_active(self.main,false)
end

function EvaluateUsIOSView:on_btn_rate_click()
    SDK.AppleSignSocre()
    ModelList.PlayerInfoModel.ReqSubmitScore(5,"")
    this.close_ui()
end

function EvaluateUsIOSView:on_btn_suggest_click()
    --调起 反馈弹窗
    ModelList.PlayerInfoModel.ReqSubmitScore(0,this.InputField.text)
    this.close_ui()
end

function EvaluateUsIOSView:on_btn_suggest_close_click()
    --调起 反馈弹窗
    ModelList.PlayerInfoModel.ReqSubmitScore(0,"")
    this.close_ui()
end

function EvaluateUsIOSView:on_btn_feedBack_click()
    this:ChangeView()
end

function EvaluateUsIOSView:on_btn_later_click()
    ModelList.PlayerInfoModel.ResetShowScore()
    this.close_ui()
end

function EvaluateUsIOSView:close_ui()
    Facade.SendNotification(NotifyName.CloseUI, this)
    Event.Brocast(EventName.Event_popup_EvaluateUs_finish)
end

return this












