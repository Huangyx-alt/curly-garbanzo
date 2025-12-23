
TopCurrencyVipView = TopCurrencyView:New("TopCurrencyVipView")
local this = TopCurrencyVipView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_buy",
    "text_coin_value",
    "text_dimond_value",
    "left_icon",
    "right_icon",
    "buy_bg_img",
    "buy_letter_img",
    "img_vip_cion",
    "text_emetald",
    "text_viplevel",
    "text_extra_gold",
    "text_extra_diamon",
    "img_reddot",
    --------------------------头像-----------------    
    "btn_head",
    "img_head_frame",
    "img_head_icon",
    "slid_exp",
    "text_exp",
    "text_level",
    "text_leaf",
--------------------------头像-----------------
    "rocket",
    "vip",
    "text_rocket_value"
}

function TopCurrencyVipView:New(viewName, atlasName, parentView,disable,reddot)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.viewName = viewName
    o.atlasName = atlasName
    o._parentView = parentView
    o._disable = disable
    o._reddot = reddot or RedDotParam.city_top_shop
    return o
end

function TopCurrencyVipView:override_OnEnable()
    self:SetVip()
    Event.AddListener(EventName.Event_UpdateRoleInfo,self.UpdataVip,self)
end


function TopCurrencyVipView:Override_OnDisable()
    Event.RemoveListener(EventName.Event_UpdateRoleInfo,self.UpdataVip,self)
end

function TopCurrencyVipView:Override_OnDestroy()

end

function TopCurrencyVipView:UpdataVip()
    self:SetVip()
end

function TopCurrencyVipView:SetVip()
    Cache.Load_Atlas(AssetList["CommonAtlas"],"CommonAtlas",function()
        local playInfo = ModelList.PlayerInfoModel:GetUserInfo()
        if playInfo then
            local vip = Csv.GetData("vip",playInfo.vip,nil)
            Cache.SetImageSprite("CommonAtlas",vip.icon,self.img_vip_cion)
            self.text_viplevel.text = string.format("LEVEL%s",playInfo.vip)
            self.text_extra_gold.text = string.format("+%s%s",(vip.shop_added - 100),"%")
            self.text_extra_diamon.text = string.format("+%s%s",(vip.shop_added - 100),"%")
        end
    end)
end