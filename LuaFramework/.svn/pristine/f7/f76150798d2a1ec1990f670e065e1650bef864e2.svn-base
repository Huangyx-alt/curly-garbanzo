
local TournamentRankNextReward = BaseView:New("TournamentRankNextReward")
local this = TournamentRankNextReward
this.viewType = CanvasSortingOrderManager.LayerType.None

local nextRewardList = {}
local nextRewardObjList  = {}
this.auto_bind_ui_items ={
    "NextRewards",
    "CommonItem",
    "Content",
    "textNextStage",
    "btn_OepnBaseReward",
    "canvasgroup",
}

function TournamentRankNextReward:New(showTiers)
    local o = {}
    self.__index = self
    self.showTiers = showTiers
    setmetatable(o,self)
    return o
end

function TournamentRankNextReward:Awake()
    self:on_init()
end

function TournamentRankNextReward:OnEnable()
    self:InitRewardList()
    self:ShowInfo()
end

function TournamentRankNextReward:OnDisable()
    self:OnDispose()
end

function TournamentRankNextReward:OnDestroy()
    nextRewardObjList = {}
    nextRewardList = {}
    self.showTiers = nil
    self.hasInitData = false
    self.openAutoCloseView = false
end

function TournamentRankNextReward:ShowInfo()
    if self.hasInitData == true then
        return
    end
    self.hasInitData = true
    local model = ModelList.TournamentModel
    local nextReward = self:GetRankNextReward()
    
    if nextReward then
        local view = require("View/CommonView/CollectRewardsItem")
        for k ,v in pairs(nextReward) do
            local go = fun.get_instance(self.CommonItem,self.Content)
            table.insert(nextRewardObjList , go)
            local item = view:New()
            item:SkipLoadShow(go)
            item:SetReward(v)
            fun.set_active(go.transform,true)
        end
    end

    local tip = Csv.GetDescription(1304)
    self.textNextStage.text = string.format(tip," <color=#FEEDA7>" , "</color><color=#1CFF4F>" ,"</color> " )
end

function TournamentRankNextReward:OnDispose()

end

function TournamentRankNextReward:on_btn_item_click()
    self:RequestPlayerTournamentInfo()
end


function TournamentRankNextReward:on_btn_OepnBaseReward_click()
    self.openAutoCloseView = true
    Event.Brocast(NotifyName.Tournament.RankClickNextRewardBtn)
end

function TournamentRankNextReward:AnimOpenView()
    if self:CheckHasOpen() then
        -- 避免重复缩放动画
        return
    end
    self.canvasgroup.alpha = 1
    fun.set_gameobject_scale(self.go,0,1,1)
    Anim.scale_to_x(self.go,1, 0.25)
end

function TournamentRankNextReward:AnimCloseView()
    Anim.scale_to_xy(self.go,0, 1, 0.25,  function()
        self.canvasgroup.alpha = 0
    end)
end

function TournamentRankNextReward:FirstAnimCloseView()
    if self.openAutoCloseView then
        log.log("已经自动关闭了")
        return
    end
    self.openAutoCloseView = true
    Anim.scale_to_xy(self.go,0, 1, 0.25,  function()
        self.canvasgroup.alpha = 0
    end)
end

function TournamentRankNextReward:InitRewardList()
    local tiers,difficulty = ModelList.TournamentModel:GetTiers()
    local csvData = ModelList.TournamentModel.GetTournamentCsvData()
    for index, value in ipairs(csvData) do
        if value.difficulty == difficulty and 
        value.ranking_section == 2 then
            table.insert(nextRewardList,value.next_reward)
        end
    end
end

function TournamentRankNextReward:GetRankNextReward()
    local useTiers = nil
    if self.showTiers then
        useTiers = self.showTiers
    else
        useTiers = ModelList.TournamentModel:GetTiers()
    end
    return self:GetNextRewardByTiers(useTiers)
end

function TournamentRankNextReward:GetNextRewardByTiers(tiers)
    if tiers and nextRewardList[tiers] then
        return nextRewardList[tiers]
    end
    return {}
end

function TournamentRankNextReward:RefreshTiers(tiers)
    self.showTiers = tiers
    local nextReward = self:GetRankNextReward()
    for k ,v in pairs(nextRewardObjList) do
        if v then
            fun.set_active(v, false)
        end
    end
    nextRewardObjList = {}
    self.hasInitData = false
    self:ShowInfo()
end

function TournamentRankNextReward:CheckHasOpen()
    if self.go and self.go.transform.localScale.x >= 1 then
        return true
    end
    return false
end



return this