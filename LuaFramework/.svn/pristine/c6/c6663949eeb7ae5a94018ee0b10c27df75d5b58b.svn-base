local HallofFameGoldRankItem = require "View/HallofFame/HallofFameGoldRankItem"
local HallofFameGoldMyRankItem = HallofFameGoldRankItem:New()
local this = HallofFameGoldMyRankItem

local reward_item = nil

this.auto_bind_ui_items = {
    "img_head",
    "text_thValue",
    "text_thSign",
    "text_userName",
    "text_rewards",
    "content",
    "reward_item",
    "btn_item",
    "imageFrame",
    "rankNormal",
    "rankTop2",
    "rankTop3",
    "rankTop45",
}

function HallofFameGoldMyRankItem:Awake()
    self:on_init()
end

function HallofFameGoldMyRankItem:OnDispose()
    reward_item = nil
end

function HallofFameGoldMyRankItem:IsMyRank()
    return true
end

function HallofFameGoldMyRankItem:RequestPlayerTournamentInfo()
    --点击自己不弹出玩家信息
end

function HallofFameGoldMyRankItem:GetHeadIcon()
    return fun.get_strNoEmpty(ModelList.PlayerInfoModel:GetHeadIcon(), "xxl_head016")
end

function HallofFameGoldMyRankItem:SetRewardItem(tiers,difficulty,order)
    local view = require("View/CommonView/CollectRewardsItem")
    if not tiers or not difficulty  then
        tiers,difficulty = ModelList.HallofFameModel:GetTiers()
    end
    if not order then
        order = self._data.order
    end
    if reward_item == nil then
        reward_item = {}
    end

    if self._data and self._data.reward then
        local itemIndex = 0
        for key, value2 in pairs(self._data.reward) do
            itemIndex = itemIndex + 1
            if reward_item[itemIndex] then
                reward_item[itemIndex]:SetReward(value2)
                fun.set_active(reward_item[itemIndex].go.transform,true)
            else
                local go = fun.get_instance(self.reward_item,self.content)
                local item = view:New()
                item:SetReward(value2)
                item:SkipLoadShow(go)
                fun.set_active(go.transform,true)
                table.insert(reward_item,item)
            end
        end
        if itemIndex < #reward_item then
            for i = itemIndex + 1, #reward_item do
                reward_item[i]:Close()
                reward_item[i] = nil
            end
        end
    end
end

function HallofFameGoldMyRankItem:GetBuffPosParams()
    local params = {}
    if self.parent.viewName == "TournamentBlackGoldView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    elseif self.parent.viewName == "TournamentBlackGoldSettleView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    end
    return params
end

return this