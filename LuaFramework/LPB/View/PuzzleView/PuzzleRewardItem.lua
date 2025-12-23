

local PuzzleRewardItem = BaseView:New("PuzzleRewardItem")
local this = PuzzleRewardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num"
}

function PuzzleRewardItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function PuzzleRewardItem:Awake()
    self:on_init()
end

function PuzzleRewardItem:OnEnable()
    self._init = true
    if self.cacheData then
        self:SetReward(self.cacheData)
    end
end

function PuzzleRewardItem:OnDisable()
    self:Close()
    self._init = nil
    self.cacheData = nil
end

function PuzzleRewardItem:OnDestroy()

end

function PuzzleRewardItem:on_close()

end

function PuzzleRewardItem:SetReward(data)
    self.cacheData = data
    if self._init then
        if data.id then
            local icon = Csv.GetData("resources",data.id,"icon")
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            self.text_num.text = tostring(data.value)
        else
            local icon = Csv.GetData("resources",data[1],"icon")
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            self.text_num.text = tostring(data[2])
        end
        
    end
end

return this