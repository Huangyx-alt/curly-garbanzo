require "State/Common/CommonState"
require "View/CommonView/RemainTimeCountDown"

local TournamentBlackGoldView = BaseView:New("TournamentBlackGoldView","TournamentAtlas")
local this = TournamentBlackGoldView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local TournamentRankItem = require "View/Tournament/TournamentBlackGoldRankItem"
local TournamentMyRankItem = require "View/Tournament/TournamentBlackGoldMyRankItem"
local TournamentShowTopOneView = require "View/Tournament/TournamentShowTopOneView"
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
    "tournamentBlackGold",
    "btn_topOne",
    "Tournament_itemOther",
    "Tournament_itemMy",
    "TournamentSprintBuffFlag",
}

function TournamentBlackGoldView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldView:OnEnable(params)

    ModelList.TournamentModel:GetTotalTournamentTrophy()
    Facade.RegisterView(self)
    self:AddTopAreaEvent()
    self:CheckShowTopArea()
    CommonState.BuildFsm(self,"TournamentBlackGoldView")

    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"in","TournamentRewardViewenter"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    self.OnResphoneRankInfo()
    self:ShowTopOnePlayer()
    remainTimeCountDown:StartCountDown(CountDownType.cdt1,
        ModelList.TournamentModel:GetRemainTime(),
        self.text_countdown,
    function()

    end)
end


function TournamentBlackGoldView:OnDisable()
    self:StopDelayAutonReward()
    self:RemoveTopAreaEvent()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
    rankItemList = nil
    nextRewardView = nil
    nextTrophyView = nil
    remainTimeCountDown:StopCountDown()
end

function TournamentBlackGoldView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"out","TournamentRewardViewexit"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end)
end

function TournamentBlackGoldView:on_btn_help_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentBlackGoldHelperView)
        self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
    end)
end

function TournamentBlackGoldView.OnResphoneRankInfo()
    if rankItemList == nil then
        rankItemList = {}
    end
    local isBlackTier = ModelList.TournamentModel:CheckIsBlackTire()

    local rankInfoList = ModelList.TournamentModel:GetRankInfoPlayerList()
    if rankInfoList then
        local myUid = ModelList.PlayerInfoModel:GetUid()
        local curIndex = 1
        local layerIndex = 0
        local totalNum = 5
        for i = 1 , 5 do
            local playerData = rankInfoList[i]
            if playerData.uid == myUid then
                local go = fun.get_instance(this.Tournament_itemMy,this.rank_content)
                local view = TournamentMyRankItem:New(false)
                view:SetParent(this)
                view:SkipLoadShow(go.gameObject)
                rankItemList[i] = view
                rankItemList[i]:SetRankData(playerData,isBlackTier)
                rankItemList[i]:SetLayerIndex(layerIndex)
            else
                local go = fun.get_instance(this.Tournament_itemOther,this.rank_content)
                local view = TournamentRankItem:New(false)
                view:SetParent(this)
                view:SkipLoadShow(go.gameObject)
                rankItemList[i] = view
                rankItemList[i]:SetRankData(playerData,isBlackTier)
                rankItemList[i]:SetLayerIndex(layerIndex)
            end
            layerIndex = layerIndex + 1
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
        -- this.section1.sizeDelta = Vector2.New(20,(section[2] / section[3]) * 726)
        -- this.section2.sizeDelta = Vector2.New(20,(section[1] / section[3]) * 726)
    end
    -- this.slider_tournament.value =  1 - (rankItemList[3]:GetOrder() - 1) / section[3]
end

function TournamentBlackGoldView.OnResphonePlayerInfo()
    if ModelList.TournamentModel:GetPlayerInfo() then
        Facade.SendNotification(NotifyName.ShowUI,ViewList.TournamentTrophyView)
    end
end

function TournamentBlackGoldView:OpenNextRankTrophyView()

    if ModelList.TournamentModel:CheckIsBlackTire() then
        return
    end

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

function TournamentBlackGoldView:OpenNextRankRewardView()
    if nextRewardView ~= nil then
        return
    end

    local model = ModelList.TournamentModel
    if not model:CheckHasNextReward() then
        return
    end
    
    if model:CheckIsBlackGoldUser() and model:GetSettleClimbCurrentOrder() == 1 then
        log.log("黑金用户第一名不展示下个阶段奖励")
        return
    end

    local isFirst = model:GetRankIsFirst()
    local TournamentRankNextReward = require "View/Tournament/TournamentRankNextReward"
    nextRewardView = TournamentRankNextReward:New()
    nextRewardView:SkipLoadShow(self.nextRewards.gameObject)
end


function TournamentBlackGoldView:RankClickNextRewardBtn()
    self:StopDelayAutonReward()
    self:AnimCloeNextReward()
end

function TournamentBlackGoldView:ShowResultToCloseRankView()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function TournamentBlackGoldView:AddTopAreaEvent()
    Event.AddListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)
    Event.AddListener(NotifyName.Tournament.ShowResultToCloseRankView,self.ShowResultToCloseRankView,self)

end

function TournamentBlackGoldView:RemoveTopAreaEvent()
    Event.RemoveListener(NotifyName.Tournament.RankClickNextRewardBtn,self.RankClickNextRewardBtn,self)
    Event.RemoveListener(NotifyName.Tournament.ShowResultToCloseRankView,self.ShowResultToCloseRankView,self)
end

function TournamentBlackGoldView:on_btn_OepnNextReward_click()
   self:AnimOpenNextReward()
end

function TournamentBlackGoldView:AnimOpenNextReward()
    if ModelList.TournamentModel:CheckIsMaxTrophy() then
        log.log("周榜等级已经最高")
        return
    end
    self:OpenNextRankRewardView()
    if nextRewardView then
        nextRewardView:AnimOpenView()
    end
end

function TournamentBlackGoldView:AnimCloeNextReward()
    if nextRewardView then
        nextRewardView:AnimCloseView()
    end
end

function TournamentBlackGoldView:FirstAnimCloseView()
    if nextRewardView then
        nextRewardView:FirstAnimCloseView()
    end
end

function TournamentBlackGoldView:AnimOpenNextTrophy()
    self:OpenNextRankTrophyView()
    if nextTrophyView then
        nextTrophyView:AnimOpenView()
    end
end

function TournamentBlackGoldView:AnimCloeNextTrophy()
    if nextTrophyView then
        nextTrophyView:AnimCloseView()
    end
end

function TournamentBlackGoldView:OepnNextTrophy()
    self:AnimOpenNextTrophy()
end


function TournamentBlackGoldView:CheckShowTopArea()
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

function TournamentBlackGoldView:StopDelayAutonReward()
    if self.autoDelayReward then
        LuaTimer:Remove(self.autoDelayReward)
        self.autoDelayReward = nil
    end
    if self.autoDelayReward2 then
        LuaTimer:Remove(self.autoDelayReward2)
        self.autoDelayReward2 = nil
    end
end

function TournamentBlackGoldView.StopDelayAutonTrophy()
    if self.autoDelayTrophy then
        LuaTimer:Remove(self.autoDelayTrophy)
        self.autoDelayTrophy = nil
    end
end


function TournamentBlackGoldView:ShowTopOnePlayer()
    if ModelList.TournamentModel:CheckIsBlackTire() then
        fun.set_active(self.tournamentBlackGold, true)
        local topOneData = self:GetTopOneData()
        TournamentShowTopOneView:SetParent(self)
        TournamentShowTopOneView:OnEnable({topOneUi = self.tournamentBlackGold , topOneData = topOneData})
    else
        fun.set_active(self.tournamentBlackGold, false)
    end
end

function TournamentBlackGoldView:on_btn_topOne_click()
    self:RequestPlayerTournamentInfo()
end

function TournamentBlackGoldView:RequestPlayerTournamentInfo()
    local topOneData = self:GetTopOneData()
    if not topOneData then
        log.r("错误缺少第一名玩家数据")
        return
    end
    local myUid = ModelList.PlayerInfoModel:GetUid()
    if topOneData.uid == myUid then
        log.log("自己是第一名不处理")
        return
    end
    if topOneData then
        ModelList.TournamentModel.C2S_RequestPlayerTournamentInfo(topOneData.uid,topOneData.robot)
    end
end

function TournamentBlackGoldView:GetTopOneData()
    return ModelList.TournamentModel:GetRankInfoTopOneData()
end



this.NotifyList = {
    {notifyName = NotifyName.Tournament.ResphoneRankInfo,func = this.OnResphoneRankInfo},
    {notifyName = NotifyName.Tournament.ResphonePlayerInfo,func = this.OnResphonePlayerInfo}
}

return this