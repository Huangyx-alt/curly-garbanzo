local PowerupjokeHelperview = BaseView:New('PowerupjokeHelperview');

local this = PowerupjokeHelperview

function PowerupjokeHelperview:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


this.auto_bind_ui_items = {
  "btn_close",
  "btn_claim",
  "Toggle",
  "Text1",--说明2
  "Text2",--说明3
  "Text3",--说明4
}

function PowerupjokeHelperview.Awake(obj, obj2)
    this:on_init()
end

function PowerupjokeHelperview.OnEnable()
   this:initData()
   
end

function PowerupjokeHelperview:initData()
    self.Text1.text = Csv.GetDescription(1083)
    self.Text2.text = Csv.GetDescription(1084)
    self.Text3.text = Csv.GetDescription(1085)

    self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(go,check)
        self:SetHelpToggle(check)
    end)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    ModelList.GuideModel:OpenUI("PowerupjokeHelperview")
    local value = fun.read_value("PowerupjokeHelperview".."uid"..playerInfo.uid,nil)
    if not value or value == 0 then 
        self.Toggle.isOn = false
    else 
        self.Toggle.isOn = true
    end     


end 

function PowerupjokeHelperview.OnDisable()
    Event.Brocast(EventName.Event_popup_GameHallHelp_finish)
end

function PowerupjokeHelperview:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end


function PowerupjokeHelperview:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function PowerupjokeHelperview:SetHelpToggle(check)
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then 
        fun.save_value("PowerupjokeHelperview".."uid"..playerInfo.uid,1)
    else 
        fun.save_value("PowerupjokeHelperview".."uid"..playerInfo.uid,0)
    end 
end 

function PowerupjokeHelperview.OnDestroy()
    this:Destroy()
end

return this 