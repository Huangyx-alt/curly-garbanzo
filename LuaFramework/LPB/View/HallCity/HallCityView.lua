
---@class HallCityView :BaseView
---
--require "View/CommonView/TopCurrencyView"
require "View/CommonView/ShowHeadView"
--require "View/CommonView/TopQuickTaskView"
--require "View.CommonView.TopCompetitionView"

--require "View/HallCity/CityLevelProgressView"
local FunctionIconView = require "View/CommonView/FunctionIconView"

local GiftPackEnterView = require "View/CommonView/GiftPackEnterView"
--require "View.Popup.FoodBagClaimView"

require "State/HallCityView/BaseHallCityState"
require "State/HallCityView/HallCityOriginalState"
require "State/HallCityView/HallCityEnterState"
require "State/HallCityView/HallCityStiffState"
require("View.Bingo.EffectPool.HomeEffectCache")

local DownloadUtility =  require "View/CommonView/DownloadUtility"

HallCityView = TrunkControllerView:New('HallCityView')
local this = HallCityView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

--local _currency = TopCurrencyView:New(nil,nil,"HallCityView",false,nil,RedDotNode.city_top_shop)
--local _topQuickTask = TopQuickTaskView:New(true,ParasitiferType.mainCity)

--local _cityLevel = CityLevelProgressView:New()

local _giftpack = GiftPackEnterView:New()
local _DownloadUtility = DownloadUtility:New(AD_EVENTS.AD_EVENTS_SEASON_UP)

local _tournamentEntrance = require "View/HallCity/TournamentEntrance"
local _hallofFameEntrance = require "View/HallCity/HallofFameEntrance"
local _winzoneEntrance = require "View/HallCity/WinZoneEntrance"

local _functionIcon = nil

--local openTournamentType =
--{
--    ClickIcon = "ClickIcon",
--    CountDownEnd = "CountDownEnd",
--    Idle = "Idle",
--}

local openHallofFameType =
{
    ClickIcon = "ClickIcon",
    CountDownEnd = "CountDownEnd",
    Idle = "Idle",
}
--
--local currentOpenTournamentType = openTournamentType.Idle
--local currentOpenHallofFameType = openHallofFameType.Idle

this.auto_bind_ui_items = {
    --"TopCurrency",
    "top_left_content",
    "top_right_content",
    "center_right_content",
    "countdown_function",
    --"btn_goback",
    "btn_club",
    "btn_slots",
    "btn_city",
    "btn_bingo",
    "anima",
    "TopQuickTask",
    "column3",
    "TurnPage",
    "btn_turnleft",
    "btn_turnright",
    "img_bingo",
    "bingo_lock",
    --"CityLevelProgress",
    --"citylevelgroup",
    --"img_coverage",
    --"regularlyAward",
    "GiftPack",
    --"TopQuickTask_popup",
    "img_reddot_auto",
    "img_reddotleft",
    "img_reddotright",
    "trophy_lock",
    "IconRoot",
    "bingoLock",
    "center_left_content",
    "TournamentTitle",
    "TournamentTime",
    "center_left_content",
    --"TopCompetitionView",
    "CompetitionRoot",
    "TournamentBuffBg",
    "TournamentBuffTime",
    "club_lock",
    "img_reddotleft_club",
    "btn_winzone",
    "winzon_lock",
    "bottom_left_content",
    "RightIconArea",
    "LeftIconArea",
    "toggleBingoHall",
    "toggleVipRoom",
    "bingoHallOffParam",
    "bingoHallOnParam",
    "vipRoomOffParam",
    "vipRoomOnParam",
    "vipRoomParent",
    "btn_vip_attr",
    
}

function HallCityView:OpenView(callback,active,occasion)
    Facade.SendNotification(NotifyName.HallCity.ShowCityMainView,this,function()
        if callback then
            callback()
        end
    end,active,occasion)
end

function HallCityView:CloseView(callback)
    Facade.SendNotification(NotifyName.HideUI,this)
end

function HallCityView:UpdateCompetitionView(needPop)
    --判断是否是过期obj
    if fun.is_not_null(self.TopCompetitionView) then
        local name = self.TopCompetitionView.transform.name
        local isCookie = string.find(name, "Cookie")
        if isCookie then
            if not ModelList.CompetitionModel:IsActivityAvailable() then
                self._topCompetition = nil
                Destroy(self.TopCompetitionView)
                self.TopCompetitionView = nil
            end
        else
            if not ModelList.CarQuestModel:IsActivityAvailable() then
                self._topCompetition = nil
                Destroy(self.TopCompetitionView)
                self.TopCompetitionView = nil
            end
        end
    end
    
    if self.TopCompetitionView and self._topCompetition then
        self._topCompetition:CheckActivity(self.TopCompetitionView)
    end
    
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local topCompetitionView = dependentFile:GetCompetitionView()
    if topCompetitionView then
        if not self._topCompetition then
        self._topCompetition = topCompetitionView:New(true, ParasitiferType.mainCity)
        end
        if not self.TopCompetitionView then
            self:CheckCompetitionObj(self.TopCompetitionView, self, needPop)
            if self.TopCompetitionView and self._topCompetition then
                self._topCompetition:CheckActivity(self.TopCompetitionView)
            end
        end
    else
        self._topCompetition = nil
        
        if fun.is_not_null(self.TopCompetitionView) then
            Destroy(self.TopCompetitionView)
        end
        self.TopCompetitionView = nil
    end
end

function HallCityView:Awake(obj)
    --this.update_x_enabled = true
    self:on_init()
    ----[[
    --_functionIcon = FunctionIconView:New(FunctionIconView.belong2Type.hallmain
    --,self.top_left_content
    --,self.top_right_content
    --,self.center_right_content
    --,self.center_left_content
    --,self.bottom_left_content)
    ----_functionIcon:ShowIcon()
---
    _functionIcon = FunctionIconView:New(FunctionIconView.belong2Type.hallmain
    ,self.LeftIconArea
    ,self.RightIconArea)
    self:BindToggleFunc()
    fun.set_active(self.img_bingo,false)
    --]]
end

function HallCityView:OnEnable()
    fun.set_active(self.btn_vip_attr, false)
    
    ---[[不要在OnEnable里处理其他功能了，请在入场动画播完的回调里处理，要不在低端机会卡入场动画显示不出来完整ui
    Facade.RegisterView(self)
    --self:SetTournamentActivityType(openTournamentType.Idle)
    --self:SetHallofFameActivityType(openHallofFameType.Idle)

    --_currency:SkipLoadShow(self.TopCurrency)
    --_topQuickTask:CheckActivity(self.TopQuickTask)

    self:UpdateCompetitionView()
    
    --_cityLevel:SkipLoadShow(self.CityLevelProgress)
    --_regularlyAward:SkipLoadShow(self.regularlyAward)

    _giftpack:SkipLoadShow(self.GiftPack)

    _functionIcon:OnEnable()
    _tournamentEntrance:OnEnable({
        self.btn_slots,
        self.trophy_lock,
        self.TournamentTitle,
        self.TournamentTime,
        self.TournamentBuffBg,
        self.TournamentBuffTime,
    })
    _hallofFameEntrance:OnEnable({
        self.btn_slots,
        self.trophy_lock,
        self.TournamentTitle,
        self.TournamentTime,
        self.TournamentBuffBg,
        self.TournamentBuffTime,
    })
    _winzoneEntrance:OnEnable(self.btn_winzone)
    self:BuildFsm("HallCityView")

    self:UpdateBtnLock()
    self:SetCurrentCityIndex()
    self:initBingoBtn() --设置底下的bingo
    self._fsm:GetCurState():EnterHallCity(self._fsm)
    self:AddTournamentNextOpenTimeCountDownEvent()
    self:AddHallofFameNextOpenTimeCountDownEvent()
    self:RegisterEvent()
    --]]不要在OnEnable里处理其他功能了，请在入场动画播完的回调里处理，要不在低端机会卡入场动画显示不出来完整ui
end

function HallCityView:BindToggleFunc()
    self.luabehaviour:AddToggleChange(self.toggleBingoHall.gameObject, function(go,check)
        log.log("dps 点击toggle toggleBingoHall" , check)
        UISound.play("kick")
        self:RefreshBingoHallToggle(check)
    end)
end

function HallCityView:RefreshBingoHallToggle(check)
    if check then
        fun.set_active(self.bingoHallOffParam, false)
        fun.set_active(self.bingoHallOnParam, true)
        fun.set_active(self.vipRoomOffParam, true)
        fun.set_active(self.vipRoomOnParam, false)
        self.toggleBingoHall.transform:SetAsLastSibling()
        self:HideVipRoom()
    else
        fun.set_active(self.bingoHallOffParam, true)
        fun.set_active(self.bingoHallOnParam, false)
        fun.set_active(self.vipRoomOffParam, false)
        fun.set_active(self.vipRoomOnParam, true)
        self.toggleVipRoom.transform:SetAsLastSibling()
        self:ShowVipRoom()
    end
end

function HallCityView:HideVipRoom()
    if self.vipRoomCode then
        self.vipRoomCode:HideVipRoom()
    end
end

function HallCityView:ShowVipRoom()
    if self.vipRoomCode then
        self.vipRoomCode:ShowVipRoom()
    else
        local code = ViewList.VipRoomView
        Cache.load_prefabs(AssetList.VipRoomView,"VipRoomView",function(ret)
            if ret then
                local go = fun.get_instance(ret)
                go.transform.localScale = Vector3.New(1,1,1)
                fun.set_parent(go, self.vipRoomParent)
                self.vipRoomCode = code:New();
                self.vipRoomCode:SkipLoadShow(go,true,nil,true)
            else
                log.r("错误 缺少加载内容 VipRoomView")
            end
        end)
    end
end

function HallCityView:OnEnterHallCity()
    Event.Brocast(EventName.Event_enter_dragcity)
    self.toggleBingoHall.isOn = true
    
    AnimatorPlayHelper.Play(self.anima,"HallCityView_enter",false,function()
        UISound.play_bgm("city")
        --先監聽事件，要不可能收不到
        self:CheckPopUpView()
    end)
    self:RegisterRedDotNode()

    Cache.load_prefabs(AssetList["bingo_root"],"bingo_root",function()
        fun.set_active(self.img_bingo,true)
    end)
end

function HallCityView:CheckPopUpView()
    Event.AddListener(EventName.Event_enterhome_previous_finish,self.OnPreviousFinish,self)
    local extra = {}
    extra.lastPlayId = ModelList.CityModel.GetLastPlayId()
    ModelList.CityModel.ClearLastPlayId()
    Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder,self.occasion, extra)
end

function HallCityView:OnPreviousFinish(occasion)
    Event.RemoveListener(EventName.Event_enterhome_previous_finish,self.OnPreviousFinish,self)
    if self._fsm then
        self._fsm:GetCurState():Finish(self._fsm)
    end
    Event.Brocast(EventName.Event_enter_homescene,occasion)
    Event.Brocast(EventName.Event_Enter_City_Check_function_icon_change_double)
end

function HallCityView:RegisterRedDotNode()
    --RedDotManager:RegisterNode(RedDotEvent.decals_reddot_event,"city_auto_btn",self.img_reddot_auto)
    RedDotManager:RegisterNode(RedDotEvent.maincity_auto_event,"city_auto_btn",self.img_reddot_auto,RedDotParam.auto_city_cuisines)
    --RedDotManager:RegisterNode(RedDotEvent.othercitycuisines_reddot_event,"city_turn_left",self.img_reddotleft,RedDotParam.city_truenpage_left)
    --RedDotManager:RegisterNode(RedDotEvent.othercitycuisines_reddot_event,"city_turn_right",self.img_reddotright,RedDotParam.city_turnpage_right)
    RedDotManager:RegisterNode(RedDotEvent.club_reddot_event,"club_btn",self.img_reddotleft_club, "club_gift_tip")
end

function HallCityView:UnRegisterRedDotNode()
    --RedDotManager:UnRegisterNode(RedDotEvent.decals_reddot_event,"city_auto_btn")
    RedDotManager:UnRegisterNode(RedDotEvent.maincity_auto_event,"city_auto_btn",RedDotParam.auto_city_cuisines)
    --RedDotManager:UnRegisterNode(RedDotEvent.othercitycuisines_reddot_event,"city_turn_left",RedDotParam.city_truenpage_left)
    --RedDotManager:UnRegisterNode(RedDotEvent.othercitycuisines_reddot_event,"city_turn_right",RedDotParam.city_turnpage_right)
    RedDotManager:UnRegisterNode(RedDotEvent.club_reddot_event,"club_btn")
end

function HallCityView:CheckTurnPageRedDot()
    RedDotManager:Check(RedDotEvent.othercitycuisines_reddot_event)
    RedDotManager:Check(RedDotEvent.club_reddot_event)
end

function HallCityView:BuildFsm()
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm("HallCityView",self,{
        HallCityOriginalState:New(),
        HallCityEnterState:New(),
        HallCityStiffState:New()
    })
    self._fsm:StartFsm("HallCityOriginalState")
end

function HallCityView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function HallCityView.OnFunctionIconClick(view,params,...)
    if this._fsm then
        this._fsm:GetCurState():OnFunctionIconClick(this._fsm,view,params,...)
    end
end

function HallCityView.OnFunctionIconClickSpecial(view,params)
    if this._fsm then
        this._fsm:GetCurState():OnFunctionIconClickSpecial(this._fsm,view,params)
    end
end

function HallCityView:OnFunctionIconShowViewSpecial(view,params)
    Facade.SendNotification(NotifyName.ShowUI,view,function()
    end, false , params)
end

function HallCityView:OnFunctionIconShowView(view,params,...)
    if ... then
        ModelList.GiftPackModel:ShowGiftById(...)
    else
        --undo 临时方案
        if view == "SeasonCardGroupView" then
            ModelList.SeasonCardModel:EnterSystem()
            local playerLevel = ModelList.PlayerInfoModel:GetLevel()
            SDK.click_card_icon(playerLevel)
        else
            Facade.SendNotification(NotifyName.ShowUI,ViewList[view],function()
                if params then
                    Facade.SendNotification(NotifyName.HideUI,self)
                end
            end)
        end
    end
end

function HallCityView.Function_icon_click_special(view,params,...)
    if this._fsm then
        this._fsm:GetCurState():OnFunctionIconClick(this._fsm,view,params,...)
    end
end

function HallCityView:initBingoBtn()
    --bingo 
    local recommdIdOf = ModelList.CityModel:GetRecommendid()
    local peId = nil
    if recommdIdOf ~= nil then 
        peId = recommdIdOf
    else 
        peId = Csv.getSGPEntrance()
    end 

    local recommdData =  Csv.GetData("feature_enter",recommdIdOf) 
    if recommdData == nil then 
        peId = Csv.getSGPEntrance()
        recommdData =  Csv.GetData("feature_enter",peId)
    end
    
    --如果 推荐玩法在配置表中不存在，则设置成夏威夷
    fun.clear_all_child(self.IconRoot)
    
    local abName, iconPrefabName = AssetList[recommdData.modular_icon]
    local moduleAtlasName = recommdData.modular_atlas
    if not abName then
        local modularCfg = Csv.GetData("modular", recommdData.modular_id)
        iconPrefabName = string.format("%sIcon", modularCfg.modular_name)
    else
        iconPrefabName = recommdData.modular_icon
    end
    if not moduleAtlasName or moduleAtlasName == "0" then
        moduleAtlasName = "SpecialGameplay"
    end
    log.r(  "HallCityView:initBingoBtn() recommdIdOf %s, recommdData %s, abName %s, iconPrefabName %s, moduleAtlasName %s", recommdIdOf, recommdData, abName, iconPrefabName, moduleAtlasName)
    Cache.Load_Atlas(AssetList[moduleAtlasName],moduleAtlasName,function()
        Cache.load_prefabs(nil, iconPrefabName, function(ret)
            local iconObj = fun.get_instance(ret,self.IconRoot)
            self:SetShortPassIconEventFlag(iconObj,recommdData.city_play)
        end)
    end)
   
    --看下有没有加锁，遍历所有玩法如果，所有玩法都没有，就判断
    -- 0223推荐玩法是一定不加锁得
    fun.set_active(self.bingoLock,false)
end

---新增需求 https://www.tapd.cn/65500448/prong/stories/view/1165500448001013665
---副玩法入口增加气泡提示，气泡内显示EVENTS，主要用于提示对应副玩法中，存在活动任务
function HallCityView:SetShortPassIconEventFlag(obj,playId)
    if ModelList.GameActivityPassModel.HasDataByCityData(playId) then
        local eventFlag = fun.get_component(obj,fun.REFER)
        if eventFlag then
            eventFlag:Get("eventFlag").sprite =  AtlasManager:GetSpriteByName("CommonAtlas", "TsrkEvent")
        end
    end
end


function HallCityView:CheckClubOpen()
    --检查是否开启了club 
    
end 

function HallCityView.OpenShopView()
    if this._fsm then
        this._fsm:GetCurState():OpenShopView(this._fsm)
    end
end

function HallCityView:OnOpenShopView()
    Facade.SendNotification(NotifyName.ShopView.PopupShop,PopupViewType.show,nil,nil,nil)
end

function HallCityView:ChangeCityHolder()
    self._holderTimer = Invoke(function()
        if self._fsm then
            self._fsm:GetCurState():CheckPopUpView(self._fsm)
            self.occasion = PopupOrderOccasion.changeCity
            log.log("检查大厅流程 ChangeCityHolder" , self.occasion)
            self:CheckPopUpView()
        end
    end,1)
end

function HallCityView:StopHolderTimer()
    if self._holderTimer then
        self._holderTimer:Stop()
        self._holderTimer = nil
    end
end

function HallCityView:UpdateBtnLock()
     if ModelList.PlayerInfoModel:IsAutoLobbyOpen() then
        --self.img_bingo.sprite = AtlasManager:GetSpriteByName("CityAtlas","c_ent_bingo")
        fun.set_active(self.bingo_lock,false)
        if fun.is_not_null(self.btn_city) then
            Util.SetImageColorGray(self.btn_city.transform.parent.gameObject,false)
        end
    else
        --self.img_bingo.sprite = AtlasManager:GetSpriteByName("CityAtlas","c_ent_bingoan")
        fun.set_active(self.bingo_lock,true)
        if fun.is_not_null(self.btn_city) and fun.is_not_null(self.btn_city.transform.parent) then
            Util.SetImageColorGray(self.btn_city.transform.parent.gameObject,true)
        end
    end
    
    local isClubOpen = ModelList.ClubModel.IsClubOpen()
    fun.set_active(self.club_lock, not isClubOpen)
    Util.SetImageColorGray(self.btn_club.gameObject, not isClubOpen)

    --- 名人堂
    --local check = ModelList.HallofFameModel:IsActivityAvailable()
    --local isWinZoneOpen = ModelList.WinZoneModel:IsActivityValid()
    --check = check and isWinZoneOpen
    --fun.set_active(self.winzon_lock, not check)
    --Util.SetImageColorGray(self.btn_winzone.gameObject, not check)

    --- 名人堂
    local isWinZoneOpen = ModelList.WinZoneModel:IsActivityValid()
    fun.set_active(self.winzon_lock, not isWinZoneOpen)
    Util.SetImageColorGray(self.btn_winzone.gameObject, not isWinZoneOpen)

end

function HallCityView:SetAlpha(value)
    if fun.is_not_null(self.anima) then
        self.anima.enabled = false
        --self.citylevelgroup.alpha = value
        self.TurnPage.alpha = value
    end
end

function HallCityView:SetCurrentCityIndex(index)
    --if self:IsDragRightMax() then
    --    fun.set_active(self.btn_turnleft,false)
    --else
    --    fun.set_active(self.btn_turnleft,true)
    --end
    --if self:IsDragLeftMax() then
    --    fun.set_active(self.btn_turnright,false)
    --else
    --    fun.set_active(self.btn_turnright,true)
    --end

    --[[
    if CityHomeScene:GetCurrentCity() then
        _cityLevel:ChangeCity(CityHomeScene:GetCurrentCity())
    end
    --]]
end

function HallCityView:IsDragLeftMax()
    return CityHomeScene:IsDragLeftMax()
end

function HallCityView:IsDragRightMax()
    return CityHomeScene:IsDragRightMax()
end

function HallCityView:OnDisable()
    Facade.RemoveView(self)
    _functionIcon:OnDisable()
    _tournamentEntrance:OnDisable()
    _hallofFameEntrance:OnDisable()
    _winzoneEntrance:OnDisable()
    self:StopHolderTimer()
    self:DisposeFsm()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
    self:RemoveTournamentNextOpenTimeCountDownEvent()
    self:RemoveHallofFameNextOpenTimeCountDownEvent()
    ModelList.ApplicationGuideModel:UnloadGuide("HallCityView")
end

function HallCityView:on_close()

end

function HallCityView:OnDestroy()
    self:Close()
    self:DisposeFsm()
    _functionIcon:Dispose()
    _tournamentEntrance:OnDestroy()
    _hallofFameEntrance:OnDestroy()
    _winzoneEntrance:OnDestroy()
    _functionIcon = nil
    
    if fun.is_not_null(self.TopCompetitionView) then
        Destroy(self.TopCompetitionView)
        self.TopCompetitionView = nil
    end
    if self._topCompetition then
        self._topCompetition = nil
    end
    if self.vipRoomCode then
        self.vipRoomCode:Close()
        self.vipRoomCode = nil
    end
    --Cache.unload_ab("luaprefab_prefabs_cityentity")
end

function HallCityView:on_btn_bingo_click()
--    self.OnClick_City_Enter(true)
    -- if self.bingoLock.gameObject.activeSelf == true then 
    --     return 
    -- end 
    log.log("检查大厅流程 btn_bingo_click")
    if CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayView,nil,nil,nil)
    end 
   
end

function HallCityView:on_btn_vip_attr_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.VipAttributeBonusView)
end

function HallCityView:OnAutoBingoClick()
    --Facade.SendNotification(NotifyName.SceneCity.Click_auto_Enter)
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,false,101,ModelList.CityModel.GetPlayIdByCity(101))
end

function HallCityView:on_btn_goback_click()

end

function HallCityView:on_btn_get_cold_click()
    if GameUtil.is_windows_editor() then
        Facade.SendNotification(NotifyName.ShowDialog, ViewList.GMView)
    end
    UISound.play("button_invalid")
end

function HallCityView:on_btn_club_click()
    if not CmdCommonList.CmdEnterCityPopupOrder.IsFinish() then
        return 
    end 
    
    local isClubOpen = ModelList.ClubModel.IsClubOpen()
    if not isClubOpen then
        UISound.play("button_invalid")
        UIUtil.show_common_popup(8017,true)
        return
    end
    
    if not _DownloadUtility:NewNode(8,self.btn_club) then 
        return 
    end
    
    --检测是否已经加入了Club
    local isJoinClub = ModelList.ClubModel.CheckPlayerHasJoinClub()
    local cb = function()
        if resMgr then
            --TODO by LwangZg 运行时热更部分
            resMgr:RefreshModuleInfo("Club")
        elseif LuaHelper.GetResManager()  then
            LuaHelper.GetResManager():RefreshModuleInfo("Club")
        end
        ModelList.BattleModel.RequireModuleLua("Club")
        if isJoinClub then
            Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubMainView)
        else
            --获取公会列表
            ModelList.ClubModel.C2S_ClubQueryList(function()
                Facade.SendNotification(NotifyName.ShowUI,ViewList.ClubListSearchView)
            end)
        end
    end
    ModelList.BattleModel.RequireModuleLua("Club",8)

    --本地持久化存储，是否点击过按钮
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    local key = string.format("%s-%s", "btn_club", userID)
    local ret = fun.get_int(key, 0)
    
    if isJoinClub or ret == 1 then
        cb()
    else
        fun.save_int(key, 1)
        Facade.SendNotification(NotifyName.ShowUI ,ViewList.PlayerInfoSysChangeNickNameView, nil, nil, {
            onClose = cb
        })
    end
end

--undo 要处理 判断是打开周榜还是名人堂
function HallCityView:on_btn_slots_click()
    --if ModelList.TournamentModel:IsActivityAvailable() then
    --    if _tournamentEntrance:IsOpen() and self._fsm:GetCurState():TournamentStiff(self._fsm) then
    --        self:SetTournamentActivityType(openTournamentType.ClickIcon)
    --        ModelList.TournamentModel:C2S_RequestTournamentRankInfo()
    --    end
    --elseif ModelList.HallofFameModel:IsActivityAvailable() then
    --    if _hallofFameEntrance:IsOpen() and self._fsm:GetCurState():TournamentStiff(self._fsm) then
    --        self:SetHallofFameActivityType(openHallofFameType.ClickIcon)
    --        ModelList.HallofFameModel:C2S_RequestRankInfo()
    --    end
    --else
    --    UISound.play("button_invalid")
    --    UIUtil.show_common_popup(8017,true)
    --end
end

function HallCityView.OnResphoneTournamentInfo()
    --if this._fsm then
    --    this._fsm:GetCurState():FinishStiff(this._fsm)
    --end
    --
    --if currentOpenTournamentType == openTournamentType.CountDownEnd then
    --    this:RefreshTournament()
    --    --是通过下次开启倒计时请求的数据 不展示界面
    --elseif currentOpenTournamentType == openTournamentType.ClickIcon then
    --    local tourmodel = ModelList.TournamentModel
    --    if tourmodel:IsRankInfoAvailable() then
    --  --ModelList.TournamentModel:C2S_RequestTournamentRewardInfo()
    --  --if tourmodel:CheckIsBlackGoldUser() then
    --            --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentBlackGoldView")
    --        --else
    --            --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentView")
    --    ----ModelList.TournamentModel:GetTierAddAwards();       
    --        --end
    --  --Facade.SendNotification(NotifyName.HallCity.Function_icon_click_special,"TournamentScoreView",{isSettle = false})
    --  Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentScoreView")
    --else
    --        UIUtil.show_common_popup(8025,true)
    --    end
    --else
    --    --idle不处理
    --end
    --this:SetTournamentActivityType(openTournamentType.Idle)
end

function HallCityView.OnResphoneFameInfo()
    --if this._fsm then
    --    this._fsm:GetCurState():FinishStiff(this._fsm)
    --end
    --
    --if currentOpenHallofFameType == openHallofFameType.CountDownEnd then
    --    this:RefreshFame()
    --    --是通过下次开启倒计时请求的数据 不展示界面
    --elseif currentOpenHallofFameType == openHallofFameType.ClickIcon then
    --    local tourmodel = ModelList.HallofFameModel
    --    if tourmodel:IsRankInfoAvailable() then
    --        Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "HallofFameScoreView")
    --    else
    --        UIUtil.show_common_popup(1932,true)
    --    end
    --else
    --    --idle不处理
    --end
    --this:SetHallofFameActivityType(openHallofFameType.Idle)
end

function HallCityView.OnDownloadGameSuccess(id)
    if not id then 
        return
    end 

    --某些界面已经显示得上面得时候不用显示
    if (ViewList.SpecialGameplayView and ViewList.SpecialGameplayView.go and fun.get_active_self(ViewList.SpecialGameplayView.go)) then 
        return 
    end
    
    local tmpData = Csv.GetData("modular",id)

    if tmpData and tmpData.modular_type == 2 then 
        return 
    end 

    --此处监听是否已经下载完成
    Facade.SendNotification(NotifyName.ShowUI,ViewList.SpecialGameplayTip,nil,nil,id)
end

function HallCityView:on_btn_city_click()
    if self._fsm then
        self._fsm:GetCurState():OnAutoBingoClick(self._fsm)
    end
end
--
--function HallCityView:on_btn_turnleft_click()
--    if self._fsm then
--        self._fsm:GetCurState():OnTurnCityLeft(self._fsm)
--    end
--end    

function HallCityView:OnTurnCityRight()
    self:OnStartDragCity()
    Facade.SendNotification(NotifyName.SceneCity.DragCityRight)
end    
--
--function HallCityView:on_btn_turnright_click()
--     --需要判断
--     if self:IsDragLeftMax() then
--        return 
--    end
--    if self._fsm then
--        self._fsm:GetCurState():OnTurnCityRight(self._fsm)
--    end
--end

function HallCityView:OnTurnCityLeft()
    self:OnStartDragCity()
    Facade.SendNotification(NotifyName.SceneCity.DragCityLeft)
end

--[[
function HallCityView:FinishTopQuickTask()
    --fun.set_active(this.img_coverage,false)
end
--]]

function HallCityView:RestoreLuaDray()
    Util.SetLuaDrag(self.OnDragCity)
    --log.r("Guide RestoreLuaDray")
end

function HallCityView:PlayBtnClickSound(btn_name)
    if btn_name == "btn_club" or btn_name == "btn_slots" or btn_name == "btn_city" then
        UISound.play("button_invalid")
    else
        UISound.play("kick")    
    end
end

function HallCityView.OnStartDragCity()
    --this:StopHolderTimer()
    --this:SetAlpha(0.2)
    --if this._fsm then
    --    this._fsm:GetCurState():Change2Stiff(this._fsm)
    --end
end

function HallCityView.OnEndDragCity()
    --if this._fsm then
    --    this._fsm:GetCurState():FinishStiff(this._fsm)
    --end
    --
    --this:SetAlpha(1)
    ----this:SetCurrentCityIndex()
    --this:UpdateBtnLock()
    --this:ChangeCityHolder()
    --this:CheckTurnPageRedDot()
end

function HallCityView.OnClick_City_Enter(isMax,cityid)
    if this._fsm then
        this._fsm:GetCurState():OnCityClick(this._fsm,isMax,cityid)
    end
end

function HallCityView:OnCityClick(isMax,cityid)
    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,isMax,cityid)
end

function HallCityView:RefreshTournament()
    if _tournamentEntrance then
        _tournamentEntrance:InitData()
        _tournamentEntrance:ShowInfo()
    end
end

function HallCityView:RefreshFame()
    if _hallofFameEntrance then
        _hallofFameEntrance:InitData()
        _hallofFameEntrance:ShowInfo()
    end
end

function HallCityView:AddTournamentNextOpenTimeCountDownEvent()
    Event.AddListener(NotifyName.Tournament.TournamentNextOpenTimeCountDownEnd,self.TournamentNextOpenTimeCountDownEnd,self)
end

function HallCityView:RemoveTournamentNextOpenTimeCountDownEvent()
    Event.RemoveListener(NotifyName.Tournament.TournamentNextOpenTimeCountDownEnd,self.TournamentNextOpenTimeCountDownEnd,self)
end

function HallCityView:TournamentNextOpenTimeCountDownEnd()
    --self:SetTournamentActivityType(openTournamentType.CountDownEnd)
    ModelList.TournamentModel.C2S_RequestMyTournamentJoinInfo()
end

function HallCityView:AddHallofFameNextOpenTimeCountDownEvent()
    Event.AddListener(NotifyName.HallofFame.FameNextOpenTimeCountDownEnd, self.HallofFameNextOpenTimeCountDownEnd,self)
end

function HallCityView:RemoveHallofFameNextOpenTimeCountDownEvent()
    Event.RemoveListener(NotifyName.HallofFame.FameNextOpenTimeCountDownEnd, self.HallofFameNextOpenTimeCountDownEnd,self)
end

function HallCityView:HallofFameNextOpenTimeCountDownEnd()
    self:SetHallofFameActivityType(openHallofFameType.CountDownEnd)
    ModelList.HallofFameModel:C2S_RequestMyJoinInfo()
end

function HallCityView.ReqRefreshIcon()
    this:RefreshTournament()
end

function HallCityView.ReqRefreshFameIcon()
    this:RefreshFame()
end

function HallCityView.OnWeeklyEntrance()
    --- WinZone入口
    local check = ModelList.HallofFameModel:IsActivityAvailable()
    local isWinZoneOpen = ModelList.WinZoneModel:IsActivityValid()
    check = check and isWinZoneOpen
    fun.set_active(this.winzon_lock, not check)
    if fun.is_not_null(this.btn_winzone) then
        Util.SetImageColorGray(this.btn_winzone.gameObject, not check)
    end
    
    _winzoneEntrance:CheckOpen()
    _winzoneEntrance:CheckBuff()
end

function HallCityView:SetTournamentActivityType(type)
    currentOpenTournamentType = type
end

function HallCityView:SetHallofFameActivityType(type)
    currentOpenHallofFameType = type
end

function HallCityView:PopupShowCompetition()
    if not this.TopCompetitionView then
        self:UpdateCompetitionView(true)
    else
        --log.r("PopupShowCompetition TopCompetitionView is not nil")
        Event.Brocast(EventName.Event_show_competition_task)
    end
end

function HallCityView:RegisterEvent()
    Event.AddListener(EventName.Event_competition_show_popup,self.PopupShowCompetition,self)
    --Event.AddListener(EventName.Event_Check_Double_Activity,self.OnTaskUpdate,self)
end

function HallCityView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_competition_show_popup,self.PopupShowCompetition,self)
    --Event.AddListener(EventName.Event_Check_Double_Activity,self.OnTaskUpdate,self)
end

function HallCityView:GetCompetitionView()
    return self._topCompetition
end

function HallCityView:OnPlayerInfoUpdate()
    this:UpdateBtnLock()
end

function HallCityView:OnResNotify()
    --杯赛活动关闭时删除数据
    this:UpdateCompetitionView()
end

function HallCityView:OnStartDownloadWinZone()
    if this and fun.is_not_null(this.btn_winzone) then
         _DownloadUtility:NewNode(14,this.btn_winzone)
    end
end

---打开WinZone界面
function HallCityView:on_btn_winzone_click()
    _winzoneEntrance:OnClick()
end

--设置消息通知
this.NotifyList =
{
    {notifyName = NotifyName.HallCity.Click_City_Enter, func = this.OnClick_City_Enter},
    {notifyName = NotifyName.HallCity.Function_icon_click, func = this.OnFunctionIconClick},
    {notifyName = NotifyName.ShopView.OpenShopView, func = this.OpenShopView},
    {notifyName = NotifyName.SceneCity.StartDragCity, func = this.OnStartDragCity},
    {notifyName = NotifyName.SceneCity.EndDragCity, func = this.OnEndDragCity},
    --{notifyName = NotifyName.Tournament.ResphoneRankInfo,func = this.OnResphoneTournamentInfo},
    {notifyName = NotifyName.Event_machine_download_success_view, func = this.OnDownloadGameSuccess},
    {notifyName = NotifyName.HallCity.Function_icon_click_special, func = this.OnFunctionIconClickSpecial},
    {notifyName = NotifyName.Tournament.ReqRefreshIcon,func = this.ReqRefreshIcon},
    {notifyName = NotifyName.PlayerInfo.UpdateRoleInfo,func = this.OnPlayerInfoUpdate},
    {notifyName = NotifyName.Competition.ResphoneNotify,func = this.OnResNotify},
    {notifyName = NotifyName.WinZone.StartDownloadMachine,func = this.OnStartDownloadWinZone},
    --{notifyName = NotifyName.HallofFame.FameResphoneRankInfo,func = this.OnResphoneFameInfo},
    --{notifyName = NotifyName.HallofFame.FameReqRefreshIcon,func = this.ReqRefreshFameIcon},
    {notifyName = NotifyName.OnWeeklyEntrance,func = this.OnWeeklyEntrance},
}

return this
