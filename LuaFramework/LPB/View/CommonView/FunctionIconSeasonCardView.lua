-- 赛季卡片
require "View/CommonView/RemainTimeCountDown"
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
local FunctionIconSeasonCardView = FunctionIconBaseView:New()
local this = FunctionIconSeasonCardView
local spacing = 150
local switchIconTime = 5
this.viewType = CanvasSortingOrderManager.LayerType.None
local ItemEntityCache = {}
this.index = 0
this.ICON_INDEX = 1
this.CLOWN_CARD_INDEX = 2

this.auto_bind_ui_items = {
    "btn_icon",
    "text_countdown",
    --"Content",
    --"Icon1",
    --"Icon2",
    --"iconsPanel",
    --"newFlag",
    "bubbleTip",
    "text_tip",
    "progressBg",
    "progressBar",
    "txtProgress",
    --"imgGiftBg",
}

local ResStates = {
    none = 1,
    waitingDownloadRes = 2,
    resDownloading = 3,
    resDownloaded = 4,
    resDownloadFail = 5,
}

function FunctionIconSeasonCardView:New()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.remainTimeCountDown = RemainTimeCountDown:New()
    return o
end

function FunctionIconSeasonCardView:Awake()
    self:on_init()
end

function FunctionIconSeasonCardView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:RegisterRedDotNode()
    self:RegisterEvent()
    self:InitData()
    self:InitView()
end

function FunctionIconSeasonCardView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
    self:StopSlideShowTimer()
    self.remainTimeCountDown:StopCountDown()
    self:HideBubble()
end

function FunctionIconSeasonCardView:OnDestroy()
    self:Close()
end

function FunctionIconSeasonCardView:InitData()
    self.seasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    self.downloadUrl = ModelList.SeasonCardModel:GenDownloadUrl(self.seasonId)
    self.unzipDir = ModelList.SeasonCardModel:GenUnzipResDir(self.seasonId)
    self:InitResState()
end

function FunctionIconSeasonCardView:InitView()
    self:StopSlideShowTimer()
    self:InitIconPos()
    self:StartDisplayIcon(1)
    self:UpdateIconSlideState()
    self:UpdateNewFlag()
    self:UpdateRewardFlag()
    self:SetLeftTime()
    self:HideBubble()
    self:InitResStateUI()
end

function FunctionIconSeasonCardView:InitResState()
    local curSeasonId = ModelList.SeasonCardModel:GetCurSeasonId()
    if ModelList.SeasonCardModel:IsNeedDownloadRes(curSeasonId) then
        self:SetResState(ResStates.waitingDownloadRes)
    else
        self:SetResState(ResStates.resDownloaded)
    end
end

function FunctionIconSeasonCardView:InitResStateUI()
    if self.resState == ResStates.resDownloaded then
        fun.set_active(self.progressBg, false)
    else
        if ZipDownloadManager.IsHasRequestDownload(self.downloadUrl) then
            local progress = ZipDownloadManager.GetZipDownloadProgress(self.downloadUrl)
            self:UpdateDownloadProgress(progress)
            fun.set_active(self.progressBg, true)
            log.log(" FunctionIconSeasonCardView:InitResStateUI 已在下载任务中", self.downloadUrl)
        else
            fun.set_active(self.progressBg, false)
            self:UpdateDownloadProgress(0)
            log.log(" FunctionIconSeasonCardView:InitResStateUI 不在下载任务中", self.downloadUrl)
        end
    end
end

function FunctionIconSeasonCardView:StartDownloadRes()
    log.log("FunctionIconSeasonCardView:StartDownloadRes", self.downloadUrl, self.unzipDir)
    ZipDownloadManager.StartDownLoadZip(self.downloadUrl, self.unzipDir, nil, true)
    fun.set_active(self.progressBg, true)
    self:UpdateDownloadProgress(0)
    self:SetResState(ResStates.resDownloading)
end

function FunctionIconSeasonCardView:UpdateDownloadProgress(progress)
    progress = progress or 0
    self.progressBar.fillAmount = progress / 100
    self.txtProgress.text = math.floor(progress) .. "%"
end

function FunctionIconSeasonCardView:SetResState(state)
    self.resState = state
end

function FunctionIconSeasonCardView:UpdateIconSlideState()
    if ModelList.SeasonCardModel:IsHasClownCard() then
        if not self.slideShowTimer then
            self:StartSlideIcon()
        end
    else
        self:StopSlideIcon()
    end
end

function FunctionIconSeasonCardView:OnSwitchIconStart()
    self:HideBubble()
end

function FunctionIconSeasonCardView:OnSwitchIconFinish()
    --for i = 1, 2 do
    --    local curPosX = fun.get_gameobject_pos(self["Icon" .. i], true).x
    --    if curPosX < -spacing / 4 then
    --        fun.set_gameobject_pos(self["Icon" .. i], spacing, 0, 0, true)
    --    elseif curPosX < spacing / 4 then
    --        self:StartDisplayIcon(i)
    --    end
    --end
    --if not ModelList.SeasonCardModel:IsHasClownCard() then
    --    self:StopSlideIcon()
    --end
end

--开启定时器轮播图片
--function FunctionIconSeasonCardView:StartSlideIcon()
--    self:StopSlideShowTimer()
--    self.slideShowTimer = LuaTimer:SetDelayLoopFunction(0, switchIconTime, -1, function()
--        for i = 1, 2 do
--            local curPosX = fun.get_gameobject_pos(self["Icon" .. i], true).x
--            local cb = nil
--            if i == 2 then
--                self:OnSwitchIconStart()
--                cb = function() self:OnSwitchIconFinish() end
--            end
--            Anim.move_to_xy_local_ease(self["Icon" .. i], curPosX - spacing, 0, 1, cb)
--        end
--    end,nil,nil,LuaTimer.TimerType.UI)
--end

function FunctionIconSeasonCardView:StopSlideIcon()
    log.log("FunctionIconSeasonCardView:StopSlideIcon")
    self:InitIconPos()
    self:StartDisplayIcon(1)
    self:StopSlideShowTimer()
    self:HideBubble()
end

function FunctionIconSeasonCardView:InitIconPos()
    --for i = 1, 2 do
    --    fun.set_gameobject_pos(self["Icon" .. i], (i - 1) * spacing, 0, 0, true)
    --end
end

function FunctionIconSeasonCardView:UpdateNewFlag(isHasNewCard)
    --fun.set_active(self.newFlag, false)
    --for i = 1, 2 do
    --    local ref = fun.get_component(self["Icon" .. i], fun.REFER)
    --    local newFlag = ref:Get("newFlag")
    --    fun.set_active(newFlag, false)
    --end
    --
    --if isHasNewCard == nil then
    --    isHasNewCard = ModelList.SeasonCardModel:IsHasNewCardInAlbum()
    --end
    --
    --fun.set_active(self.newFlag, isHasNewCard)
end

function FunctionIconSeasonCardView:UpdateRewardFlag()
    --local isHasUnclaimedReward = ModelList.SeasonCardModel:IsHasUnclaimedReward(self.seasonId)
    --fun.set_active(self.imgGiftBg, isHasUnclaimedReward)
    --if isHasUnclaimedReward then
    --    fun.set_active(self.newFlag, false)
    --end
end

function FunctionIconSeasonCardView:StartDisplayIcon(index)
    if index == self.CLOWN_CARD_INDEX then
        self:ShowBubble()
    end
end

function FunctionIconSeasonCardView:StopSlideShowTimer()
    if self.slideShowTimer then
        LuaTimer:Remove(self.slideShowTimer)
        self.slideShowTimer = nil
    end
end
  
function FunctionIconSeasonCardView:RegisterEvent()
end

function FunctionIconSeasonCardView:UnRegisterEvent()
end

function FunctionIconSeasonCardView:RegisterRedDotNode()
end

function FunctionIconSeasonCardView:UnRegisterRedDotNode()
end

--是否过期
function FunctionIconSeasonCardView:IsExpired()
    if not ModelList.SeasonCardModel:IsActivityValid() then
        return true
    end

    --[[现在两个赛季无缝衔接，无过期的概念
    if ModelList.SeasonCardModel:GetLeftTime() <= 0 then
        return true
    end
    --]]

    return false
end

function FunctionIconSeasonCardView:on_btn_icon_click()
    --[[
    ModelList.SeasonCardModel:EnterSystem()
    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    SDK.click_card_icon(playerLevel)
    --]]
    --[[
    --undo 临时方案
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SeasonCardGroupView", false)
    --]]

    log.log("SeasonCardAlbumItem:on_btn_album_click current state is", self.state)
    if self.resState == ResStates.waitingDownloadRes then
        self:StartDownloadRes()
    elseif self.resState == ResStates.resDownloadFail then
        self:StartDownloadRes()
    elseif self.resState == ResStates.resDownloaded then
        Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SeasonCardGroupView", false)
    else
    end
end

function FunctionIconSeasonCardView:SetLeftTime()
    local endTimeStamp = ModelList.SeasonCardModel:GetActivityExpireTime()
    local curTime = ModelList.PlayerInfoModel.get_cur_server_time()
    local endTime = endTimeStamp - curTime
    if endTime > 0 then
        if not self.remainTimeCountDown then
            self.remainTimeCountDown = RemainTimeCountDown:New()
        end
        self.remainTimeCountDown:StopCountDown()
        self.remainTimeCountDown:StartCountDown(CountDownType.cdt2, endTime, self.text_countdown, function()
            if self:IsExpired() then
                --self:Hide()
                log.log("FunctionIconSeasonCardView:SetLeftTime 赛季已经过期1", endTimeStamp, curTime, endTime)
            else
                self:SetLeftTime()
            end
        end)
    else
        --self:Hide()
        log.log("FunctionIconSeasonCardView:SetLeftTime 赛季已经过期2", endTimeStamp, curTime)
    end
end

function FunctionIconSeasonCardView:ShowBubble()
    fun.set_active(self.bubbleTip, true)
    self:SetClownCardLeftTime()
end

function FunctionIconSeasonCardView:HideBubble()
    fun.set_active(self.bubbleTip, false)
    self:RemoveClownCardTimer()
end

function FunctionIconSeasonCardView:SetBubbleText(text)
    if not fun.is_null(self.text_tip) then
        self.text_tip.text = text
    end
end

function FunctionIconSeasonCardView:SetClownCardLeftTime()
    local expireTime = ModelList.SeasonCardModel:GetSoonestClownCardExpire()
    local currentTime = ModelList.SeasonCardModel:GetCurrentTime()
    self.clownCardEndTime = expireTime - currentTime
    self:RemoveClownCardTimer()
    if self.clownCardEndTime > 0 then
        self.clownCardLoopTime = LuaTimer:SetDelayLoopFunction(0, 1, -1, function()
            if self.clownCardEndTime >= 0 then
                self:SetBubbleText("Lost countdown\n" .. fun.SecondToStrFormat(self.clownCardEndTime))
                self.clownCardEndTime = self.clownCardEndTime - 1
                if self.clownCardEndTime <= 0 then
                end
            end
        end,nil,nil,LuaTimer.TimerType.UI)
    end
end

function FunctionIconSeasonCardView:RemoveClownCardTimer()
    if self.clownCardLoopTime then
        LuaTimer:Remove(self.clownCardLoopTime)
        self.clownCardLoopTime = nil
    end
end

function FunctionIconSeasonCardView:OnAlbumNewCardStateChange(params)
    log.log("FunctionIconSeasonCardView:OnAlbumNewCardStateChange", params)
    if params.isCurSeason then
        local groupId = params.groupId
        self:UpdateNewFlag(params.isHasNew)
    end
end

function FunctionIconSeasonCardView:OnClownCardCountChange(params)
    log.log("FunctionIconSeasonCardView:OnClownCardCountChange", params)
    self:UpdateIconSlideState()
end

function FunctionIconSeasonCardView:OnReceiveAlbumWholeData(params)
    log.log("FunctionIconSeasonCardView:OnReceiveAlbumWholeData", params)
    self:UpdateIconSlideState()
    self:UpdateNewFlag()
    self:UpdateRewardFlag()
end

function FunctionIconSeasonCardView:OnStartDownload(params)
    if params.url == self.downloadUrl then
        --fun.set_active(self.progressBg, true)
    end
end

function FunctionIconSeasonCardView:OnUpdateProgress(params)
    if params.url == self.downloadUrl then
        self:UpdateDownloadProgress(params.progress)
    end
end

function FunctionIconSeasonCardView:OnDownloadSucceed(params)
    if params.url == self.downloadUrl then
        self:UpdateDownloadProgress(100)
        self:SetResState(ResStates.resDownloaded)
        self:register_invoke(function()
            fun.set_active(self.progressBg, false)
        end, 1.5)
    end
end

function FunctionIconSeasonCardView:OnDownloadFail(params)
    if params.url == self.downloadUrl then
        self:SetResState(ResStates.resDownloadFail)
    end
end

function FunctionIconSeasonCardView:OnSeasonOver(params)
    self:InitData()
    self:InitView()
end

function FunctionIconSeasonCardView:OnClickPosterToDownloadRes(params)
    self:StartDownloadRes()
end

function FunctionIconSeasonCardView:OnSeasonRewardStateChange(params)
    log.log("FunctionIconSeasonCardView:OnSeasonRewardStateChange", params)
    self:UpdateRewardFlag()
end

function FunctionIconSeasonCardView:OnCardAdd(params)
    log.log("FunctionIconSeasonCardView:OnCardAdd", params)
    self:UpdateRewardFlag()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.AlbumNewCardStateChange, func = this.OnAlbumNewCardStateChange},
    {notifyName = NotifyName.SeasonCard.ClownCardCountChange, func = this.OnClownCardCountChange},
    {notifyName = NotifyName.SeasonCard.ReceiveAlbumWholeData, func = this.OnReceiveAlbumWholeData},
    {notifyName = NotifyName.SeasonCard.SeasonOver, func = this.OnSeasonOver},
    {notifyName = NotifyName.SeasonCard.ClickPosterToDownloadRes, func = this.OnClickPosterToDownloadRes},
    {notifyName = NotifyName.SeasonCard.SeasonRewardStateChange, func = this.OnSeasonRewardStateChange},
    {notifyName = NotifyName.SeasonCard.CardAdd, func = this.OnCardAdd},

    {notifyName = NotifyName.ZipResDownload.StartDownload, func = this.OnStartDownload},
    {notifyName = NotifyName.ZipResDownload.UpdateProgress, func = this.OnUpdateProgress},
    {notifyName = NotifyName.ZipResDownload.DownloadSucceed, func = this.OnDownloadSucceed},
    {notifyName = NotifyName.ZipResDownload.DownloadError, func = this.OnDownloadFail},
}

return this