
local TrophyItem = BaseView:New("TrophyItem")
local this = TrophyItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_trophy",
    "text_trophy"
}

function TrophyItem:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._data = data
    return o
end

function TrophyItem:Awake()
    self:on_init()
end

function TrophyItem:OnEnable()
    if self._data then
        local trophyName = fun.GetCurrTournamentActivityImg(self._data.id)
        Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
            if sprite then
                self.img_trophy.sprite = sprite
            end
        end)
        self.text_trophy.text = tostring(self._data.num)
    end
end

function TrophyItem:OnDisable()
    self._data = nil
end

return this