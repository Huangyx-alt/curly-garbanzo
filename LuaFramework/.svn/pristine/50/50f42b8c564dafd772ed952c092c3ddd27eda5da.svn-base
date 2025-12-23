local TournamentSettleOriginalState = require "State/TournamentSettle/TournamentSettleOriginalState"
local TournamentSettleEnterState = require "State/TournamentSettle/TournamentSettleEnterState"
local TournamentSettleExiteState = require "State/TournamentSettle/TournamentSettleExiteState"
local TournamentSettleJumpCityState = require "State/TournamentSettle/TournamentSettleJumpCityState"
require "View/CommonView/RemainTimeCountDown"

local TournamentBlackGoldGuideView = BaseView:New("TournamentBlackGoldGuideView","TournamentAtlas")
local this = TournamentBlackGoldGuideView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local remainTimeCountDown = nil

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_Help",
    "text_remainTime",
    "Clock01",
    "cub",
    "describeMoney",
    "describe1",
    "describe2",

}

function TournamentBlackGoldGuideView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldGuideView:OnEnable(params)
	self._isPop = params;
	Facade.RegisterView(self)
    self:BuildFsm()
    self:CubSetactiveCd()
    self._fsm:GetCurState():PlayEnter(self._fsm)
    self:StartCountDown()
    UISound.play("list_pop_up") 
    
    if fun.is_ios_platform() then
        self.describe1.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZBxuanchuanyemian4old")
        self.describe2.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZBxuanchuanyemian11old")
        self.describeMoney.text = "$200"
    else
        self.describe1.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZBxuanchuanyemian4")
        self.describe2.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZBxuanchuanyemian11")
        self.describeMoney.text = "VIP"
    end
end

function TournamentBlackGoldGuideView:CubSetactiveCd()
    local CdFlag = ModelList.TournamentModel:HasSprintBuff()
    if CdFlag  then
        fun.set_active(self.cup,true)
        fun.set_active(self.Clock01,false)
    else
        fun.set_active(self.cup,false)
        fun.set_active(self.Clock01,true)
    end
end

function TournamentBlackGoldGuideView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("TournamentBlackGoldGuideView",self,{
        TournamentSettleOriginalState:New(),
        TournamentSettleEnterState:New(),
        TournamentSettleExiteState:New(),
        TournamentSettleJumpCityState:New()
    })
    self._fsm:StartFsm("TournamentSettleOriginalState")
end


function TournamentBlackGoldGuideView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function TournamentBlackGoldGuideView:PlayEnter()
    
    AnimatorPlayHelper.Play(self.anima,{"start","TournamentBlackGoldGuideView_start"},false,function()
    --     self._fsm:GetCurState():EnterFinish(self._fsm)
    --    ModelList.GuideModel:BreakGuideStep()  --跟普通周榜一样做一样的处理
   end)

   self:ClearTimer()
   self.delayTimer = LuaTimer:SetDelayFunction(3.4, function()
            self._fsm:GetCurState():EnterFinish(self._fsm)
        --    ModelList.GuideModel:BreakGuideStep() --有概率报错
   end)
end

function TournamentBlackGoldGuideView:ClearTimer()
    if self.delayTimer then
        LuaTimer:Remove(self.delayTimer)
        self.delayTimer = nil
    end
end

function TournamentBlackGoldGuideView:OnDisable()
	self._isPop = nil;
	self:ClearTimer()
    Event.RemoveListener(NotifyName.Tournament.GuideViewClose,self.PlayExiteToCity,self)
    Facade.RemoveView(self)
    self:RemoveCountDown()
end

function TournamentBlackGoldGuideView:on_btn_PlayNow_click()
    self._fsm:GetCurState():ClimbNext(self._fsm)
end

function TournamentBlackGoldGuideView:on_btn_Help_click()
    Event.AddListener(NotifyName.Tournament.GuideViewClose,self.PlayExiteToCity,self)
    self._fsm:GetCurState():ShowHelpView(self._fsm)
end

function TournamentBlackGoldGuideView:OnShowHelpView()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentBlackGoldPlayHelperView)
end

function TournamentBlackGoldGuideView:PlayExiteToCity()
    self:CloseView(function()
        if CityHomeScene:IsSelectCity() then   
            Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter)
        else
            Facade.SendNotification(NotifyName.SceneCity.HomeScene_promotion)
        end
    end)
end

function TournamentBlackGoldGuideView:StartCountDown()
    local time = ModelList.TournamentModel:GetRemainTime()
    if self.remainTimeCountDown == nil then
        self.remainTimeCountDown = RemainTimeCountDown:New()
    end
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,time,self.text_remainTime,function()
        Event.Brocast(NotifyName.Tournament.GuidePlayHelpViewClose)
        self:CloseView()
    end)
end

function TournamentBlackGoldGuideView:RemoveCountDown()
    if self.remainTimeCountDown then
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown = nil
    end
end

function TournamentBlackGoldGuideView:CloseView(callBack)
    Event.Brocast(EventName.Event_show_first_tournament_guide_view)
    AnimatorPlayHelper.Play(self.anima,{"end","TournamentBlackGoldGuideView_end"},false, function()
        if self._isPop == nil and callBack then
            callBack()
        end
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

return this