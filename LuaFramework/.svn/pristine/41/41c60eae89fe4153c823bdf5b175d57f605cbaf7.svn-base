MiniGame01PlayHelperView = BaseMiniGame01:New("MiniGame01PlayHelperView","MiniGame01PopupAtlas","luaprefab_minigame_minigame01")
local this = MiniGame01PlayHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local Input = nil
local KeyCode = nil

this.auto_bind_ui_items = {
    "anima",
    "text_step1",
    "text_step2",
    "text_step3"
}

function MiniGame01PlayHelperView:Awake(obj)
    self:on_init()
end

function MiniGame01PlayHelperView:OnEnable(params)
    self.text_step1.text = Csv.GetDescription(989)
    self.text_step2.text = Csv.GetDescription(990)
    self.text_step3.text = Csv.GetDescription(991)
    self:BuildFsm()
    self._fsm:GetCurState():Change2Enter(self._fsm)
    Input = UnityEngine.Input
    KeyCode = UnityEngine.KeyCode
end

function MiniGame01PlayHelperView:OnDisable()
    self:DisposeFsm()
    Input = nil
    KeyCode = nil
end

function MiniGame01PlayHelperView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MiniGame01PlayHelperView",self,{
        MiniGame01OriginalState:New(),
        MiniGame01EnterState:New(),
        MiniGame01StiffState:New()
    })
    self._fsm:StartFsm("MiniGame01OriginalState")
end

function MiniGame01PlayHelperView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MiniGame01PlayHelperView:PlayEnterAction()
    AnimatorPlayHelper.Play(self.anima,{"start","HelpView_start"},false,function()
        self._fsm:GetCurState():EnterFinish2Original(self._fsm)
        self.update_x_enabled = true
        self:start_x_update()
    end)
end

function MiniGame01PlayHelperView:OnExitPlayHelper()
    AnimatorPlayHelper.Play(self.anima,{"end","HelpView_end"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
    end)
end

function MiniGame01PlayHelperView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        self._fsm:GetCurState():DoAction2Stiff(self._fsm,MiniGame01Stiffparams.exitPlayHelper)
    end
end