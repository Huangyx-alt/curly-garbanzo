local WinZoneExplainView = BaseDialogView:New('WinZoneExplainView', "WinZoneExplainAtlas")
local this = WinZoneExplainView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this._cleanImmediately = true
fun.ExtendClass(this, fun.ExtendFunction.mutual)

function WinZoneExplainView:New(view)
    local o = {}
    setmetatable(o, {__index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_close",
    "btn_claim",
    "Toggle",
    "CityTitle",
    "Text1",
    "Text2",
    "Text3",
    "Text4",
    "anima",
}

function WinZoneExplainView:Awake()
    self:on_init()
end

function WinZoneExplainView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    self:InitView()
end

function WinZoneExplainView:InitView()
    fun.set_active(self.Toggle, false)
    self.Text1.text = Csv.GetDescription(1190)
    self.Text2.text = Csv.GetDescription(1191)
    self.Text3.text = Csv.GetDescription(1192)
    self.Text4.text = Csv.GetDescription(1193)
    self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(go,check)
        self:SetHelpToggle(check)
    end)

    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value("WinZoneExplain".."uid"..playerInfo.uid,nil)
    if not value or value == 0 then 
        self.Toggle.isOn = false
    else 
        self.Toggle.isOn = true
    end

    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"HelpView_start", "HelpView_start"}, false, function()
                self:MutualTaskFinish()
            end)
        end

        self:DoMutualTask(task)
    end
end 

function WinZoneExplainView.OnDisable()
    Facade.RemoveViewEnhance(self)
end

function WinZoneExplainView:on_btn_close_click()
    self:CloseSelf()
end

function WinZoneExplainView:on_btn_claim_click()
    self:CloseSelf()
end

function WinZoneExplainView:SetHelpToggle(check)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then 
        fun.save_value("WinZoneExplain" .. "uid" .. playerInfo.uid, 1)
    else 
        fun.save_value("WinZoneExplain" .. "uid" .. playerInfo.uid, 0)
    end 
end

function WinZoneExplainView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            AnimatorPlayHelper.Play(self.anima, {"HelpView_end", "HelpView_end"}, false, function()
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end

        self:DoMutualTask(task)
    else
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function WinZoneExplainView:OnCloseLobbyView()
    --self:CloseSelf()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.WinZone.CloseLobbyView, func = this.OnCloseLobbyView},
}

return this