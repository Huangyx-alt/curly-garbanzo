
local TournamentHelperItem = require "View/Tournament/TournamentHelperItem"

require "State/Common/CommonState"

local TournamentHelperView = BaseView:New("TournamentRewardView","TournamentAtlas")
local this = TournamentHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
-- local keys={id=1,tiers_id=2,difficulty=3,tiers_range=4,ranking_section=5,ranking=6,reward=7,next_reward=8,rank_point=9,rank_times=10,rank_random=11,rank_begin=12,rank_begin_reduce=13,frame_icon=14,daily_reward=15}
local keys = {id=1,tiers_id=2,difficulty=3,tiers_range=4,ranking_section=5,ranking=6,reward=7,next_reward=8,reward_gold=9,next_reward_gold=10,rank_point=11,rank_times=12,rank_random=13,rank_percent=14,rank_begin=15,rank_begin_reduce=16,frame_icon=17,daily_reward=18}

local keyTable = {}

this.auto_bind_ui_items = {
    "btn_close",
    "content",
    "item",
    "anima"
}

function TournamentHelperView:Awake(obj)
    self:on_init()
end

function TournamentHelperView:OnEnable()
    self:SetKey()
    Facade.RegisterView(self)
    CommonState.BuildFsm(self,"TournamentHelperView")

    self:SetTrounamentReward()

    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"in","TournamentRewardViewenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
end

function TournamentHelperView:OnDisable()
    keyTable = {}
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function TournamentHelperView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"out","TournamentRewardViewexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function TournamentHelperView:CheckRanking(rankingList)
    if rankingList and rankingList[1] and rankingList[1] == 1 and not rankingList[2] then
        return true
    end
    return false
end

function TournamentHelperView:SetTrounamentReward()
    local itemTitle = Csv.GetDescription(1306)
    local rewardItemList = {}
    local tiers,difficulty = ModelList.TournamentModel:GetTiers()
    local csvData = ModelList.TournamentModel.GetTournamentCsvData()
    for index, value in ipairs(csvData) do
        if value.difficulty == difficulty and value.ranking_section == 1 and self:CheckRanking(value.ranking) then
            local itemList = {}
            for k, v in pairs(value) do
                local targetKey = self:GetKey(k)
                itemList[targetKey] = DeepCopy(v)
            end
            if itemList.daily_reward then
                table.insert(itemList.reward , 
                {
                    [1] = Resource.dailycoins_bonus,
                    [2] = itemList.daily_reward
                }
            )
            end
            itemList.title = itemTitle 
            table.insert(rewardItemList,itemList)
        end
    end
    for i = #rewardItemList, 1,-1 do
        local go = fun.get_instance(self.item,self.content)
        local item = TournamentHelperItem:New(rewardItemList[i])
        item:SkipLoadShow(go)
        fun.set_active(go.transform,true)
    end
end

function TournamentHelperView:SetKey()
    keyTable = {}
    for k ,v in pairs(keys) do
        keyTable[v] = k
    end
end

function TournamentHelperView:GetKey(id)
    return keyTable[id] or nil
end

this.NotifyList = 
{

}

return this