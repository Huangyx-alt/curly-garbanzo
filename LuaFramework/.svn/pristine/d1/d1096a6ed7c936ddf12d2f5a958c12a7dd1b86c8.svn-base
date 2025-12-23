local CompetitionRankItem = require "View/DailyCompetition/CompetitionRankItem"
local CompetitionMyRankItem = CompetitionRankItem:New()
local this = CompetitionMyRankItem

local reward_item = nil

this.auto_bind_ui_items = {
    "img_head",
    "text_thValue",
    "text_userName",
    "text_rewards",
    "btn_item",
    "TopRank1",
    "TopRank2",
    "TopRank3",
    "RewardType",
    "DoubleGift",
    "DoubleCollect",
    "imageFrame",
}

function CompetitionMyRankItem:Awake()
    self:on_init()
end

function CompetitionMyRankItem:OnDispose()
    reward_item = nil
end

function CompetitionMyRankItem:IsMyRank()
    return true
end

function CompetitionMyRankItem:RequestPlayerTournamentInfo()
    --点击自己不弹出玩家信息
end

function CompetitionMyRankItem:GetHeadIcon()
    return fun.get_strNoEmpty(ModelList.PlayerInfoModel:GetHeadIcon(), "xxl_head016")
end

function CompetitionMyRankItem:SetRewardItem(tiers,difficulty,order)
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
    --for index, value in ipairs(Csv.weekly_list) do
    --    if tiers == value.tiers_id and
    --            difficulty == value.difficulty and
    --            (order == value.ranking[1] or
    --                    (order >= value.ranking[1] and
    --                            order <= (value.ranking[2] or 0))) then
    --        local itemIndex = 0
    --        for key, value2 in pairs(value.reward) do
    --            itemIndex = itemIndex + 1
    --            if reward_item[itemIndex] then
    --                reward_item[itemIndex]:SetReward(value2)
    --                fun.set_active(reward_item[itemIndex].go.transform,true)
    --            else
    --                local go = fun.get_instance(self.reward_item,self.content)
    --                local item = view:New()
    --                item:SetReward(value2)
    --                item:SkipLoadShow(go)
    --                fun.set_active(go.transform,true)
    --                table.insert(reward_item,item)
    --            end
    --        end
    --        if itemIndex < #reward_item then
    --            for i = itemIndex + 1, #reward_item do
    --                reward_item[i]:Close()
    --                reward_item[i] = nil
    --            end
    --        end
    --        break
    --    end
    --end
end

return this