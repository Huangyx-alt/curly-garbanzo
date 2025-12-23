local SeasonCardAlbumItem = require "View/SeasonCard/SeasonCardAlbumItem"
local SeasonCardAlbumPageView = BaseView:New("SeasonCardAlbumPageView")
local this = SeasonCardAlbumPageView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Content",
    "AlbumItem",
}

function SeasonCardAlbumPageView:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardAlbumPageView:Awake()
end

function SeasonCardAlbumPageView:OnEnable()
    Facade.RegisterView(self)
end

function SeasonCardAlbumPageView:on_after_bind_ref()
    fun.set_active(self.AlbumItem, false)
     self:InitPageView()
end

function SeasonCardAlbumPageView:SetData(data)
    self.data = data
    self.seasonIds = data and data.seasonIds
end

function SeasonCardAlbumPageView:InitPageView()
    fun.clear_all_child(self.Content)
    if not self.data then
        return
    end
    for index, id in ipairs(self.data.seasonIds) do
        local groupItem = self:CreateAlbumItem(index, id)
    end
end

function SeasonCardAlbumPageView:CreateAlbumItem(groupIndex, seasonId)
    local itemGo = fun.get_instance(self.AlbumItem)
    local data = {index = groupIndex, parent = self, seasonId = seasonId}
    local item = SeasonCardAlbumItem:New()
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(true)
    fun.set_parent(itemGo, self.Content, true)
    fun.set_active(itemGo, true)
    return item
end

return this