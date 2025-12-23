local ClubHelpView = BaseView:New('ClubHelpView');

local this = ClubHelpView

function ClubHelpView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


this.auto_bind_ui_items = {
  "btn_close",
  "btn_claim",
  "Text1",
  "Text2",
  "Text3",
}

function ClubHelpView:Awake(obj, obj2)
    this:on_init()
end

function ClubHelpView:OnEnable()
    
    self.Text1.text = Csv.GetDescription(30059)
    self.Text2.text = Csv.GetDescription(30061)
    self.Text3.text = Csv.GetDescription(30063)
end

function ClubHelpView:OnDisable()
    Event.Brocast(EventName.Event_popup_PopupClubCheck_finish)
end

function ClubHelpView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end


function ClubHelpView:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ClubHelpView.OnDestroy()
    this:Destroy()
end

return this 