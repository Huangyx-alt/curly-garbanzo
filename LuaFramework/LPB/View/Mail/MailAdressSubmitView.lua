
local MailAdressSubmitView = BaseView:New("MailAdressSubmitView","MailadressAtlas")
local this = MailAdressSubmitView

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
   "btn_close",
   "btn_submit", --拉起邮箱
   "coinText",
   "ZByoujian13",
}


function MailAdressSubmitView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


function MailAdressSubmitView.Awake(obj, obj2)
    this:on_init()
end

function MailAdressSubmitView.OnEnable()
    this:initData()
    
 end

function MailAdressSubmitView:initData()
    local count = Csv.GetData("control", 141, "content")[1][2] 
    self.coinText.text = fun.format_money(count) 

    if fun.is_ios_platform() then
        self.ZByoujian13.sprite = AtlasManager:GetSpriteByName("MailadressAtlas", "ZByoujian13old")
    else
        self.ZByoujian13.sprite = AtlasManager:GetSpriteByName("MailadressAtlas", "ZByoujian13")
    end
end

function MailAdressSubmitView.OnDisable()
   
end

function MailAdressSubmitView.OnDestroy()
    this:Destroy()
end

function MailAdressSubmitView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressSubmitView,nil,nil,nil)
    Event.Brocast(EventName.Event_popup_MailPopAddress_finish)
end

function MailAdressSubmitView:on_btn_submit_click()
    --先发邮件确认消息，
    ModelList.MailModel.C2S_UserEmailSubmit()

    ModelList.PlayerInfoModel:SubmitEmailAdress()

    --关闭UI
    Event.Brocast(EventName.Event_popup_MailPopAddress_finish)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressSubmitView,nil,nil,nil)
    -- Event.Brocast(EventName.Event_popup_MailPopAddress_finish)
end

return this 