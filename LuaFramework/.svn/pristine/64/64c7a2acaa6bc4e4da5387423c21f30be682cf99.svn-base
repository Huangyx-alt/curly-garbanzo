local MailAdressRewardView = BaseView:New("MailAdressRewardView","MailAtlas")
local this = MailAdressRewardView
this.viewType = CanvasSortingOrderManager.LayerType.Shop_Dialog

this.auto_bind_ui_items = {
    "contentText",  --内容文字
    "coinText",
    "btn_activate",  --确认收集按钮
    "btn_delete",  --确认收集按钮
    "btn_close",   -- 删除按钮
    "ZBzhenjinjiangli4",
}

function MailAdressRewardView:Awake()
    self:on_init()
end 

function MailAdressRewardView:OnEnable(params)
    this.recordInfo = params
    local mailInfo = ModelList.MailModel.GetMailInfo(this.recordInfo.RecordId)
    local str = string.split(mailInfo.content,"&") 
    local contentstr = Csv.GetData("description", 29, "description")
    local code = str[1] or mailInfo.content
    self.contentText.text = string.format(contentstr, ModelList.PlayerInfoModel:GetUserInfo().nickname,code) 
    self.coinText.text = "$".. str[2]

    if fun.is_ios_platform() then
        self.ZBzhenjinjiangli4.sprite = AtlasManager:GetSpriteByName("MailAtlas", "ZBzhenjinjiangli4old")
    else
        self.ZBzhenjinjiangli4.sprite = AtlasManager:GetSpriteByName("MailAtlas", "ZBzhenjinjiangli4")
        self.coinText.text = ""
    end
end 

function MailAdressRewardView:OnDisable()

end

function MailAdressRewardView:on_btn_activate_click()
    local mailInfo = ModelList.MailModel.GetMailInfo(this.recordInfo.RecordId)
    local str = string.split(mailInfo.content,"&") 
    local code = str[1] or mailInfo.content
    local amazonUrl = Csv.GetData("description", 30, "description")
    Util.CopyTextToClipboard(tostring(code))
    fun.OpenURL(amazonUrl)
 --   Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressRewardView,nil,nil,nil)
end 

function MailAdressRewardView:on_btn_delete_click()
    --TO DO 删除邮件
    ModelList.MailModel.C2S_RequestMailGetReward(this.recordInfo.RecordId)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressRewardView,nil,nil,nil)
end 

function MailAdressRewardView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.MailAdressRewardView,nil,nil,nil)
 
end


return this 