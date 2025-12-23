
local PowerupHelperItem = BaseView:New("PowerupHelperItem")
local this = PowerupHelperItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_icon",
    "img_quality",
    "text_name",
    "text_describe"
}

function PowerupHelperItem:New(cardId)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._cardId = cardId
    return o
end

function PowerupHelperItem:Awake()
    self:on_init()
end

function PowerupHelperItem:OnEnable()
    if self._cardId then
        local powerCard = Csv.GetData("new_powerup",self._cardId)
        if powerCard then
            self.img_icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas",powerCard.icon)
            self.text_name.text = powerCard.name
            self.text_describe.text = Csv.GetData("description",powerCard.description,"description")
            if powerCard.level == 1 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pGood")
            elseif powerCard.level == 2 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pGreat")
            elseif powerCard.level == 3 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pEpic") 
            elseif powerCard.level == 6 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas", "pLegend")
                ---[[
                local buffRemainTime = ModelList.CityModel:GetPuBuffRemainTime()
                self:register_invoke(function()
                    fun.set_active(self.go, false)
                end, buffRemainTime)
                --]]
            end
        end
    end
end

function PowerupHelperItem:OnDisable()

end

function PowerupHelperItem:on_close()
    self._cardId = nil
end

function PowerupHelperItem:OnDestroy()
    self:Close()
end

return this