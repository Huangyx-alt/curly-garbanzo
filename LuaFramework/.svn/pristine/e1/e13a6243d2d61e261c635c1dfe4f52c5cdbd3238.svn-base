

ShopNormalChildItemcRuledi5 = ShopChildItemBaseView:New()
local this = ShopNormalChildItemcRuledi5
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "item_tips",
    "item_text_exp",
    "item_text_cost",
    "item_text_bonus",
    "btn_item_rule",
    "item_text_discount",
    "img_mask",
    "img_icon",
    "text_countdown",
    "ultra_shop_icon",
    "LH_Tip",
	"bundled_shop_icon",
    "text_bonus_panel",
    "text_bonus1",
    "text_bonus2",
    "tag_time_limit",
    "text_times1",
}

function ShopNormalChildItemcRuledi5:New(shopItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem = shopItem
    return o
end

function ShopNormalChildItemcRuledi5:Awake()
    self:on_init()
end

function ShopNormalChildItemcRuledi5:OnEnable()
    self:RegisterEvent()
    self:BuildFsm("ShopNormalChildItemcRuledi5")
    self:CheckState()
    self:RegisterViewEnhance()
    self:RefreshUltraBetUI()
end

function ShopNormalChildItemcRuledi5:OnDisable()
    self:RemoveEvent()
    self:DisposeFsm()
    self:StopTimer()
    self:RemoveViewEnhance()
end

function ShopNormalChildItemcRuledi5:on_close()

end

function ShopNormalChildItemcRuledi5:OnDestroy()
    self._shopItem = nil
end

function ShopNormalChildItemcRuledi5:SetAvailable()
    fun.set_active(self.img_mask,false)
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi5:SetDisable()
    fun.set_active(self.img_mask,true)
    self.text_countdown.text = ""
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi5:SetCountdDown()
    fun.set_active(self.img_mask,true)
    self:StartTimer()
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi5:SetShopItemInfo()
    if self._shopItem then
        local shopData = Csv.GetData("shop",self._shopItem.id,nil)
        if shopData then
            fun.set_active(self.item_tips,shopData.bonus ~= 0)
            if self.item_text_discount then
                self.item_text_discount.text = string.format("%s%s",shopData.bonus,"%")
            end
            if self.item_text_bonus then
                --self.item_text_bonus:SetTextComma(tonumber(shopData.item_description[1][2]))
                --self.item_text_bonus.text = shopData.item_description[1][2]
                self.item_text_bonus:SetValue(tonumber(shopData.item_description[1][2]))
            end
            if self.item_text_exp then
                --self.item_text_exp.text = shopData.item[2][2]
                self.item_text_exp:SetValue(tonumber(shopData.item[2][2]))
            end
            if self.item_text_cost then
                self.item_text_cost.text = string.format("$%s",shopData.price)
            end

            self.img_icon.sprite = AtlasManager:GetSpriteByName("CommonAtlas",shopData.itemicon)
        end
        self:CheckHaveGiftPackage(shopData)
		self:SetBundledIcon(shopData.bundled_item)

        self:SetItemPromotionInfo(shopData)
    end
end

function ShopNormalChildItemcRuledi5:on_btn_item_rule_click()
    self._fsm:GetCurState():ShopItemClick(self._fsm)
end

function ShopNormalChildItemcRuledi5:SetItemPromotionInfo(data)
    if not data then
        return
    end

    if ModelList.MainShopModel:IsPromotionValid() and self:IsInPromotion(data) then
        fun.set_active(self.text_bonus_panel, true)
        fun.set_active(self.tag_time_limit, true)
        fun.set_active(self.item_text_bonus, false)
        if self.text_bonus1 then
            self.text_bonus1:SetValue(tonumber(data.item_description[1][2]))
        end

        if self.text_bonus2 then
            local v1 = tonumber(data.item_description[1][2])
            local v2 = tonumber(data.item_description_sale[1][2])
            if v1 and v2 then
                if v2 > v1 then
                    --self.text_bonus2:SetValue(tonumber(v2 - v1))
                    local txtBonus2 = fun.get_component(self.text_bonus2, fun.OLDTEXT)
                    txtBonus2.text = "<size=50>+" .. fun.NumInsertComma(v2 - v1) .. "</size><size=40> Extra</size>"
                elseif v2 == v1 then
                    log.log("ShopNormalChildItemcRuledi5 SetItemPromotionInfo error 1 ", data)
                else
                    log.log("ShopNormalChildItemcRuledi5 SetItemPromotionInfo error 2 ", data)
                end
            else

            end
        end

        if self.text_times1 then
            local total_times = data.frequency_sale or 0
            local remain_times = self._shopItem and self._shopItem.promoBuyCount or 0
            self.text_times1.text = remain_times .. "/" .. total_times
        end
    else
        fun.set_active(self.text_bonus_panel, false)
        fun.set_active(self.tag_time_limit, false)
        fun.set_active(self.item_text_bonus, true)
    end
end

return this