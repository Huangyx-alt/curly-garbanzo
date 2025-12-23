
local HallMainOriginalState = require "State/HallMainView/HallMainOriginalState"
local HallMainEnterState = require "State/HallMainView/HallMainEnterState"
local HallMainStiffState = require "State/HallMainView/HallMainStiffState"

local BaseHallView = TopBarControllerView:New()
local this = BaseHallView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local HallViewInstance = nil

function BaseHallView:SetCurInstance()
    HallViewInstance = self
end

function GetCurHallView()
    return HallViewInstance
end

function GetPlayCardsPos(genre)
    local curHallView = GetCurHallView()
    if curHallView then
        if genre == CardGenre.onecard then
            return curHallView._hallFunction:Play1CardGetPosition()
        elseif genre == CardGenre.twocard then
            return curHallView._hallFunction:Play2CardGetPosition()
        elseif genre == CardGenre.fourcard then
            return curHallView._hallFunction:Play4CardGetPosition()
        else
            return curHallView._hallFunction:Play4CardGetPosition()
        end
    end
end

function GetPlayCardsGo(genre)
    local curHallView = GetCurHallView()
    if curHallView then
        if genre == CardGenre.onecard then
            return curHallView._hallFunction:Play1CardGameObject()
        elseif genre == CardGenre.twocard then
            return curHallView._hallFunction:Play2CardGameObject()
        elseif genre == CardGenre.fourcard then
            return curHallView._hallFunction:Play4CardGameObject()
        else
            return curHallView._hallFunction:Play4CardGameObject()
        end
    end
end

function BaseHallView:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName,isShow = false,isLoaded = false,changeSceneClear = true}
    self.__index = self
    setmetatable(o,self)
    return o
end

function BaseHallView:BuildFsm(name)
    self:DisposeFsm()
    self._fsm = Fsm.CreateFsm(name or "BaseHallView",self,{
        HallMainOriginalState:New(),
        HallMainEnterState:New(),
        HallMainStiffState:New()
    })
    self._fsm:StartFsm("HallMainOriginalState")
end

function BaseHallView:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function BaseHallView:IsCacheGo()
    return true
end

function BaseHallView:GetHallViewGoName()
    return "HallMainView"
end

function BaseHallView:CmdShowHallView(view,go,show,occasion,callback)
    self.occasion = occasion
    Facade.SendNotification(NotifyName.SkipLoadShowUI,view,go,nil,function()
        if callback then
            callback()
        end
    end,show)
end

function BaseHallView:Awake()
    self:on_init()
    local FunctionIconView = require "View/CommonView/FunctionIconView"
    self._hallFunction:InitFunctionIcon(FunctionIconView.belong2Type.normalbattle,self.LeftIconArea , self.RightIconArea)
end

function BaseHallView:OnEnable()
    self.isInCityPopupState = true
    fun.set_active(self.SuperMatchJackpotEnable, false)
    self:StepRunEnableHandle()
    self:UpdateCompetitionView()
    self:InitMiniGameIcon()
    SDK.BI_Event_Tracker("enter_lobby",{
        playId = ModelList.CityModel.GetPlayIdByCity(),
    })
end

function BaseHallView:StepRunEnableHandle()
    coroutine.start(function()
        self:SetCurInstance()
        ---[[不要在OnEnable里处理其他功能了，请在入场动画播完的回调里处理，要不在低端机会卡入场动画显示不出来完整ui
        --ModelList.TaskModel.testTask = 1
        Facade.RegisterView(self)
        Facade.RegisterViewEnhance(self)
        self._hallFunction:BetRateOperatorSkipLoadShow(self.betRateOperator)
        WaitForEndOfFrame()
        --if
        self._hallFunction:Play1CardSkipLoadShow(self.Play1cardView)
        WaitForEndOfFrame()
        self._hallFunction:Play2CardSkipLoadShow(self.Play2cardView)
        WaitForEndOfFrame()
        self._hallFunction:Play4CardSkipLoadShow(self.Play4cardView)
        WaitForEndOfFrame()

        self._hallFunction:LobbyAdvertiseSkipLoadShow(self.lobbyAdvertise)
        WaitForEndOfFrame()
        self._hallFunction:GiftpackSkipLoadShow(self.GiftPack)
        WaitForEndOfFrame()
        self._hallFunction:EnableFunctionIcon()
        WaitForEndOfFrame()
        self:RefreshUltraBetUI()
        WaitForEndOfFrame()
        self:SetHallInfo(true)
        WaitForEndOfFrame()
        self:BuildFsm()
        self:RegisterEvent()
        if self._fsm then
            self._fsm:GetCurState():EnterHallMain(self._fsm)
        end
        ---]]不要在OnEnable里处理其他功能了，请在入场动画播完的回调里处理，要不在低端机会卡入场动画显示不出来完整ui

        Event.AddListener(EventName.Event_Update_TournamentSprintBuff_Time, self.CheckTournamentSprintBuff, self)
        WaitForEndOfFrame()
        self:CheckTournamentSprintBuff()
    end)
end



function BaseHallView:OnEnterHallMain()
    Event.Brocast(EventName.Event_enter_normalhall)
    AnimatorPlayHelper.Play(self.Animator,"HallView",false,function()
        --先監聽事件，要不可能收不到
        Event.AddListener(EventName.Event_enterhome_previous_finish,self.OnPreviousFinish,self)
        Event.AddListener(EventName.WatchLobbyAdViewRefresh,self.AdRefreshCallBack,self)
        self.isPreviousFinish = false
        
        --先監聽事件，要不可能收不到 --end
        self:CheckBGMPlay()
        local extra = {}
        local playType = ModelList.CityModel.GetCurPlayType()
        extra.playType = playType
        Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder,self.occasion, extra)
        --self._hallFunction:Play1CardCheckCoupon()
        --self._hallFunction:Play2CardCheckCoupon()
        --self._hallFunction:Play4CardCheckCoupon()

        --self._hallFunction:ShowJackpotConsole()
        --self._hallFunction:CheckLobbyAdvertise()
    end)

    --自动跑战斗功能
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
            ModelList.GMModel:AutoEnterBattle()
    end
end

function BaseHallView:OnPreviousFinish()
    self.isInCityPopupState = false
    if self._fsm then
        self._fsm:GetCurState():EnterFinish(self._fsm)
        Event.RemoveListener(EventName.Event_enterhome_previous_finish,self.OnPreviousFinish,self)

        Event.Brocast(EventName.Event_enter_hallView) --要先发送事件，任务依赖这个事件
        Event.Brocast(EventName.Event_Enter_City_Check_function_icon_change_double)  -- 进入战斗结束

        self.isPreviousFinish = true
        self:ShowSeasonPowerUpPoster()
    end
end

function BaseHallView:ShowSeasonPowerUpPoster()
    if not ModelList.CityModel:IsPuBuffSeasonValid() then
        log.r(string.format("Cant Show SeasonPowerUpPosterView, not valid season!!"))
        return
    end

    local playID =  ModelList.CityModel.GetPlayIdByCity()
    if not ModelList.CityModel:CanCurPlayUsePuBuff() then
        log.log("Cant Show SeasonPowerUpPosterView 玩法禁止", playID)
        return
    end
    
    local userInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local userID = userInfo.uid
    local endTime = ModelList.CityModel:GetPuBuffSeasonEndTime()
    local popKey = "PopupSeasonPuPosterOrder" .. endTime .. userID
    local flag = fun.read_value(popKey,0)
    if flag == 1 then
        log.r(string.format("Cant Show SeasonPowerUpPosterView, have showed this season!!"))
        return
    end

    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonPowerUpPosterView)
    fun.save_value(popKey,1)
end

function BaseHallView:SetHallInfo(enter)
    local betRate = ModelList.CityModel:CalculatePlayCardBaseCost(nil)
    --
    
    --self._hallFunction:Play1CardSetInfo(betRate)
    --self._hallFunction:Play2CardSetInfo(betRate)
    --self._hallFunction:Play4CardSetInfo(betRate)
    --
    --self._hallFunction:SetBetRateInfo(betRate, enter)
end

function BaseHallView:on_close()
    Event.RemoveListener(EventName.Event_Update_TournamentSprintBuff_Time, self.CheckTournamentSprintBuff, self)
    Event.RemoveListener(EventName.WatchLobbyAdViewRefresh,self.AdRefreshCallBack)
    Facade.RemoveView(self)
    Facade.RemoveViewEnhance(self)
end

function BaseHallView:OnDestroy()
    self:Close()
    
    self._hallFunction:DestroyFunctionIcon()
    if fun.is_not_null(self.TopCompetitionView) then
        Destroy(self.TopCompetitionView)
        self.TopCompetitionView = nil
    end
    
    if self._hallFunction then
        self._hallFunction._topCompetition = nil
    end
    if self.miniGameView then
        self.miniGameView:Close()
        self.miniGameView = nil
    end
end

function BaseHallView:OnDisable()
    self._hallFunction:DisableFunctionIcon()
    self:DisposeFsm()
    self:on_close()
    self:UnRegisterEvent()
    ModelList.ApplicationGuideModel:UnloadGuide("HallMainView")

    if self.tournamentBuffRemainCountDown then
        self.tournamentBuffRemainCountDown:StopCountDown()
        self.tournamentBuffRemainCountDown = nil
    end
    self.isInCityPopupState = false
end

function BaseHallView:OnPlayCardsClick(cardGenre, ignoreCheckRes, cb)
    if self and self._fsm then
        self._fsm:GetCurState():PlayCardsClick(self._fsm,cardGenre, ignoreCheckRes, cb)
    end
end

function BaseHallView:DoPlayCardsClick(cardGenre, ignoreCheckRes, cb)
    if cardGenre == CardGenre.onecard then
        self._hallFunction:Play1CardDoCardClick(ignoreCheckRes, cb)
    elseif cardGenre == CardGenre.twocard then
        self._hallFunction:Play2CardDoCardClick(ignoreCheckRes, cb)
    elseif cardGenre == CardGenre.fourcard then
        self._hallFunction:Play4CardDoCardClick(ignoreCheckRes, cb)
    end
end

function BaseHallView:CloseTopBarParent(exitType)
    if self._fsm then
        self._fsm:GetCurState():GobackClick(self._fsm,exitType)
    end
end

function BaseHallView:DoGobackClick(exitType)

    Facade.SendNotification(NotifyName.SceneCity.Goback_select_city,exitType)
end

function BaseHallView:OnRefreshHallInfo()
    self:SetHallInfo()
end

function BaseHallView:OnFunctionIconClick(view,params,...)
    if self and self._fsm then
        self._fsm:GetCurState():OnFunctionIconClick(self._fsm,view,params,...)
    end
end

function BaseHallView:OnFunctionIconShowView(view,params,...)
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

function BaseHallView:OnFunctionIconClickSpecial(view,params)
    if self and self._fsm then
        self._fsm:GetCurState():OnFunctionIconClickSpecial(self._fsm,view,params)
    end
end

function BaseHallView:OnFunctionIconShowViewSpecial(view,params)
    Facade.SendNotification(NotifyName.ShowUI,view,function()
    end, false , params)
end

function BaseHallView:OpenShopView()
    if self and self._fsm then
        self._fsm:GetCurState():OpenShopView(self._fsm)
    end
end

function BaseHallView:OnOpenShopView()
    Facade.SendNotification(NotifyName.ShopView.PopupShop, PopupViewType.show, nil, nil, nil)
end

function BaseHallView:CheckBGMPlay()
    UISound.play_bgm("city")
end

function BaseHallView:IsInFocus()
    local inFocus = not CanvasSortingOrderManager.IsViewBackGround(self.viewType, self.go)
    return inFocus
end

--- 是否在特殊引导中
function BaseHallView:IsSpecialGuide()
    return (ModelList.GuideModel:IsGuiding() and ModelList.GuideModel:GetIns().m_CurGuideID == 77) and true or false
end

function BaseHallView:Replace1CardClick(isReplace)
    self._hallFunction:Play1CardReplaceBtnPlayEvent(isReplace)
end

function BaseHallView:Replace2CardClick(isReplace)
    if isReplace then
        ModelList.CityModel:SetCardNumber(2)
    end
    self._hallFunction:Play2CardReplaceBtnPlayEvent(isReplace)
end

function BaseHallView:SetCardRayCast()
    self._hallFunction:Play2CardRayCast()
    self._hallFunction:Play4CardRayCast()
end

function BaseHallView:OnRefreshCouponInfo(coupon)
    local curHallView = GetCurHallView()
    if curHallView then
        if coupon == CouponType.discount_4card then
            curHallView._hallFunction:Play4CardCheckCoupon()
        elseif coupon == CouponType.discount_2card then
            curHallView._hallFunction:Play2CardCheckCoupon()
        elseif coupon == CouponType.discount_1card then
            curHallView._hallFunction:Play1CardCheckCoupon()
        elseif coupon == (CouponType.discount_2card + CouponType.discount_4card) then
            curHallView._hallFunction:Play2CardCheckCoupon()
            curHallView._hallFunction:Play4CardCheckCoupon()
        end
    end
end

function BaseHallView:OnLobbyRequestWatchAd(viewState)
    if self and self._fsm then
        self._fsm:GetCurState():LobbyRequestWatchAd(self._fsm,viewState)
    end
end

function BaseHallView:DoLobbyWatchAd()

end

function BaseHallView:OnBetRateChange(betrate,isBetrateOpen,openLevel)
    local curHallView = GetCurHallView()
    if curHallView then
        if isBetrateOpen then
            curHallView._hallFunction:Play1CardNumberAvailable()
            curHallView._hallFunction:Play4CardNumberAvailable()
            curHallView._hallFunction:Play2CardNumberAvailable(function()
               -- fun.set_active(self.text_lock.transform.parent,false)
               -- AnimatorPlayHelper.Play(self.cards_anima,{"out","HallViewdisableout"},false,nil)
            end)
        else
            curHallView._hallFunction:Play1CardNumberDisable()
            curHallView._hallFunction:Play4CardNumberDisable()
            curHallView._hallFunction:Play2CardNumberDisable(function()
              --  fun.set_active(self.text_lock.transform.parent,true)
              --  self.text_lock.text = string.format("Unlocks at <color=#ffff00>Lv.%s</color>",openLevel)
              --  AnimatorPlayHelper.Play(self.cards_anima,{"in","HallViewdisableenter"},false,nil)
            end)
        end
    end
end


function BaseHallView.OnDownloadGameSuccess(id)
    if not id then
        return
    end
    --增加某些界面不用显示

    local tmpData = Csv.GetData("modular",id)

    if tmpData and tmpData.modular_type == 2 then 
        return 
    end 

    --此处监听是否已经下载完成
    Facade.SendNotification(NotifyName.ShowUI,ViewList.SpecialGameplayTip,nil,nil,id)
end

function BaseHallView:AdRefreshCallBack()
    self._hallFunction:CheckLobbyAdvertise()
end

--- 日榜是每周会变的
function BaseHallView:CheckCompetitionObj(competitionObj,refTable,isPop)
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local info = dependentFile[1]
    if info then
        if fun.is_not_null(competitionObj) then
            local checkCur = string.find(competitionObj.name, info.topPrefabName)
            if not checkCur then
                Destroy(competitionObj)
                competitionObj = nil
            end
        end

        if fun.is_null(competitionObj) then
            Cache.load_prefabs(AssetList[info.topPrefabName],info.topPrefabName,function(obj2)
                local obj = fun.get_instance(obj2,refTable.CompetitionRoot)
                refTable.TopCompetitionView = obj
                if refTable._topCompetition then
                    refTable._topCompetition:CheckActivity(obj)
                end
                if refTable._hallFunction then
                    refTable._hallFunction:TopQuickTaskCheckActivity(refTable.TopCompetitionView)
                end
                if isPop then
                    Event.Brocast(EventName.Event_show_competition_task)
                end
            end)
        else
            if refTable._topCompetition then
                refTable._topCompetition:CheckActivity(competitionObj)
            end
            if refTable._hallFunction then
                refTable._hallFunction:TopQuickTaskCheckActivity(competitionObj)
            end
        end
    end
end

function BaseHallView:PopupShowCompetition()
    if not self.TopCompetitionView then
        self._hallFunction:InitTopCompetition()
        self:CheckCompetitionObj(self.TopCompetitionView,self,true)
    else
        Event.Brocast(EventName.Event_show_competition_task)
    end
end

function BaseHallView:RegisterEvent()
    Event.AddListener(EventName.Event_competition_show_popup,self.PopupShowCompetition,self)
end

function BaseHallView:UnRegisterEvent()
    Event.RemoveListener(EventName.Event_competition_show_popup,self.PopupShowCompetition,self)
end

local OnNotifyFunctionIconClick = function(view,params,...)
    if HallViewInstance then
        HallViewInstance:OnFunctionIconClick(view,params,...)
    end
end

local OnNotifyFunctionIconClickSpecial = function(view,params)
    if HallViewInstance then
        HallViewInstance:OnFunctionIconClickSpecial(view,params)
    end
end

local OnNotifyOpenShopView = function()
    if HallViewInstance then
        HallViewInstance:OpenShopView()
    end
end

local OnNotifyPlayCardsClick = function(cardGenre, ignoreCheckRes, cb)
    if HallViewInstance then
        HallViewInstance:OnPlayCardsClick(cardGenre, ignoreCheckRes, cb)
    end
end

local OnNotifyRefreshHallInfo = function()
    if HallViewInstance then
        HallViewInstance:OnRefreshHallInfo()
    end
end

local OnNotifyRefreshCouponInfo = function(coupon)
    if HallViewInstance then
        HallViewInstance:OnRefreshCouponInfo(coupon)
    end
end

local OnNotifyRequestWatchAd = function(viewState)
    if HallViewInstance then
        HallViewInstance:OnLobbyRequestWatchAd(viewState)
    end
end

local OnNotifyBetRateChange = function(betrate,isBetrateOpen,openLevel)
    if HallViewInstance then
        HallViewInstance:OnBetRateChange(betrate,isBetrateOpen,openLevel)
    end
end

function BaseHallView:RefreshUltraBetUI()
    if self.ultra_jackpot_console then
        if ModelList.UltraBetModel:IsActivityValidForCurPlay() then
            fun.set_active(self.jackpot_console, false)
            self._hallFunction:JackpotConsoleSkipLoadShow(self.ultra_jackpot_console)
        else
            fun.set_active(self.ultra_jackpot_console, false)
            self._hallFunction:JackpotConsoleSkipLoadShow(self.jackpot_console)
        end
    else
        self._hallFunction:JackpotConsoleSkipLoadShow(self.jackpot_console)
    end
end

function BaseHallView:OnUltraBetStart()
    self:RefreshUltraBetUI()
    self:SetHallInfo()
end

function BaseHallView:OnUltraBetEnd()
    self:RefreshUltraBetUI()
    self:SetHallInfo()
end

function BaseHallView:OnGroupPrefixRefresh()
    self:SetHallInfo()
end

function BaseHallView:OnShopViewClose()
    if self:IsInFocus() then
        local isUltraNeedPopup = ModelList.UltraBetModel:IsActivityNewlyOpen()
        if isUltraNeedPopup then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.UltraBetPosterView)
            ModelList.UltraBetModel:UpdatePopupPosterTimes()
        end
    end
end

function BaseHallView:OnResNotify()
    if self.TopCompetitionView and self._hallFunction._topCompetition then
        self._hallFunction._topCompetition:CheckActivity(self.TopCompetitionView)
    end
    
    self._hallFunction:InitTopCompetition()
    if not self._hallFunction._topCompetition then
        if fun.is_not_null(self.TopCompetitionView) then
            Destroy(self.TopCompetitionView)
        end
        self.TopCompetitionView = nil
    end
    self:CheckCompetitionObj(self.TopCompetitionView,self)
end

function BaseHallView:OnFetchPowerUp_Result()
    if self.isPreviousFinish then
        --判断是否打开赛季PU海报
        self:ShowSeasonPowerUpPoster()
    end
end

function BaseHallView:OnOpenSuperMatchJackpot()
    if fun.is_not_null(self.SuperMatchJackpotEnable) then
        self:UpdateSmallGameIcon()
        fun.set_active(self.SuperMatchJackpotEnable, false)
        fun.set_active(self.SuperMatchJackpotEnable, true)
        UISound.play("supermatchactivate")
    end
end

---根据当前小游戏类型更新icon
function BaseHallView:UpdateSmallGameIconOld()
    local obj = fun.find_child(self.SuperMatchJackpotEnable, "font_jackpot")
    if obj then

        local img = fun.get_component(obj, fun.IMAGE)
        if img and img.sprite then
            local iconInfo = ModelList.SmallGameModel.GetCurrentGameJackpotIconInfo()
            if not fun.starts(img.sprite.name ,iconInfo) then
                Cache.load_texture_to_sprite(iconInfo, img, false)
            end
        end
    end

    local obj2 = fun.find_child(self.SuperMatchJackpotEnable, "font_enabled")
    if obj2 then
        local img = fun.get_component(obj2, fun.IMAGE)
        local iconInfo = ModelList.SmallGameModel.GetCurrentGameIconInfo()
        if img and img.sprite then
            if not fun.starts(img.sprite.name ,iconInfo) then
                Cache.load_texture_to_sprite(iconInfo, img)
            end
        end
    end
end

---根据当前小游戏类型更新icon
function BaseHallView:UpdateSmallGameIcon()
    local obj = fun.find_child(self.SuperMatchJackpotEnable, "font_jackpot")
    if obj then
        local iconInfo = ModelList.SmallGameModel.GetCurrentGameJackpotIconInfo()
        fun.eachChild(obj, function(child)
            fun.set_active(child, child.name == iconInfo)
        end)
    end

    local obj2 = fun.find_child(self.SuperMatchJackpotEnable, "font_enabled")
    if obj2 then
        local iconInfo = ModelList.SmallGameModel.GetCurrentGameIconInfo()
        fun.eachChild(obj2, function(child)
            fun.set_active(child, child.name == iconInfo)
        end)
    end
end

function BaseHallView:on_btn_tournament_buff_click()
    if not self:CheckCanClickViewBtn() then
        return
    end
    
    local bubble = ViewList.BubbleTipView and ViewList.BubbleTipView.go
    if bubble and bubble.gameObject.activeSelf then
        return 
    end
    local des_text = ModelList.TournamentModel:GetSprintBuffDes()
    local ArrowDirection = ViewList.BubbleTipView.ArrowDirection
    local params = {
        pos = self.TournamentSprintBuffIcon.transform.position, 
        dir = ArrowDirection.bottom,
        text = des_text,
        offset = Vector3.New(220, 90, 0),
        exclude = {self.btn_tournament_buff},
        arrowOffset = -200,
    }
    Facade.SendNotification(NotifyName.ShowUI, ViewList.BubbleTipView, nil, false, params)
end

function BaseHallView:CheckTournamentSprintBuff()
    if fun.is_null(self.TournamentSprintBuffIcon) then
        return
    end

    --这里就是要临时删除此功能
    if true then
        fun.set_active(self.TournamentSprintBuffIcon, false)
        return
    end

    if ModelList.TournamentModel:HasSprintBuff() then
        fun.set_active(self.TournamentSprintBuffIcon, true)
    else
        fun.set_active(self.TournamentSprintBuffIcon, false)
    end
    local buffRemainTime = ModelList.TournamentModel:GetSprintBuffRemainTime()
    if buffRemainTime > 0 then
        self.tournamentBuffRemainCountDown = self.tournamentBuffRemainCountDown or RemainTimeCountDown:New()
        self.tournamentBuffRemainCountDown:StartCountDown(CountDownType.cdt2, buffRemainTime, self.text_tournament_buff_time,
            function()
                self:CheckTournamentSprintBuff()
            end
        )
    end
end

function BaseHallView:UpdateCompetitionView()
    --判断是否是过期obj
    if fun.is_null(self.TopCompetitionView) then
        self.TopCompetitionView = nil
    end
    if self.TopCompetitionView then
        local name = self.TopCompetitionView.transform.name
        local isCookie = string.find(name, "Cookie")
        if isCookie then
            if not ModelList.CompetitionModel:IsActivityAvailable() then
                self._hallFunction._topCompetition = nil
                Destroy(self.TopCompetitionView)
                self.TopCompetitionView = nil
            end
        else
            if not ModelList.CarQuestModel:IsActivityAvailable() then
                self._hallFunction._topCompetition = nil
                Destroy(self.TopCompetitionView)
                self.TopCompetitionView = nil
            end
        end
    else

    end
    self._hallFunction:InitTopCompetition()
    self:CheckCompetitionObj(self.TopCompetitionView,self)
end

function BaseHallView:on_btn_play_click()
    if not self:CheckCanClickViewBtn() then
        return
    end
    
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local sceneId = ModelList.CityModel.GetCity()
    if playId > 1 then sceneId = 0 end  --此处先强制校正
    if sceneId == 0 then
        --子玩法
        local key = string.format("%s%s", sceneId, playId)
        local viewName = string.format("SelectBattleConfigView%s", key)
        local View = require(string.format("View/PeripheralSystem/SelectBattleConfigView/%s",viewName))
        Facade.SendNotification(NotifyName.ShowUI, View)
    else
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SelectBattleConfigView)
    end
end

function BaseHallView:CheckCanClickViewBtn()
    --local isGuideComplete = ModelList.GuideModel:IsGuideComplete(7) 
    --local cantClick = not isGuideComplete and self.isInCityPopupState
    local cantClick = self.isInCityPopupState
    return not cantClick
end

function BaseHallView:InitMiniGameIcon()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    log.log("进入的机台数据"  ,  playId)
    local miniGamePrefabName = nil
    for k ,v in pairs(Csv.new_city_play) do
        if v.play_type == playId then
            miniGamePrefabName = v.function_btn
            break
        end
    end
    if not miniGamePrefabName then
        log.log("缺少机台玩法小游戏prefab  " , playId)
        return
    end
    if self.miniGameView and self.miniGameView:GetMiniGameName() == miniGamePrefabName then
        self.miniGameView:RefreshItem()
        log.log("刷新已有的")
        return
    end

    if self.miniGameView then
        self.miniGameView:Close()
        self.miniGameView = nil
    end
    Cache.load_prefabs(AssetList[miniGamePrefabName],miniGamePrefabName,function(ret)
        if ret then
            local go = Cache.create(AssetList[miniGamePrefabName],miniGamePrefabName)
            fun.set_parent(go,self.minigameParent,true)
            local view = ViewList[miniGamePrefabName]
            view:SkipLoadShow(go)
            view.owner = self
            self.miniGameView = view
        else
            log.log("错误 资源丢失 小游戏prefab " , miniGamePrefabName)
        end
    end)
end

this.NotifyList = {
    {notifyName = NotifyName.HallCity.Function_icon_click, func = OnNotifyFunctionIconClick},
    {notifyName = NotifyName.ShopView.OpenShopView, func = OnNotifyOpenShopView},
    {notifyName = NotifyName.HallMainView.PlayCardsClick,func = OnNotifyPlayCardsClick},
    {notifyName = NotifyName.HallMainView.RefreshHallInfo,func = OnNotifyRefreshHallInfo},
    {notifyName = NotifyName.HallMainView.RefreshCouponInfo, func = OnNotifyRefreshCouponInfo},
    {notifyName = NotifyName.LobbyAdvertise.RequestWatchAd, func = OnNotifyRequestWatchAd},
    {notifyName = NotifyName.BetRateOperatedView.betRateChange, func = OnNotifyBetRateChange},
    {notifyName = NotifyName.Event_machine_download_success_view, func = this.OnDownloadGameSuccess},

    {notifyName = NotifyName.HallCity.Function_icon_click_special, func = OnNotifyFunctionIconClickSpecial},
}

this.NotifyEnhanceList = {
    {notifyName = NotifyName.UltraBet.ActivityStart, func = this.OnUltraBetStart},
    {notifyName = NotifyName.UltraBet.ActivityEnd, func = this.OnUltraBetEnd},
    {notifyName = NotifyName.PlayerInfo.RefreshGroupPrefix, func = this.OnGroupPrefixRefresh},
    {notifyName = NotifyName.ShopView.OnCloseViewFinish, func = this.OnShopViewClose},
    {notifyName = NotifyName.Competition.ResphoneNotify,func = this.OnResNotify},
    {notifyName = NotifyName.PowerUps.FetchPowerUp_Result2,func = this.OnFetchPowerUp_Result},
    {notifyName = NotifyName.HallMainView.OpenSuperMatchJackpot,func = this.OnOpenSuperMatchJackpot},
}

return this
