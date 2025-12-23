require "State/Common/CommonState"
require "View/CommonView/RemainTimeCountDown"

local TournamentView = BaseView:New("TournamentView","TournamentAtlas")
local this = TournamentView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local TournamentRankItem = require "View/Tournament/TournamentRankItem"
local TournamentMyRankItem = require "View/Tournament/TournamentMyRankItem"
local remainTimeCountDown = RemainTimeCountDown:New()

local rankItemList = nil

local nextTrophyView = nil
local nextRewardView = nil


this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "reward_content",
    "reward_item",
    "rank_content",
    "slider_tournament",
    "text_countdown",
    "text_awards",
    "text_TopPercent",
    "text_thValue",
    "text_thSign",
    "text_refresh",
    "anima",
    "img_trophy",
    "section1",
    "section2",
    "nextTrophy",
    "nextRewards",
    "ZBTiaomuDi",
    "btn_OepnNextReward",
    "TournamentSprintBuffFlag",
}

function TournamentView:Awake(obj)
    self:on_init()
end

function TournamentView:OnEnable(params)

    ModelList.TournamentModel:GetTotalTournamentTrophy()
    Facade.RegisterView(self)
    self:AddTopAreaEvent()
    self:CheckShowTopArea()
    CommonState.BuildFsm(self,"TournamentView")

    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"in","TournamentRewardViewenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    self.OnResphoneRankInfo()

    remainTimeCountDown:StartCountDown(CountDownType.cdt1,
        ModelList.TournamentModel:GetRemainTime(),
        self.text_countdown,
    function()

    end)
end


function TournamentView:OnDisable()
    self:StopDelayAutonReward()
    self:RemoveTopAreaEvent()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
    rankItemList = nil
    nextRewardView = nil
    nextTrophyView = nil
    remainTimeCountDown:StopCountDown()
end

function TournamentView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"out","TournamentRewardViewexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function TournamentView:on_btn_help_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentHelperView)
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
    end)
end

function TournamentView.OnResphoneRankInfo()
    if rankItemList == nil then
        rankItemList = {}
        for i = 0 , 4 do
            local go = fun.get_child(this.rank_content,i)
            if go then
                if i == 2 then
                    local view = TournamentMyRankItem:New(false)
                    view:SetParent(this)
                    view:SkipLoadShow(go.gameObject)
                    -- table.insert(rankItemList,view)
                    rankItemList[3] = view
                else
                    local view = TournamentRankItem:New(false)
                    view:SetParent(this)
                    view:SkipLoadShow(go.gameObject)
                    -- table.insert(rankItemList,view)
                    rankItemList[i + 1] = view
                end
            end
        end
    end
    local rankInfoList = ModelList.TournamentModel:GetRankInfoPlayerList()
    if rankInfoList then
        local myUid = ModelList.PlayerInfoModel:GetUid()
        local indexs = {1,2,4,5}
        local curIndex = 1
        local layerIndex = 0
        local totalNum = 5
        for key, value in pairs(rankInfoList) do
            if totalNum > 0 then
                if myUid == value.uid then
                    
                    rankItemList[3]:SetRankData(value)
                    rankItemList[3]:SetLayerIndex(layerIndex)
                else
                    local useIndex = indexs[curIndex]
                   
                    rankItemList[useIndex]:SetRankData(value)
                    rankItemList[useIndex]:SetLayerIndex(layerIndex)
                    curIndex = curIndex + 1
                end
                layerIndex = layerIndex + 1
            end
            totalNum = totalNum - 1
        end
    end

    local useSection = ModelList.TournamentModel:GetUseSection()
    this.text_thValue.text = useSection * 0.1

    local view = require("View/CommonView/CollectRewardsItem")
    local tiers,difficulty = ModelList.TournamentModel:GetTiers()
    local csvData = ModelList.TournamentModel.GetTournamentCsvData()
    for index, value in ipairs(csvData) do
        if tiers == value.tiers_id and 
        difficulty == value.difficulty and 
        6 == value.ranking[1] then
            -- log.log("周榜优化 查找数据 排行奖励" , value)
            for index, value2 in ipairs(value.reward) do
                local go = fun.get_instance(this.reward_item,this.reward_content)
                local item = view:New()
                item:SetReward(value2)
                item:SkipLoadShow(go)
                fun.set_active(go.transform,true)
            end
            break
        end
    end

    local trophyName = fun.GetCurrTournamentActivityImg(tiers)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            this.img_trophy.sprite = sprite
        end
    end)

    local section = ModelList.TournamentModel:GetSection()
    if section then
        this.section1.sizeDelta = Vector2.New(20,(section[2] / section[3]) * 726)
        this.section2.sizeDelta = Vector2.New(20,(section[1] / section[3]) * 726)
    end
    this.slider_tournament.value =  1 - (rankItemList[3]:GetOrder() - 1) / section[3]
end

function TournamentView.OnResphonePlayerInfo()
    if ModelList.TournamentModel:GetPlayerInfo() then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentTrophyView)
    end
end

function TournamentView:OpenNextRankTrophyView()
    if nextTrophyView ~= nil then
        return
    end
    local model = ModelList.TournamentModel

    local nextScore = model:GetRankNextTiersNeedScore()
    if not nextScore or nextScore <= 0 then
        log.log("周榜兼容旧版 不展示下阶段")
        return
    end
    if model:CheckIsMaxTrophy() then
        --满级不展示奖杯
        return
    end
    local isFirst = model:GetRankIsFirst()
    local TournamentRankNextTrophy = require "View/Tournament/TournamentRankNextTrophy"
    nextTrophyView = TournamentRankNextTrophy:New()
    nextTrophyView:SkipLoadShow(self.nextTrophy.gameObject)
end

function TournamentView:OpenNextRankRewardView()
    if nextRewardView ~= nil then
        return
    end

    local model = ModelList.TournamentModel
    if not model:CheckHasNextReward() then
        return
    end
    
    local isFirst = model:GetRankIsFirst()
    local TournamentRankNextReward = require "View/Tournament/TournamentRankNextReward"
    nextRewardView = TournamentRankNextReward:New()
    nextRewardView:SkipLoadShow(self.nextRewards.gameObject)
end


function TournamentView:RankClickNextRewardBtn()
    self:StopDelayAutonReward()
    self:AnimCloeNextReward()
end

function TournamentView:ShowResultToCloseRankView()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function TournamentView:AddTopAreaEvent()
    Event.AddListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)
    Event.AddListener(NotifyName.Tournament.ShowResultToCloseRankView,self.ShowResultToCloseRankView,self)

end

function TournamentView:RemoveTopAreaEvent()
    Event.RemoveListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)
    Event.RemoveListener(NotifyName.Tournament.ShowResultToCloseRankView,self.ShowResultToCloseRankView,self)
end

function TournamentView:on_btn_OepnNextReward_click()
   self:AnimOpenNextReward()
end

function TournamentView:AnimOpenNextReward()
    if ModelList.TournamentModel:CheckIsMaxTrophy() then
        log.log("周榜等级已经最高")
        return
    end
    self:OpenNextRankRewardView()
    if nextRewardView then
        nextRewardView:AnimOpenView()
    end
end

function TournamentView:AnimCloeNextReward()
    if nextRewardView then
        nextRewardView:AnimCloseView()
    end
end

function TournamentView:FirstAnimCloseView()
    if nextRewardView then
        nextRewardView:FirstAnimCloseView()
    end
end

function TournamentView:AnimOpenNextTrophy()
    self:OpenNextRankTrophyView()
    if nextTrophyView then
        nextTrophyView:AnimOpenView()
    end
end

function TournamentView:AnimCloeNextTrophy()
    if nextTrophyView then
        nextTrophyView:AnimCloseView()
    end
end

function TournamentView:OepnNextTrophy()
    self:AnimOpenNextTrophy()
end


function TournamentView:CheckShowTopArea()
    local model = ModelList.TournamentModel
    if model:CheckIsMaxTrophy() then
        --最高段位
        return
    end

    local isFirst = model:GetRankIsFirst()
    if isFirst then
        self:OpenNextRankTrophyView()
    else
        self.autoDelayReward = LuaTimer:SetDelayFunction(1, function()
            self:AnimOpenNextReward()
        end)

        self.autoDelayReward2 = LuaTimer:SetDelayFunction(3, function()
            self:AnimCloeNextReward()
            self:StopDelayAutonReward()
        end)
    end
end

function TournamentView:StopDelayAutonReward()
    if self.autoDelayReward then
        LuaTimer:Remove(self.autoDelayReward)
        self.autoDelayReward = nil
    end
    if self.autoDelayReward2 then
        LuaTimer:Remove(self.autoDelayReward2)
        self.autoDelayReward2 = nil
    end
end

function TournamentView.StopDelayAutonTrophy()
    if self.autoDelayTrophy then
        LuaTimer:Remove(self.autoDelayTrophy)
        self.autoDelayTrophy = nil
    end
end


this.NotifyList = {
    {notifyName = NotifyName.Tournament.ResphoneRankInfo,func = this.OnResphoneRankInfo},
    {notifyName = NotifyName.Tournament.ResphonePlayerInfo,func = this.OnResphonePlayerInfo}
}

return this