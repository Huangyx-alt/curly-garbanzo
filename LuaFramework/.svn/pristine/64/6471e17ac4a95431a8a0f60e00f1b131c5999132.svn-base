--请求卡牌界面 帮忙
--传参 cardid msd 

local ClubOpenPackGiftGetListView = BaseView:New("ClubOpenPackGiftGetListView", "ClubAtlas")
local base64 = require "Common/base64"
local this = ClubOpenPackGiftGetListView
  
this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_close",  --请求发送
    "btn_claim",  --关闭
    "itemList",     --初始化头像
    "item",    --加载一张卡牌
}

function ClubOpenPackGiftGetListView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubOpenPackGiftGetListView:Awake()
    self:on_init()
end


function ClubOpenPackGiftGetListView:OnEnable(msgid)
    local messageInfo = ModelList.ClubModel.getMessageForid(msgid)

    if messageInfo ~= nil then 
        local decoded = base64.decode(messageInfo.msgBase64)
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
        for _,v in pairs(ChatInfo.packetInfo) do 
            local itemGrid = fun.get_instance(self.item, self.itemList)
            this:SetItem(v,itemGrid)
        end 
    else
        local topPackage = ModelList.ClubModel.getTopPackage()
        for k,v in pairs(topPackage) do 
            if v.msgId == msgid then 
                messageInfo = v 
                break;
            end 
        end 
        if messageInfo ~= nil then 
            local decoded = base64.decode(messageInfo.msgBase64)
            local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_PACKET,decoded)
            for _,v in pairs(ChatInfo.packetInfo) do 
                local itemGrid = fun.get_instance(self.item, self.itemList)
                this:SetItem(v,itemGrid)
            end 
        end 
    end 

end

function ClubOpenPackGiftGetListView:SetItem(v,itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)

    local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(v.player.avatar)
    local headImg = refItem:Get("imgHead")
    local name = refItem:Get("Text")
    local Count =  refItem:Get("CountText")
    local icon =  refItem:Get("icon")
    local item = v.reward[1] or {id =1,value =0}
    local itemSpriteName = Csv.GetItemOrResource(item.id, "icon")

    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, headImg)
    
  --  headImg.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemSpriteName)
    name.text = tostring(v.player.nickname)
    Count.text = "x".. tostring(item.value)
end 
 
function ClubOpenPackGiftGetListView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,ViewList.ClubOpenPackGiftGetView)
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ClubOpenPackGiftGetListView:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
    
end

function ClubOpenPackGiftGetListView:OnDisable()
 
end

function ClubOpenPackGiftGetListView.OnDestroy()
    this:Destroy()
end

return this