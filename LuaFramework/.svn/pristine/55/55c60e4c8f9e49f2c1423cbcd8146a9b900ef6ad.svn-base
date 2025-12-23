local SeasonCardGalleryItem = require "View/SeasonCard/SeasonCardGalleryItem"
local SeasonCardGalleryPageView = BaseView:New("SeasonCardGalleryPageView")
local this = SeasonCardGalleryPageView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Content",
    "CardItem",
}

local ReFreshStrategy = {
    {1, 4, 7},
    {2, 5, 8},
    {3, 6, 9},
}

function SeasonCardGalleryPageView:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardGalleryPageView:Awake()
end

function SeasonCardGalleryPageView:OnEnable()
    self.itemList = {}
end

function SeasonCardGalleryPageView:OnDisable()
    self.itemList = nil
end

function SeasonCardGalleryPageView:on_after_bind_ref()
    fun.set_active(self.CardItem, false)
    self:InitPageView()
end

function SeasonCardGalleryPageView:SetData(data)
    self.data = data
    self.seasonId = data and data.seasonId
end

function SeasonCardGalleryPageView:InitPageView()
    fun.clear_all_child(self.Content)
    if not self.data then
        return
    end
    for index, id in ipairs(self.data.cardIds) do
        local item = self:CreateGalleryItem(index, id)
        table.insert(self.itemList, item)
    end
end

function SeasonCardGalleryPageView:CreateGalleryItem(cardIndex, cardId)
    local itemGo = fun.get_instance(self.CardItem)
    local data = {index = cardIndex, parent = self, cardId = cardId, seasonId = self.seasonId}
    local item = SeasonCardGalleryItem:New()
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(true)
    fun.set_parent(itemGo, self.Content, true)
    fun.set_active(itemGo, true)
    return item
end

function SeasonCardGalleryPageView:RefreshItems()
    for i, v in ipairs(self.itemList) do
        v:ReadyRefresh()
    end

    for i1, v1 in ipairs(ReFreshStrategy) do
        for i2, v2 in ipairs(v1) do
            self:register_invoke(function()
                if self.itemList[v2] then
                    self.itemList[v2]:StartRefresh()
                end
            end, (i1 - 1) * 0.1)
        end
    end
end

return this