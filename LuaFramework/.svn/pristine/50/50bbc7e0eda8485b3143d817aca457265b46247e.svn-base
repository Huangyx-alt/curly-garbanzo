local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
require "View/CommonView/RemainTimeCountDown"
local FunctionIconTournamentView = FunctionIconBaseView:New()
local this = FunctionIconTournamentView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown",
}

local openTournamentType =
{
    ClickIcon = "ClickIcon",
    CountDownEnd = "CountDownEnd",
    Idle = "Idle",
}


local openHallofFameType =
{
    ClickIcon = "ClickIcon",
    CountDownEnd = "CountDownEnd",
    Idle = "Idle",
}

local currentOpenTournamentType = nil
local currentOpenHallofFameType = nil
local _hallofFameEntrance = require "View/HallCity/HallofFameEntrance"
function FunctionIconTournamentView:New()
    local o = {}
    self.__index = self
    o.remainTimeCountDown = RemainTimeCountDown:New()
    setmetatable(o,self)
    return o
end

function FunctionIconTournamentView:Awake()
    self:on_init()
end

function FunctionIconTournamentView:OnEnable()
    Facade.RegisterView(self)
    currentOpenTournamentType = openTournamentType.Idle
    currentOpenHallofFameType = openHallofFameType.Idle
    self:ShowTime()
end

function FunctionIconTournamentView:OnDisable()
    self.remainTimeCountDown:StopCountDown()
end

function FunctionIconTournamentView:on_btn_icon_click()
    if ModelList.TournamentModel:IsActivityAvailable() then
        if _tournamentEntrance:IsOpen() then
            self:SetTournamentActivityType(openTournamentType.ClickIcon)
            ModelList.TournamentModel:C2S_RequestTournamentRankInfo()
        end
    elseif ModelList.HallofFameModel:IsActivityAvailable() then
        if _hallofFameEntrance:IsOpen() then
            self:SetHallofFameActivityType(openHallofFameType.ClickIcon)
            ModelList.HallofFameModel:C2S_RequestRankInfo()
        end
    else
        UISound.play("button_invalid")
        UIUtil.show_common_popup(8017,true)
    end
end


function FunctionIconTournamentView:OnResphoneTournamentInfo()
    if currentOpenTournamentType == openTournamentType.CountDownEnd then
        this:RefreshTournament()
        --是通过下次开启倒计时请求的数据 不展示界面
    elseif currentOpenTournamentType == openTournamentType.ClickIcon then
        local tourmodel = ModelList.TournamentModel
        if tourmodel:IsRankInfoAvailable() then
            --ModelList.TournamentModel:C2S_RequestTournamentRewardInfo()
            --if tourmodel:CheckIsBlackGoldUser() then
            --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentBlackGoldView")
            --else
            --Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentView")
            ----ModelList.TournamentModel:GetTierAddAwards();       
            --end
            --Facade.SendNotification(NotifyName.HallCity.Function_icon_click_special,"TournamentScoreView",{isSettle = false})
            Facade.SendNotification(NotifyName.HallCity.Function_icon_click,"TournamentScoreView")
        else
            UIUtil.show_common_popup(8025,true)
        end
    else
        --idle不处理
    end
    this:SetTournamentActivityType(openTournamentType.Idle)
end


function FunctionIconTournamentView:IsFunctionOpen()
    return true
end

--�Ƿ����
function FunctionIconTournamentView:IsExpired()
    return not (ModelList.CarQuestModel:IsActivityAvailable() or false)
end

function FunctionIconTournamentView:ShowTime()
    self.remainTimeCountDown:StartCountDown(CountDownType.cdt2,ModelList.CarQuestModel:GetActivityRemainTime(),self.text_countdown)
end

function FunctionIconTournamentView:RefreshRedDot()
    RedDotManager:Refresh(RedDotEvent.bingopass_reddot_event)
end

function FunctionIconTournamentView:OnCityResourceChange()
    log.w("FunctionIconTournamentView =>OnCityResourceChange")

    self:RefreshRedDot()
end


function FunctionIconTournamentView:OnResphoneFameInfo()
    if currentOpenHallofFameType == openHallofFameType.CountDownEnd then
        this:RefreshFame()
        --是通过下次开启倒计时请求的数据 不展示界面
    elseif currentOpenHallofFameType == openHallofFameType.ClickIcon then
        local tourmodel = ModelList.HallofFameModel
        if tourmodel:IsRankInfoAvailable() then
            Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "HallofFameScoreView")
        else
            UIUtil.show_common_popup(1932,true)
        end
    else
        --idle不处理
    end
    this:SetHallofFameActivityType(openHallofFameType.Idle)
end

function FunctionIconTournamentView.ReqRefreshFameIcon()
    self:RefreshFame()
end

function FunctionIconTournamentView:RefreshFame()
    if _hallofFameEntrance then
        _hallofFameEntrance:InitData()
        _hallofFameEntrance:ShowInfo()
    end
end

function FunctionIconTournamentView:SetTournamentActivityType(type)
    currentOpenTournamentType = type
end

function FunctionIconTournamentView:SetHallofFameActivityType(type)
    currentOpenHallofFameType = type
end
--
this.NotifyList =
{
    {notifyName = NotifyName.HallofFame.FameResphoneRankInfo,func = this.OnResphoneFameInfo},
    {notifyName = NotifyName.HallofFame.FameReqRefreshIcon,func = this.ReqRefreshFameIcon},
    {notifyName = NotifyName.Tournament.ResphoneRankInfo,func = this.OnResphoneTournamentInfo},
}

return this