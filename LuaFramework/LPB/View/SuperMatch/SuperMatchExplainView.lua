local SuperMatchExplainView = BaseDialogView:New('SuperMatchExplainView', "SuperMatchExplainAtlas")
local this = SuperMatchExplainView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

function SuperMatchExplainView:New(view)
    local o = {}
    setmetatable(o, {__index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_close",
    "btn_claim",
    "Toggle",
    "Text1",
    "Text2",
    "Text3",
    "Text4",
    "anima",
}

function SuperMatchExplainView:Awake()
    self:on_init()
end

function SuperMatchExplainView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self:InitView()
end

function SuperMatchExplainView:InitView()
    fun.set_active(self.Toggle, false)
    fun.set_active(self.Text4, false)
    self.Text1.text = Csv.GetDescription(85001)
    self.Text2.text = Csv.GetDescription(85002)
    self.Text3.text = Csv.GetDescription(85003)
    self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(go,check)
        self:SetHelpToggle(check)
    end)

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value("SuperMatchExplain".."uid"..playerInfo.uid,nil)
    if not value or value == 0 then 
        self.Toggle.isOn = false
    else 
        self.Toggle.isOn = true
    end

    --if fun.is_not_null(self.anima) then
    --    local task = function()
    --        AnimatorPlayHelper.Play(self.anima, {"HelpView_start", "HelpView_start"}, false, function()
    --            self:MutualTaskFinish()
    --        end)
    --    end
    --
    --    self:DoMutualTask(task)
    --end
end 

function SuperMatchExplainView.OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SuperMatchExplainView:on_btn_close_click()
    self:CloseSelf()
end

function SuperMatchExplainView:on_btn_claim_click()
    self:CloseSelf()
end

function SuperMatchExplainView:SetHelpToggle(check)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then 
        fun.save_value("SuperMatchExplain" .. "uid" .. playerInfo.uid, 1)
    else 
        fun.save_value("SuperMatchExplain" .. "uid" .. playerInfo.uid, 0)
    end 
end

function SuperMatchExplainView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"end", "SuperMatchExplainViewend"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end

        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
    Event.Brocast(EventName.Event_Super_Match_Close_Explain_View)
end

--设置消息通知
this.NotifyEnhanceList =
{
    --{notifyName = NotifyName.WinZone.CloseLobbyView, func = this.OnCloseLobbyView},
}

return this
