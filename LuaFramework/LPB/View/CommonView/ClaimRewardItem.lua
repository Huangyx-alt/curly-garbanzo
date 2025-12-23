
local ClaimRewardItem = BaseView:New("ClaimRewardItem")
local this = ClaimRewardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num"
}

function ClaimRewardItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClaimRewardItem:Awake()
    self:on_init()
end

function ClaimRewardItem:OnEnable()
    self._init = true
    if self.cacheData then
        self:SetReward(self.cacheData)
    end
end

function ClaimRewardItem:OnDisable()
    self._init = nil
    self.cacheData = nil
end

function ClaimRewardItem:SetReward(data)
    self.cacheData = data
    if self._init then
        local icon = Csv.GetData("resources",data.id or data[1],"icon")
        Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
        self.text_num.text = tostring(data.value or data[2])
    end
end

return this