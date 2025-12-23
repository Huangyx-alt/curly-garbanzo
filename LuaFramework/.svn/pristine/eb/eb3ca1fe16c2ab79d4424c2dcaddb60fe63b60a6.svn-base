require "View/CommonView/WatchADUtility"
ShopNormalChildItemcRuledi3 = ShopChildItemBaseView:New()
local this = ShopNormalChildItemcRuledi3
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "item_tips",
    "item_text_name",
    "item_text_cost",
    "btn_item_rule",
    "img_mask",
    "img_icon",
    "img_vidio",
    "text_countdown",
    "img_reddot",
    "Noads",
    "ultra_shop_icon",
    "LH_Tip",
	"bundled_shop_icon"
}
local _watchADUtility = WatchADUtility:New(AD_EVENTS.AD_EVENTS_SHOP_ITEM)
function ShopNormalChildItemcRuledi3:New(shopItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem = shopItem
    return o
end

function ShopNormalChildItemcRuledi3:Awake()
    self:on_init()
end

function ShopNormalChildItemcRuledi3:OnEnable()
    self:RegisterEvent()
    self:BuildFsm("ShopNormalChildItemcRuledi3")
    self:CheckState(true)
    self:RegisterRedDotNode()
    self:RegisterViewEnhance()
    self:RefreshUltraBetUI()
end

function ShopNormalChildItemcRuledi3:OnDisable()
    self:RemoveEvent()
    self:DisposeFsm()
    self:StopTimer()
    self:UnRegisterRedDotNode()
    self:RemoveViewEnhance()
end

function ShopNormalChildItemcRuledi3:on_close()

end

function ShopNormalChildItemcRuledi3:OnDestroy()
    self._shopItem = nil
end

function ShopNormalChildItemcRuledi3:RegisterRedDotNode()
    if self._shopItem then
        RedDotManager:RegisterNode(RedDotEvent.shop_coinfree_event,"shop_coin_free",self.img_reddot,self._shopItem.id)
    end
end

function ShopNormalChildItemcRuledi3:UnRegisterRedDotNode()
    if self._shopItem then
        RedDotManager:UnRegisterNode(RedDotEvent.shop_coinfree_event,"shop_coin_free",self._shopItem.id)
    end
end

function ShopNormalChildItemcRuledi3:SetAvailable(isinit)
    --local shopData = Csv.GetData("shop",self._shopItem.id,nil)
    fun.set_active(self.img_mask,false)
    fun.set_active(self.img_vidio,self._shopItem.fetchType == ShopFetchType.adType)
    fun.set_active(self.item_tips,false)
    self:HideNoAd()
    self:SetShopItemInfo(true)
    if not isinit then
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function ShopNormalChildItemcRuledi3:SetDisable(isinit)
    fun.set_active(self.img_mask,true)
    fun.set_active(self.item_tips,false)
    fun.set_active(self.img_vidio,false)
    self.text_countdown.text = ""
    self:HideNoAd()
    self:SetShopItemInfo(false)
    if not isinit then
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function ShopNormalChildItemcRuledi3:SetCountdDown(isinit)
    fun.set_active(self.img_mask,true)
    fun.set_active(self.item_tips,false)
    fun.set_active(self.img_vidio,false)
    self:HideNoAd()
    self:StartTimer()
    self:SetShopItemInfo(false)
    if not isinit then
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function ShopNormalChildItemcRuledi3:HideNoAd()
    fun.set_active(self.item_text_cost,true)
    fun.set_active(self.Noads,false)
    --
    --local img3 = fun.get_component(self.img_mask, fun.IMAGE)
    --fun.set_img_color(img3, Color.New(1, 1, 1, 1))

    local img3 = fun.get_component(self.item_tips, fun.IMAGE)
    fun.set_img_color(img3, Color.New(1, 1, 1, 1))

    local img3 = fun.get_component(self.btn_item_rule, fun.IMAGE)
    fun.set_img_color(img3, Color.New(1, 1, 1, 1))
    local img3 = fun.get_component(self.img_icon, fun.IMAGE)
    fun.set_img_color(img3, Color.New(1, 1, 1, 1))
    local img3 = fun.get_component(self.img_vidio, fun.IMAGE)
    fun.set_img_color(img3, Color.New(1, 1, 1, 1))

    local btnBg = fun.find_child(self.Noads.transform.parent,"Image")
    local img = fun.get_component(btnBg,fun.IMAGE)
    if img and not fun.starts(img.sprite.name,"cButtonlv")   then
        Cache.SetImageSprite("ShopAtlas", "cButtonlv", img)
    end
    RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
end

function ShopNormalChildItemcRuledi3:SetNoAd(isinit)
    --fun.set_active(self.img_mask,true)
    --fun.set_active(self.item_tips,false)

    --local bg3 = fun.find_child(this.btn_watch_video, "btn_watch_video/Img_vido")
    --local img3 = fun.get_component(self.img_mask, fun.IMAGE)
    --fun.set_img_color(img3, Color.New(0.47, 0.47, 0.47, 1))

    local img3 = fun.get_component(self.item_tips, fun.IMAGE)
    fun.set_img_color(img3, Color.New(0.47, 0.47, 0.47, 1))

    local img3 = fun.get_component(self.btn_item_rule, fun.IMAGE)
    fun.set_img_color(img3, Color.New(0.47, 0.47, 0.47, 1))
    local img3 = fun.get_component(self.img_icon, fun.IMAGE)
    fun.set_img_color(img3, Color.New(0.47, 0.47, 0.47, 1))
    local img3 = fun.get_component(self.img_vidio, fun.IMAGE)
    fun.set_img_color(img3, Color.New(0.47, 0.47, 0.47, 1))

    fun.set_active(self.item_text_cost,false)
    fun.set_active(self.Noads,true)
    local btnBg = fun.find_child(self.Noads.transform.parent,"Image")
    local img = fun.get_component(btnBg, fun.IMAGE)
    if img and not fun.starts(img.sprite.name, "lButtonPurpleH") then
        --log.r("img  lButtonPurpleH")
        Cache.SetImageSprite("CommonAtlas", "lButtonPurpleH", img)
    end
    self:StartTimer()
    if not isinit then
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event)
    end
end

function ShopNormalChildItemcRuledi3:IsAbleWatchAd()
    return _watchADUtility:IsAbleWatchAd()
end

function ShopNormalChildItemcRuledi3:SetShopItemInfo(checkAd)
    if self._shopItem then
        if self._shopItem.fetchType == 1 and not ModelList.MainShopModel:CheckFreeRewardAvailable() and checkAd then
            self:SetNoAd()
        else
            self:HideNoAd()
            local shopData = Csv.GetData("shop", self._shopItem.id, nil)
            if shopData then
                self.item_text_name.text = tostring(shopData.item_description[1][2]) --res.name
                fun.set_active(self.item_text_name.gameObject, true)
                self.item_text_cost.text = "Free"
                --log.r("text  Free ")
                --fun.set_active(self.item_text_cost.gameObject,true)
                self.img_icon.sprite = AtlasManager:GetSpriteByName("CommonAtlas", shopData.itemicon)
            end
        end

        local shopData = Csv.GetData("shop", self._shopItem.id, nil)
        if shopData then
            self.item_text_name.text = tostring(shopData.item_description[1][2]) --res.name
            fun.set_active(self.item_text_name.gameObject,true)
            self.item_text_cost.text = "Free"
            --log.r("text  Free ")
            --fun.set_active(self.item_text_cost.gameObject,true)
            self.img_icon.sprite = AtlasManager:GetSpriteByName("CommonAtlas", shopData.itemicon)
            self:CheckHaveGiftPackage(shopData)
			self:SetBundledIcon(shopData.bundled_item)
        end
    end
end

function ShopNormalChildItemcRuledi3:on_btn_item_rule_click()
    self._fsm:GetCurState():ShopItemClick(self._fsm)
end

return this