local TournamentSettleBaseState = require "State/TournamentSettle/TournamentSettleBaseState"
local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleOriginalState"
local TournamentSettleEnterState = require "State/TournamentSettle/TournamentSettleEnterState"
local TournamentSettleExiteState = require "State/TournamentSettle/TournamentSettleExiteState"
local TournamentSettleJumpCityState = require "State/TournamentSettle/TournamentSettleJumpCityState"


local TournamentPlayHelperView = BaseView:New("TournamentPlayHelperView","TournamentAtlas")

local this = TournamentPlayHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local Input = nil
local KeyCode = nil

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_Close",
    "explain1",
    "explain2",
    "explain3",
    "explain4",

}

function TournamentPlayHelperView:Awake(obj)
    self:on_init()
end

function TournamentPlayHelperView:OnEnable(params)
    Event.AddListener(NotifyName.Tournament.GuidePlayHelpViewClose,self.PlayExite,self)
    self:BuildFsm()
    self._fsm:GetCurState():PlayEnter(self._fsm)
    self:SetDescription()
end

function TournamentPlayHelperView:OnDisable()
    Event.RemoveListener(NotifyName.Tournament.GuidePlayHelpViewClose,self.PlayExite,self)
    self:DisposeFsm()
end

function TournamentPlayHelperView:SetDescription()
    self.explain1.text = Csv.GetDescription(1078)
    self.explain2.text = Csv.GetDescription(1079)
    self.explain3.text = Csv.GetDescription(1080)
    self.explain4.text = Csv.GetDescription(1081)

end

function TournamentPlayHelperView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentPlayHelperView",self,{
        TournamentSettleOriginalState:New(),
        TournamentSettleEnterState:New(),
        TournamentSettleExiteState:New(),
        TournamentSettleJumpCityState:New()
    })
    self._fsm:StartFsm("TournamentSettleOriginalState")
end

function TournamentPlayHelperView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentPlayHelperView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"start","TournamentExplainView_start"},false,function()
        self._fsm:GetCurState():EnterFinish(self._fsm)
    end)
end

function TournamentPlayHelperView:OnExitPlayHelper()
    AnimatorPlayHelper.Play(self.anima,{"end","HelpView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function TournamentPlayHelperView:on_btn_PlayNow_click()
    self._fsm:GetCurState():ClimbNext(self._fsm)
end

function TournamentPlayHelperView:on_btn_Close_click()
    self._fsm:GetCurState():PlayExite(self._fsm)
end

function TournamentPlayHelperView:PlayExite()
    AnimatorPlayHelper.Play(self.anima,{"end","TournamentExplainView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function TournamentPlayHelperView:PlayExiteToCity()
    Event.Brocast(NotifyName.Tournament.GuideViewClose)
    AnimatorPlayHelper.Play(self.anima,{"end","TournamentExplainView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

return this