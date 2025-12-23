
---礼盒帮助界面
local ClubReqGiftPacketHelpView =  BaseView:New("ClubReqGiftPacketHelpView","ClubAtlas")

local this = ClubReqGiftPacketHelpView

this.ViewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_close",  --请求发送
    "itemParent",  --关闭
    "CountTxt",     --
    "title",    --加载一张卡牌
    "item",    --
    "name",
    "liheIcon",
    "itemIcon",
    "StyleLiheLight",
    "btn_claim",
    "content"
}

function ClubReqGiftPacketHelpView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubReqGiftPacketHelpView:Awake()
    self:on_init()
end

function ClubReqGiftPacketHelpView:OnEnable(level)
   
        local tb_reward =  Csv.GetRewardShowForId(level)

        -- 初始化奖励
        local itemIconSprite =  Csv.GetItemOrResource(tb_reward.reward_show_best[1], "icon")
        self.itemIcon.sprite =  AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)
        self.CountTxt.text = tb_reward.reward_show_best[2]
        self.name.text = Csv.GetDescription(30086)
        self.title.text =  Csv.GetDescription(30085)

        if tb_reward ~= nil then 
            for _,v in pairs(tb_reward.reward_show) do
                local itemGrid = fun.get_instance(self.item, self.itemParent)
                fun.set_active(itemGrid,true)
                this:setItemId(v,itemGrid)
            end 
        end     

        if level == 2 then 
            self.liheIcon.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "LH01")
            self.StyleLiheLight.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "ClubboxSMlight01")
        elseif level == 1 then 
            self.liheIcon.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "LH08")
            self.StyleLiheLight.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "ClubboxSMlight02")
        else
            self.liheIcon.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "LH02")
            self.StyleLiheLight.sprite = AtlasManager:GetSpriteByName("ClubAtlas", "ClubboxSMlight03")
        end 

end

function ClubReqGiftPacketHelpView:setItemId(item,itemNode)
    local itemIconSprite = Csv.GetItemOrResource(item[1], "icon")
    local count = item[2] or 0
    local refItem = fun.get_component(itemNode , fun.REFER)
    local icon = refItem:Get("icon")
    local CountTxt  = refItem:Get("CountTxt")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", itemIconSprite)
    CountTxt.text = count
end 

function ClubReqGiftPacketHelpView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function ClubReqGiftPacketHelpView:on_btn_claim_click()
   --跳转商店
   Facade.SendNotification(NotifyName.CloseUI,this)
   Facade.SendNotification(NotifyName.ShopView.PopupShop,PopupViewType.show,nil,nil,nil)
end

function ClubReqGiftPacketHelpView:OnDisable()
 
end

function ClubReqGiftPacketHelpView.OnDestroy()
    this:Destroy()
end

return this