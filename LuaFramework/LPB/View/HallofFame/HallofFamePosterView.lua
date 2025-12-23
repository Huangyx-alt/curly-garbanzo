require "View/CommonView/RemainTimeCountDown"
local DownloadUtility = require "View/CommonView/DownloadUtility"
local _DownloadUtility = DownloadUtility:New()
local HallofFamePosterView = BaseView:New("HallofFamePosterView", "TournamentAtlas")
local this = HallofFamePosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_Help",
    "text_remainTime",
    "Clock",
    "Buff",
}

function HallofFamePosterView:Awake(obj)
    self:on_init()
end

function HallofFamePosterView:on_after_bind_ref()
    AnimatorPlayHelper.Play(self.anima, { "start", "HallofFameBlackGoldGuideView_start" }, false, function()

    end)
end

function HallofFamePosterView:OnEnable(params)
    Facade.RegisterView(self)
    
    local buffRemainTime = ModelList.WinZoneModel:GetDoubleBuffRemainTime()
    if buffRemainTime > 0 then
        fun.set_active(self.Buff,true)
        fun.set_active(self.Clock,false)
        self:StartCountDown(buffRemainTime)
    else
        fun.set_active(self.Buff,false)
        fun.set_active(self.Clock,true)
        self:StartCountDown()
    end
    
    UISound.play("list_pop_up")
end

function HallofFamePosterView:OnDisable()
    Facade.RemoveView(self)
    self:RemoveCountDown()
end

function HallofFamePosterView:StartCountDown()
    local time = ModelList.HallofFameModel:GetRemainTime()
    if self.remainTimeCountDown == nil then
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2, time, self.text_remainTime, function()
        Event.Brocast(NotifyName.HallofFame.FameGuidePlayHelpViewClose)
        self:CloseView()
    end)
end

function HallofFamePosterView:RemoveCountDown()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function HallofFamePosterView:CloseView(callBack)
    AnimatorPlayHelper.Play(self.anima, { "end", "HallofFameBlackGoldGuideView_end" }, false, function()
        if callBack then
            callBack()
        else
            Event.Brocast(EventName.Event_HallofFame_PopEnd)
        end
        Facade.SendNotification(NotifyName.CloseUI, self)
    end)
end

function HallofFamePosterView:on_btn_PlayNow_click()
    self:CloseView(function()
        if not _DownloadUtility:NewNode(14, ViewList.HallCityView.btn_winzone) then
            Event.Brocast(EventName.Event_HallofFame_PopEnd)
            return
        else
            if not ModelList.WinZoneModel:IsVipLevelEnough() then
                --UIUtil.show_common_popup(8039, true)
                Event.Brocast(EventName.Event_HallofFame_PopEnd)
                return
            elseif not ModelList.WinZoneModel:IsPlayerLevelEnough() then
                --UIUtil.show_common_popup(8038, true)
                Event.Brocast(EventName.Event_HallofFame_PopEnd)
                return
            else
                ModelList.BattleModel.RequireModuleLua("WinZone")
                local view = require("View/WinZone/WinZoneHelperView")
                Facade.SendNotification(NotifyName.ShowUI, view:New(),nil,nil,"hallofFamePosterView")
            end
        end
    end)
end

function HallofFamePosterView:on_btn_Help_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameHelpView)
end

return this