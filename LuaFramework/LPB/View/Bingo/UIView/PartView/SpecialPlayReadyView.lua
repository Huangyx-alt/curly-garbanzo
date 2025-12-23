local SpecialPlayReadyView = BaseDialogView:New()
local this = SpecialPlayReadyView
this.__index = this
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
this.auto_bind_ui_items = {
    "img_countdown",
    "root",
    "competition",--我自己 的头像
    "jokerPos",
}

this.can_start_num_inscrease = false
this.can_start_power_fly = false
this.power_up_card = 0



local IsPlayReady = false

function SpecialPlayReadyView.Awake()
    --Facade.RegisterView(this)
    this:on_init()
    LuaTimer:Clear(LuaTimer.TimerType.UI)
end

local InitEnableTimeContent = function()
    local countdowns = Csv.GetData("control",34,"content")
    if ModelList.GuideModel:IsFirstBattle() then
        countdowns = {{3}}
    end
    this.img_countdown.text = countdowns[1][1]
end

function SpecialPlayReadyView.OnEnable(self, params)
    this.params = params or {}
    this.can_start_num_inscrease = false
    this.can_start_power_fly = false
    IsPlayReady = false
    this.update_x_enabled = true
    this:start_x_update()
    InitEnableTimeContent()
    this.Register()
    --this:StartCompetitionRank()
    this.DealSpecialUI()
end

local StartPlayReady = function()
    this.StartCountdown()
    UISound.play("city1_loading_over")
    LuaTimer:SetDelayFunction(MCT.DelayPlayWhipse,function()
        UISound.play_loop("whisper")
    end,nil,LuaTimer.TimerType.Battle)
    Event.Brocast(Notes.CLEAR_DELAY_TIMMER)
end


function SpecialPlayReadyView:on_x_update()
    if not IsPlayReady then
        local stateInfo = this.root:GetCurrentAnimatorStateInfo(0)
        if  (  stateInfo:IsName("time_start")  or stateInfo:IsName("time_start2") or  stateInfo:IsName("time_idle") )  and  stateInfo.normalizedTime>0.95 then
            IsPlayReady = true
            StartPlayReady()
        end
    end
end


function SpecialPlayReadyView.StartCountdown()
    local countdowns = Csv.GetData("control",34,"content")
    if ModelList.GuideModel:IsFirstBattle() then
        countdowns = {{3}}
        this.img_countdown.text = countdowns[1][1]
    end
    this.countdown = tonumber(countdowns[1][1])
    local  cards = ModelList.BattleModel:GetCurrModel():GetPowerUps()
    this.power_up_card = #cards
    this.timerId = LuaTimer:SetDelayLoopFunction(0,1,-1, function()
        if this.countdown and this.countdown > 0 then
            this.img_countdown.text = this.countdown

            local ani = fun.get_component(this.img_countdown.gameObject,fun.ANIMATOR)
            if ani then
                ani:Play("GetReady_Count1")
            end
            
            this.PlayCountDownSound(this.countdown)
            
            if this.countdown == 5 then
                --this:UnloadLobby()
            end
            if  this.countdown == 3 then

            end
            if this.countdown == 2 then
                local city = ModelList.CityModel:GetCity()
                local playId = ModelList.CityModel.GetPlayIdByCity()
                local city_music =  Csv.GetData("city_play",playId,"music")
                UISound.play_bgm(city_music)
                UISound.set_bgm_volume(0.7)
                UISound.max_fade_in_bgm()
                UISound.tween_out_music("whisper.mp3", 2, 1, 0.7, nil)
                --UISound.play_loop("whisper")
                
                if this.params and this.params.onBattleStart then
                    fun.SafeCall(this.params.onBattleStart)
                else
                    Event.Brocast(EventName.CardEffect_Enter_Effect)
                    Facade.SendNotification(NotifyName.Bingo.StartBingosleftIncrease)
                    LuaTimer:SetDelayFunction(0.7,function()
                        Event.Brocast(Notes.START_POWERUP_ENABLE)
                    end,nil,LuaTimer.TimerType.Battle)
                end
            end
            if this.countdown == 1 then
                if this.params and this.params.onBattleStart then
                else
                    Event.Brocast(EventName.CardEffect_Drop_All_Cell_Item)
                end
            end
            this.countdown = this.countdown - 1
        else
            this.StopCountdown()
            if this.countdown <= 0 then
                Event.Brocast(Notes.BINGO_TIME_COUNT_OVER)
            end
            this:Exit()
        end
    end,nil, nil,LuaTimer.TimerType.Battle)
end

function SpecialPlayReadyView.StopCountdown()
    if this.timerId then
        LuaTimer:Remove(this.timerId)
        this.timerId = nil
    end
end

function SpecialPlayReadyView:UnloadLobby()
    local lobby = require("Logic.Bundle.UnloadLobbyBundle")
    lobby:StartUnload()
end

function SpecialPlayReadyView:Exit()
    this.root:Play("time_end")
    if this.delay_show then
        LuaTimer:Remove(this.delay_show)
        this.delay_show = nil
    end
    LuaTimer:SetDelayFunction(1,function()
        ModelList.BattleModel:GetCurrBattleView():SetReadyForPreUseItem(5)
        Facade.SendNotification(NotifyName.CloseUI,ViewList.SpecialPlayReadyView)
        if this.params and this.params.onBattleStart then
            
        else
            Event.Brocast(EventName.Event_Preload_Bingo_Effect)
        end
    end,nil,LuaTimer.TimerType.BattleUI)

    this.params = {}
end

function SpecialPlayReadyView:on_close()
    this.StopCountdown()
    this.UnRegister()
    this:UnloadLobby()
    --- 3s后卸载准备界面资源
    LuaTimer:SetDelayFunction(3,function()
        local sceneName  =  fun.get_active_scene().name
        if ModelList.BattleModel:IsGameing()  and sceneName~="SceneHome"   then
            this:UnloadBattleReady()
        end
    end,nil,LuaTimer.TimerType.Battle)
    --resMgr:ShowLoadAssetBundle()
    --UnityEngine.AssetBundle.UnloadAllAssetBundles(false)
end

function SpecialPlayReadyView:UnloadBattleReady()
    UISound.unload_sound_data_in_need(1)
end

function SpecialPlayReadyView.OnDestroy()
    this:Close()
    UISound.unload_sound_data_in_need(1)
end


---开始日榜入场
--function SpecialPlayReadyView:StartCompetitionRank()
    --local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    --local rankData = dependentFile:GetCompetitionRankData()
    --
    --if self.competition and rankData then
    --    self.root:Play("time_start2")
    --
    --    local info = dependentFile:GetDenpendentInfo()
    --    local readyViewName = info.readyViewName
    --    Cache.load_prefabs(AssetList[readyViewName],readyViewName,function(obj)
    --        if obj then
    --            local go = fun.get_instance(obj,self.competition)
    --            if go then
    --                local CompetitionReadyView = require(info.readyViewPath)
    --                self.comptition_view = CompetitionReadyView:New()
    --                self.comptition_view:SkipLoadShow(go)
    --                --fun.set_gameobject_pos(go,0,0,0,true)
    --                fun.set_rect_local_pos_y(go,0)
    --            end
    --        end
    --    end)
    --end
--end

function SpecialPlayReadyView.New()
    local o = {}
    setmetatable(o, SpecialPlayReadyView)
    o.__index = o
    return o;
end

function SpecialPlayReadyView.StartTimeDown()

end

function SpecialPlayReadyView.PlayCountDownSound(countDown)
    local playType = ModelList.BattleModel:GetGameType()
    if cityPlayID == PLAY_TYPE.PLAY_TYPE_LOOK_FOR_CANDY then
        --糖果玩法自定义倒计时音效
        UISound.play("candysweetscountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_GOLDEN_PIGGY then
        UISound.play("goldenpigCountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_GOLDEN_DRAGON then
        UISound.play("dragonCountdown")    
    elseif playType == PLAY_TYPE.PLAY_TYPE_NEW_GREEN_HEAD then
        UISound.play("newleetolemancountdown")    
    elseif playType == PLAY_TYPE.PLAY_TYPE_EASTER_DAY then
        UISound.play("eastercountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_VOLCANO_PATH then
        UISound.play("lavacountdown")   
    elseif playType == PLAY_TYPE.PLAY_TYPE_PIRATE_PATH then
        UISound.play("piratecountdown")   
    elseif playType == PLAY_TYPE.PLAY_TYPE_CAT_THIEF then
        UISound.play("thievescountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_MINING then
        UISound.play("minercountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_BISON then
        if countDown > 3 then
            UISound.play("bisoncountdown")
        elseif countDown == 3 then
            UISound.play("bisonbuffalo")
        end
    elseif playType == PLAY_TYPE.PLAY_TYPE_HORSE_RACE then
        UISound.play("horseracingcountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_SCRATCH_WINNER then
        UISound.play("scratchwinnercountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_GOLD_TRAIN then
        UISound.play("goldentraincountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_CHRISTMAS_SYNTHESIS then
        UISound.play("santablessingcountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_THREE_PIGS then
        UISound.play("gotyoucountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_LET_THEM_ROLL then
        UISound.play("letemrollcountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_PIGGY_BANK then
        UISound.play("piggybankcountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_SOLITAIRE then
        UISound.play("solitairecountdown")
    elseif playType == PLAY_TYPE.PLAY_TYPE_MONOPOLY then
        UISound.play("monopolycountdown")
    else
        UISound.play("countdown")  
    end
end

function SpecialPlayReadyView.DealSpecialUI()
    local playType = ModelList.BattleModel:GetGameType()
    if playType == PLAY_TYPE.PLAY_TYPE_MINING then
        this.DealMoleMineSpecialUI()
    elseif playType == PLAY_TYPE.PLAY_TYPE_PIRATE_PATH then
        this.DealPirateShipSpecialUI()
    elseif playType == PLAY_TYPE.PLAY_TYPE_SOLITAIRE then
        this.DealSolitaireSpecialUI()
    end
end

function SpecialPlayReadyView.DealMoleMineSpecialUI()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local ref = fun.get_component(this.go, fun.REFER)
    if fun.is_not_null(ref) then
        for i = 1, 4 do
            local itemImg = ref:Get("img_item" .. i)
            if fun.is_not_null(itemImg) then
                local imgName = curModel:GetMineralImageNameByIdxAndLevel(i, collectLevel)
                itemImg.sprite = AtlasManager:GetSpriteByName("MoleMinerBingoAtlas", imgName)
            end
        end
    end
end

function SpecialPlayReadyView.DealPirateShipSpecialUI()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local collectLevel = curModel:GetCurrentCollectLevel()
    local ref = fun.get_component(this.go, fun.REFER)
    if fun.is_not_null(ref) then
        local itemImg = ref:Get("icon")
        if fun.is_not_null(itemImg) then
            local imgName = curModel:GetTargetImageNameByLevel(collectLevel, "ready")
            itemImg.sprite = AtlasManager:GetSpriteByName("PirateShipBingoAtlas", imgName)
        end
    end
end

function SpecialPlayReadyView.DealSolitaireSpecialUI()
    local curModel = ModelList.BattleModel:GetCurrModel()
    local ref = fun.get_component(this.go, fun.REFER)
    if fun.is_not_null(ref) then
        local itemImg1 = ref:Get("icon1")
        local itemImg2 = ref:Get("icon2")
        if fun.is_not_null(itemImg1) and fun.is_not_null(itemImg2) then
            if curModel:IsTriggerExtraReward() then
                fun.set_active(itemImg1, false)
                fun.set_active(itemImg2, true)
            else
                fun.set_active(itemImg1, true)
                fun.set_active(itemImg2, false)
            end
        end
    end
end

function SpecialPlayReadyView.Register()
    Event.AddListener(EventName.Guide_Allow_Time_Down,this.StartTimeDown)
end

function SpecialPlayReadyView.UnRegister()
    Event.RemoveListener(EventName.Guide_Allow_Time_Down,this.StartTimeDown)
end


return this

