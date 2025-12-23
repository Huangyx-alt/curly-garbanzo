require "State/BetRateOperatedView/BetRateOperatedBaseState"
require "State/BetRateOperatedView/BetRateOperatedOriginalState"
require "State/BetRateOperatedView/BetRateOperatedStiffState"

local DoubleCookiesRewards = require "View/CommonView/DoubleCookiesRewards"
local HallExplainHelpView = require "View/CommonView/HallExplainHelpView"

BetRateOperatedView = BaseView:New("BetRateOperatedView")
local this = BetRateOperatedView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "txt_info",
    "btn_increase",
    "btn_decrease",
    "coin_rate",
    "diam_rate",
    "btn_max",
    "btn_help",
    "coin_aima",
    "diamond_anim",
    "maxbet_particle",
    "coin_particle",
    "diamond_particle",
    "pieces_anima",
    "piece_rate",
    "piece_particle",
    "betrate_lock",
    "PuzzleDoubleFlag",
    "Progress",
    "anm_btn_increase",
    "particle_bet",
    "TipWindow",
    "btn_tip",
    "flash_anima",
    "flash_rate",
    "flash_max",
    "flash_paricle",
    "horizontal",
    "Betputai_anima",
    "coin_bg_light",
    "pieces_bg_light",
    "diamond_bg_light",
    "flash_bg_light",
    "Betputa_suotou",
    "week_point_anima",
    "week_point_bg_light",
    "week_point_rate",
    "week_point_paricle",
    "quest_anima",
    "cookie_rate",
    "cookie_anima",
    "supermatchTip",
    "extraRewardTip",
    "extraRewardTipIcon",
    "img_supermatch",
    "ultraBetPanel",
    "btn_ultra_open",
    "btn_ultra_close",
}

this.PropName2IdMap = {
    coin_rate = 5,
    flash_rate = 12,
    --diam_rate = {2001, 2002},
    piece_rate = { 4001, 4002, 4003, 4004, 4005, 4006, 4007, 4008, 4009, 4010, 5001 },
}

local enableFlagForCompetition = false

function BetRateOperatedView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.doubleCookiesRewards = DoubleCookiesRewards:New()
    return o
end

function BetRateOperatedView:Awake()
    self:on_init()
end

function BetRateOperatedView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:BuildFsm()
    self:LoadData()
    -- 动画会抽风，先关闭再激活
    fun.set_active(self.horizontal, false)
    self.Progress.fillAmount = 0
    self.superMatchTipBetCount = 1
    local btn = fun.get_component(self.btn_help, fun.BUTTON)
    if btn then
        btn.interactable = false
    end

    fun.set_active(self.supermatchTip, false)
    fun.set_active(self.ultraBetPanel, false)
    LuaTimer:SetDelayFunction(0.6, function()
        fun.set_active(self.horizontal, true)

        self.isEnable = true
        enableFlagForCompetition = true
        self:SetBetRateInfo(self._tem_betRate, true)
        self:BingopassInitNode()
        self:SetPuzzleDouble()
        self:RegisterEvent()
        self:RefreshRateFont()
        self:RefreshUltraEffect()
        if fun.is_not_null(self.cookie_rate) then
            self.doubleCookiesRewards:CheckCookiesBetRate(self.cookie_anima.transform.gameObject)
        elseif fun.is_not_null(self.diamond_anim) then
            self.doubleCookiesRewards:CheckCookiesBetRate(self.diamond_anim.transform.gameObject)
        end

        --LuaTimer:SetDelayFunction(0.2, function()
        --    UnityEngine.UI.LayoutRebuilder.MarkLayoutForRebuild(self.horizontal.transform)
        --end, nil, LuaTimer.TimerType.UI)

        self:UpdateSuperMatchBetTip()
        self:UpdateExtraRewardBetTip()
    end, nil, LuaTimer.TimerType.UI)

    --检查令牌的是否要开启

    self.spriteAssetContainer = fun.get_component(self.go, fun.SPRITEASSETCONTAINER)
end

--获取周榜积分数据
function BetRateOperatedView:GetWeekPointData(cityPlayId)
    local weekPointData = {};
    local cityId = ModelList.CityModel:GetCity();
    local betspend = Csv.GetData("city_play", cityPlayId, "betspend");
    local cardspend = Csv.GetData("city_play", cityPlayId, "cardspend");
    local bingoPoints = Csv.GetCityBingoPoints(cityPlayId, 1, 1);
    for i, v in ipairs(betspend) do
        local card1spend
        if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
            card1spend = ModelList.UltraBetModel:GetSingleCardCostByBet(i)
        else
            --与策划确定过这里cardspend[i][1]表示第i档有几张卡片
            card1spend = cardspend[1][2] / cardspend[1][1] * v / 100;
        end
        local weekPoint = math.ceil(card1spend * bingoPoints[i][2] / 10000);
        weekPointData[i] = weekPoint;
    end
    return weekPointData;
end

function BetRateOperatedView:LoadData()
    local cityPlayId = ModelList.CityModel.GetPlayIdByCity(ModelList.CityModel:GetCity())
    self.betData = Csv.GetCityPlayData(cityPlayId, "bet")
    self.weekPointData = self:GetWeekPointData(cityPlayId);
    self.falshData = Csv.GetCityPlayData(cityPlayId, "bet_season_display")
    self._betRate = nil

    --需要用到单卡cost，BetRateOperatedView和hallview的enable顺序可能不同，导致取不到数据
    LuaTimer:SetDelayFunction(0.3, function()
        self:SetCompetitionShow(cityPlayId)
    end, nil, LuaTimer.TimerType.UI)
end

function BetRateOperatedView:BingopassInitNode()
    local BingoPasslevel = ModelList.BingopassModel:GetLevel()
    local level_max = Csv.GetData("season_pass", BingoPasslevel, "level_max")
    if ModelList.BingopassModel:IsSeasonValid() then
        fun.set_active(self.flash_anima.gameObject, true)
    else
        fun.set_active(self.flash_anima.gameObject, false)
    end

    fun.set_active(self.TipWindow, false)

    --判断是否使用
    if level_max == 1 then
        fun.set_active(self.flash_max, true)
    else
        fun.set_active(self.flash_max, false)
    end
end

function BetRateOperatedView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("BetRateOperatedView", self, {
        BetRateOperatedOriginalState:New(),
        BetRateOperatedStiffState:New()
    })
    self._fsm:StartFsm("BetRateOperatedOriginalState")
end

function BetRateOperatedView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BetRateOperatedView:GetMayRankScore()
    if not ModelList.TournamentModel:IsActivityAvailable() then
        return 0
    end

    local rankInfoList = ModelList.TournamentModel:GetRankInfoPlayerList();
    local myUid = ModelList.PlayerInfoModel:GetUid();
    if rankInfoList then
        for key, value in pairs(rankInfoList) do
            if myUid == value.uid then
                return value.score;
            end
        end
    end
    return 0;
end

function BetRateOperatedView:SetBetRateInfo(betRate, entor)
    if betRate == nil then
        return
    end
    if not self.isEnable then
        self._tem_betRate = betRate
        return
    end

    local score = self:GetMayRankScore()
    fun.set_active(self.week_point_anima, score > 0);
    self.coin_rate.text = this.GetBetRateStr(self.betData[betRate][1], "coin_rate")
    self.piece_rate.text = this.GetBetRateStr(self.betData[betRate][2], "piece_rate")
    self.week_point_rate.text = this.GetBetRateStr(self.weekPointData[betRate], "week_point_rate")

    self:SetActivityItemInfo(betRate)

    if self.falshData then
        local falshCount = math.ceil(self.falshData[betRate] * (ModelList.BingopassModel:get_booster() / 100))
        self.flash_rate.text = this.GetBetRateStr(falshCount, "flash_rate")
        local anim_string = string.format("flash_add_%s", falshCount <= 9 and falshCount or 9)
        self.flash_anima:Play(anim_string, 0, 0)
    end

    --self.img_jackpot.sprite = AtlasManager:GetSpriteByName("HallMainAtlas", string.format("t_jackpot%s", betRate))

    --数字动画
    self.coin_aima:Play(string.format("coin_add_%s", self.betData[betRate][1] <= 9 and self.betData[betRate][1] or 9), 0,
        0)
    self.pieces_anima:Play(
    string.format("diamond_add_%s", self.betData[betRate][2] <= 9 and self.betData[betRate][2] or 9), 0, 0)
    self.week_point_anima:Play(
    string.format("coin_add_%s", self.betData[betRate][1] <= 9 and self.betData[betRate][1] or 9), 0, 0)

    if self._betRate == nil or betRate > self._betRate then
        Util.PlayParticle(self.coin_particle)
        Util.PlayParticle(self.diamond_particle)
        Util.PlayParticle(self.piece_particle)
        Util.PlayParticle(self.week_point_paricle)
        Util.PlayParticle(self.flash_paricle)
        --活动道具
        if fun.is_not_null(self.quest_particle) then Util.PlayParticle(self.quest_particle) end
        if fun.is_not_null(self.volcano_particle) then Util.PlayParticle(self.volcano_particle) end

        --self.jackpot_anima:Play("img_jackpot_add_1", 0, 0)
        fun.set_active(self.particle_bet, false)
        fun.set_active(self.particle_bet, true)

        local data = ModelList.CityModel:GetPowerUpRange()
        local playid = ModelList.CityModel.GetPlayIdByCity()
        local isJokerOpen = ModelList.CityModel:CheckIsJokerOpen(playid)
        fun.set_active(self.Betputa_suotou, not isJokerOpen)

        local isUltraBetOpen = ModelList.UltraBetModel:IsActivityValidForCurPlay()
        local playAnima = function(animaName)
            if CityHomeScene and CityHomeScene:CheckEnterHallFromBattle() then
                log.log("游戏返回 不展示特效 Betputai")
                return
            end
            this.tempName = animaName
            if not isUltraBetOpen then
                self.Betputai_anima:Play(animaName)
            elseif isUltraBetOpen and entor then
                self.Betputai_anima:Play("04")
            end
        end
        if data[playid][1].bet[2] >= betRate then
            playAnima("01")
        elseif data[playid][2].bet[2] >= betRate then
            playAnima("02")
        elseif data[playid][3].bet[2] >= betRate then
            playAnima("03")
        elseif data[playid][4].bet[2] >= betRate then
            playAnima("04")
        end

        local curHall = GetCurHallView()


        local isSpecialGuide = curHall:IsSpecialGuide()
        if curHall:IsInFocus() or isSpecialGuide then
            if CityHomeScene and CityHomeScene:CheckEnterHallFromBattle() and not isSpecialGuide then
                --屏蔽效果
                log.log("游戏返回 不展示特效 SelectJackpotConsoleShow")
            else
                self:SelectJackpotConsoleShow(entor)
            end
        end
    end

    if MaxBatRate() == betRate or 1 == betRate then
        self.SetBetRateScale(self.coin_rate)
        self.SetBetRateScale(self.diam_rate)
        self.SetBetRateScale(self.piece_rate)
        self.SetBetRateScale(self.flash_rate)
        self.SetBetRateScale(self.week_point_rate)
    end

    if self.max_btn_component == nil then
        self.max_btn_component = fun.get_component(self.btn_max, fun.BUTTON)
    end
    if self.btn_increase_component == nil then
        self.btn_increase_component = fun.get_component(self.btn_increase, fun.BUTTON)
    end
    if self.btn_decrease_component == nil then
        self.btn_decrease_component = fun.get_component(self.btn_decrease, fun.BUTTON)
    end

    local isRateOpen, open_level = ModelList.CityModel:IsBatRateOpen(betRate)

    self.Progress.fillAmount = betRate / MaxBatRate() --进度条

    if betRate == MaxBatRate() then
        self.max_btn_component.interactable = false
        self.btn_increase_component.interactable = false
        self.btn_decrease_component.interactable = true
        fun.set_active(self.btn_tip, false)
        fun.set_active(self.ultraBetPanel, ModelList.UltraBetModel:IsCurPlaySupportUltra())
        self:RefreshUltraBetBtn()
        self.anm_btn_increase:Play("idle", 0, 0)

        if isRateOpen then
            fun.set_active(self.betrate_lock, false, false)
            local gameMode = ModelList.CityModel:GetEnterGameMode()
            local playCards = gameMode ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET and CardGenre.onecard or CardGenre.fourcard
            local cardCost = ModelList.CityModel:GetCostCoin(playCards)
            self.txt_info.text = string.format("Bet Per Card:%s", fun.NumInsertComma(cardCost))
        else
            fun.set_active(self.betrate_lock, true, false)
            self.txt_info.text = string.format("Unlocks at <color=#fff79e>Lv.%s</color> ", open_level) -- <color=#fff79e>Lv.%s</color>
        end
        if CityHomeScene and CityHomeScene:CheckEnterHallFromBattle() then
            log.log("游戏返回 不展示特效 MAXBET")
            if self._fsm then
                self._fsm:GetCurState():FinishOperate(self._fsm)
            end
        else
            fun.set_active(self.maxbet_particle.transform, true)
            self.timer = Invoke(function()
                fun.set_active(self.maxbet_particle, false)
                self._fsm:GetCurState():FinishOperate(self._fsm)
            end, 1)
        end
    else
        -- self._jackpotEnable = true
        fun.set_active(self.ultraBetPanel, ModelList.UltraBetModel:IsActivityValid())
        if isRateOpen then
            local MaxRate = ModelList.CityModel:GetMaxRateOpen()
            if MaxRate == betRate then
                self.anm_btn_increase:Play("idle", 0, 0)
                self.max_btn_component.interactable = false
                self.btn_increase_component.interactable = false
                fun.set_active(self.btn_tip, true)
            else
                self.anm_btn_increase:Play("show", 0, 0)
                self.max_btn_component.interactable = true
                fun.set_active(self.btn_tip, false)
                self.btn_increase_component.interactable = true
            end

            fun.set_active(self.betrate_lock, false, false)
            local gameMode = ModelList.CityModel:GetEnterGameMode()
            local playCards = gameMode ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET and CardGenre.onecard or CardGenre.fourcard
            local cardCost = ModelList.CityModel:GetCostCoin(playCards)
            self.txt_info.text = string.format("Bet Per Card:%s", fun.NumInsertComma(cardCost))
        else
            self.anm_btn_increase:Play("idle", 0, 0)
            self.max_btn_component.interactable = false
            self.btn_increase_component.interactable = false
            fun.set_active(self.btn_tip, false)
            fun.set_active(self.betrate_lock, true, false)
            self.txt_info.text = string.format("Unlocks at <color=#ffff00>Lv.%s</color>", open_level)
        end
        if betRate == 1 then
            self.btn_decrease_component.interactable = false
        elseif not self.btn_decrease_component.interactable then
            self.btn_decrease_component.interactable = true
        end
        if betRate > (self._betRate or 1) then
            self.timer = Invoke(function()
                fun.set_active(self.maxbet_particle, false)
                self._fsm:GetCurState():FinishOperate(self._fsm)
            end, 0.5)
        else
            self._fsm:GetCurState():FinishOperate(self._fsm)
        end
    end
    self._betRate = betRate

    Event.Brocast(EventName.Event_MaxBetrateEnableJackpot, betRate)
    Facade.SendNotification(NotifyName.BetRateOperatedView.betRateChange, betRate, isRateOpen, open_level)

    self:CheckBetBtnState()
end

---活动道具展示
function BetRateOperatedView:SetActivityItemInfo(betRate)
    --饼干
    if self.competitionRate then
        if fun.is_not_null(self.cookie_rate) then
            self.cookie_rate.text = self.GetBetRateStr(self.competitionRate[betRate], "diam_rate")
        elseif fun.is_not_null(self.diam_rate) then
            self.diam_rate.text = self.GetBetRateStr(self.competitionRate[betRate], "diam_rate")
        end
        if fun.is_not_null(self.cookie_anima) then
            self.cookie_anima:Play(
            string.format("diamond_add_%s", self.competitionRate[betRate] <= 9 and self.competitionRate[betRate] or 9), 0,
                0)
        end
    end
    --赛车
    if fun.is_not_null(self.quest_anima) and ModelList.CarQuestModel:IsActivityAvailable() then
        self:SetQuestRate()
        self.quest_anima:Play(string.format("diamond_add_%s", 1), 0, 0)
    end
    --火山活动
    if fun.is_not_null(self.volcano_anima) and ModelList.VolcanoMissionModel:IsStartActivity() then
        self:SetVolcanoRate()
        self.volcano_anima:Play(string.format("diamond_add_%s", 1), 0, 0)
    end
end

function BetRateOperatedView:CanTriggerUpgradeOrExtraReward()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if playId == PLAY_TYPE.PLAY_TYPE_PIGGY_BANK then
        local curModel = ModelList.BattleModel.GetModelByPlayID(playId)
        if curModel:IsTriggerExtraReward() then
            return true
        end
    elseif playId == PLAY_TYPE.PLAY_TYPE_SOLITAIRE then
        local curModel = ModelList.BattleModel.GetModelByPlayID(playId)
        if curModel:IsTriggerExtraReward() then
            return true
        end
    end

    return false
end

--- 出于性能考虑，延迟显示JackpotConsoleView
function BetRateOperatedView:SelectJackpotConsoleShow(isEnter)
    if not enableFlagForCompetition and isEnter then
        self:CoroutineLoadJackpotConsole()
        if ModelList.SmallGameModel:CanOpenGameForBet() and not ModelList.UltraBetModel:IsActivityValid() then
            Facade.SendNotification(NotifyName.HallMainView.OpenSuperMatchJackpot)
        end

        if self:CanTriggerUpgradeOrExtraReward() and not ModelList.UltraBetModel:IsActivityValid() then
            Facade.SendNotification(NotifyName.HallMainView.OpenPiggyBankJackpot)
            Facade.SendNotification(NotifyName.HallMainView.OpenCustomizedJackpot)
        end
    else
        if self:CanTriggerUpgradeOrExtraReward() and not ModelList.UltraBetModel:IsActivityValid() then
            Facade.SendNotification(NotifyName.HallMainView.OpenPiggyBankJackpot)
            Facade.SendNotification(NotifyName.HallMainView.OpenCustomizedJackpot)
            return
        end
        --开启super match优化
        --if not isEnter then
        if ModelList.SmallGameModel:CanOpenGameForBet() and not ModelList.UltraBetModel:IsActivityValid() then
            Facade.SendNotification(NotifyName.HallMainView.OpenSuperMatchJackpot)
            return
        end
        --end

        if ModelList.VolcanoMissionModel:IsStartActivity() then
            if enableFlagForCompetition then
                enableFlagForCompetition = false
                Cache.load_prefabs(AssetList["VolcanoMissionJackpotEnableView"], "VolcanoMissionJackpotEnableView",
                    function(prefab)
                        Facade.SendNotification(NotifyName.ShowDialog, ViewList.VolcanoMissionJackpotEnableView)
                    end)
            else
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.VolcanoMissionJackpotEnableView)
            end
        elseif ModelList.CarQuestModel:IsActivityAvailable() then
            if enableFlagForCompetition then
                enableFlagForCompetition = false
                Cache.load_prefabs(AssetList["JackpotEnableViewQuest"], "JackpotEnableViewQuest", function(prefab)
                    Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewQuest)
                end)
            else
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewQuest)
            end
        elseif ModelList.CompetitionModel:IsActivityAvailable() then
            if enableFlagForCompetition then
                enableFlagForCompetition = false
                Cache.load_materials("luaprefab.material.ef_hall_Coincookie", "ef_hall_Coincookie", function()
                    Cache.load_prefabs(AssetList["JackpotEnableViewCookie"], "JackpotEnableViewCookie", function(prefab)
                        Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewCookie)
                    end)
                end)
            else
                Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableViewCookie)
            end
        else
            Facade.SendNotification(NotifyName.ShowDialog, ViewList.JackpotEnableView)
        end
    end
end

function BetRateOperatedView:CoroutineLoadJackpotConsole()
    coroutine.start(function()
        coroutine.wait(0.5)
        Cache.Load_Atlas(AssetList["JackpotEnableAtlas"], "JackpotEnableAtlas")
        coroutine.wait(0.5)

        if ModelList.VolcanoMissionModel:IsStartActivity() then
            Cache.load_prefabs(AssetList["VolcanoMissionJackpotEnableView"], "VolcanoMissionJackpotEnableView")
        elseif ModelList.CarQuestModel:IsActivityAvailable() then
            Cache.load_prefabs(AssetList["JackpotEnableViewQuest"], "JackpotEnableViewQuest")
        elseif ModelList.CompetitionModel:IsActivityAvailable() then
            Cache.load_prefabs(AssetList["JackpotEnableViewCookie"], "JackpotEnableViewCookie")
        else
            Cache.load_prefabs(AssetList["JackpotEnableView"], "JackpotEnableView")
        end
    end)
end

function BetRateOperatedView:RefreshUltraEffect()
    if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
        fun.set_active(self.coin_bg_light, true)
        fun.set_active(self.pieces_bg_light, true)
        fun.set_active(self.diamond_bg_light, true)
        fun.set_active(self.flash_bg_light, true)
        fun.set_active(self.week_point_bg_light, true)

        --赛车道具
        if fun.is_not_null(self.quest_bg_light) then
            fun.set_active(self.quest_bg_light, true)
        end
    else
        fun.set_active(self.coin_bg_light, false)
        fun.set_active(self.pieces_bg_light, false)
        fun.set_active(self.diamond_bg_light, false)
        fun.set_active(self.flash_bg_light, false)
        fun.set_active(self.week_point_bg_light, false)

        --赛车道具
        if fun.is_not_null(self.quest_bg_light) then
            fun.set_active(self.quest_bg_light, false)
        end
    end
end

function BetRateOperatedView.GetBetRateMultiple(uiName)
    local multiple = 1
    if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
        if this.PropName2IdMap[uiName] then
            if ModelList.UltraBetModel:CanPropMultiple(this.PropName2IdMap[uiName]) then
                multiple = ModelList.UltraBetModel:GetBetMultiple()
            elseif uiName == "coin_rate" then
                --经验特殊处理
                -- multiple = ModelList.UltraBetModel:GetBetMultiple()
            elseif uiName == "diam_rate" then
                --赛车、火山特殊处理
                if ModelList.CarQuestModel:IsActivityAvailable() or ModelList.VolcanoMissionModel:IsStartActivity() then
                    return multiple
                else
                    --饼干特殊处理
                    multiple = ModelList.UltraBetModel:GetBetMultiple()
                end
            end
        elseif uiName == "week_point_rate" then
            multiple = ModelList.UltraBetModel:GetBetMultiple()
        end
    end
    return multiple
end

function BetRateOperatedView:RefreshRateFont()
    local fontName = "font_bet_rate"
    if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
        fontName = "font_ultra_bet"
    end

    self:SetRateFont(self.coin_rate, fontName)
    self:SetRateFont(self.diam_rate, fontName)
    self:SetRateFont(self.piece_rate, fontName)
    self:SetRateFont(self.flash_rate, fontName)
    self:SetRateFont(self.week_point_rate, fontName)

    --- 饼干
    if fun.is_not_null(self.cookie_rate) then
        self:SetRateFont(self.cookie_rate, fontName)
    end

    --赛车玩法道具
    if fun.is_not_null(self.quest_rate) then
        self:SetRateFont(self.quest_rate, fontName)
    end
    --火山玩法道具
    if fun.is_not_null(self.volcano_rate) then
        self:SetRateFont(self.volcano_rate, fontName)
    end
end

function BetRateOperatedView:SetRateFont(txtComponent, fontName)
    if self.spriteAssetContainer then
        local newAsset = self.spriteAssetContainer:Get(fontName)
        if newAsset then
            txtComponent.spriteAsset = newAsset
        end
    end
end

function BetRateOperatedView.GetBetRateStr(betRate, uiName)
    local multiple = this.GetBetRateMultiple(uiName)
    betRate = math.ceil(betRate * multiple)

    local str = "<sprite name=\"x\">"
    local charTb = string.toCharTable(tostring(betRate))
    table.each(charTb, function(char)
        str = string.format("%s<sprite name=\"%s\">", str, char)
    end)
    return str
end

function BetRateOperatedView.SetBetRateScale(sp)
    if sp then
        --[[
        local parent = sp.transform.parent.gameObject
        fun.set_gameobject_scale(parent,0.8,0.8,1)
        Anim.scale_to_xy_ease(parent,1,1,0.3,DG.Tweening.Ease.InOutBack)
        --]]
    end
end

function BetRateOperatedView:on_btn_tip_left_click()
    if self._betRate == nil or self._betRate >= MaxBatRate() then
        return
    end

    fun.set_rect_local_pos(self.TipWindow, -315, 82, 0)
    fun.set_active(self.TipWindow, true)
    self:SetTipWindowText(self._betRate - 1)
    LuaTimer:SetDelayFunction(2, function()
        fun.set_active(self.TipWindow, false)
    end)
end

function BetRateOperatedView:on_btn_tip_click()
    if self._betRate == nil or self._betRate >= MaxBatRate() then
        return
    end

    fun.set_rect_local_pos(self.TipWindow, 142, 82, 0)
    fun.set_active(self.TipWindow, true)
    self:SetTipWindowText(self._betRate + 1)
    LuaTimer:SetDelayFunction(2, function()
        fun.set_active(self.TipWindow, false)
    end)
end

function BetRateOperatedView:SetTipWindowText(bet)
    local playType = ModelList.CityModel.GetCurPlayType()
    if playType == PLAY_TYPE.PLAY_TYPE_VICTORY_BEATS then
        --WinZone玩法，只有首轮战斗可以调整bet
        local data = ModelList.WinZoneModel:GetPlayReadyData()
        local ret = not data or not data.curRound or data.curRound == 1
        if not ret then
            return
        end
    end

    local text = fun.find_child(self.TipWindow, "Text")
    local txt = fun.get_component(text, fun.OLDTEXT)
    local isRateOpen, open_level = ModelList.CityModel:IsBatRateOpen(bet)
    local str = Csv.GetData("description", 968, "description")
    txt.text = string.format(str, open_level)
end

function BetRateOperatedView:OnDisable()
    self.isEnable = nil
    self.max_btn_component = nil
    self.btn_increase_component = nil
    self.btn_decrease_component = nil
    self._jackpotEnable = nil

    self._betRate = nil
    self._tem_betRate = nil

    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end

    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end

    self.doubleCookiesRewards:OnDisable()
    self:UnRegisterEvent()
    Facade.RemoveViewEnhance(self)
    self.isSupermatchTipShowing = nil
    self.isExtraRewardTipShowing = nil
    self.isExtraRewardTipInit = nil
end

function BetRateOperatedView:on_close()
    self.doubleCookiesRewards:Dispose()
end

function BetRateOperatedView:OnDestroy()
    self:Close()
end

function BetRateOperatedView:CheckBetBtnState()
    local playType = ModelList.CityModel.GetCurPlayType()
    if playType == PLAY_TYPE.PLAY_TYPE_VICTORY_BEATS then
        --WinZone玩法，只有首轮战斗可以调整bet
        local data = ModelList.WinZoneModel:GetPlayReadyData()
        local ret = not data or not data.curRound or data.curRound == 1
        if not ret then
            fun.set_active(self.btn_tip, true)
            fun.set_active(self.btn_tip_left, true)

            --tip文本
            local text = fun.find_child(self.TipWindow, "Text")
            local txt = fun.get_component(text, fun.OLDTEXT)
            txt.text = Csv.GetData("description", 8049, "description")

            --fun.enable_button(self.btn_increase, false)
            --fun.enable_button(self.btn_decrease, false)
            --fun.enable_button(self.btn_max, false)
        end
    end
end

function BetRateOperatedView:on_btn_increase_click()
    self._fsm:GetCurState():Operate(self._fsm, 1)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    SDK.increase_bet(playId, self._betRate)
end

function BetRateOperatedView:OnIncreaseClick()
    ModelList.CityModel:SetBetRateStep(1)
    Facade.SendNotification(NotifyName.HallMainView.RefreshHallInfo)
    UISound.play("bet_1")

    local playId = ModelList.CityModel.GetPlayIdByCity()
    self:SetCompetitionShow(playId)
    self:UpdateSuperMatchBetTip()
    self:UpdateExtraRewardBetTip()
end

function BetRateOperatedView:on_btn_decrease_click()
    self._fsm:GetCurState():Operate(self._fsm, 2)
    fun.set_active(self.TipWindow, false)

    local playId = ModelList.CityModel.GetPlayIdByCity()
    SDK.decrease_bet(playId, self._betRate)
    ModelList.GuideModel:CheckSuperMatchMaxbetGuide()
end

function BetRateOperatedView:OnDecreaseClick()
    ModelList.CityModel:SetBetRateStep(-1)
    Facade.SendNotification(NotifyName.HallMainView.RefreshHallInfo)
    UISound.play("bet_2")

    local playId = ModelList.CityModel.GetPlayIdByCity()
    self:SetCompetitionShow(playId)
    self:UpdateSuperMatchBetTip()
    self:UpdateExtraRewardBetTip()
end

function BetRateOperatedView:on_btn_max_click(isAutoClick)
    if not isAutoClick then
        local playId = ModelList.CityModel.GetPlayIdByCity()
        SDK.click_max_bet(playId)
    end

    self._fsm:GetCurState():Operate(self._fsm, 3)
end

function BetRateOperatedView:OnMaximumClick()
    local currRate = ModelList.CityModel:GetMaxRateOpen()

    ModelList.CityModel:SetBetRate(currRate)
    Facade.SendNotification(NotifyName.HallMainView.RefreshHallInfo)
    self:UpdateSuperMatchBetTip()
    self:UpdateExtraRewardBetTip()
end

function BetRateOperatedView:on_btn_ultra_open_click()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    ModelList.UltraBetModel.C2S_RequestUltraBetOpen(playId)
end

function BetRateOperatedView:on_btn_ultra_close_click()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    ModelList.UltraBetModel.C2S_RequestUltraBetClose(playId)
end

function BetRateOperatedView:on_btn_help_click()
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local playType = Csv.GetData("city_play", playid, "play_type")
    local helpSetting = Csv.GetData("new_game_help_setting", playid)
    local assetviewName, atlasViewName = helpSetting.asset_viewname, helpSetting.atlas_viewname
    if assetviewName == "0" or atlasViewName == "0" then
        return
    end

    if playType == PLAY_TYPE.PLAY_TYPE_NORMAL then
        Cache.Load_Atlas(AssetList["HallMainHelpAtlas"], "HallMainHelpAtlas", function()
            Cache.load_prefabs(AssetList[assetviewName], atlasViewName, function(obj)
                local root = HallExplainHelpView:GetRootView()
                local gameObject = fun.get_instance(obj, root)
                HallExplainHelpView:SkipLoadShow(gameObject)
            end)
        end)
    else
        Cache.load_prefabs(AssetList[assetviewName], atlasViewName, function(obj)
            local root = HallExplainHelpView:GetRootView()
            local gameObject = fun.get_instance(obj, root)
            HallExplainHelpView:SkipLoadShow(gameObject)
        end)
    end
end

function BetRateOperatedView:SetPuzzleDouble()
    if ModelList.ActivityModel:IsActivityAvailable(ActivityTypes.doublePuzzle) then
        fun.set_active(self.PuzzleDoubleFlag, true)
    end
end

function BetRateOperatedView:ChangePuzzleDoubleFlag(isOpen)
    fun.set_active(self.PuzzleDoubleFlag, isOpen)
end

--------------------------------Competition--------------------------------------------------------------------------

--- 创建饼干bet动画
function BetRateOperatedView:CreateCookieBetAnima(cityPlayId)
    --饼干
    self:CalculateCookieRate(cityPlayId)
    if fun.is_null(self.cookie_rate) then
        Cache.load_prefabs(AssetList["cookie_rate"], "cookie_rate", function(obj)
            local instance = fun.get_instance(obj, self.diam_rate.transform.parent.parent)
            instance.transform:SetSiblingIndex(2);
            self.cookie_anima = fun.get_component(instance, fun.ANIMATOR)
            local ctrl = fun.find_child(instance, "diamond_rate_text")
            self.cookie_rate = fun.get_component(ctrl, fun.TXTPRO)
            ctrl = fun.find_child(instance, "Image")
            self.cookie_image = fun.get_component(ctrl, fun.IMAGE)

            self.quest_bg_light = fun.find_child(instance, "bg_light")
            fun.set_active(self.quest_bg_light, ModelList.UltraBetModel:IsActivityValidForCurPlay())

            self.cookie_particle = fun.find_child(instance, "ring01")
            self.cookie_buff = fun.find_child(instance, "Tip")
            --buff
            local haveBuff = ModelList.CompetitionModel:GetDoubleCollectBuffTime() > 0
            fun.set_active(self.cookie_buff, haveBuff)
            --设置油桶图片
            --if fun.is_not_null(self.cookie_image) then
            --    Cache.GetSpriteByName("HallMainAtlas", "City8Cookie", function(sprite)
            --        if not fun.is_null(sprite) then
            --            self.cookie_image.sprite = sprite
            --        end
            --    end)
            --end
            fun.set_active(self.cookie_rate.transform.parent, true, false)
        end)
    else
        fun.set_active(self.cookie_rate.transform.parent, true, false)
    end

    --if fun.is_not_null(self.cookie_rate) then
    --    fun.set_active(self.cookie_rate.transform.parent, false)
    --end
end

--- 创建赛车bet动画
function BetRateOperatedView:CreateQuestRate(cityPlayId)
    --赛车
    fun.set_active(self.diam_rate.transform.parent, false, false)
    if fun.is_not_null(self.volcano_rate) then
        fun.set_active(self.volcano_rate.transform.parent, false, false)
    end

    --取展示道具
    local singleCardCost = ModelList.CityModel:GetCostCoin(1)
    if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        singleCardCost = ModelList.CityModel:GetCostCoin(4) / 4
    end

    local cfg = table.find(Csv["competition_racing_putin"], function(k, v)
        local range = v.coin_range
        return range[1] <= singleCardCost and singleCardCost <= range[2]
    end)
    if not cfg then
        if fun.is_not_null(self.quest_rate) then
            fun.set_active(self.quest_rate.transform.parent, false)
        end
        return
    end

    --已经创建了
    if fun.is_not_null(self.quest_rate) then
        fun.set_active(self.quest_rate.transform.parent, true)
        return
    end

    Cache.load_prefabs(AssetList["QuestBetItem"], "QuestBetItem", function(obj)
        local instance = fun.get_instance(obj, self.diam_rate.transform.parent.parent)
        instance.transform:SetSiblingIndex(3);
        self.quest_anima = fun.get_component(instance, fun.ANIMATOR)
        local ctrl = fun.find_child(instance, "diamond_rate_text")
        self.quest_rate = fun.get_component(ctrl, fun.TXTPRO)
        ctrl = fun.find_child(instance, "Image")
        self.quest_image = fun.get_component(ctrl, fun.IMAGE)

        self.quest_bg_light = fun.find_child(instance, "bg_light")
        fun.set_active(self.quest_bg_light, ModelList.UltraBetModel:IsActivityValidForCurPlay())

        self.quest_particle = fun.find_child(instance, "ring01")
        self.quest_buff = fun.find_child(instance, "Tip")

        --设置油桶图片
        if fun.is_not_null(self.quest_image) and not fun.is_empty_str(cfg.oil_type) then
            local spriteName = Csv.GetItemOrResource(cfg.oil_type, "icon")
            Cache.GetSpriteByName("GameItemAtlas", spriteName, function(sprite)
                if not fun.is_null(sprite) then
                    self.quest_image.sprite = sprite
                end
            end)
        end
    end)
end

--- 创建火山bet动画
function BetRateOperatedView:CreateVolcanoRate(cityPlayId)
    --火山活动
    fun.set_active(self.diam_rate.transform.parent, false, false)
    --if fun.is_not_null(self.quest_rate) then
    --    fun.set_active(self.quest_rate.transform.parent, false, false)
    --end

    --取展示道具
    local singleCardCost = ModelList.CityModel:GetCostCoin(1)
    if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        singleCardCost = ModelList.CityModel:GetCostCoin(4) / 4
    end

    local cfg = table.find(Csv["volcano_putin"], function(k, v)
        local range = v.coin_range
        return range[1] <= singleCardCost and singleCardCost <= range[2]
    end)
    if not cfg then
        if fun.is_not_null(self.volcano_rate) then
            fun.set_active(self.volcano_rate.transform.parent, false)
        end
        return
    end

    --已经创建了
    if fun.is_not_null(self.volcano_rate) then
        fun.set_active(self.volcano_rate.transform.parent, true)
        return
    end

    Cache.load_prefabs(AssetList["VolcanoMissionBetItem"], "VolcanoMissionBetItem", function(obj)
        local instance = fun.get_instance(obj, self.diam_rate.transform.parent.parent)

        self.volcano_anima = fun.get_component(instance, fun.ANIMATOR)
        local ctrl = fun.find_child(instance, "diamond_rate_text")
        self.volcano_rate = fun.get_component(ctrl, fun.TXTPRO)
        ctrl = fun.find_child(instance, "Image")
        self.volcano_image = fun.get_component(ctrl, fun.IMAGE)

        self.volcano_bg_light = fun.find_child(instance, "bg_light")
        fun.set_active(self.volcano_bg_light, ModelList.UltraBetModel:IsActivityValidForCurPlay())

        self.volcano_particle = fun.find_child(instance, "ring01")
        self.volcano_buff = fun.find_child(instance, "Tip")

        --设置图片
        if fun.is_not_null(self.volcano_image) and not fun.is_empty_str(cfg.prop_type) then
            local spriteName = Csv.GetItemOrResource(cfg.prop_type, "icon")
            Cache.GetSpriteByName("GameItemAtlas", spriteName, function(sprite)
                if not fun.is_null(sprite) then
                    self.volcano_image.sprite = sprite
                end
            end)
        end
    end)
end

--设置杯赛活动道具
function BetRateOperatedView:SetCompetitionShow(cityPlayId)
    if ModelList.CompetitionModel:IsActivityAvailable() then
        self:CreateCookieBetAnima(cityPlayId)
        fun.set_active(self.diam_rate.transform.parent, false, false)
    else
        self.competitionRate = nil
        fun.set_active(self.diam_rate.transform.parent, false, false)
        if fun.is_not_null(self.cookie_rate) then
            fun.set_active(self.cookie_rate.transform.parent, false)
        end
    end

    if ModelList.CarQuestModel:IsActivityAvailable() then
        self:CreateQuestRate(cityPlayId)
    end

    if ModelList.VolcanoMissionModel:IsStartActivity() then
        self:CreateVolcanoRate(cityPlayId)
    else
        if fun.is_not_null(self.volcano_rate) then
            fun.set_active(self.volcano_rate.transform.parent, false)
        end
    end
end

function BetRateOperatedView:SetQuestRate()
    if fun.is_not_null(self.quest_rate) and fun.is_not_null(self.quest_image) then
        local singleCardCost = ModelList.CityModel:GetCostCoin(1)
        if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
            singleCardCost = ModelList.CityModel:GetCostCoin(4) / 4
        end

        local cfg = table.find(Csv["competition_racing_putin"], function(k, v)
            local range = v.coin_range
            return range[1] <= singleCardCost and singleCardCost <= range[2]
        end)
        if not cfg then
            return
        end

        --图标、数量
        local itemID, count = cfg.oil_type, cfg.number
        local spriteName = Csv.GetItemOrResource(itemID, "icon")
        Cache.GetSpriteByName("GameItemAtlas", spriteName, function(sprite)
            if not fun.is_null(sprite) then
                self.quest_image.sprite = sprite
            end
        end)
        self.quest_rate.text = this.GetBetRateStr(count, "diam_rate")

        local fontName = ModelList.UltraBetModel:IsActivityValidForCurPlay() and "font_ultra_bet" or "font_bet_rate"
        self:SetRateFont(self.quest_rate, fontName)

        --buff
        local haveBuff = ModelList.CarQuestModel:GetMoreItemBuffTime() > 0
        fun.set_active(self.quest_buff, haveBuff)
    end
end

function BetRateOperatedView:SetVolcanoRate()
    if fun.is_not_null(self.volcano_rate) and fun.is_not_null(self.volcano_image) then
        local singleCardCost = ModelList.CityModel:GetCostCoin(1)
        if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
            singleCardCost = ModelList.CityModel:GetCostCoin(4) / 4
        end

        local cfg = table.find(Csv["volcano_putin"], function(k, v)
            local range = v.coin_range
            return range[1] <= singleCardCost and singleCardCost <= range[2]
        end)
        if not cfg then
            return
        end

        --图标、数量
        local itemID, count = cfg.prop_type, cfg.number
        local spriteName = Csv.GetItemOrResource(itemID, "icon")
        Cache.GetSpriteByName("GameItemAtlas", spriteName, function(sprite)
            if not fun.is_null(sprite) then
                self.volcano_image.sprite = sprite
            end
        end)
        self.volcano_rate.text = this.GetBetRateStr(count, "diam_rate")

        local fontName = ModelList.UltraBetModel:IsActivityValidForCurPlay() and "font_ultra_bet" or "font_bet_rate"
        self:SetRateFont(self.volcano_rate, fontName)

        --buff
        local haveBuff = ModelList.VolcanoMissionModel:GetDoubleItemBuffTime() > 0
        fun.set_active(self.volcano_buff, haveBuff)
    end
end

--计算杯赛饼干道具倍率
function BetRateOperatedView:CalculateCookieRate(playId)
    -- 只取单bingo
    local bingoReward = Csv.GetBingoRewardOfPlayid(playId, 1)
    bingoReward = bingoReward / 100 or 0

    local betCompetition = Csv.GetCityPlayData(playId, "bet_competition_new")
    local cardspend = Csv.GetData("city_play", playId, "cardspend")
    local betspend = Csv.GetData("city_play", playId, "betspend")

    local competitionRate = {}
    for i, v in ipairs(betCompetition) do
        competitionRate[i] = cardspend[1][2] * betspend[i] / 100 * bingoReward / v
    end
    self.competitionRate = competitionRate
end

--------------------------------------------------------------------------------------------------------------

--会比较依赖order 得命令
function BetRateOperatedView:isCanShowHelpView()
    local btn = fun.get_component(self.btn_help, fun.BUTTON)
    if btn then
        btn.interactable = true
    end
end

function BetRateOperatedView:RegisterEvent()
    Event.AddListener(EventName.Event_Hide_BetRateOperatedView_Double_Flag, self.ChangePuzzleDoubleFlag, self)
    Event.AddListener(EventName.Event_Is_Can_Show_Help_View, self.isCanShowHelpView, self)
    Event.AddListener(EventName.Event_competition_quest_item_buff, self.OnResourceChange, self)
    Event.AddListener(EventName.Event_competition_show_popup, self.PopupShowCompetition, self)
    Event.AddListener(EventName.Event_VolcanoMission_Item_Buff, self.OnResourceChange, self)
end

function BetRateOperatedView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_Hide_BetRateOperatedView_Double_Flag, self.ChangePuzzleDoubleFlag, self)
    Event.RemoveListener(EventName.Event_Is_Can_Show_Help_View, self.isCanShowHelpView, self)
    Event.RemoveListener(EventName.Event_competition_quest_item_buff, self.OnResourceChange, self)
    Event.RemoveListener(EventName.Event_competition_show_popup, self.PopupShowCompetition, self)
    Event.RemoveListener(EventName.Event_VolcanoMission_Item_Buff, self.OnResourceChange, self)
end

function BetRateOperatedView:RefreshUltraBetUI()
    ---[[要重新计算weekPointData
    local cityPlayId = ModelList.CityModel.GetPlayIdByCity(ModelList.CityModel:GetCity())
    self.weekPointData = self:GetWeekPointData(cityPlayId)
    --]]

    self:on_btn_max_click(true)
    self:RefreshRateFont()
    self:RefreshUltraEffect()
    self:UpdateSuperMatchBetTip()
    self:UpdateExtraRewardBetTip()
    self:RefreshUltraBetBtn()
end

function BetRateOperatedView:RefreshUltraBetBtn()
    local cityPlayId = ModelList.CityModel.GetPlayIdByCity(ModelList.CityModel:GetCity())
    local ultraOpen = ModelList.UltraBetModel:IsActivityValid(cityPlayId)
    fun.set_active(self.btn_ultra_open, not ultraOpen)
    fun.set_active(self.btn_ultra_close, ultraOpen)
end

function BetRateOperatedView:OnUltraBetStart()
    self:RefreshUltraBetUI()
end

function BetRateOperatedView:OnUltraBetEnd()
    self:RefreshUltraBetUI()
end

function BetRateOperatedView:OnGroupPrefixRefresh()
    self:LoadData()
    self:SetBetRateInfo(self._tem_betRate)
end

function BetRateOperatedView:OnResNotify()

end

function BetRateOperatedView:OnResourceChange()
    if fun.is_not_null(self.quest_buff) then
        local haveBuff = ModelList.CarQuestModel:GetMoreItemBuffTime() > 0
        fun.set_active(self.quest_buff, haveBuff)
    end
    if fun.is_not_null(self.volcano_buff) then
        local haveBuff = ModelList.VolcanoMissionModel:GetDoubleItemBuffTime() > 0
        fun.set_active(self.volcano_buff, haveBuff)
    end
end

function BetRateOperatedView:PopupShowCompetition()
    local cityPlayId = ModelList.CityModel.GetPlayIdByCity(ModelList.CityModel:GetCity())
    self:SetCompetitionShow(cityPlayId)

    if self._tem_betRate then
        self:SetBetRateInfo(self._tem_betRate, true)
    end
end

function BetRateOperatedView:OnStartVolcanoMission()
    local cityPlayId = ModelList.CityModel.GetPlayIdByCity(ModelList.CityModel:GetCity())
    self:SetCompetitionShow(cityPlayId)

    if self._tem_betRate then
        self:SetBetRateInfo(self._tem_betRate, true)
    end
end

--[[
function BetRateOperatedView:UpdateSuperMatchBetTipV1()
    local condition1 = ModelList.SuperMatchModel:CanEnterSuperMatch()
    local condition2 = ModelList.SuperMatchModel:CanEnterSuperMatchIgnoreBet()
    if not condition1 and condition2 then
        if self.superMatchTipBetCount > 0 then
            fun.set_active(self.supermatchTip, false)
            fun.set_active(self.supermatchTip, true)
            fun.set_active(self.supermatchTip, false, 2)
            self.superMatchTipBetCount = self.superMatchTipBetCount - 1
        else
            fun.set_active(self.supermatchTip, false)
        end
    else
        fun.set_active(self.supermatchTip, false)
    end
end
--]]

function BetRateOperatedView:UpdateSuperMatchBetTip()
    if not ModelList.SmallGameModel:CanOpenGameForBet() and ModelList.SmallGameModel:CanOpenGameForCurrPlay()
        and not ModelList.SmallGameModel:IsSmallGameTriggerInLobby() then
        if not self.isSupermatchTipShowing then
            fun.set_active(self.supermatchTip, false)
            self:UpdateSmallGameIcon(self.img_supermatch)
            fun.set_active(self.supermatchTip, true)
            self.isSupermatchTipShowing = true
        end
    else
        fun.set_active(self.supermatchTip, false)
        if self.isSupermatchTipShowing then
            fun.set_active(self.supermatchTip, false)
            fun.set_active(self.supermatchTip, true)
            self.isSupermatchTipShowing = false
            fun.play_animator(self.supermatchTip, "end")
        end
    end
end

---根据当前小游戏类型更新icon
function BetRateOperatedView:UpdateSmallGameIcon(img)
    local iconInfo = ModelList.SmallGameModel.GetCurrentGameIconInfo()
    if img and img.sprite then
        if not fun.starts(img.sprite.name, iconInfo) then
            Cache.load_texture_to_sprite(iconInfo, img)
        end
    end
end

function BetRateOperatedView:UpdateExtraRewardBetTip()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    -- local curModel = ModelList.BattleModel:GetCurrModel() --get nil
    --[[
    local modelName = Csv.GetData("new_game_mode", playId, "model")
    local curModel = ModelList[modelName]
    --]]
    local curModel = ModelList.BattleModel.GetModelByPlayID(playId)
    if curModel.IsTriggerExtraReward then
        if not curModel:IsTriggerExtraReward() then
            if not self.isExtraRewardTipShowing then
                fun.set_active(self.extraRewardTip, false)
                fun.set_active(self.extraRewardTip, true)
                self.isExtraRewardTipShowing = true
                if playId == PLAY_TYPE.PLAY_TYPE_GOLD_TRAIN then
                    ModelList.GuideModel:TriggerGoldenTrainPuGuide()
                elseif playId == PLAY_TYPE.PLAY_TYPE_CHRISTMAS_SYNTHESIS then
                    ModelList.GuideModel:TriggerChristmasSynthesisPuGuide()
                end
            end
        else
            fun.set_active(self.extraRewardTip, false)
            if self.isExtraRewardTipShowing then
                fun.set_active(self.extraRewardTip, false)
                fun.set_active(self.extraRewardTip, true)
                self.isExtraRewardTipShowing = false
                fun.play_animator(self.extraRewardTip, "end")
            end
        end
        if not self.isExtraRewardTipInit and self.extraRewardTipIcon then
            self.extraRewardTipIcon.sprite = curModel:GetExtraRewardTipIconSprite()
            self.isExtraRewardTipInit = true
        end
    else
        fun.set_active(self.extraRewardTip, false)
    end
end

--设置消息通知
this.NotifyEnhanceList = {
    { notifyName = NotifyName.UltraBet.ActivityStart,        func = this.OnUltraBetStart },
    { notifyName = NotifyName.UltraBet.ActivityEnd,          func = this.OnUltraBetEnd },
    { notifyName = NotifyName.PlayerInfo.RefreshGroupPrefix, func = this.OnGroupPrefixRefresh },
    { notifyName = NotifyName.Competition.ResphoneNotify,    func = this.PopupShowCompetition },
    { notifyName = NotifyName.VolcanoMission.StartActivity,  func = this.OnStartVolcanoMission },
}
