local SeasonCardAlbumItem = BaseView:New("SeasonCardAlbumItem")
local this = SeasonCardAlbumItem
this.viewType = CanvasSortingOrderManager.LayerType.none

this.auto_bind_ui_items = {
    "imgBg",
    "imgIcon",
    "progressBg",
    "progressBar",
    "txtProgress",
    "imgNew",
    "btn_album",
    "scalePanel",
    "nameBg",
    "txtName",
    "iconFinish",
    "txtSeason",
    "txtDes",
}

local States = {
    none = 1,
    waitingDownloadRes = 2,
    resDownloading = 3,
    resDownloadFail = 4,
    waitingReqData = 5,
    dataRequesting = 6,
    idle = 7,
}

function SeasonCardAlbumItem:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SeasonCardAlbumItem:Awake()
end

function SeasonCardAlbumItem:OnEnable()
    Facade.RegisterViewEnhance(self)
    self.isSelected = false
end

function SeasonCardAlbumItem:on_after_bind_ref()
    fun.set_active(self.progressBg, false)
    fun.set_active(self.iconFinish, false)
    self:SetNewIconVisible(false)
    self:InitItem()
end

function SeasonCardAlbumItem:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function SeasonCardAlbumItem:SetData(data)
    log.log("SeasonCardAlbumItem:SetData", data)
    self.data = data
    self.parent = data.parent
    self.index = data.index or 0
    self.seasonId = data.seasonId
    self.albumBaseInfo = ModelList.SeasonCardModel:GetSeasonBasicInfo(data.seasonId)
    self.albumFixedData = ModelList.SeasonCardModel:GetAlbumFixedData(data.seasonId)
    log.log("SeasonCardAlbumItem:SetData the albumFixedData is ", self.albumFixedData)
    
    self.downloadUrl = ModelList.SeasonCardModel:GenDownloadUrl(self.seasonId)
    self.unzipDir = ModelList.SeasonCardModel:GenUnzipResDir(self.seasonId)
    self:UpdateState()
end

function SeasonCardAlbumItem:UpdateState()
    if ModelList.SeasonCardModel:IsNeedDownloadRes(self.seasonId) then
        self:SetState(States.waitingDownloadRes)
    elseif not self:IsHasWholeData() then
        self:SetState(States.waitingReqData)
    else
        self:SetState(States.idle)
    end
end

function SeasonCardAlbumItem:SetState(state)
    self.state = state
end

function SeasonCardAlbumItem:InitItem()
    if not self.albumBaseInfo then
        return
    end
    self:InitBasicElement()
    if self.state == States.waitingDownloadRes then
        self:SetGray(true)
        if ZipDownloadManager.IsHasRequestDownload(self.downloadUrl) then
            local progress = ZipDownloadManager.GetZipDownloadProgress(self.downloadUrl)
            self:UpdateDownloadProgress(progress)
            fun.set_active(self.progressBg, true)
            self:SetState(States.resDownloading)
            log.log("SeasonCardAlbumItem:InitItem 资源已在下载任务中", self.downloadUrl)
        else
            log.log("SeasonCardAlbumItem:InitItem 资源不在下载任务中", self.downloadUrl)
            fun.set_active(self.progressBg, false)
        end
    else
        self:SetGray(false)
    end
end

function SeasonCardAlbumItem:InitBasicElement()
    local imgBg = fun.get_component(self.imgBg, fun.IMAGE)
    self.imgBg = imgBg

    --local iconName = "CardHistoryENT02"
    local iconName = self.albumFixedData.icon
    local imgIcon = fun.get_component(self.imgIcon, fun.IMAGE)
    self.imgIcon = imgIcon
    self.imgIconName = iconName

    self.txtName.text = self.albumFixedData.name
    fun.set_active(self.txtName, false)
    self.txtSeason.text = "Season" .. self.seasonId
end

function SeasonCardAlbumItem:SetGray(isGray)
    --fun.set_color_grey(self.txtSeason.gameObject, true)
    if isGray then
        self.txtSeason.color = Color(0.5, 0.5, 0.5, 1)
        self.imgBg.sprite = AtlasManager:GetSpriteByName("SeasonCardHistory", "CardHistoryENTdiAn")
        self.imgIcon.sprite = AtlasManager:GetSpriteByName("SeasonCardHistory", self.imgIconName .. "An")
    else
        self.txtSeason.color = Color(1, 1, 1, 1)
        self.imgBg.sprite = AtlasManager:GetSpriteByName("SeasonCardHistory", "CardHistoryENTdi")
        self.imgIcon.sprite = AtlasManager:GetSpriteByName("SeasonCardHistory", self.imgIconName)
    end
end

function SeasonCardAlbumItem:SetNewIconVisible(visible)
    fun.set_active(self.imgNew, visible)
end

function SeasonCardAlbumItem:SetGiftIconVisible(visible)
    fun.set_active(self.imgGiftBg, visible)
end

function SeasonCardAlbumItem:SetLockIconVisible(visible)
    fun.set_active(self.imgLock, visible)
end

function SeasonCardAlbumItem:on_btn_album_click()
    if not self.clickEnable then
        return
    end

    log.log("SeasonCardAlbumItem:on_btn_album_click current state is", self.state)
    if self.state == States.waitingDownloadRes then
        self:StartDownloadRes()
    elseif self.state == States.waitingReqData then
        self:RequestWholeData()
    elseif self.state == States.idle then
        self:SwitchAlbum()
    else
    end
end

function SeasonCardAlbumItem:SetClickEnable(enable)
    self.clickEnable = enable
end

-- function SeasonCardAlbumItem:IsNeedDownloadRes()
--     if not self:IsResDownloaded() then
--         return true
--     end

--     return ModelList.SeasonCardModel:IsNeedUpdateRes(self.seasonId)
-- end

-- function SeasonCardAlbumItem:IsResDownloaded()
--     local localVer = ModelList.SeasonCardModel:GetLocalResVersion(self.seasonId)
--     return localVer and localVer > 0
-- end

-- function SeasonCardAlbumItem:GenDownloadUrl()
--     local baseUrl = ModelList.SeasonCardModel:GetSourceUrl(self.seasonId)
--     local downloadUrl = baseUrl .. self.seasonId .. "/" .. self.seasonId .. ".zip"

--     --undo for test wait delete
--     if self.seasonId == 2 then
--         downloadUrl = baseUrl .. 1 .. "/" .. self.seasonId .. ".zip"
--     end

--     return downloadUrl
-- end

-- function SeasonCardAlbumItem:GenUnzipResDir()
--     local unzipDir = UnityEngine.Application.persistentDataPath .. "/SeasonCard/" .. self.seasonId .. "/"
--     return unzipDir
-- end

function SeasonCardAlbumItem:StartDownloadRes()
    log.log("dghdgh0007 SeasonCardAlbumItem:StartDownloadRes", self.downloadUrl, self.unzipDir)
    ZipDownloadManager.StartDownLoadZip(self.downloadUrl, self.unzipDir, nil, true)
    fun.set_active(self.progressBg, true)
    self:UpdateDownloadProgress(0)
    self:SetState(States.resDownloading)
end

function SeasonCardAlbumItem:UpdateDownloadProgress(progress)
    progress = progress or 0
    self.progressBar.fillAmount = progress / 100
    self.txtProgress.text = math.floor(progress) .. "%"
end

function SeasonCardAlbumItem:IsHasWholeData()
    return ModelList.SeasonCardModel:IsHasSeasonWholeData(self.seasonId)
end

function SeasonCardAlbumItem:HandleWholeDataResponse(succeed)
    self:UpdateState()
    if succeed then
        self:SwitchAlbum()
    else

    end
end

function SeasonCardAlbumItem:SwitchAlbum()
    local bundle = {seasonId = self.seasonId}
    Facade.SendNotification(NotifyName.SeasonCard.SwitchAlbum, bundle)
end

function SeasonCardAlbumItem:RequestWholeData()
    self:SetState(States.dataRequesting)
    ModelList.SeasonCardModel:RequestSeasonWholeData(self.seasonId, function(succeed)
        self:HandleWholeDataResponse(succeed)
    end)
end

function SeasonCardAlbumItem:OnStartDownload(params)
    if params.url == self.downloadUrl then
        --fun.set_active(self.progressBg, true)
    end
end

function SeasonCardAlbumItem:OnUpdateProgress(params)
    if params.url == self.downloadUrl then
        self:UpdateDownloadProgress(params.progress)
    end
end

function SeasonCardAlbumItem:OnDownloadSucceed(params)
    if params.url == self.downloadUrl then
        self:UpdateDownloadProgress(100)
        self:UpdateState()
        self:register_invoke(function()
            fun.set_active(self.progressBg, false)
            self:SetGray(false)
        end, 1.5)
    end
end

function SeasonCardAlbumItem:OnDownloadFail(params)
    if params.url == self.downloadUrl then
        self:SetState(States.resDownloadFail)
    end
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.ZipResDownload.StartDownload, func = this.OnStartDownload},
    {notifyName = NotifyName.ZipResDownload.UpdateProgress, func = this.OnUpdateProgress},
    {notifyName = NotifyName.ZipResDownload.DownloadSucceed, func = this.OnDownloadSucceed},
    {notifyName = NotifyName.ZipResDownload.DownloadError, func = this.OnDownloadFail},
}

return this