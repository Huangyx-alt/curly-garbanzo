
MailAdressCheckView = BaseView:New("MailAdressCheckView","MailadressAtlas")
local this = MailAdressCheckView

this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

this.auto_bind_ui_items = {
   "MailAdressText",
   "btn_yes",
   "btn_Resend",
   "ZByoujian13"
}


function MailAdressCheckView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


function MailAdressCheckView.Awake(obj, obj2)
    this:on_init()
end

function MailAdressCheckView.OnEnable()
    this:initData()
    
 end

function MailAdressCheckView:initData()
    self.MailAdressText.text =  not ModelList.PlayerInfoModel.mail and " " or ModelList.PlayerInfoModel.mail

    if fun.is_ios_platform() then
        self.ZByoujian13.sprite = AtlasManager:GetSpriteByName("MailadressAtlas", "ZByoujian13old")
    else
        self.ZByoujian13.sprite = AtlasManager:GetSpriteByName("MailadressAtlas", "ZByoujian13")
    end
end

function MailAdressCheckView.OnDisable()
   
end

function MailAdressCheckView:on_btn_yes_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressCheckView,nil,nil,nil)
    ModelList.PlayerInfoModel:SubmitEmailAdress()
end


function MailAdressCheckView:on_btn_Resend_click()
    ModelList.PlayerInfoModel:SubmitEmailAdress()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressCheckView,nil,nil,nil)
end



function MailAdressCheckView.OnDestroy()
    this:Destroy()
end

return this 