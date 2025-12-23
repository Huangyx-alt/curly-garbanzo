local SeasonCardGroupItem = require "View/SeasonCard/SeasonCardGroupItem"
local SeasonCardGroupPageView = BaseView:New("SeasonCardGroupPageView")
local this = SeasonCardGroupPageView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "Separator1",
    "Separator2",
    "Separator3",
    "Content",
    "GroupItem",
}

function SeasonCardGroupPageView:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardGroupPageView:Awake()
end

function SeasonCardGroupPageView:OnEnable()
    Facade.RegisterView(self)
end

function SeasonCardGroupPageView:on_after_bind_ref()
    fun.set_active(self.Separator1, false)
    fun.set_active(self.Separator2, false)
    fun.set_active(self.Separator3, false)
    fun.set_active(self.GroupItem, false)
     self:InitPageView()
end

function SeasonCardGroupPageView:SetData(data)
    self.data = data
    self.seasonId = data and data.seasonId
end

function SeasonCardGroupPageView:InitPageView()
    fun.clear_all_child(self.Content)
    if not self.data then
        return
    end
    for index, id in ipairs(self.data.groupIds) do
        local groupItem = self:CreateGroupItem(index, id)
    end
end

function SeasonCardGroupPageView:CreateGroupItem(groupIndex, groupId)
    local itemGo = fun.get_instance(self.GroupItem)
    local data = {index = groupIndex, parent = self, groupId = groupId, seasonId = self.seasonId}
    local item = SeasonCardGroupItem:New()
    item:SetData(data)
    item:SkipLoadShow(itemGo)
    item:SetClickEnable(true)
    fun.set_parent(itemGo, self.Content, true)
    fun.set_active(itemGo, true)
    return item
end

return this