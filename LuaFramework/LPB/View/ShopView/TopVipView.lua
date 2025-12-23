
TopVipView = BaseView:New("TopVipView")
local this = TopVipView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    --"img_vip_cion",
    "text_emetald",
    "text_viplevel",
    "text_extra_gold",
    "text_extra_diamon"
}

function TopVipView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function TopVipView:Awake()
    self:on_init()
end

function TopVipView:OnEnable()
    self:SetVip()
    Event.AddListener(EventName.Event_UpdateRoleInfo,self.UpdataVip,self)
end

function TopVipView:OnDisable()
    Event.RemoveListener(EventName.Event_UpdateRoleInfo,self.UpdataVip,self)
end

function TopVipView:UpdataVip()
    self:SetVip()
end

function TopVipView:SetVip()
    local playInfo = ModelList.PlayerInfoModel:GetUserInfo()
    if playInfo then
        local vip = Csv.GetData("vip",playInfo.vip,nil)
        --Cache.SetImageSprite("CommonAtlas",vip.icon,self.img_vip_cion)
        self.text_viplevel.text = string.format("LEVEL%s",playInfo.vip)
        self.text_extra_gold.text = string.format("+%s%s",(vip.shop_added - 100),"%")
        self.text_extra_diamon.text = string.format("+%s%s",(vip.shop_added - 100),"%")
        self.text_emetald.text = Csv.GetDescription(tonumber(vip.name)) 
    end
end