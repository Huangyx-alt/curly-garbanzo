require "State/Common/CommonState"
require "View/CommonView/RemainTimeCountDown"

local HallofFameRankView = BaseView:New("HallofFameRankView", "TournamentAtlas")
local this = HallofFameRankView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

local HallofFameRankItem = require "View/HallofFame/HallofFameRankItem"
local HallofFameMyRankItem = require "View/HallofFame/HallofFameMyRankItem"
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
    "HallofFameBuffFlag",
}

function HallofFameRankView:Awake(obj)
    self:on_init()
end

function HallofFameRankView:OnEnable(params)

    ModelList.HallofFameModel:GetTotalTrophy()
    Facade.RegisterView(self)
    self:AddTopAreaEvent()
    self:CheckShowTopArea()
    CommonState.BuildFsm(self, "HallofFameRankView")

    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        AnimatorPlayHelper.Play(self.anima, { "in", "TournamentRewardViewenter" }, false, function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm, "CommonOriginalState")
        end)
    end)

    self.OnResphoneRankInfo()

    remainTimeCountDown:StartCountDown(CountDownType.cdt1,
            ModelList.HallofFameModel:GetRemainTime(),
            self.text_countdown,
            function()

            end)
end

function HallofFameRankView:OnDisable()
    self:StopDelayAutonReward()
    self:RemoveTopAreaEvent()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
    rankItemList = nil
    nextRewardView = nil
    nextTrophyView = nil
    remainTimeCountDown:StopCountDown()
end

function HallofFameRankView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        AnimatorPlayHelper.Play(self.anima, { "out", "TournamentRewardViewexit" }, false, function()
            Facade.SendNotification(NotifyName.CloseUI, this)
        end)
    end)
end

function HallofFameRankView:on_btn_help_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm, "CommonState1State", function()
        Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameRewardView)
        self._fsm:GetCurState():DoCommonState1Action(self._fsm, "CommonOriginalState")
    end)
end

function HallofFameRankView.OnResphoneRankInfo()
    if rankItemList == nil then
        rankItemList = {}
        for i = 0, 4 do
            local go = fun.get_child(this.rank_content, i)
            if go then
                if i == 2 then
                    local view = HallofFameMyRankItem:New(false)
                    view:SetParent(this)
                    view:SkipLoadShow(go.gameObject)
                    -- table.insert(rankItemList,view)
                    rankItemList[3] = view
                else
                    local view = HallofFameRankItem:New(false)
                    view:SetParent(this)
                    view:SkipLoadShow(go.gameObject)
                    -- table.insert(rankItemList,view)
                    rankItemList[i + 1] = view
                end
            end
        end
    end
    local rankInfoList = ModelList.HallofFameModel:GetRankInfoPlayerList()
    if rankInfoList then
        local myUid = ModelList.PlayerInfoModel:GetUid()
        local indexs = { 1, 2, 4, 5 }
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

    local useSection = ModelList.HallofFameModel:GetUseSection()
    this.text_thValue.text = useSection * 0.1

    local view = require("View/CommonView/CollectRewardsItem")
    local tiers, difficulty = ModelList.HallofFameModel:GetTiers()
    local csvData = ModelList.HallofFameModel.GetCsvData()
    for index, value in ipairs(csvData) do
        if tiers == value.tiers_id and
                difficulty == value.difficulty and
                6 == value.ranking[1] then
            -- log.log("周榜优化 查找数据 排行奖励" , value)
            for index, value2 in ipairs(value.reward) do
                local go = fun.get_instance(this.reward_item, this.reward_content)
                local item = view:New()
                item:SetReward(value2)
                item:SkipLoadShow(go)
                fun.set_active(go.transform, true)
            end
            break
        end
    end

    local trophyName = fun.GetCurrTournamentActivityImg(tiers)
    Cache.load_sprite(AssetList["trophyName"], trophyName, function(sprite)
        if sprite then
            this.img_trophy.sprite = sprite
        end
    end)

    local section = ModelList.HallofFameModel:GetSection()
    if section then
        this.section1.sizeDelta = Vector2.New(20, (section[2] / section[3]) * 726)
        this.section2.sizeDelta = Vector2.New(20, (section[1] / section[3]) * 726)
    end
    this.slider_tournament.value = 1 - (rankItemList[3]:GetOrder() - 1) / section[3]
end

function HallofFameRankView.OnResphonePlayerInfo()

end

function HallofFameRankView:OpenNextRankTrophyView()
    if nextTrophyView ~= nil then
        return
    end
    local model = ModelList.HallofFameModel

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
    local HallofFameRankNextTrophy = require "View/HallofFame/HallofFameRankNextTrophy"
    nextTrophyView = HallofFameRankNextTrophy:New()
    nextTrophyView:SkipLoadShow(self.nextTrophy.gameObject)
end

function HallofFameRankView:OpenNextRankRewardView()
    if nextRewardView ~= nil then
        return
    end

    local model = ModelList.HallofFameModel
    if not model:CheckHasNextReward() then
        return
    end

    local isFirst = model:GetRankIsFirst()
    local HallofFameRankNextReward = require "View/HallofFame/HallofFameRankNextReward"
    nextRewardView = HallofFameRankNextReward:New()
    nextRewardView:SkipLoadShow(self.nextRewards.gameObject)
end

function HallofFameRankView:RankClickNextRewardBtn()
    self:StopDelayAutonReward()
    self:AnimCloeNextReward()
end

function HallofFameRankView:ShowResultToCloseRankView()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function HallofFameRankView:AddTopAreaEvent()
    Event.AddListener(NotifyName.HallofFame.FameRankClickNextRewardBtn, self.RankClickNextRewardBtn, self)
    Event.AddListener(NotifyName.HallofFame.FameShowResultToCloseRankView, self.ShowResultToCloseRankView, self)

end

function HallofFameRankView:RemoveTopAreaEvent()
    Event.RemoveListener(NotifyName.HallofFame.FameRankClickNextRewardBtn, self.RankClickNextRewardBtn, self)
    Event.RemoveListener(NotifyName.HallofFame.FameShowResultToCloseRankView, self.ShowResultToCloseRankView, self)
end

function HallofFameRankView:on_btn_OepnNextReward_click()
    self:AnimOpenNextReward()
end

function HallofFameRankView:AnimOpenNextReward()
    if ModelList.HallofFameModel:CheckIsMaxTrophy() then
        log.log("周榜等级已经最高")
        return
    end
    self:OpenNextRankRewardView()
    if nextRewardView then
        nextRewardView:AnimOpenView()
    end
end

function HallofFameRankView:AnimCloeNextReward()
    if nextRewardView then
        nextRewardView:AnimCloseView()
    end
end

function HallofFameRankView:FirstAnimCloseView()
    if nextRewardView then
        nextRewardView:FirstAnimCloseView()
    end
end

function HallofFameRankView:AnimOpenNextTrophy()
    self:OpenNextRankTrophyView()
    if nextTrophyView then
        nextTrophyView:AnimOpenView()
    end
end

function HallofFameRankView:AnimCloeNextTrophy()
    if nextTrophyView then
        nextTrophyView:AnimCloseView()
    end
end

function HallofFameRankView:OepnNextTrophy()
    self:AnimOpenNextTrophy()
end

function HallofFameRankView:CheckShowTopArea()
    local model = ModelList.HallofFameModel
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

function HallofFameRankView:StopDelayAutonReward()
    if self.autoDelayReward then
        LuaTimer:Remove(self.autoDelayReward)
        self.autoDelayReward = nil
    end
    if self.autoDelayReward2 then
        LuaTimer:Remove(self.autoDelayReward2)
        self.autoDelayReward2 = nil
    end
end

function HallofFameRankView.StopDelayAutonTrophy()
    if self.autoDelayTrophy then
        LuaTimer:Remove(self.autoDelayTrophy)
        self.autoDelayTrophy = nil
    end
end

this.NotifyList = {
    { notifyName = NotifyName.HallofFame.FameResphoneRankInfo, func = this.OnResphoneRankInfo },
    { notifyName = NotifyName.HallofFame.FameResphonePlayerInfo, func = this.OnResphonePlayerInfo }
}

return this