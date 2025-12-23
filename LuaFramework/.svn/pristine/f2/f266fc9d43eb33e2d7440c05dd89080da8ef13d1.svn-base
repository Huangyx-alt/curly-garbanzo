
local TournamentHelperItem = BaseView:New("TournamentHelperItem")
local this = TournamentHelperItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "text_rewards",
    "text_awards",
    "img_trophy",
    "content",
    "reward_item"
}

function TournamentHelperItem:New(data)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._data = data
    return o
end

function TournamentHelperItem:Awake()
    self:on_init()
end

function TournamentHelperItem:OnEnable()
    local view = require("View/CommonView/CollectRewardsItem")
    for key, value in pairs(self._data.reward) do
        local go = fun.get_instance(self.reward_item,self.content)
        local item = view:New()
        item:SetReward(value)
        item:SkipLoadShow(go)
        fun.set_active(go.transform,true)
    end

    local trophyName = fun.GetCurrTournamentActivityImg(self._data.tiers_id)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            self.img_trophy.sprite = sprite
        end
    end)
    self.text_rewards.text = fun.NumInsertComma(self._data.rank_point[2])
    self:SetTitle()
end

function TournamentHelperItem:SetTitle()
    if self._data and self._data.title then
        self.text_awards.text = self._data.title
    end
end


function TournamentHelperItem:OnDisable()
    self._data = nil
end

return TournamentHelperItem