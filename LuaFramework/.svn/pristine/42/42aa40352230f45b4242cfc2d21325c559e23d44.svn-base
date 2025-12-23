
local MailEnterState = require "State/MailView/MailEnterState"
local MailIdleState = require "State/MailView/MailIdleState"
local MailNoCountState = require "State/MailView/MailNoCountState"
local MailLeaveState = require "State/MailView/MailLeaveState"


local MailView = BaseView:New("MailView","MailAtlas")
local this = MailView
this.viewType = CanvasSortingOrderManager.LayerType.None
local MaskItemEntityCache = {}

this.auto_bind_ui_items = {
    "btn_close",            --关闭按钮
    "Content",              --邮件内容
    "noTipText",            --没有邮件时显示内容
    "MailItem"              --邮件Item
}

function MailView:Awake()
    Facade.RegisterView(this)
    this:on_init()
end

function MailView:OnEnable()
    Facade.RegisterView(self)

    self:BuildFsm()

    Cache.Load_Atlas(AssetList["MailAtlas"],"MailAtlas",function()
        --请求邮件协议
        ModelList.MailModel.C2S_RequestMailList()
    end)
    
end 

function MailView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("MailView",self,{
        MailEnterState:New(),
        MailIdleState:New(),
        MailNoCountState:New(),
        MailLeaveState:New(),  
    })
    self._fsm:StartFsm("MailEnterState")
end

function MailView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function MailView:OnDisable()
    for i, v in pairs(MaskItemEntityCache) do
	    v:Close()
	end
    MaskItemEntityCache ={}
    Facade.RemoveView(self)
end 

function MailView:OnDestroy()
    this:Close()
end

--关闭按钮
function MailView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

--刷新邮件列表
function MailView:OnUpDateMailList()

    local tb =ModelList.MailModel.getMailItemListbyTime()
    local count = 0
    this:ClearMailList()

    for _,v in pairs(tb) do
        count = count +1 
        local view =  this:GetItemViewInstance(count)
        if view then 
            view:UpdateData(v)
        end 
    end 
   
    this:Change2FitState(count)

end


function MailView:Change2FitState(count)

    count = count or 0

    if count >0 then 
        self._fsm:ChangeState("MailIdleState")
    
    else 
        self._fsm:ChangeState("MailNoCountState")
    end   
end

--显示弹出框
function MailView.ShowMailMessagePop(parm)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.MailMessagePopView,nil,nil,parm)
end

--弹出亚马逊卡的框
function MailView.ShowMailAMAZONCard(parm)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.MailAdressRewardView,nil,nil,parm)
end

function MailView:OnNotMail()
    fun.set_active( self.noTipText , true)
    self:ClearMailList()
end

function MailView:ClearMailList()
 
	for i, v in pairs(MaskItemEntityCache) do
	    v:Close()
	end
    MaskItemEntityCache ={}
end

function MailView:OnHaveMail()
    fun.set_active( self.noTipText , false)
end

function MailView:GetItemViewInstance(index)
    local view = require "View/Mail/MailItemView"
    local view_instance = nil
    
    if MaskItemEntityCache[index] == nil then
        local item = fun.get_instance(self.MailItem,self.Content)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        MaskItemEntityCache[index] = view_instance
    else
        view_instance = MaskItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)

    return view_instance
end 

this.NotifyList = {
    {notifyName = NotifyName.Mail.UpDateMailList, func = this.OnUpDateMailList},
    {notifyName = NotifyName.Mail.ShopMailDialog, func = this.ShowMailMessagePop},
    {notifyName = NotifyName.Mail.ShopMailAmazonCard, func = this.ShowMailAMAZONCard},
}

return this 