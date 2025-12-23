local TournamentSettleBaseState = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleOriginalState"
local TournamentSettleEnterState = require "State/TournamentSettle/TournamentSettleEnterState"
local TournamentSettleExiteState = require "State/TournamentSettle/TournamentSettleExiteState"
local TournamentSettleJumpCityState = require "State/TournamentSettle/TournamentSettleJumpCityState"
require "View/CommonView/RemainTimeCountDown"

local TournamentGuideView = BaseView:New("TournamentGuideView","TournamentAtlas")
local this = TournamentGuideView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local remainTimeCountDown = nil

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_Help",
    "text_remainTime",
    "Clock01",
    "cup",

}

function TournamentGuideView:Awake(obj)
    self:on_init()
end

function TournamentGuideView:OnEnable(params)
	self._isPop = params;
    Facade.RegisterView(self)
    self:BuildFsm()
    self:CubSetactiveCd()
    self._fsm:GetCurState():PlayEnter(self._fsm)
    self:StartCountDown()
    UISound.play("list_pop_up") 
    
end

function TournamentGuideView:CubSetactiveCd()
    local CdFlag = ModelList.TournamentModel:HasSprintBuff()
    if CdFlag  then
        fun.set_active(self.cup,true)
        fun.set_active(self.Clock01,false)
    else
        fun.set_active(self.cup,false)
        fun.set_active(self.Clock01,true)
    end
end

function TournamentGuideView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentGuideView",self,{
        TournamentSettleOriginalState:New(),
        TournamentSettleEnterState:New(),
        TournamentSettleExiteState:New(),
        TournamentSettleJumpCityState:New()
    })
    self._fsm:StartFsm("TournamentSettleOriginalState")
end


function TournamentGuideView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentGuideView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"start","TournamentGuideViewstart"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
        ModelList.GuideModel:BreakGuideStep()
    end,3.55)
end

function TournamentGuideView:OnDisable()
	self._isPop = nil;
	Event.RemoveListener(NotifyName.Tournament.GuideViewClose,self.PlayExiteToCity,self)
    Facade.RemoveView(self)
    self:RemoveCountDown()
end

function TournamentGuideView:on_btn_PlayNow_click()
    self._fsm:GetCurState():ClimbNext(self._fsm)
end

function TournamentGuideView:on_btn_Help_click()
    Event.AddListener(NotifyName.Tournament.GuideViewClose,self.PlayExiteToCity,self)
    self._fsm:GetCurState():ShowHelpView(self._fsm)
end

function TournamentGuideView:OnShowHelpView()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentPlayHelperView)
end

function TournamentGuideView:PlayExiteToCity()
    self:CloseView(function()
        if CityHomeScene:IsSelectCity() then   
            Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter)
        else
            Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
        end
    end)
end

function TournamentGuideView.OnResphonePlayerInfo()
    if ModelList.TournamentModel:GetPlayerInfo() then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentTrophyView)
    end
end

function TournamentGuideView:StartCountDown()
    local time = ModelList.TournamentModel:GetRemainTime()
    if self.remainTimeCountDown == nil then
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,time,self.text_remainTime,function()
        Event.Brocast(NotifyName.Tournament.GuidePlayHelpViewClose)
        self:CloseView()
    end)
end

function TournamentGuideView:RemoveCountDown()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function TournamentGuideView:CloseView(callBack)
    Event.Brocast(EventName.Event_show_first_tournament_guide_view)
    AnimatorPlayHelper.Play(self.anima,{"end","TournamentGuideViewend"},false, function()
        if self._isPop == nil and callBack then
            callBack()
        end
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

this.NotifyList = {
}

return this