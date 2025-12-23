local BaseJackpotConsoleState = require "State/JackpotConsole/BaseJackpotConsoleState"
local JackpotMaxBetRateState = require "State/JackpotConsole/JackpotMaxBetRateState"
local JackpotSmallBetRateState = require "State/JackpotConsole/JackpotSmallBetRateState"

JackepotHost = { mainLobby = 1, autoLobby = 2 }
local JackpotConsoleView = BaseView:New("JackpotConsoleView")
local this = JackpotConsoleView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.ConsoleInActionName = "jackpot_consolein"
this.ConsoleInClipName = "jackpot_consolein"
local isAutoFirstEnter = nil

this.auto_bind_ui_items = {
    "jackpot_lock",
    "jackpot_dish",
    "dish",
    "text_reward",
    "anima",
    "jackpotBg", -- 背后的背景
    "titleImg",

    "OtherBonus",
    "OtherCount",
    "OtherHead",
    "OtherText",
    "ExtraCount",
    "bearBonus",
    "jBallDi",
    "jBall",
    "img_cityName",
    "Extra_lock",
    "jGeZi",
    "jGeZi2",
    "SmallGameLock",
    "SmallGameUnlock",
    "super_match_left_time_txt",
    "btn_super_bang",
    "btn_super_bang2",
}

this.bet_bg_img = {
    [1] = "HallJTitleDi01",
    [2] = "HallJTitleDi01",
    [3] = "HallJTitleDi02",
    [4] = "HallJTitleDi02",
    [5] = "HallJTitleDi03",
    [6] = "HallJTitleDi03",
    [7] = "HallJTitleDi04",
    [8] = "HallJTitleDi04",
    [9] = "HallJTitleDi05",
    [10] = "HallJTitleDi05",
}

this.title_img = {
    [1] = "XWYJBzName01",
    [2] = "XWYJBzName02",
    [3] = "XWYJBzName03",
    [4] = "XWYJBzName04",
    [5] = "XWYJBzName05",
    [6] = "XWYJBzName06",
    [7] = "XWYJBzName07",
    [8] = "XWYJBzName08",
    [9] = "XWYJBzName09",
    [10] = "XWYJBzName010",
}

function JackpotConsoleView:New(host)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o._host = host
    return o
end

function JackpotConsoleView:Awake(obj)
    self:on_init()
end

function JackpotConsoleView:OnEnable()
    Facade.RegisterViewEnhance(self)
    Event.AddListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:SetJackpotInfo()
    self:initExtraInFo()
    self:BuildFsm()
    
end

function JackpotConsoleView:RemoveUselessRaycast()
    local kuang = fun.find_child(self.go, "Root/kuang")
    if not fun.is_null(kuang) then
        fun.get_component(kuang, fun.IMAGE).raycastTarget = false
    end
end

function JackpotConsoleView:RemoveCountDownTimer()
    if self.countDownTimer then
        LuaTimer:Remove(self.countDownTimer)
        self.countDownTimer = nil
    end
end

function JackpotConsoleView:StartCountDown()
    if ModelList.SmallGameModel:IsOpenTime() then
        if fun.is_not_null(self.leftTime1) then
            local endTime = ModelList.SmallGameModel:GetLeftTime()
            self:RemoveCountDownTimer()
            self.countDownTimer = LuaTimer:SetDelayLoopFunction(0, 1, -1, function ()
                if endTime >= 0 then
                    if fun.is_not_null(self.leftTime1) then
                        self.leftTime1.text = fun.SecondToStrFormat(endTime)
                    end
                    if fun.is_not_null(self.leftTime2) then
                        self.leftTime2.text = fun.SecondToStrFormat(endTime)
                    end
                    --local text = fun.SecondToStrFormat(endTime)
                    --left_time_txt.text = text
                    --if left_time_txt2 then
                    --    left_time_txt2.text = text
                    --end
                    endTime = endTime - 1
                else
                    self:StopCountDown()
                end
            end, nil, nil, LuaTimer.TimerType.UI)
        end
    end

    self:RemoveUselessRaycast()
end

--- 结束倒计时
function JackpotConsoleView:StopCountDown()
    if self.countDownTimer then
        LuaTimer:Remove(self.countDownTimer)
        self.countDownTimer = nil
        self:ShowSuperMatchBang()
    end
end

function JackpotConsoleView:OnDisable()
    Facade.RemoveViewEnhance(self)
    Event.RemoveListener(EventName.Event_MaxBetrateEnableJackpot, self.OnMaxBetRateEnableJackpot, self)
    self:DisposeFsm()
    isAutoFirstEnter = nil
    self:RemoveCountDownTimer()
    this.lastLockState = nil
end

function JackpotConsoleView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("JackpotConsoleView", self, {
        JackpotMaxBetRateState:New(),
        JackpotSmallBetRateState:New()
    })
    if ModelList.CityModel:IsMaxBetRate() then --or ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        self._fsm:StartFsm("JackpotMaxBetRateState")
    else
        self._fsm:StartFsm("JackpotSmallBetRateState")
    end
end

function JackpotConsoleView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function JackpotConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("HallMainAtlas")
    end
    local city_name_info = nil
    local playType       = Csv.GetData("city_play", playId, "play_type")
    if playType == PLAY_TYPE.PLAY_TYPE_NORMAL or playType == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        city_name_info = Csv.GetData("city", ModelList.CityModel:GetCity(), "jackpot_res")
    end

    ---1.20新增功能，此处加上向前兼容处理,在正式版可以删掉
    --if not city_name_info then
    --    local city_name = "jCityName%s"
    --    if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
    --        city_name = "jCityName_auto%s"
    --    end
    --    local cityName = string.format(city_name,ModelList.CityModel:GetCity())
    --    city_name_info= { "HallMainAtlas",cityName}
    --end
    if city_name_info and self.img_cityName and (not self.img_cityName or self.img_cityName.sprite.name ~= city_name_info[2]) then
        Cache.GetSpriteByName(city_name_info[1], city_name_info[2], function (sprite)
            if not IsNull(sprite) then
                self.img_cityName.sprite = sprite
            else
                log.e("加载失败  图集: "..city_name_info[1].."精灵: "..city_name_info[2])
            end
        end)
    end

    local jackpotId = Csv.GetData("city_play", ModelList.CityModel.GetPlayIdByCity(), "jackpot_rule_id")
    local jackpotData = nil
    if jackpotId then
        jackpotData = Csv.GetData("jackpot", jackpotId, "coordinate")
    end
    if jackpotData and fun.is_not_null(self.jGeZi) then
        local img1 = self.jGeZi.sprite
        local img2 = self.jGeZi2.sprite
        local img_list = {}
        for i = 1, 25 do
            local tran = fun.get_child(self.dish, i - 1)
            local img = nil
            if tran then
                img = fun.get_component(tran, fun.IMAGE)
                img_list[i - 1] = img
            end
            if img then
                --img.sprite = img1
                self:SetSprite(img, img2)
            end
        end
        for key, value in pairs(jackpotData) do
            if img_list[value - 1] then
                self:SetSprite(img_list[value - 1], img1)
                --img_list[value - 1].sprite = img2
            end
        end
    end

    self:ShowSuperMatchBang()
end

function JackpotConsoleView:SetSprite(sprite, sprite2)
    if sprite.sprite.name ~= sprite2.name then
        sprite.sprite = sprite2
    end
end

function JackpotConsoleView:SetJackpotReward()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local playType = Csv.GetData("city_play", playId, "play_type")
    local isNormalModel = playType == PLAY_TYPE.PLAY_TYPE_NORMAL or playType == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET
    --特殊处理的玩法，读city_play的jackpot_reward_new
    local specialFlag = playType == PLAY_TYPE.PLAY_TYPE_NEW_CHRISTMAS

    --单卡价格
    local playCardCost = ModelList.CityModel:GetCostCoin(1)
    if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        playCardCost = ModelList.CityModel:GetCostCoin(4) / 4
    end

    if isNormalModel or specialFlag then
        local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
        if reward then
            local BingoReward = Csv.GetBingoRewardOfPlayid(playId, 1)     -- 只取单bingo
            BingoReward = BingoReward / 100 or 0
            local rewardValue = BingoReward * reward * playCardCost / 100 --做分层
            self.text_reward:SetValue(rewardValue)
        end
    else
        local BingoReward = Csv.GetBingo4RewardOfPlayid(playId)
        BingoReward = BingoReward / 100 or 0
        local rewardValue = BingoReward * playCardCost
        self.text_reward:SetValue(rewardValue)
    end
end

function JackpotConsoleView:SetJackpotImages(atlasName)
    local betrate = ModelList.CityModel:GetBetRate() or 1
    if self.bet_bg_img[betrate] then
        Cache.GetSpriteByName(atlasName, self.bet_bg_img[betrate], function (sprite)
            self.jackpotBg.sprite = sprite
        end)
    end
    if self.title_img[betrate] then
        Cache.GetSpriteByName(atlasName, self.title_img[betrate], function (sprite)
            self.titleImg.sprite = sprite
        end)
    end
end

function JackpotConsoleView:initExtraInFo()
    local bet         = ModelList.CityModel:GetBetRate() or 1
    local flag, flag2 = ModelList.CityModel.isOpenExtra(bet) --读取固定城市看是不是可以开

    if flag then
        fun.set_active(self.OtherBonus, false)
        fun.set_active(self.bearBonus, true)
        fun.set_active(self.jBallDi, false)
        fun.set_active(self.jBall, false)
        fun.set_active(self.img_cityName, false)

        if not flag2 then --上锁
            fun.set_active(self.Extra_lock, true)
        else
            fun.set_active(self.Extra_lock, false)
        end
    else
        fun.set_active(self.OtherBonus, false)
        fun.set_active(self.bearBonus, false)
        fun.set_active(self.jBallDi, true)
        fun.set_active(self.jBall, true)
        fun.set_active(self.img_cityName, true)
    end

    --读取倍数，判断是否需要放开
end

function JackpotConsoleView:SetMaxBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "ultra_jackpot_consolein" }, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, { self.ConsoleInActionName, self.ConsoleInClipName }, false, nil)
    end

    if ModelList.CityModel:GetEnterGameMode() ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET or (not isAutoFirstEnter) then
        isAutoFirstEnter = true

        fun.set_active(self.jackpot_dish.transform, true, false)
        fun.set_active(self.jackpot_lock.transform, false, false)
    elseif ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        -- self:SetJackpotInfo()
    end

    self:SetJackpotInfo()
end

function JackpotConsoleView:SetSmallBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "ultra_jackpot_consolein" }, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, { self.ConsoleInActionName, self.ConsoleInClipName }, false, nil)
    end

    if ModelList.CityModel:GetEnterGameMode() ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        --    AnimatorPlayHelper.Play(self.anima,{"idle","jackpot_consoleidle"},false,nil)

        fun.set_active(self.jackpot_dish.transform, true, false)
        fun.set_active(self.jackpot_lock.transform, false, false)
        -- fun.set_active(self.jackpot_dish.transform,false,false)
        -- fun.set_active(self.jackpot_lock.transform,true,false)
    elseif ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        --self:SetJackpotInfo()
    end
    self:SetJackpotInfo()
end

--[[
    info ={
        id,
        cost
    }
]] --
function JackpotConsoleView:ShowOther(info)
    fun.set_active(self.OtherBonus, true)
    local head = fun.find_child(self.OtherHead, "head")
    local headBgSp = fun.get_component(head, fun.IMAGE)
    local data = Csv.GetData("robot_name", info.id, "icon")
    local namestr = Csv.GetData("robot_name", info.id, "name")
    if data then
        headBgSp.sprite = AtlasManager:GetSpriteByName("HeadAtlas", data)
    end
    self.OtherText.text = namestr
    self.OtherCount:RollByTime(info.cost, 0.5, function ()
        UISound.stop("coin_fly")
    end)

    LuaTimer:SetDelayFunction(MCT.rocket_emission_time, function ()
        fun.set_active(self.OtherBonus, false)
    end)
end

--更新额外奖励得数字
function JackpotConsoleView:UpdateExtraCount(cost)
    self.ExtraCount:RollByTime(cost, 0.5, function ()
        UISound.stop("coin_fly")
    end)
end

function JackpotConsoleView:OnMaxBetRateEnableJackpot(betRate)
    self._fsm:GetCurState():BetRateChangeCheckJackpot(self._fsm)
end

function JackpotConsoleView:OnGroupPrefixRefresh()
    self:SetJackpotInfo()
end

function JackpotConsoleView:ResetInitState()
    self.isInit = false
end

-------------------------region锤力器------------------------------

---增加锤力器展示
function JackpotConsoleView:ShowSuperMatchBang()
    --基于此状态只能单向转换，且prefab的默认状态
    if not ModelList.SmallGameModel:IsLevelEnough() then
        log.log("JackpotConsoleView:ShowSuperMatchBang error 玩家等级不够")
        return
    end

    if not ModelList.SmallGameModel:IsPlayIdInAllowList() then
        self:ShowOriginalUI()
        return
    end

    if ModelList.SmallGameModel:CanOpenGameForBet() then
        if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
            self:ShowUltraBetBang()
        else
            self:ShowNormalBang()
        end
    else
        self:ShowUnlock(false)
    end
end

--- UltraBet开启时，锤力器展示
function JackpotConsoleView:ShowUltraBetBang()
    self:ShowUnlock(true)
    fun.set_active(self.jBall, false)
    fun.set_active(self.jBallDi, false)
    fun.set_active(fun.find_child(self.anima, "Root/kuang"), false)
    fun.set_active(fun.find_child(self.anima, "Root/CountDown"), false)
    --fun.set_active(fun.find_child(self.anima, "Root/CountDown2"), true)
end

--- 未开启UltraBet,锤力器展示
function JackpotConsoleView:ShowNormalBang()
    local isUnlock = ModelList.SmallGameModel:CanOpenGameForBet()
    self:ShowUnlock(isUnlock, function()
        local isUnlock = ModelList.SmallGameModel:CanOpenGameForBet()
        fun.set_active(self.SmallGameLock, not isUnlock)
    end)
    fun.set_active(self.jBallDi, false)
    fun.set_active(self.jBall, false)
    fun.set_active(self.img_cityName, false)
end

function JackpotConsoleView:ShowUnlock(isUnlock, finishCb)
    self.CheckSmallGameCallBack = function ()
        fun.set_active(self.SmallGameUnlock, isUnlock)
        if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_NORMAL then
            if not isUnlock then
                local activeState = ModelList.SmallGameModel:IsOpenTime() and (not isUnlock) or isUnlock
                local activeState2 = not ModelList.SmallGameModel:IsOpenTime()
                fun.set_active(self.SmallGameLockObj, activeState)
                fun.set_gameobject_pos(self.SmallGameLockObj, 0, 0, 0, true)
                fun.set_active(self.SmallGameLock, activeState)
                fun.set_active(self.jBallDi, activeState2)
                fun.set_active(self.jBall, activeState2)
                fun.set_active(self.img_cityName, activeState2)
            end
            if isUnlock and this.lastLockState ~= nil and this.lastLockState == isUnlock then
                self.SmallGameUnlockObj:Play("act")
            end
        end
        this.lastLockState = isUnlock
        if finishCb then
            finishCb()
        end
    end
    self.loadCompleteCount = 0
    self:CheckLoadSmallGame()
end

function JackpotConsoleView:ShowOriginalUI()
    fun.set_active(self.SmallGameUnlock, false)
    fun.set_active(self.SmallGameLock, false)
    fun.set_active(self.jBallDi, true)
    fun.set_active(self.jBall, true)
    fun.set_active(self.img_cityName, true)
    self.lastLockState = nil
end

function JackpotConsoleView:on_btn_super_bang_click()
    this:ShowSuperMatchBangView()
end

function JackpotConsoleView:on_btn_super_bang2_click()
    this:ShowSuperMatchBangView()
end

function JackpotConsoleView:ShowSuperMatchBangView()
    local viewName = ModelList.SmallGameModel.GetCurrentGameHelperInfo()
    ViewList[viewName] = require("View.HallCity.SmallGame."..viewName)
    Facade.SendNotification(NotifyName.ShowUI, ViewList[viewName])
end

--- 检查引导是否触发
function JackpotConsoleView:CheckGuideTrigger(isNormal)
    if ModelList.GuideModel:IsGuiding() or not CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        return
    end
    if isNormal then
        if not ModelList.GuideModel:IsGuideComplete(80) then
            ModelList.GuideModel:TriggerSuperMatchBangGuide(572)
        end
    else
        if not ModelList.GuideModel:IsGuideComplete(81) then
            ModelList.GuideModel:TriggerSuperMatchBangGuide(574)
        end
    end
end

-------------------------endRegion锤力器------------------------------


-------------------------Region 小游戏------------------------------
function JackpotConsoleView:CheckLoadSmallGame()
    if (fun.is_null(self.SmallGameUnlockObj) and self.SmallGameUnlock) or (fun.is_null(self.SmallGameLockObj) and self.SmallGameLock) then
        local lockName, unlockName = ModelList.SmallGameModel.GetCurrentGamePrefabName()
        if lockName ~= nil or unlockName ~= nil then
            if fun.is_null(self.SmallGameUnlockObj) and self.SmallGameUnlock then
                Cache.load_prefabs(AssetList[unlockName], unlockName, function (prefab)
                    if fun.is_not_null(self.SmallGameUnlockObj) then
                        log.log("JackpotConsoleView:CheckLoadSmallGame() 已经加载过 SmallGameUnlockObj")
                        Destroy(self.SmallGameUnlockObj)
                    end
                    local obj = fun.get_instance(prefab, self.SmallGameUnlock)
                    self:TryGetLeftTimeTxt(obj, "leftTime1")
                    if obj then
                        self.SmallGameUnlockObj = fun.get_component(obj, fun.ANIMATOR)
                    end
                    if not self.SmallGameUnlockObj then
                        self.SmallGameUnlockObj = obj
                    end
                    self:UpdateLoadCompleteCount()
                end)
            else
                self:UpdateLoadCompleteCount()
            end

            if fun.is_null(self.SmallGameLockObj) and self.SmallGameLock then
                Cache.load_prefabs(AssetList[lockName], lockName, function (prefab)
                    if fun.is_not_null(self.SmallGameLockObj) then
                        log.log("JackpotConsoleView:CheckLoadSmallGame() 已经加载过 SmallGameLockObj")
                        Destroy(self.SmallGameLockObj)
                    end
                    
                    self.SmallGameLockObj = fun.get_instance(prefab, self.SmallGameLock)
                    if self.SmallGameLockObj then
                        self:TryGetLeftTimeTxt(self.SmallGameLockObj, "leftTime2")
                    end
                    self:UpdateLoadCompleteCount()
                end)
            else
                self:UpdateLoadCompleteCount()
            end
        else
            self:DirectFinishLoad()
        end
    else
        self:DirectFinishLoad()
    end
end

function JackpotConsoleView:UpdateLoadCompleteCount()
    self.loadCompleteCount = self.loadCompleteCount or 0
    self.loadCompleteCount = self.loadCompleteCount + 1
    self:OnLoadComplete()
end

function JackpotConsoleView:DirectFinishLoad()
    self.loadCompleteCount = 2
    self:OnLoadComplete()
    self.loadCompleteCount = nil
end

--- 当预设加载完成后,执行一次
function JackpotConsoleView:OnLoadComplete()
    if self.loadCompleteCount == 2 and self.CheckSmallGameCallBack then
        self.CheckSmallGameCallBack()
        self:StartCountDown()
        self.CheckSmallGameCallBack = nil
        self.loadCompleteCount = nil
    end
end

---Ultrabet开关,切换到新窗口下
function JackpotConsoleView:SwitchUltrabetConsoleParent()
    if fun.is_not_null(self.SmallGameUnlockObj) then
        fun.set_parent(self.SmallGameUnlockObj, self.SmallGameUnlock)
    end
    if fun.is_not_null(self.SmallGameLockObj) then
        fun.set_parent(self.SmallGameLockObj, self.SmallGameLock)
    end
end

function JackpotConsoleView:OnMiniGameTypeChange()
    if self.SmallGameLockObj then
        Destroy(self.SmallGameLockObj)
        self.SmallGameLockObj = nil
    end
    if self.SmallGameUnlockObj then
        Destroy(self.SmallGameUnlockObj)
        self.SmallGameUnlockObj = nil
    end
end

function JackpotConsoleView:TryGetLeftTimeTxt(obj,target)
    if obj then
        local txtObj = fun.find_child(obj,"LeftTime")
        if txtObj then
            local txt = fun.get_component(txtObj,fun.OLDTEXT)
            if txt then
                self[target] = txt
            end
        end
    end
end

-------------------------endRegion 小游戏------------------------------


this.NotifyList = {
    { notifyName = NotifyName.ExtraBonus.ShowOthGetReward, func = this.ShowOther },
    { notifyName = NotifyName.ExtraBonus.ShowRewardCount,  func = this.UpdateExtraCount }
}

--设置消息通知
this.NotifyEnhanceList =
{
    { notifyName = NotifyName.PlayerInfo.RefreshGroupPrefix, func = this.OnGroupPrefixRefresh },
}

return this
