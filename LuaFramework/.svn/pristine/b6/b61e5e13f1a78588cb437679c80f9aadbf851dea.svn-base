
local ClubOpenPackGiftGetView = BaseView:New("ClubOpenPackGiftGetView", "ClubAtlas")
local base64 = require "Common/base64"
local this = ClubOpenPackGiftGetView
  
this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_other",  --请求发送
    "btn_thank",  --关闭
    "btn_close",     --初始化头像
    "btn_other2",    
    "CountTxt",
    "giftIcon",
    "icon",
    "name",
    "Anima"
}

this.giftIconList ={
    [2] = "gonghuilibao1",
    [1] = "gonghuilibao7",
    [9] = "gonghuilibao8",
}

function ClubOpenPackGiftGetView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubOpenPackGiftGetView:Awake()
    self:on_init()
    
    fun.set_active(self.btn_other,false)

    fun.set_active(self.btn_thank,false)
    fun.set_active(self.btn_other2,false)

end


function ClubOpenPackGiftGetView:OnEnable(msgid)
   
    self.msgid = msgid
    local isSelfFlag = false
    local messageInfo = ModelList.ClubModel.getMessageForid(msgid)
    local rewardInfo = nil
    local Level = 1 
    if messageInfo ~= nil then 
        if messageInfo.info.uid == ModelList.PlayerInfoModel:GetUid() then 
            isSelfFlag = true
        end 
    end 

    --初始化系统信息
    local decoded = base64.decode(messageInfo.msgBase64)
    local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
    local giftInfo =Csv.GetData("item",ChatInfo.itemId,"result")

    if not giftInfo or not giftInfo[2] then 
        Level = 1 
    else 
        Level =giftInfo [2]
    end 

    for _,v in pairs(ChatInfo.packetInfo) do
        if v.player.uid == ModelList.PlayerInfoModel:GetUid() then 
            rewardInfo = v.reward
        end 
    end

    if rewardInfo ~= nil and (fun.table_len(rewardInfo)>0) then 
        --初始化 数量
        self.CountTxt.text = fun.format_money(rewardInfo[1].value) 
        
        local itemIconSprite = Csv.GetItemOrResource(rewardInfo[1].id, "icon")

        if this.giftIconList[rewardInfo[1].id] then 
            self.giftIcon.sprite = AtlasManager:GetSpriteByName("ClubAtlas", this.giftIconList[rewardInfo[1].id])
        end 

        self.icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)
        --初始化，物品icon
    end 

    
    if isSelfFlag then 
        fun.set_active(self.btn_other,true)
        
        fun.set_active(self.name,false)
        fun.set_active(self.btn_thank,false)
        fun.set_active(self.btn_other2,false)
        UISound.play("club_gift_open")
        --判断等级不一样 然后显示不同动画
        if Level == 1 then 
            AnimatorPlayHelper.Play(self.Anima,{"star1","ClubReqPackGiftGetViewstart1"},false,function()
                 
            end)
        elseif Level == 2 then 
            AnimatorPlayHelper.Play(self.Anima,{"start2","ClubReqPackGiftGetViewstart2"},false,function() 
              
            end)
        elseif Level == 3 then 
            AnimatorPlayHelper.Play(self.Anima,{"start3","ClubReqPackGiftGetViewstart3"},false,function() 
              
            end)
        end 
    else 
        fun.set_active(self.btn_other,false)

        fun.set_active(self.btn_thank,true)
        fun.set_active(self.btn_other2,true)
        fun.set_active(self.name,true)

        self.name.text = "From " .. messageInfo.info.nickname
        UISound.play("club_gift_open")
        if Level == 1 then 
            AnimatorPlayHelper.Play(self.Anima,{"star1","ClubReqPackGiftGetViewstart1"},false,function()
               
            end)
        elseif Level == 2 then 
            AnimatorPlayHelper.Play(self.Anima,{"start2","ClubReqPackGiftGetViewstart2"},false,function()
             
             end)
        elseif Level == 3 then 
            AnimatorPlayHelper.Play(self.Anima,{"start3","ClubReqPackGiftGetViewstart3"},false,function()
             
            end)
        end 
    end 
end
 
function ClubOpenPackGiftGetView:on_btn_close_click()
   --关闭此界面
   AnimatorPlayHelper.Play(self.Anima,{"end","ClubReqPackGiftGetViewend"},false,function()
    Facade.SendNotification(NotifyName.CloseUI,this)
   end)
 
end

function ClubOpenPackGiftGetView:on_btn_thank_click()
    --点击感谢
    AnimatorPlayHelper.Play(self.Anima,{"end","ClubReqPackGiftGetViewend"},false,function()
        ModelList.ClubModel.C2S_ClubGiftPackageThank(self.msgid) --发送感谢
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
   
end

function ClubOpenPackGiftGetView:on_btn_other_click()
    --点击查看其他人
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubOpenPackGiftGetListView,nil,nil,self.msgid)
end

function ClubOpenPackGiftGetView:on_btn_other2_click()
    --点击查看其他人
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubOpenPackGiftGetListView,nil,nil,self.msgid)
end

function ClubOpenPackGiftGetView:OnDisable()
 
end

function ClubOpenPackGiftGetView.OnDestroy()
    this:Destroy()
end

return this