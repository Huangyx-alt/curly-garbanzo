
---收集资源界面
local ClubReqResCollectView = BaseView:New("ClubReqResCollectView","ClubAtlas")

local this = ClubReqResCollectView
  
this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_claim",  --请求发送
    "btn_close",  --关闭
    "HeadItem",     --初始化头像
    "itemList",    --加载一张卡牌
    "itemIcon",
    "CountTxt"
}

function ClubReqResCollectView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubReqResCollectView:Awake()
    self:on_init()
end


function ClubReqResCollectView:OnEnable(msgid)
    local messageInfo = ModelList.ClubModel.getMessageForid(msgid)

    if messageInfo ~= nil then 
        local ChatInfo = Proto.decode(MSG_ID.MSG_CLUB_CHAT_RESOURCE_ASK,self.data.msgBase64)
       --初始化领取物品图标
        if fun.table_len(ChatInfo.reward) >0 then 
            local itemIconSprite =  Csv.GetItemOrResource(ChatInfo.reward[1].id, "icon")
            self.itemIcon.sprite =  AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)

            self.CountTxt.text = tostring(ChatInfo.reward[1].value)
        end 
       --初始化领取得数量
        
       --初始化人数
       for _,v in pairs(ChatInfo.players) do 
        local itemGrid = fun.get_instance(self.item, self.itemList)
        this:SetItem(v,itemGrid)
    end 
    end 

end


function ClubReqResCollectView:SetItem(v,itemGrid)
    local refItem = fun.get_component(itemGrid , fun.REFER)
    local iconSpriteName = ModelList.PlayerInfoSysModel:GetConfigAvatarIconName(v.player.avatar)
   
    local headImg = refItem:Get("imgHead")
  --  headImg.sprite = AtlasManager:GetSpriteByName("HeadAtlas",iconSpriteName)
    ModelList.PlayerInfoSysModel:LoadTargetHeadSprite(iconSpriteName, headImg)
end 
 

function ClubReqResCollectView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ClubReqResCollectView:on_btn_claim_click()
    --领取奖励

end

function ClubReqResCollectView:OnDisable()
 
end

function ClubReqResCollectView.OnDestroy()
    this:Destroy()
end

return this