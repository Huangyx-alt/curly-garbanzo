ShopNormalChildItemcRuledi4 = ShopChildItemBaseView:New()
local this = ShopNormalChildItemcRuledi4
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "item_tips",
    "item_text_exp",
    "item_text_cost",
    "text_item_value1",
    "btn_item_rule",
    "item_text_discount",
    "img_mask",
    "text_item_value2",
    "img_item_icon1",
    "img_item_icon2",
    "text_countdown",
    "text_des",
    "ultra_shop_icon",
    "LH01",
    "bundled_shop_icon",
    "text_bonus_panel1",
    "text_bonus11",
    "text_bonus12",
    "img_item_icon11",
    "text_bonus_panel2",
    "text_bonus21",
    "text_bonus22",
    "img_item_icon22",
    "tag_time_limit",
    "text_times1",
}

function ShopNormalChildItemcRuledi4:New(shopItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem = shopItem
    return o
end

function ShopNormalChildItemcRuledi4:Awake()
    self:on_init()
end

function ShopNormalChildItemcRuledi4:OnEnable()
    self:RegisterEvent()
    self:BuildFsm("ShopNormalChildItemcRuledi4")
    self:CheckState()
    self:RegisterViewEnhance()
    self:RefreshUltraBetUI()
end

function ShopNormalChildItemcRuledi4:OnDisable()
    self:RemoveEvent()
    self:DisposeFsm()
    self:StopTimer()
    self:RemoveViewEnhance()
end

function ShopNormalChildItemcRuledi4:on_close()

end

function ShopNormalChildItemcRuledi4:OnDestroy()
    self._shopItem = nil
end

function ShopNormalChildItemcRuledi4:SetAvailable()
    fun.set_active(self.img_mask,false)
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi4:SetDisable()
    fun.set_active(self.img_mask,true)
    self.text_countdown.text = ""
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi4:SetCountdDown()
    fun.set_active(self.img_mask,true)
    self:StartTimer()
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi4:SetShopItemInfo()
    if self._shopItem then
        local shopData = Csv.GetData("shop",self._shopItem.id,nil)
        if shopData then
             fun.set_active(self.item_tips,shopData.bonus ~= 0)
            self.item_text_exp.text = shopData.item[3][2]
            self.item_text_cost.text = string.format("$%s",shopData.price)

            --self.text_item_value1.text = shopData.item_description[1][2]
            --self.text_item_value2.text = shopData.item_description[2][2]
            self.text_item_value1:SetValue(tonumber(shopData.item_description[1][2]))
            self.text_item_value2:SetValue(tonumber(shopData.item_description[2][2]))

            if shopData.description then
                self.text_des.text = shopData.description
            end


            -- local resData = Csv.GetData("resources",shopData.item[1][1])
            -- if resData then
            --     self.img_item_icon1.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
            -- else
              
            --     local ItemData = Csv.GetData("item",shopData.item[1][1])
            --     if ItemData then 
            --         self.img_item_icon1.sprite = AtlasManager:GetSpriteByName("ItemAtlas",ItemData.icon)
            --     else 
            --         fun.set_active(self.img_item_icon1,false)   
            --     end 
            -- end

            -- resData = Csv.GetData("resources",shopData.item[2][1])
            -- if resData then
            --     self.img_item_icon2.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
            -- else
            --     local ItemData = Csv.GetData("item",shopData.item[2][1])
            --     if ItemData then 
            --         self.img_item_icon2.sprite = AtlasManager:GetSpriteByName("ItemAtlas",ItemData.icon)
            --     else 
            --         fun.set_active(self.img_item_icon2,false)    
            --     end 
            -- end
            self:SetItemIconSprite(self.img_item_icon1, shopData.item[1][1])
            self:SetItemIconSprite(self.img_item_icon2, shopData.item[2][1])

            self:CheckHaveGiftPackage(shopData)
			self:SetBundledIcon(shopData.bundled_item)

            self:SetItemPromotionInfo(shopData)
        end
    end
end

function ShopNormalChildItemcRuledi4:on_btn_item_rule_click()
    self._fsm:GetCurState():ShopItemClick(self._fsm)
end


function ShopNormalChildItemcRuledi4:SetItemIconSprite(icon, id)
    if not icon or not id then
        return
    end

    local resData = Csv.GetData("resources", id)
    if resData then
        icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas",resData.icon)
    else
    
        local ItemData = Csv.GetData("item", id)
        if ItemData then 
            icon = AtlasManager:GetSpriteByName("ItemAtlas",ItemData.icon)
        else 
            fun.set_active(icon, false)
        end
    end
end

function ShopNormalChildItemcRuledi4:SetItemPromotionInfo(data)
    if not data then
        return
    end

    if ModelList.MainShopModel:IsPromotionValid() and self:IsInPromotion(data) then
        fun.set_active(self.text_bonus_panel1, true)
        fun.set_active(self.text_bonus_panel2, true)
        fun.set_active(self.tag_time_limit, true)
        fun.set_active(self.text_item_value1, false)
        fun.set_active(self.text_item_value2, false)

        if data.description_sale then
            self.text_des.text = data.description_sale
        end

        if self.text_bonus11 then
            self.text_bonus11:SetValue(tonumber(data.item_description[1][2]))
        end

        if self.text_bonus12 then
            self.text_bonus12:SetValue(tonumber(data.item_description_sale[1][2]))
        end

        if self.text_bonus21 then
            self.text_bonus21:SetValue(tonumber(data.item_description[2][2]))
        end

        if self.text_bonus22 then
            self.text_bonus22:SetValue(tonumber(data.item_description_sale[2][2]))
        end

        self:SetItemIconSprite(self.img_item_icon11, data.item[1][1])
        self:SetItemIconSprite(self.img_item_icon22, data.item[2][1])

        if self.text_times1 then
            local total_times = data.frequency_sale or 0
            local remain_times = self._shopItem and self._shopItem.promoBuyCount or 0
            self.text_times1.text = remain_times .. "/" .. total_times
        end
    else
        fun.set_active(self.text_bonus_panel1, false)
        fun.set_active(self.text_bonus_panel2, false)
        fun.set_active(self.tag_time_limit, false)
        fun.set_active(self.text_item_value1, true)
        fun.set_active(self.text_item_value2, true)
    end
end

return this