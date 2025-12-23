local VolcanoMissionHelpView = BaseDialogView:New('VolcanoMissionHelpView', "VolcanoMissionHelpAtlasInMain")
local this = VolcanoMissionHelpView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "Toggle",
    "Text1",
    "Text2",
    "Text3",
    "Text4",
    "Text5",
    "Text6",
    "Text7",
    "anima"
}

function VolcanoMissionHelpView:Awake() end

function VolcanoMissionHelpView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()

    --self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(go, check)
    --    self:SetHelpToggle(check)
    --end)
    --local value = fun.read_value("VolcanoMissionHelpView" .. tostring(playid) .. "uid" .. playerInfo.uid, nil)
    --if not value or value == 0 then
    --    self.Toggle.isOn = false
    --else
    --    self.Toggle.isOn = true
    --end
end

function VolcanoMissionHelpView:on_after_bind_ref()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"HelpView_start", "VolcanoMissionHelpView_start"}, false, function()
            self:MutualTaskFinish()
        end)
    end

    self:DoMutualTask(task)
    self:InitView()
end

local DesIDs = {8058, 8055, 8059, 8056, 8060, 8057, 8061}
function VolcanoMissionHelpView:InitView()
    table.each(DesIDs, function(desID, k)
        local contentStr = Csv.GetData("description", desID, "description")
        self["Text" .. k].text = contentStr
    end)
end

function VolcanoMissionHelpView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function VolcanoMissionHelpView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"HelpView_end", "VolcanoMissionHelpView_end"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.HideDialog, self)
        end)
    end

    self:DoMutualTask(task)
end

function VolcanoMissionHelpView:SetHelpToggle(check)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then
        fun.save_value("VolcanoMissionHelpView"..tostring(playid) .."uid"..playerInfo.uid,1)
    else
        fun.save_value("VolcanoMissionHelpView"..tostring(playid).."uid"..playerInfo.uid,0)
    end
end

function VolcanoMissionHelpView:on_btn_close_click()
    self:CloseSelf()
end

return this

