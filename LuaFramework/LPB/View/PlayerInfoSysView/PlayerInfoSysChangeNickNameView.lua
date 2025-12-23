
PlayerInfoSysChangeNickNameView = BaseView:New("PlayerInfoSysChangeNickNameView","PlayerInfoSysAtlas")
local this = PlayerInfoSysChangeNickNameView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local minLetters = 4 --昵称最少4个字符

this.auto_bind_ui_items = {
    "inputField",
    "textTipInput",
    "textTipConfirm1",
    "textTipConfirm2",
    "textTipConfirm3",
    "textConfirmInput",
    "btn_close",
    "btn_submit",
    "anima",
    "textTipInputWarn",
    "inputObj",
    "confirmObj",

}

function PlayerInfoSysChangeNickNameView:Awake(obj)
    self:on_init()
end

function PlayerInfoSysChangeNickNameView:OnEnable(params)
    self.params = params
    Facade.RegisterView(self)
    fun.set_active(self.inputObj , true)
    fun.set_active(self.confirmObj , false)
    Event.AddListener(NotifyName.PlayerInfo.SysChangeNickNameSuccess,self.SysChangeNickNameSuccess,self)
    Event.AddListener(NotifyName.PlayerInfo.SysChangeNickNameError,self.SysChangeNickNameError,self)
    Event.AddListener(NotifyName.PlayerInfo.SysCheckChangeNickName,self.SysCheckChangeNickName,self)
    self:AddInputFieldEndEvent()
    self:BuildFsm()
    self:UpdateInputFieldEnableState(false)
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"enter","commonViewenter"},false,function()
            self:UpdateInputFieldEnableState(true)
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
    self:InitView() 
end

function PlayerInfoSysChangeNickNameView:AddInputFieldEndEvent()
    self.luabehaviour:AddInputFieldOnEndEvent(self.inputField.gameObject, function(go,inputString)
        if not inputString or inputString == "" or string.len(inputString) < minLetters then
            --不符合
            return
        end

        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State")
    end)
end

function PlayerInfoSysChangeNickNameView:BuildFsm()
    self:DisposeFsm()
    CommonState.BuildFsm(self,"PlayerInfoSysChangeNickNameView")
end

function PlayerInfoSysChangeNickNameView:InitView()
    self.textTipInput.text = Csv.GetDescription(624)
    self.textTipConfirm1.text = Csv.GetDescription(625)
    self.textTipConfirm2.text = Csv.GetDescription(626)
    self.textTipConfirm3.text = Csv.GetDescription(627)
end

function PlayerInfoSysChangeNickNameView:OnDisable()
    self:ClearDelayReturnState()
    Event.RemoveListener(NotifyName.PlayerInfo.SysChangeNickNameSuccess,self.SysChangeNickNameSuccess,self)
    Event.RemoveListener(NotifyName.PlayerInfo.SysChangeNickNameError,self.SysChangeNickNameError,self)
    Event.RemoveListener(NotifyName.PlayerInfo.SysCheckChangeNickName,self.SysCheckChangeNickName,self)
    Facade.RemoveView(self)
    self:DisposeFsm()
end

function PlayerInfoSysChangeNickNameView:on_close()
    if self.params and self.params.onClose then
        self.params.onClose()
    end
end

function PlayerInfoSysChangeNickNameView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function PlayerInfoSysChangeNickNameView:ClickCheckNickName()
    local inputString = self.inputField.text
    if not inputString or inputString == "" or string.len(inputString) < minLetters then
        --不符合
        log.log("输入的内容不符合"  , inputString)
        return
    end
    ModelList.PlayerInfoSysModel:C2S_RequestCheckNickName(inputString)
end

function PlayerInfoSysChangeNickNameView:ClickChangeNickName()
    local inputString = self.inputField.text
    ModelList.PlayerInfoSysModel:C2S_RequestChangeNickName(inputString)
end

function PlayerInfoSysChangeNickNameView:on_btn_submit_click()
    self._fsm:GetCurState():DoCommonState3Action(self._fsm,"CommonState4State",function()
        self:DelayReturnState()
        self:ClickChangeNickName()
    end)

    self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonState2State",function()
        self:DelayReturnState()
        self:ClickCheckNickName()
    end)
end

function PlayerInfoSysChangeNickNameView:DelayReturnState()
    self:ClearDelayReturnState()
    self.Timer = Invoke(function()
        if self._fsm and self._fsm:GetCurState() then
            self._fsm:GetCurState():ChangeState(self._fsm,"CommonOriginalState")
            fun.set_active(self.inputObj , true)
            fun.set_active(self.confirmObj , false)
            self.inputField.text = ""
        end
    end, 5)
end

function PlayerInfoSysChangeNickNameView:ClearDelayReturnState()
    if self.Timer then
        self.Timer:Stop()
        self.Timer = nil
    end
end

function PlayerInfoSysChangeNickNameView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)

    self._fsm:GetCurState():DoCommonState3Action(self._fsm,"CommonOriginalState",function()
        AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function PlayerInfoSysChangeNickNameView:SysCheckChangeNickName(checkState)
    self:ClearDelayReturnState()
    if checkState then
        --检查通过
        fun.set_active(self.textTipInputWarn, false)
        self._fsm:GetCurState():DoCommonState2Action(self._fsm,"CommonState3State",function()
            fun.set_active(self.inputObj , false)
            fun.set_active(self.confirmObj , true)
            self:SetConfirm()
        end)
    else
        --检查不通过 回到初始状态
        if self._fsm and self._fsm:GetCurState() then
            self._fsm:GetCurState():ChangeState(self._fsm,"CommonOriginalState")
        end
        fun.set_active(self.textTipInputWarn, true)
        self.textTipInputWarn.text = Csv.GetDescription(623)
    end
end

function PlayerInfoSysChangeNickNameView:SetConfirm()
    local checkNickName = ModelList.PlayerInfoSysModel.GetCheckNickName()
    self.textConfirmInput.text = checkNickName 
end

function PlayerInfoSysChangeNickNameView:SysChangeNickNameSuccess()
    AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function PlayerInfoSysChangeNickNameView:SysChangeNickNameError()
    AnimatorPlayHelper.Play(self.anima,{"end","commonViewend"},false,function()     
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

function PlayerInfoSysChangeNickNameView:UpdateBtnEnableState(enableState)
    fun.enable_button(self.btn_submit , enableState)
    fun.enable_button(self.btn_close , enableState)
end

function PlayerInfoSysChangeNickNameView:UpdateInputFieldEnableState(enableState)
    self.inputField.enabled = enableState
end


return this
