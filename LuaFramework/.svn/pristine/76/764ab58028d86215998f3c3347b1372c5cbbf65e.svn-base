--- 机台全开活动宣传页
local FullGameplayPosterView = BaseDialogView:New("FullGameplayPosterView")
local remainTimeCountDown = RemainTimeCountDown:New()
local this = FullGameplayPosterView

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true

this.auto_bind_ui_items = {
    "btn_play",
    "text_remainTime",
    "anima"
}

function FullGameplayPosterView:Awake()
    Facade.RegisterView(this)
    self:on_init()
end

function FullGameplayPosterView:OnEnable()
    remainTimeCountDown:StartCountDown(CountDownType.cdt2, ModelList.CityModel:GetFullGameplayRemainTime(), self.text_remainTime, function()
        --结束
        Facade.SendNotification(NotifyName.CloseUI, self)
    end, function()
        --更新

    end)
end

function FullGameplayPosterView:OnDisable()
    Facade.RemoveView(this)
    remainTimeCountDown:StopCountDown()
end

function FullGameplayPosterView:on_close()
    if self.CloseCb then
        self.CloseCb()
        self.CloseCb = nil
    end
end

--播放显示动画
function FullGameplayPosterView:TweenShow()
    self:PlayViewAni("start")
end

--隐藏动画
function FullGameplayPosterView:TweenHide()

end

function FullGameplayPosterView:on_btn_play_click()
    self.CloseCb = function()
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayView, nil, nil, {
            OpenByFullGameplayPoster = true,
            OnClose = function()
                Event.Brocast(EventName.Event_popup_FullGameplay_finish, false)
                Facade.SendNotification(NotifyName.HideDialog, self)
            end,
            OnClickPlay = function()
                Event.Brocast(EventName.Event_popup_FullGameplay_finish, true)
                Facade.SendNotification(NotifyName.HideDialog, self)
            end
        })
    end
    
    --先关闭，等SpecialGameplayView反馈
    Facade.SendNotification(NotifyName.HideDialog, self)
end

this.NotifyList = {
}

return this










