--WinZone专用

local ShopNormalChildItemcRuledi7 = ShopChildItemBaseView:New()
local this = ShopNormalChildItemcRuledi7
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "item_text_cost",
    "btn_item_rule",
    "text_des",
    "title_image",
    "img_mask",
    "text_countdown",
    "musicIcon"
}

function ShopNormalChildItemcRuledi7:New(shopItem)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem = shopItem
    return o
end

function ShopNormalChildItemcRuledi7:Awake()
    self:on_init()
end

function ShopNormalChildItemcRuledi7:OnEnable()
    self:RegisterEvent()
    self:BuildFsm("ShopNormalChildItemcRuledi7")
    self:CheckState()
    self:RegisterViewEnhance()
end

function ShopNormalChildItemcRuledi7:OnDisable()
    self:RemoveEvent()
    self:DisposeFsm()
    self:StopTimer()
    self:RemoveViewEnhance()
end

function ShopNormalChildItemcRuledi7:on_close()

end

function ShopNormalChildItemcRuledi7:OnDestroy()
    self._shopItem = nil
end

function ShopNormalChildItemcRuledi7:SetAvailable()
    fun.set_active(self.img_mask,false)
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi7:SetDisable()
    fun.set_active(self.img_mask,true)
    self.text_countdown.text = ""
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi7:SetCountdDown()
    fun.set_active(self.img_mask,true)
    self:StartTimer()
    self:SetShopItemInfo()
end

function ShopNormalChildItemcRuledi7:SetShopItemInfo()
    if self._shopItem then
        local shopData = Csv.GetData("shop",self._shopItem.id,nil)
        if shopData then
             fun.set_active(self.item_tips,shopData.bonus ~= 0)
            self.item_text_cost.text = shopData.price
            if shopData.description then
                self.text_des.text = shopData.description
            end
            self.title_image.sprite = AtlasManager:GetSpriteByName("ShopAtlas",shopData.itemicon)
			self:SetBundledIcon(shopData.bundled_item);
        end
    end
end

function ShopNormalChildItemcRuledi7:item_rule_click_callBack()
    --self._fsm:GetCurState():ShopItemClick(self._fsm)
    if self and self._shopItem then
        ModelList.MainShopModel.C2S_VICTORY_BEATS_NOTE_EXCHANGE(self._shopItem.id)
    end
end

function ShopNormalChildItemcRuledi7:on_btn_item_rule_click()
    --self._fsm:GetCurState():ShopItemClick(self._fsm)
    self.winzoneConfirmView = require("View/WinZone/WinZoneExchangeConfirmView"):New()
    if self.winzoneConfirmView then
        self.winzoneConfirmView:SetConfirmCallback(self)
        Facade.SendNotification(NotifyName.ShowUI,self.winzoneConfirmView:New(),nil,nil,self._shopItem.id)
    end

end

function ShopNormalChildItemcRuledi7:OnConfirmPurchase()
    self._fsm:GetCurState():ShopItemClick(self._fsm)
end

return this



