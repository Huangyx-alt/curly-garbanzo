local WinZoneReadyView = BaseDialogView:New()
local this = WinZoneReadyView
this.__index = this
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
this.auto_bind_ui_items = {
    "img_countdown",
    "root",
    "competition",
    "jokerPos",
    "Img_getReady",
    "JackpotList",
    "CurRoundText",
    "CurRoundBg",
    "FinalRoundTip",
}

this.can_start_num_inscrease = false
this.can_start_power_fly = false
this.power_up_card = 0
this.itemList = {}

local IsPlayReady = false
local RoundBg2Image = {
    "WinzonTtRoundDi",      --1
    "WinzonTtRoundDi2",     --2
    "WinzonTtRoundDi3",     --3
    "WinzonTtRoundDi4",     --4
    "WinzonTtRoundDi4",     --5
    "WinzonTtRoundDi4",     --6
    "WinzonTtRoundDi5",     --7
    "WinzonTtRoundDi5",     --8
    "WinzonTtRoundDi5",     --9
}

function WinZoneReadyView.Awake()
    this:on_init()
    LuaTimer:Clear(LuaTimer.TimerType.UI)
end

local InitEnableTimeContent = function()
    local countdowns = Csv.GetData("control", 34, "content")
    if ModelList.GuideModel:IsFirstBattle() then
        countdowns = { { 3 } }
    end
    this.img_countdown.text = countdowns[1][1]
end

function WinZoneReadyView.OnEnable()
    this.can_start_num_inscrease = false
    this.can_start_power_fly = false
    IsPlayReady = false
    this.update_x_enabled = true
    this:start_x_update()
    InitEnableTimeContent()
    this.Register()
    --this:StartCompetitionRank()
    this:ShowJackpot()

    local data = ModelList.WinZoneModel:GetPlayReadyData()
    local curRound = data and data.curRound or 1
    this.CurRoundText.text = curRound
    local imgName = RoundBg2Image[data.curRound] or RoundBg2Image[1]
    this.CurRoundBg.sprite = AtlasManager:GetSpriteByName("WinZonePromote1Atlas", imgName)

    local isLastRound = ModelList.WinZoneModel:IsInLastRound()
    fun.set_active(this.CurRoundText.transform.parent, not isLastRound)
    fun.set_active(this.FinalRoundTip, isLastRound)
end

function WinZoneReadyView:OnDisable()
    this.itemList = {}
end

local StartPlayReady = function()
    if not ModelList.GuideModel:IsGuideComplete(67) then
        ModelList.GuideModel:TriggerWinZoneBattleGuide(319)
    end
    
    this.StartCountdown()
    UISound.play("city1_loading_over")
    LuaTimer:SetDelayFunction(MCT.DelayPlayWhipse, function()
        UISound.play_loop("whisper")
    end, nil, LuaTimer.TimerType.Battle)
    Event.Brocast(Notes.CLEAR_DELAY_TIMMER)
end

function WinZoneReadyView:on_x_update()
    if not IsPlayReady then
        local stateInfo = this.root:GetCurrentAnimatorStateInfo(0)
        if (stateInfo:IsName("time_start") or stateInfo:IsName("time_start2") or stateInfo:IsName("time_idle")) and stateInfo.normalizedTime > 0.95 then
            IsPlayReady = true
            StartPlayReady()
        end
    end
end

function WinZoneReadyView.StartCountdown()
    local countdowns = Csv.GetData("control", 34, "content")
    if ModelList.GuideModel:IsFirstBattle() then
        countdowns = { { 3 } }
        this.img_countdown.text = countdowns[1][1]
    end
    this.countdown = tonumber(countdowns[1][1])
    if ModelList.GMModel.IsBattleAccele then
        this.countdown = this.countdown / 2
    end

    local cards = ModelList.BattleModel:GetCurrModel():GetPowerUps()
    this.power_up_card = #cards
    this.timerId = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
        if this.countdown and this.countdown > 0 then
            this.img_countdown.text = this.countdown

            local ani = fun.get_component(this.img_countdown.gameObject, fun.ANIMATOR)
            ani:Play("GetReady_Count1")

            this.PlayCountDownSound()

            if this.countdown == 5 then
                --this:UnloadLobby()
            end
            if this.countdown == 3 then

            end
            if this.countdown == 2 then 
                this:PlayLastRoundSound()
                
                local city = ModelList.CityModel:GetCity()
                local playId = ModelList.CityModel.GetPlayIdByCity()
                local city_music = Csv.GetData("city_play", playId, "music")
                UISound.play_bgm(city_music)
                UISound.set_bgm_volume(0.7)
                UISound.max_fade_in_bgm()
                UISound.tween_out_music("whisper.mp3", 2, 1, 0.7, nil)
                --UISound.play_loop("whisper")
                Event.Brocast(EventName.CardEffect_Enter_Effect)
                Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease)
                LuaTimer:SetDelayFunction(0.7, function()
                    Event.Brocast(Notes.START_POWERUP_ENABLE)
                end, nil, LuaTimer.TimerType.Battle)
            end
            if this.countdown == 1 then
                Event.Brocast(EventName.CardEffect_Drop_All_Cell_Item)
            end
            this.countdown = this.countdown - 1
        else
            this.StopCountdown()
            if this.countdown <= 0 then
                Event.Brocast(Notes.BINGO_TIME_COUNT_OVER)
            end
            this:Exit()
        end
    end, nil, nil, LuaTimer.TimerType.Battle)
end

function WinZoneReadyView.StopCountdown()
    if this.timerId then
        LuaTimer:Remove(this.timerId)
        this.timerId = nil
    end
end

function WinZoneReadyView:UnloadLobby()
    local lobby = require("Logic.Bundle.UnloadLobbyBundle")
    lobby:StartUnload()
end

function WinZoneReadyView:Exit()
    this.root:Play("time_end")
    if this.delay_show then
        LuaTimer:Remove(this.delay_show)
        this.delay_show = nil
    end
    LuaTimer:SetDelayFunction(1, function()
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(5)
        Facade.SendNotification(NotifyName.CloseUI, ViewList.WinZoneReadyView)
        Event.Brocast(EventName.Event_Preload_Bingo_Effect)
    end, nil, LuaTimer.TimerType.BattleUI)
end

function WinZoneReadyView:on_close()
    this.StopCountdown()
    this.UnRegister()
    this:UnloadLobby()
    --- 3s后卸载准备界面资源
    LuaTimer:SetDelayFunction(3, function()
        local sceneName = fun.get_active_scene().name
        if ModelList.BattleModel:IsGameing() and sceneName ~= "SceneHome" then
            this:UnloadBattleReady()
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function WinZoneReadyView:UnloadBattleReady()
    UISound.unload_sound_data_in_need(1)
end

function WinZoneReadyView.OnDestroy()
    this:Close()
    UISound.unload_sound_data_in_need(1)
end

---开始日榜入场
--function WinZoneReadyView:StartCompetitionRank()
--    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
--    local rankData = dependentFile:GetCompetitionRankData()
--
--    if self.competition and rankData then
--        self.root:Play("time_start2")
--
--        local info = dependentFile:GetDenpendentInfo()
--        local readyViewName = info.readyViewName
--        Cache.load_prefabs(AssetList[readyViewName], readyViewName, function(obj)
--            if obj then
--                local go = fun.get_instance(obj, self.competition)
--                if go then
--                    local CompetitionReadyView = require(info.readyViewPath)
--                    self.comptition_view = CompetitionReadyView:New()
--                    self.comptition_view:SkipLoadShow(go)
--                    --fun.set_gameobject_pos(go,0,0,0,true)
--                    fun.set_rect_local_pos_y(go, 0)
--                end
--            end
--        end)
--    end
--end

function WinZoneReadyView.New()
    local o = {}
    setmetatable(o, WinZoneReadyView)
    o.__index = o
    return o;
end

function WinZoneReadyView.StartTimeDown()

end

function WinZoneReadyView.PlayCountDownSound()
    local cityPlayID = ModelList.BattleModel:GetGameCityPlayID()
    if cityPlayID == 13 then
        --糖果玩法自定义倒计时音效
        UISound.play("candysweetscountdown")
    else
        UISound.play("countdown")
    end
end

function WinZoneReadyView.Register()
    Event.AddListener(EventName.Guide_Allow_Time_Down, this.StartTimeDown)
end

function WinZoneReadyView.UnRegister()
    Event.RemoveListener(EventName.Guide_Allow_Time_Down, this.StartTimeDown)
end

function WinZoneReadyView:ShowJackpot()
    UISound.play("winzoneRandompattern")
    
    for i = 1, 25, 1 do
        local item = fun.find_child(this.JackpotList, tostring(i - 1))
        table.insert(this.itemList, item)
    end

    local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
    local jackpotRuleId = loadData.jackpotRuleId
    if jackpotRuleId then
        local jackpotRule = Csv.GetData("jackpot", jackpotRuleId[1], "coordinate")
        table.each(jackpotRule, function(cellIndex)
            fun.set_active(this.itemList[cellIndex], true)
        end)
    end
end

function WinZoneReadyView:PlayLastRoundSound()
    if not ModelList.WinZoneModel:IsInLastRound() then
        return
    end

    UISound.play("winzoneLastbattle")
end

return this

