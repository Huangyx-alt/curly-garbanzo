local ClubWelcomeView = BaseView:New('ClubWelcomeView',"ClubAtlas")

local this = ClubWelcomeView
local private = {}

function ClubWelcomeView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "Text",
    "btn_ok",
    "btn_close"
}

function ClubWelcomeView:Awake()
    self:on_init()
end

function ClubWelcomeView:OnEnable()
    local clubName = ModelList.ClubModel.GetSelfClubName()
    local text = Csv.GetDescription(30056)
    text = string.format(text, clubName)
    self.Text.text = text
end

function ClubWelcomeView:OnDisable()

end

function ClubWelcomeView:OnDestroy()
    self:Destroy()
end

function ClubWelcomeView:on_btn_ok_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function ClubWelcomeView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

----------------------Private Func-----------------------------

function private.PrivateFunc()

end

return this 

