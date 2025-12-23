
ExtraRewardView = BaseView:New("ExtraRewardView")
local this = ExtraRewardView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon",
    "value"
}

function ExtraRewardView:New(data)
    local o = {}
    self.__index = self
    o._data = data
    setmetatable(o,self)
    return o
end

function ExtraRewardView:Awake()
    self:on_init()
end

function ExtraRewardView:OnEnable()
    if self._data then
        self.value.text = tostring(self._data.value)
        local icon = Csv.GetItemOrResource(self._data.id)
        Cache.SetImageSprite("ItemAtlas",icon.icon,self.icon)
    end
end

function ExtraRewardView:OnDisable()
end