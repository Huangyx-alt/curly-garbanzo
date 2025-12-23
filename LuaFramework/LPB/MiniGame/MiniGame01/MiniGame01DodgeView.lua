MiniGame01DodgeView = BaseMiniGame01:New("MiniGame01DodgeView","MiniGame01Atlas","luaprefab_minigame_minigame01")
local this = MiniGame01DodgeView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "btn_getit"
}

function MiniGame01DodgeView:Awake(obj)
    self:on_init()
end

function MiniGame01DodgeView:OnEnable(params)
    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)
end

function MiniGame01DodgeView:OnDisable()
    self:DisposeFsm()
    Event.Brocast(NotifyName.MiniGame01.DogeFreeShowTips)
end

function MiniGame01DodgeView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01DodgeView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01DodgeView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGame01DodgeView:PlayEnterAction()
    AnimatorPlayHelper.Play(self.anima,{"start","MiniGame01QuitView_start"},false,function()
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
    end)
end

function MiniGame01DodgeView:on_btn_getit_click()
    self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.dodgeExit)
end

function MiniGame01DodgeView:OnDodgeExit()
    AnimatorPlayHelper.Play(self.anima,{"end","MiniGame01QuitView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end