local TournamentRankItem = require "View/Tournament/TournamentRankItem"
local TournamentMyRankItem = TournamentRankItem:New()
local this = TournamentMyRankItem

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
}

function TournamentMyRankItem:Awake()
    self:on_init()
end

function TournamentMyRankItem:OnDispose()
    reward_item = nil
end

function TournamentMyRankItem:IsMyRank()
    return true
end

function TournamentMyRankItem:RequestPlayerTournamentInfo()
    --点击自己不弹出玩家信息
end

function TournamentMyRankItem:GetHeadIcon()
    return fun.get_strNoEmpty(ModelList.PlayerInfoModel:GetHeadIcon(), "xxl_head016")
end

function TournamentMyRankItem:SetRewardItem(tiers,difficulty,order)
    local view = require("View/CommonView/CollectRewardsItem")
    if not tiers or not difficulty  then
        tiers,difficulty = ModelList.TournamentModel:GetTiers()
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
                fun.set_active(reward_item[itemIndex].go,true)
            else
                local go = fun.get_instance(self.reward_item,self.content)
                local item = view:New()
                item:SetReward(value2)
                item:SkipLoadShow(go)
                fun.set_active(go,true)
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

function TournamentMyRankItem:GetBuffPosParams()
    local params = {}
    if self.parent.viewName == "TournamentView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    elseif self.parent.viewName == "TournamentSettleView" then
        params.buffX = 20
        params.buffY = 20
        params.bubbleX = 0
        params.bubbleY = 90
        params.arrowOffset = 0
    end
    return params
end

return this