-- undo for test wait delete
local TestData = require("Model/SeasonCardModelTestData")
local SeasonCardModel = BaseModel:New("SeasonCardModel")
local this = SeasonCardModel
this.Consts = {
    TODAY_NO_LONGER_POPUP = "SeasonCardNoLongerPopup",
    TODAY_TIMESTAMP = "SeasonCardTimestamp",
    HAS_SHOWED_GUIDE = "SeasonCardHasShowedGuide",
    GROUP_COUNT_PER_PAGE = 9,
    CARD_COUNT_PER_PAGE = 9,

    MIN_PACKAGE_ID = 50000000,
    MAX_PACKAGE_ID = 59999999,
    CLOWN_CARD_ID = 10000000,

    RewardType = {
        album = 1,
        group = 2,
        card = 3,
        treasureBox = 4,
    },

    USE_LOCAL_CARD_RES = false,
}
local systemNeedAtlas = {
    "SeasonCardIconGroupS01", 
    "SeasonCardGallery", 
    "SeasonCardOpenPackage",
    "SeasonCardCommon",
}

local openCardBagNeedAtlas = {
    "SeasonCardGallery", 
    "SeasonCardOpenPackage",
    "SeasonCardCommon",
}

function SeasonCardModel:InitData()
    self.curSeasonId = nil      --当前的最新的
    self.curSeasonAlbum = nil
    self.hasNecessaryData = false
    self.unopenedPackages = nil
    self.isHasUnopenedPackage = false
    self.sourceBaseUrl = nil

    self.showingSeasonId = nil  --正在浏览的（可以是最新的，也可以是历史的）
    self.showingSeasonAlbum = nil
    self.seasonAlbumList = nil
    self.simplifiedAlbumList = nil
    self.validAlbumDataList = nil
end

function SeasonCardModel:GetSourceUrl(seasonId)
    return self.sourceBaseUrl or "https://d24rbv31oqc5gm.cloudfront.net/SeasonCard/"
end

function SeasonCardModel:GetServerResVersion(seasonId)
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].version
    end

    return 1
end

function SeasonCardModel:GetLocalResVersion(seasonId)
    --local relativePath = "SeasonCard/" .. seasonId .. "/" .. seasonId .. ".txt"
    local relativePath = "SeasonCard/" .. seasonId .. "/detail.txt"
    local ver = ZipDownloadManager.ReadResLocalVersion(relativePath)
    return ver
end

function SeasonCardModel:IsNeedUpdateRes(seasonId)
    local localVer = self:GetLocalResVersion(seasonId)
    local serverVer = self:GetServerResVersion(seasonId)
    log.log("dghdgh0007 is need update res ", seasonId, localVer, serverVer)
    return localVer == 0 or localVer < serverVer
end

function SeasonCardModel:IsNeedDownloadRes(seasonId)
    if not self:IsResDownloaded(seasonId) then
        return true
    end

    return self:IsNeedUpdateRes(seasonId)
end

function SeasonCardModel:IsResDownloaded(seasonId)
    local localVer = self:GetLocalResVersion(seasonId)
    return localVer and localVer > 0
end

function SeasonCardModel:GenDownloadUrl(seasonId)
    local baseUrl = self:GetSourceUrl(seasonId)
    local downloadUrl = baseUrl .. seasonId .. "/" .. seasonId .. ".zip"
    return downloadUrl
end

function SeasonCardModel:GenUnzipResDir(seasonId)
    local unzipDir = UnityEngine.Application.persistentDataPath .. "/SeasonCard/" .. seasonId .. "/"
    return unzipDir
end

function SeasonCardModel:IsHasSeasonWholeData(seasonId)
    -- self.seasonAlbumList = nil
    -- self.validAlbumDataList = nil
    return self:IsAlbumDataValid(seasonId)
end

--当前活动是否有效
function SeasonCardModel:IsActivityValid()
    return self.curSeasonAlbum and self.curSeasonAlbum.isOpen
end

function SeasonCardModel:GetActivityExpireTime(seasonId)
    seasonId = seasonId or self.curSeasonId
    local expireTime = 0
    --expireTime = self.curSeasonAlbum and self.curSeasonAlbum.expireTime or 0
    --expireTime = self:GetCurrentTime() + 1800 --for test
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        expireTime = self.seasonAlbumList[seasonId].expireTime or 0    
    end
    return expireTime
end

function SeasonCardModel:GetCurrentTime()
    return ModelList.PlayerInfoModel.get_cur_server_time()
end

function SeasonCardModel:GetLeftTime(seasonId)
    return self:GetActivityExpireTime(seasonId) - self:GetCurrentTime()
end

function SeasonCardModel:GetGroups(seasonId)
    --[[
    seasonId = seasonId or self.curSeasonId
    local groups = Csv.GetData("season_card_time", seasonId, "card_group")
    return groups
    --]]
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].groups
    end

    --默认值取最新赛季的
    return self.curSeasonAlbum and self.curSeasonAlbum.groups
end


function SeasonCardModel:GetAlbumFixedData(seasonId)
    local info = Csv.GetData("season_card_time", seasonId)
    return info
end

function SeasonCardModel:GetGroupCount(seasonId)
    local groups = self:GetGroups(seasonId)
    if groups then
        return #groups
    end

    return 0
end

function SeasonCardModel:IsHasNewCardInAlbum(seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].hasNewCard
    end

    -- 默认当前（最新）赛季
    return self.curSeasonAlbum and self.curSeasonAlbum.hasNewCard
end

function SeasonCardModel:GetAlbumRewardInfo(seasonId)
    --[[
    seasonId = seasonId or self.curSeasonId
    local reward = Csv.GetData("season_card_time", seasonId, "reward")
    local formatReward = {}
    --转成统一形式
    for i, v in ipairs(reward) do
        formatReward[i] = {}
        formatReward[i].id = v[1]
        formatReward[i].value = v[2]
    end
    return formatReward
    --]]

    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].reward
    end

    --默认正在浏览的赛季
    return self.showingSeasonAlbum.reward
end

function SeasonCardModel:GetGroupInfo(groupId, seasonId)
    seasonId = seasonId or self.curSeasonId
    local groupInfo = {}
    groupInfo.groupId = groupId
    groupInfo.fixedData = self:GetGroupFixedData(groupId, seasonId)
    groupInfo.flexibleData = self:GetGroupFlexibledata(groupId, seasonId)
    groupInfo.seasonId = seasonId
    return groupInfo
end

function SeasonCardModel:GetCardCount(cardId, seasonId)
    seasonId = seasonId or self.curSeasonId
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].cardMap[cardId] and self.seasonAlbumList[seasonId].cardMap[cardId].collectNum or 0
    end

    return 0
end

--这里依赖表的内容
function SeasonCardModel:GetGroupFixedData(groupId, seasonId)
    --[[
    local groupInfo = Csv.GetData("season_card_group", groupId)
    return groupInfo
    --]]
    seasonId = seasonId or self.curSeasonId
    if not Csv.season_card_group then
        log.log("SeasonCardModel:GetGroupFixedData(groupId, seasonId) season_card_group 配置表Error", groupId, seasonId)
        return
    end

    for i, v in ipairs(Csv.season_card_group) do
        if v.id == groupId and v.season == seasonId then
            return v
        end
    end
end

function SeasonCardModel:GetGroupFlexibledata(groupId, seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].groupMap[groupId]
    end

    return self.curSeasonAlbum and self.curSeasonAlbum.groupMap[groupId]
end

function SeasonCardModel:GetCardInfo(cardId, seasonId)
    seasonId = seasonId or self.showingSeasonId
    local cardInfo = {}
    cardInfo.cardId = cardId
    cardInfo.fixedData = self:GetCardFixedData(cardId, seasonId)
    cardInfo.flexibleData = self:GetCardFlexibledata(cardId, seasonId)
    cardInfo.seasonId = seasonId
    return cardInfo
end

--deprecated
function SeasonCardModel:GetCardFixedDataOld(cardId)
    local cardInfo = Csv.GetData("season_card", cardId)
    return cardInfo
end

--兼容新老两个版本的配置表数据，临时处理undo待做赛季切换功能时做进一步处理
function SeasonCardModel:GetCardFixedData(cardId, seasonId)
    if not Csv.season_card then
        local userId = tostring(ModelList.PlayerInfoModel:GetUid())
        log.log("SeasonCardModel:GetCardFixedData(cardId) season_card 配置表Error", cardId)
        fun.ReportErrorLog(userId .. " SeasonCardModel:GetCardFixedData(cardId) season_card 配置表Error " .. tostring(cardId) .. " ".. tostring(seasonId))
        return
    end
    local orgSeasonId = seasonId
    
    if Csv.season_card[1] and Csv.season_card[1].serial_number then
        seasonId = seasonId or self.curSeasonId
        for i, v in ipairs(Csv.season_card) do
            if v.id == cardId and (v.season == seasonId or v.season == 0) then
                return v
            end
        end
        local userId = tostring(ModelList.PlayerInfoModel:GetUid())
        log.log("SeasonCardModel:GetCardFixedData(cardId) 获得数据有误 " .. tostring(cardId) .. " orgSeasonId is ".. tostring(orgSeasonId) .. " seasonId is " .. tostring(seasonId))
        fun.ReportErrorLog(userId .. "SeasonCardModel:GetCardFixedData(cardId) 获得数据有误 " .. tostring(cardId) .. " orgSeasonId is ".. tostring(orgSeasonId) .. " seasonId is " .. tostring(seasonId))
    else
        local cardInfo = Csv.GetData("season_card", cardId)
        return cardInfo
    end
end

function SeasonCardModel:GetCardFlexibledata(cardId, seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].cardMap[cardId]
    end

    return self.curSeasonAlbum and self.curSeasonAlbum.cardMap[cardId]
end

function SeasonCardModel:GetBoxIds()
    return self.curSeasonAlbum.boxIds
end

function SeasonCardModel:GetBoxInfo(boxId)
    local boxInfo = {}
    boxInfo.boxId = boxId
    boxInfo.fixedData = self:GetBoxFixedData(boxId)
    boxInfo.flexibleData = self:GetBoxFlexibledata(boxId)
    return boxInfo
end

function SeasonCardModel:GetBoxFixedData(boxId, seasonId)
    seasonId = seasonId or self.curSeasonId
    for i, v in ipairs(Csv.season_card_exchange) do
        if v.box_id == boxId and v.season == seasonId then
            return v
        end
    end
end

function SeasonCardModel:GetAllBoxInfo()
    local boxIds = self:GetBoxIds() or {}
    local ret = {}
    for index, id in ipairs(boxIds) do
        table.insert(ret, self:GetBoxInfo(id))
    end

    return ret
end

--[[
function SeasonCardModel:GetBoxFixedData(boxId)
    local cardInfo = Csv.GetData("season_card_exchange", boxId)
    return cardInfo
end
--]]

function SeasonCardModel:GetBoxFlexibledata(boxId)
    return self.curSeasonAlbum.boxMap[boxId]
end

function SeasonCardModel:IsCardPackage(id)
    if not id then
        log.log("SeasonCardModel:IsCardPackage 输入id有问题")
        fun.ReportErrorLog("SeasonCardModel:IsCardPackage 输入id有问题 " .. debug.traceback())
        return false
    end

    if id >= self.Consts.MIN_PACKAGE_ID and id <= self.Consts.MAX_PACKAGE_ID then
        return true
    end
    return false
end

function SeasonCardModel:GetCardPackageInfo(packageId, seasonId)
    --[[
    local packageInfo = Csv.GetData("season_card_box", packageId)
    return packageInfo
    --]]

    if not Csv.season_card_box then
        log.log("SeasonCardModel:GetCardPackageInfo(cardId, seasonId) season_card_box 配置表Error", packageId, seasonId)
        return
    end
    seasonId = seasonId or self.curSeasonId
    for i, v in ipairs(Csv.season_card_box) do
          if v.id == packageId and (v.season == seasonId or v.season == 0) then
            return v
        end
    end

    if not fun.IsEditor() then
        log.log("SeasonCardModel:GetCardPackageInfo(cardId, seasonId) 配置表中查不到数据", packageId, seasonId)
        return Csv.season_card_box[1]
    end
end

function SeasonCardModel:OpenCardPackage(params)
    log.log("SeasonCardModel:OpenCardPackage", params)
    if not params or not params.bagIds or #params.bagIds < 1 then
        log.log("SeasonCardModel:OpenCardPackage pass parameter error", params)
        return
    end
    self.openCardPackageParams = params
    ModelList.SeasonCardModel:C2S_OpenCardBag()
end

function SeasonCardModel:EnterGroup(groupId)
    local bundle = {}
    local groupInfo = self.showingSeasonAlbum.groupMap[groupId]
    if groupInfo.hasNewSeasonCard then
        groupInfo.hasNewSeasonCard = false
        bundle.newStateChange = true
        self:C2S_OpenCardGroup(groupId)
        self:UpdateAlbumNewCardState(groupId, self.showingSeasonId)
    end

    bundle.groupId = groupId
    Facade.SendNotification(NotifyName.SeasonCard.EnterGroup, bundle)
end

function SeasonCardModel:UpdateAlbumNewCardState(groupId, seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] and self.seasonAlbumList[seasonId].groups then
    --if self.curSeasonAlbum and self.curSeasonAlbum.groups then
        local findNew = false
        local hasNewSeasonCard = self.seasonAlbumList[seasonId].hasNewSeasonCard
        for index, group in ipairs(self.seasonAlbumList[seasonId].groups) do
            if group.hasNewSeasonCard then
                self.seasonAlbumList[seasonId].hasNewSeasonCard = true
                findNew = true
                break
            end
        end
        if not findNew then
            self.seasonAlbumList[seasonId].hasNewSeasonCard = false
        end
        if self.seasonAlbumList[seasonId].hasNewSeasonCard ~= hasNewSeasonCard then
            local bundle = {}
            bundle.groupId = groupId
            bundle.isHasNew = self.seasonAlbumList[seasonId].hasNewSeasonCard
            bundle.seasonId = seasonId
            bundle.isCurSeason = seasonId == self.curSeasonId
            Facade.SendNotification(NotifyName.SeasonCard.AlbumNewCardStateChange, bundle)
        end
    end
end

function SeasonCardModel:SetShowingGroupId(groupId)
    self.showingGroupId = groupId
end

function SeasonCardModel:GetShowingGroupId()
    return self.showingGroupId
end

function SeasonCardModel:ClearShowingGroupId()
    self.showingGroupId = nil
end

function SeasonCardModel:IsAlbumCompleted(seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].isCompleted
    end
    return self.showingSeasonAlbum.isCompleted
end

function SeasonCardModel:IsAlbumRewarded(seasonId)
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        return self.seasonAlbumList[seasonId].isRewarded
    end
    return self.showingSeasonAlbum.isRewarded
end

function SeasonCardModel:IsGroupCompleted(groupId, seasonId)
    local groupInfo = self.showingSeasonAlbum.groupMap[groupId]
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        groupInfo = self.seasonAlbumList[seasonId].groupMap[groupId]
    end

    return groupInfo.isCompleted
end

function SeasonCardModel:IsGroupRewarded(groupId, seasonId)
    local groupInfo = self.showingSeasonAlbum.groupMap[groupId]
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        groupInfo = self.seasonAlbumList[seasonId].groupMap[groupId]
    end
    return groupInfo.isRewarded
end

--当前正在浏览的赛季id
function SeasonCardModel:GetShowingSeasonId()
    return self.showingSeasonId
end

--当前(最新)赛季id
function SeasonCardModel:GetCurSeasonId()
    return self.curSeasonId
end

function SeasonCardModel:EnterSystem()
    if self.hasNecessaryData and self:IsAlbumDataValid(self.curSeasonId) then
        -- ViewList.SeasonCardGroupView:SetData({seasonId = self.curSeasonId})

        -- Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardGroupView)
        --Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SeasonCardGroupView", true)
        self:OpenSystemView()
    else
        self.watingEnterSystem = true
        self:C2S_CardGroupList(self.curSeasonId)
    end
end

--undo temp deal
function SeasonCardModel:OpenSystemView()
    ViewList.SeasonCardGroupView:SetData({seasonId = self.curSeasonId})

    local leftCount = #systemNeedAtlas
    if leftCount > 0 then
        for i = 1, #systemNeedAtlas do
            Cache.Load_Atlas(AssetList[systemNeedAtlas[i]], systemNeedAtlas[i], function()
                leftCount = leftCount - 1
                if leftCount == 0 then
                    log.log("SeasonCardModel:OpenSystemView 加载图集完成 ", #systemNeedAtlas)
                    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardGroupView, function()
                        self:AfterEnterSystem()
                    end)
                    --Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SeasonCardGroupView", true)
                end
            end)
        end
    else
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardGroupView, function()
            self:AfterEnterSystem()
        end)
        --Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "SeasonCardGroupView", true)
    end
end

function SeasonCardModel:AfterEnterSystem()
    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local value = fun.read_value(ModelList.SeasonCardModel.Consts.HAS_SHOWED_GUIDE .. playerInfo.uid, false)
    if not value then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardHelpView)
        fun.save_value(ModelList.SeasonCardModel.Consts.HAS_SHOWED_GUIDE .. playerInfo.uid, true)
    end
end

--undo temp deal
function SeasonCardModel:ExitSystem()
    -- for i = 1, #systemNeedAtlas do
    --     Cache.unload_atlas_ab(systemNeedAtlas[i])
    -- end
    Cache.unload_atlas_ab("SeasonCardIconGroupS01")
    ViewTool:ClearAllSeasonCardSprite()
end

--数据是否还可用
function SeasonCardModel:IsAlbumDataValid(seasonId)
    return self.validAlbumDataList and self.validAlbumDataList[seasonId]
end

function SeasonCardModel:ExpireAlbumData(seasonId)
    if seasonId then
        self.validAlbumDataList = self.validAlbumDataList or {}
        self.validAlbumDataList[seasonId] = false
    end
end

function SeasonCardModel:ActiveAlbumData(seasonId)
    self.validAlbumDataList = self.validAlbumDataList or {}
    self.validAlbumDataList[seasonId] = true
end

-----------------------------------------------小丑卡相关-----------------------------------------------begin
--前提，最新赛季才有小丑卡
function SeasonCardModel:IsHasClownCard()
    if not self.curSeasonAlbum then
        return false
    end

    if not self.curSeasonAlbum.jokerCards then
        return false
    end

    return self:GetSoonestClownCardExpire() > 0
end

function SeasonCardModel:IsClownCard(cardId)
    local fixedData = self:GetCardFixedData(cardId)
    if fixedData then
        return fixedData.level == 0
    else
        log.log("SeasonCardModel:IsClownCard 输入cardId有问题", cardId)
        local userId = tostring(ModelList.PlayerInfoModel:GetUid())
        fun.ReportErrorLog(userId .. " SeasonCardModel:IsClownCard 输入cardId有问题 " .. tostring(cardId) .. " curSeasonId is " .. tostring(self.curSeasonId).. " ".. debug.traceback())
        return false
    end
end

function SeasonCardModel:GetSoonestClownCardExpire()
    local curTime = self:GetCurrentTime()
    for i, v in ipairs(self.curSeasonAlbum.jokerCards) do
        if v > curTime then
            return v
        end
    end

    return 0
end

function SeasonCardModel:GetAllClownCard()
    return self.curSeasonAlbum and self.curSeasonAlbum.jokerCards
end

function SeasonCardModel:GetClownCardId()
    return self.Consts.CLOWN_CARD_ID
end

function SeasonCardModel:SyncClownCard(clownCards)
    if not self.curSeasonAlbum or not clownCards then
        return
    end

    self.curSeasonAlbum.jokerCards = clownCards
end
-----------------------------------------------小丑卡相关-----------------------------------------------end

function SeasonCardModel:SetShowingAlbumById(seasonId)
    self.showingSeasonAlbum = self.seasonAlbumList[seasonId]
end

function SeasonCardModel:SetShowingAlbumId(seasonId)
    self.showingSeasonId = seasonId
end

function SeasonCardModel:ClearShowingAlbum()
    self.showingSeasonAlbum = nil
end

function SeasonCardModel:ClearShowingAlbumId()
    self.showingSeasonId = nil
end

function SeasonCardModel:IsGroupHasProgressReward(groupId, seasonId)
    local groupInfo = self.showingSeasonAlbum.groupMap[groupId]
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        groupInfo = self.seasonAlbumList[seasonId].groupMap[groupId]
    end
    return groupInfo.isCompleted and not groupInfo.isRewarded
end

function SeasonCardModel:IsGroupHasSingleCardReward(groupId, seasonId)
    local groupInfo = self.showingSeasonAlbum.groupMap[groupId]
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        groupInfo = self.seasonAlbumList[seasonId].groupMap[groupId]
    end

    for i, v in ipairs(groupInfo.cards) do
        --[[
        if v.hasReward and not v.isRewarded and v.collectNum > 0 then
            return true
        end
        --]]
        if self:IsHasSingleCardReward(v.cardId) then
            return true
        end
    end
    return false
end

function SeasonCardModel:IsHasSingleCardReward(cardId, seasonId)
    local cardInfo
    if seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        cardInfo = self.seasonAlbumList[seasonId].cardMap[cardId]
    else
        cardInfo = self.showingSeasonAlbum and self.showingSeasonAlbum.cardMap[cardId]
    end

    if cardInfo and cardInfo.hasReward and not cardInfo.isRewarded and cardInfo.collectNum > 0 then
        return true
    end

    return false
end

--是否有可领取的奖励（包括所有类型）
function SeasonCardModel:IsHasUnclaimedReward(seasonId)
    local seasonAlbum = seasonId and self.seasonAlbumList and self.seasonAlbumList[seasonId] or self.curSeasonAlbum

    if not seasonAlbum then
        log.log("SeasonCardModel:IsHasUnclaimedReward 数据异常 1")
        return false
    end

    if not seasonAlbum.groupMap then
        log.log("SeasonCardModel:IsHasUnclaimedReward 数据异常 2")
        return false
    end

    --季奖励
    if seasonAlbum.isCompleted and not seasonAlbum.isRewarded then
        log.log("SeasonCardModel:IsHasUnclaimedReward 季奖励")
        return true
    end

    --组奖励
    for i, v in pairs(seasonAlbum.groupMap) do
        if v.isCompleted and not v.isRewarded then
            log.log("SeasonCardModel:IsHasUnclaimedReward 组奖励")
            return true
        end
    end

    --卡奖励
    for i, v in pairs(seasonAlbum.groupMap) do
        if v.cards then
            for idx, card in ipairs(v.cards) do
                if self:IsHasSingleCardReward(card.cardId) then
                    log.log("SeasonCardModel:IsHasUnclaimedReward 卡奖励")
                    return true
                end
            end
        end
    end

    return false
end

--3016物品推送变化
function SeasonCardModel:SetDataUpdate(data, params)
    if data.updateSeasonCard then
        self:SetUnopenedPackageInfo(data.seasonCardInfo)
        self:ExpireAlbumData(self.curSeasonId)
    end
end

--获得玩家星星数量
function SeasonCardModel:GetStarCount()
    local count = ModelList.ItemModel.getResourceNumByType(Resource.season_card_star) or 0
    return count
end

--玩家星星数量发生变化
function SeasonCardModel:StarCountChange(from, to)
    local bundle = {}
    bundle.from = from or 0
    bundle.to = to or 0
    bundle.offset = bundle.to - bundle.from
    Facade.SendNotification(NotifyName.SeasonCard.StarCountChange, bundle)
    --log.log("SeasonCardModel:StarCountChange(from, to)", from, to, bundle)
    self:ExpireAlbumData(self.curSeasonId)
end

--玩家未打开过的卡包
function SeasonCardModel:SetUnopenedPackageInfo(data)
    self.unopenedPackages = data
    self.unopenedPackageCount = 0
    for i, v in ipairs(data) do
        --v.id
        self.unopenedPackageCount = self.unopenedPackageCount + v.value
    end

    self.isHasUnopenedPackage = self.unopenedPackageCount > 0
end

function SeasonCardModel:IsHasUnopenedPackage()
    return self.isHasUnopenedPackage
end

--处理卡册数据
function SeasonCardModel:HandleSeasonAlbumData(seasonAlbum)
    local album = {}

    if seasonAlbum then
        album.createTime = seasonAlbum.createTime
        album.expireTime = seasonAlbum.expireTime
        album.isOpen = seasonAlbum.isSeasonCardOpen
        album.reward = seasonAlbum.reward
        album.hasNewCard = seasonAlbum.hasNewSeasonCard
        album.bags = seasonAlbum.bags
        album.boxes = seasonAlbum.boxes
        album.groups = seasonAlbum.groups
        album.isCompleted = seasonAlbum.isCompleted
        album.isRewarded = seasonAlbum.isRewarded
        album.jokerCards = seasonAlbum.jokerCards
        album.version = seasonAlbum.version
        --album.jokerCards = seasonAlbum.jokerCards and {1695987229, 1693545060}
        local groupMap = {}
        local cardMap = {}
        local cardToGroupMap = {}
        for i1, v1 in ipairs(album.groups) do
            groupMap[v1.groupId] = v1
            v1.cardIds = {}
            for i2, v2 in ipairs(v1.cards) do
                cardMap[v2.cardId] = v2
                table.insert(v1.cardIds, v2.cardId)
                cardToGroupMap[v2.cardId] = v1.groupId
            end
        end
        album.groupMap = groupMap
        album.cardMap = cardMap
        album.cardToGroupMap = cardToGroupMap
        --转换成统一形式
        local unopenedPackages = {}
        for i, v in ipairs(album.bags) do
            unopenedPackages[i] = {}
            unopenedPackages[i].id = v.bagId
            unopenedPackages[i].value = v.num
        end
        album.unopenedPackages = unopenedPackages
    end

    local boxMap = {}
    local boxIds = {}
    for i1, v1 in ipairs(album.boxes) do
        boxMap[v1.boxId] = v1
        table.insert(boxIds, v1.boxId)
    end
    album.boxMap = boxMap
    album.boxIds = boxIds

    return album
end


function SeasonCardModel:HandleSimplifiedAlbumList(albums)
    if albums and #albums > 0 then
        --[[
        self.simplifiedAlbumList = {}
        for index, album in ipairs(albums) do
            self.simplifiedAlbumList[album.seasonId] = album
        end
        --]]

        self.simplifiedAlbumList = albums
    end
end

-- depercated
function SeasonCardModel:OpenOneCardPackage(bag)
    local find = false
    for i, v in ipairs(self.unopenedPackages) do
        if bag.bagId == v.id and v.value > 0 then
            find = true
            v.value = v.value - 1
        end
    end
    
    if find then
        self.unopenedPackageCount = self.unopenedPackageCount - 1
        self.isHasUnopenedPackage = self.unopenedPackageCount > 0
    end
end

--卡包打开成功
function SeasonCardModel:OpenCardBagSucc(content)
    if self:IsActivityValid() and self.hasNecessaryData then
        self:OpenCardBagSuccV1(content)
    else
        self:OpenCardBagSuccV2(content)
    end
end

--卡包打开成功(系统已经开放isopen为true, 且数据已经完全激活)
function SeasonCardModel:OpenCardBagSuccV1(content)
    log.log("SeasonCardModel:OpenCardBagSuccV1 ", content)
    local bagList = {}

    for idx, data in ipairs(content.seasons) do
        self:UpdateGroupRewardState(data.completeGroups, data.seasonId)
        self:UpdateAlbumRewardState(data.isAlbumComplete, data.seasonId)
        if data.seasonId == self.curSeasonId then
            self:SyncClownCard(data.jokerCards)
        end
        
        for i1, v1 in ipairs(data.bags) do
            --self:OpenOneCardPackage(v1) 暂不做此处理，当前需求为只要请打开卡包时，就会打开玩家当时所有未打开的卡包
            local bag = {}
            bag.bagId = v1.bagId
            bag.cardIds = {}
            bag.seasonId = data.seasonId
            for i2, v2 in ipairs(v1.cards) do
                self:AddCard(v2, data.seasonId)
                for i3 = 1, v2.collectNum do
                    table.insert(bag.cardIds, v2.cardId)
                end
            end

            table.insert(bagList, bag)
        end
    end
    if self.openCardPackageParams and self.openCardPackageParams.succCallback then
        self.openCardPackageParams.succCallback(bagList)
    end

    if #bagList > 0 then
        -- ViewList.SeasonCardOpenPackageView:SetData(bagList)
        -- ViewList.SeasonCardOpenPackageView:SetCloseCallback(self.openCardPackageParams and self.openCardPackageParams.finishCallback)
        -- Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenPackageView)
        self:EnterOpenCardBagView(bagList)
    else
        if self.openCardPackageParams and self.openCardPackageParams.finishCallback then
            self.openCardPackageParams.finishCallback()
        end
    end

    --当前需求为只要请打开卡包时，就会打开玩家当时所有未打开的卡包，故做此处理
    self.isHasUnopenedPackage = false
end

--卡包打开成功(系统未开放isopen为false, 或数据未完全激活)
function SeasonCardModel:OpenCardBagSuccV2(content)
    log.log("SeasonCardModel:OpenCardBagSuccV2 ", content)
    local bagList = {}
    for idx, data in ipairs(content.seasons) do
        for i1, v1 in ipairs(data.bags) do
            --self:OpenOneCardPackage(v1) 暂不做此处理，当前需求为只要请打开卡包时，就会打开玩家当时所有未打开的卡包
            local bag = {}
            bag.bagId = v1.bagId
            bag.cardIds = {}
            bag.seasonId = data.seasonId
            for i2, v2 in ipairs(v1.cards) do
                for i3 = 1, v2.collectNum do
                    table.insert(bag.cardIds, v2.cardId)
                end
            end

            table.insert(bagList, bag)
        end
    end
    if self.openCardPackageParams and self.openCardPackageParams.succCallback then
        self.openCardPackageParams.succCallback(bagList)
    end

    if #bagList > 0 then
        -- ViewList.SeasonCardOpenPackageView:SetData(bagList)
        -- ViewList.SeasonCardOpenPackageView:SetCloseCallback(self.openCardPackageParams and self.openCardPackageParams.finishCallback)
        -- Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenPackageView)
        self:EnterOpenCardBagView(bagList)
    else
        if self.openCardPackageParams and self.openCardPackageParams.finishCallback then
            self.openCardPackageParams.finishCallback()
        end
    end

    --当前需求为只要请打开卡包时，就会打开玩家当时所有未打开的卡包，故做此处理
    self.isHasUnopenedPackage = false
end

--卡包打开失败
function SeasonCardModel:OpenCardBagFail(code)
    if self.openCardPackageParams and self.openCardPackageParams.failCallback then
        self.openCardPackageParams.failCallback(code)
    end
end

--undo temp deal
--进入卡包打开界面
function SeasonCardModel:EnterOpenCardBagView(bagList)
    ViewList.SeasonCardOpenPackageView:SetData(bagList)
    ViewList.SeasonCardOpenPackageView:SetCloseCallback(self.openCardPackageParams and self.openCardPackageParams.finishCallback)

    local leftCount = #openCardBagNeedAtlas
    if leftCount > 0 then
        for i = 1, #openCardBagNeedAtlas do
            Cache.Load_Atlas(AssetList[openCardBagNeedAtlas[i]], openCardBagNeedAtlas[i], function()
                leftCount = leftCount - 1
                if leftCount == 0 then
                    log.log("SeasonCardModel:EnterOpenCardBagView 加载图集完成 ", #openCardBagNeedAtlas)
                    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenPackageView)
                end
            end)
        end
    else
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenPackageView)
    end
end

--更新卡册奖励状态
function SeasonCardModel:UpdateAlbumRewardState(isCompleted, seasonId)
    seasonId = seasonId or self.curSeasonId
    local seasonInfo
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        seasonInfo = self.seasonAlbumList[seasonId]
    else
        seasonInfo = self.curSeasonAlbum
    end

    --默认正在最新的赛季
    if seasonInfo and seasonInfo.isCompleted ~= isCompleted then
        seasonInfo.isCompleted = isCompleted
        local bundle = {}
        bundle.isCompleted = isCompleted
        bundle.seasonId = seasonId
        Facade.SendNotification(NotifyName.SeasonCard.AlbumRewardStateChange, bundle)
    end
end

--新获得卡片
function SeasonCardModel:AddCard(cardInfo, seasonId)
    seasonId = seasonId or self.curSeasonId
    if not self.seasonAlbumList[seasonId] then
        log.log("SeasonCardModel:AddCard(cardInfo, seasonId) 无此赛季数据记录", cardInfo, seasonId)
        return
    end
    local origCardInfo = self.seasonAlbumList[seasonId].cardMap[cardInfo.cardId]
    if origCardInfo then
        local origCardCount = origCardInfo.collectNum
        origCardInfo.hasReward = cardInfo.hasReward
        origCardInfo.isNew = cardInfo.isNew
        origCardInfo.collectNum = origCardInfo.collectNum + cardInfo.collectNum
        origCardInfo.isRewarded = cardInfo.isRewarded

        local groupId = self.seasonAlbumList[seasonId].cardToGroupMap[cardInfo.cardId]
        local groupInfo = self.seasonAlbumList[seasonId].groupMap[groupId]
        if cardInfo.isNew and groupInfo and origCardCount == 0 then
            groupInfo.progress = groupInfo.progress + 1
            if groupId == self.showingGroupId and seasonId == self.showingSeasonId then
                groupInfo.hasNewSeasonCard = false
                self:C2S_OpenCardGroup(groupId)
            else
                groupInfo.hasNewSeasonCard = true
            end
            self:UpdateAlbumNewCardState(groupId, seasonId)

            local bundle = {}
            bundle.groupId = groupId
            bundle.seasonId = seasonId
            Facade.SendNotification(NotifyName.SeasonCard.GroupStateChange, bundle)
        end
    else
        --没有记录，当前只有第一次获得小丑卡时
        self.curSeasonAlbum.cardMap[cardInfo.cardId] = deep_copy(cardInfo)
    end

    local bundle1 = {}
    bundle1.cardId = cardInfo.cardId
    bundle1.count = cardInfo.collectNum
    Facade.SendNotification(NotifyName.SeasonCard.CardAdd, bundle1)

    if self:IsClownCard(cardInfo.cardId) then
        local bundle2 = {}
        Facade.SendNotification(NotifyName.SeasonCard.ClownCardCountChange, bundle2)
    end

    self:ExpireAlbumData(seasonId)
end

--丢掉一张卡片
function SeasonCardModel:DropOneCard(cardId, seasonId)
    if not self.curSeasonAlbum then
        log.log("SeasonCardModel:DropOneCard 卡片系统未初始化", cardId, seasonId)
        return
    end

    if not self.seasonAlbumList or not self.seasonAlbumList[seasonId] then
        log.log("SeasonCardModel:DropOneCard 指定赛季的卡册未初始化", cardId, seasonId)
        return
    end

    local origCardInfo = self.curSeasonAlbum.cardMap[cardId]
    if origCardInfo then
        local origCardCount = origCardInfo.collectNum
        origCardInfo.collectNum = origCardInfo.collectNum - 1
        log.log("SeasonCardModel:DropOneCard 操作成功", cardId, origCardInfo.collectNum)
        local bundle = {}
        bundle.cardId = cardId
        bundle.seasonId = seasonId
        Facade.SendNotification(NotifyName.SeasonCard.DropOneCard, bundle)
    else
        log.log("SeasonCardModel:DropOneCard 找不到此卡片的记录", cardId)
    end

    self:ExpireAlbumData(seasonId)
end

--获取赛季卡组列表
function SeasonCardModel:UpdateGroupRewardState(completeGroups, seasonId)
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        for i, v in ipairs(completeGroups) do
            local groupInfo = self.seasonAlbumList[seasonId].groupMap[v]
            groupInfo.isCompleted = true
        end
    end
end

function SeasonCardModel:HandleAlbumReward(data)
    log.log("SeasonCardModel:HandleAlbumReward", data)
    local bundle = {}
    bundle.rewardType = self.Consts.RewardType.album
    bundle.reward = data.reward
    --bundle.seasonId = data.id
    bundle.seasonId = data.seasonId
    if self.seasonAlbumList and self.seasonAlbumList[data.seasonId] then
        self.seasonAlbumList[data.seasonId].isRewarded = true
    end

    local useUniversalClaimReward = false
    if useUniversalClaimReward then
        local isShowTopBar = true
        --Facade.SendNotification(NotifyName.SeasonCard.ReceiveAlbumdReward, bundle)
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show, ClaimRewardViewType.claimReward, data.reward, function()
            Event.Brocast(EventName.Event_currency_change)
            Facade.SendNotification(NotifyName.SeasonCard.CollectAlbumdRewardFinish, bundle)
        end, isShowTopBar)
    else
        bundle.closeCallback = function ()
            Facade.SendNotification(NotifyName.SeasonCard.CollectAlbumdRewardFinish, bundle)
        end
        ViewList.SeasonCardStageRewardView:SetData(bundle)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardStageRewardView)
    end
end

function SeasonCardModel:HandleGroupReward(data)
    log.log("SeasonCardModel:HandleGroupReward", data)
    local bundle = {}
    bundle.rewardType = self.Consts.RewardType.group
    bundle.reward = data.reward
    bundle.groupId = data.id
    bundle.seasonId = data.seasonId

    if self.seasonAlbumList and self.seasonAlbumList[data.seasonId] then
        local groupInfo = self.seasonAlbumList[data.seasonId].groupMap[data.id]
        if groupInfo then
            groupInfo.isRewarded = true
        end
    end

    local useUniversalClaimReward = false
    if useUniversalClaimReward then
        local isShowTopBar = true
        --Facade.SendNotification(NotifyName.SeasonCard.ReceiveGroupdReward, bundle)
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show, ClaimRewardViewType.claimReward, data.reward, function()
            Event.Brocast(EventName.Event_currency_change)
            Facade.SendNotification(NotifyName.SeasonCard.CollectGroupdRewardFinish, bundle)
        end, isShowTopBar)
    else
        bundle.closeCallback = function ()
            Facade.SendNotification(NotifyName.SeasonCard.CollectGroupdRewardFinish, bundle)
        end
        ViewList.SeasonCardStageRewardView:SetData(bundle)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardStageRewardView)
    end
end

function SeasonCardModel:HandleCardReward(data)
    log.log("SeasonCardModel:HandleCardReward", data)
    local bundle = {}
    bundle.reward = data.reward
    bundle.cardId = data.id
    bundle.seasonId = data.seasonId

    if self.seasonAlbumList and self.seasonAlbumList[data.seasonId] then
        bundle.groupId = self.seasonAlbumList[data.seasonId].cardToGroupMap[data.id]

        local cardInfo = self.seasonAlbumList[data.seasonId].cardMap[data.id]
        if cardInfo then
            cardInfo.isRewarded = true
        end
    end

    local isShowTopBar = true
    --Facade.SendNotification(NotifyName.SeasonCard.ReceiveSingleCardReward, bundle)
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show, ClaimRewardViewType.claimReward, data.reward, function()
        Event.Brocast(EventName.Event_currency_change)
        Facade.SendNotification(NotifyName.SeasonCard.CollectSingleCardRewardFinish, bundle)
    end, isShowTopBar)
end

function SeasonCardModel:AddUnopenedCardPackage(bag)
    local find = false
    for i, v in ipairs(self.unopenedPackages) do
        if bag.id == v.id then
            find = true
            v.value = v.value + bag.value
        end
    end
    
    if find then
        local ret = {}
        ret.id = bag.id
        ret.value = bag.value
        table.insert(self.unopenedPackages, ret)
    end

    self.unopenedPackageCount = self.unopenedPackageCount + bag.value
    self.isHasUnopenedPackage = true
end

function SeasonCardModel:HandleTreasureBoxReward(data)
    log.log("SeasonCardModel:HandleTreasureBoxReward", data)
    --[[正常这里不用处理，用3016来处理
    for i, v in ipairs(data.reward) do
        if self:IsCardPackage(v.id) then
            self:AddUnopenedCardPackage(v)
        end
    end
    --]]
    local bundle = {}
    bundle.reward = data.reward
    bundle.boxId = data.id
    bundle.seasonId = data.seasonId
    self:SetTreasureBoxFixedCd(data.id, data.seasonId)
    Facade.SendNotification(NotifyName.SeasonCard.ReceiveTreasureBoxReward, bundle)
end

function SeasonCardModel:SetTreasureBoxFixedCd(boxId, seasonId)
    local boxFixedData = self:GetBoxFixedData(boxId, seasonId)
    local cd = boxFixedData.cd + self:GetCurrentTime()

    local boxInfo
    if self.seasonAlbumList and self.seasonAlbumList[seasonId] then
        boxInfo = self.seasonAlbumList[seasonId].boxMap[boxId]
    else
        boxInfo = self.curSeasonAlbum.boxMap[boxId]
    end

    if boxInfo then
        boxInfo.cd = cd
    end
end

function SeasonCardModel:GetAlbums()
    return self.simplifiedAlbumList
end

function SeasonCardModel:GetSeasonBasicInfo(seasonId)
    for i, v in ipairs(self.simplifiedAlbumList) do
        if v.seasonId == seasonId then
            return v
        end
    end
end

--开始计时
function SeasonCardModel:StartCounting(delay)
    local delay = delay or 0
    local currentTime = self:GetCurrentTime()
    local expireTime = self:GetActivityExpireTime()
    local duration = expireTime - currentTime
    self:RemoveCountDownTimer()

    duration = duration > 0 and duration or delay
    if duration > 0 then
        self.countDownTimer = LuaTimer:SetDelayFunction(duration, function()
            self:RemoveCountDownTimer()
            self:C2S_SeasonSwithCheck(self.curSeasonId)
        end)
    end
end

function SeasonCardModel:RemoveCountDownTimer()
    if self.countDownTimer then
        LuaTimer:Remove(self.countDownTimer)
        self.countDownTimer = nil
    end
end

function SeasonCardModel:RequestSeasonWholeData(seasonId, callback)
    self.waitingSwitchAlbum = true
    self.requestSeasonWholdDataCb = callback
    
    self:C2S_CardGroupList(seasonId)
end

-------------------------------------------------网络消息-------------------------------------------------Begin
-------------------------------------------------消息请求-------------------------------------------------Begin
--获取赛季卡活动信息
function SeasonCardModel:C2S_SeasonInfo()
    self.SendMessage(MSG_ID.MSG_FETCH_SEASON_CARD_ACTIVITY_INFO, {})
end

--打卡赛季卡卡包
function SeasonCardModel:C2S_OpenCardBag()
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_BAG_OPEN, {}, false, true)
end

--获取赛季卡组列表
function SeasonCardModel:C2S_CardGroupList(seasonId)
    if seasonId == 0 then
        seasonId = nil
    else
        seasonId = seasonId or self.curSeasonId
    end
    self.SendMessage(MSG_ID.MSG_FETCH_SEASON_CARD_ALBUM_INFO, {seasonId = seasonId})
end


--登录时获取赛季卡组列表
function SeasonCardModel:Login_C2S_CardGroupList(seasonId)
    if seasonId == 0 then
        seasonId = nil
    else
        seasonId = seasonId or self.curSeasonId
    end
    return MSG_ID.MSG_FETCH_SEASON_CARD_ALBUM_INFO,Base64.encode(Proto.encode(MSG_ID.MSG_FETCH_SEASON_CARD_ALBUM_INFO,{seasonId = seasonId}))
  --  self.SendMessage(MSG_ID.MSG_FETCH_SEASON_CARD_ALBUM_INFO, {seasonId = seasonId})
end

--[[
--获取赛季卡组详情(卡片列表)
function SeasonCardModel:C2S_CardGroupDetail(groupId)
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_GROUP_DETAIL, {groupId = groupId})
end
--]]

--[[
--获取赛季兑换宝箱列表
function SeasonCardModel:C2S_ExchangeBoxList()
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_BOX_FETCH, {})
end
--]]

--领取卡片系统内奖励
function SeasonCardModel:C2S_ReceiveAward(rewardType, goodsId, seasonId)
    seasonId = seasonId or self.showingSeasonId
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_RECEIVE_AWARD, {type = rewardType, seasonId = seasonId, id = goodsId})
end

function SeasonCardModel:C2S_ReceiveAlbumAward(seasonId)
    self:C2S_ReceiveAward(self.Consts.RewardType.album, seasonId, seasonId)
end

function SeasonCardModel:C2S_ReceiveGroupAward(groupId, seasonId)
    self:C2S_ReceiveAward(self.Consts.RewardType.group, groupId, seasonId)
end

function SeasonCardModel:C2S_ReceiveCardAward(cardId, seasonId)
    self:C2S_ReceiveAward(self.Consts.RewardType.card, cardId, seasonId)
end

--开宝箱（只用于最新赛季）
function SeasonCardModel:C2S_ReceiveTreasureBoxAward(boxId, seasonId)
    seasonId = seasonId or self.curSeasonId
    self:C2S_ReceiveAward(self.Consts.RewardType.treasureBox, boxId, seasonId)
end

--重置卡箱兑换cd时间（只用于最新赛季）
function SeasonCardModel:C2S_ResetBoxCD(boxId)
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_CLEAR_BOX_CD, {boxId = boxId, seasonId = self.curSeasonId})
end

--通知服务端打开了某卡组,用于重置此卡组的红点
function SeasonCardModel:C2S_OpenCardGroup(groupId)
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_GROUP_OPEN, {groupId = groupId, seasonId = self.showingSeasonId}, true)
end

--用小丑卡兑换指定的卡片（只用于最新赛季）
function SeasonCardModel:C2S_ClownCardExchange(cardId, seasonId)
    seasonId = seasonId or self.curSeasonId
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_JOKER_CARD_EXCHANGE, {cardId = cardId, seasonId = seasonId})
end


--当前赛季是否已经过期
function SeasonCardModel:C2S_SeasonSwithCheck(seasonId)
    seasonId = seasonId or self.curSeasonId
    self.SendMessage(MSG_ID.MSG_SEASON_CARD_SEASON_SWITCH_CHECK, {seasonId = seasonId})
end
-------------------------------------------------消息请求-------------------------------------------------End

-------------------------------------------------消息返回-------------------------------------------------Begin
--获取赛季卡活动信息，这里目前只用来处活动开启时，4，7级（付费）服务端的推送
function SeasonCardModel.S2C_SeasonInfo(code, data)
    log.log("SeasonCardModel.S2C_SeasonInfo the code data is ", code, data)
    if code == RET.RET_SUCCESS then
        this.seasonAlbumList = this.seasonAlbumList or {}
        this.sourceBaseUrl = data.sourceBaseUrl
        local previousIsOpen = this:IsActivityValid()
        this.curSeasonId = data.curSeasonId
        this:HandleSimplifiedAlbumList(data.albums)
        local album = this:HandleSeasonAlbumData(data.curAlbum)
        this.seasonAlbumList[data.curSeasonId] = album
        this.curSeasonAlbum = album
        --this:ExpireAlbumData() --现在加了推送
        this.hasNecessaryData = false

        if this:IsActivityValid() and not previousIsOpen then
            local bundle = {}
            bundle.componentName = "FunctionIconSeasonCardView"
            Event.Brocast(EventName.Event_Add_Function_Icon, bundle)
        end
    else
        log.log("消息返回异常 SeasonCardModel.S2C_SeasonInfo code is ", code)
    end
end

--打卡赛季卡卡包（依旧无赛概念，一次性把所有卡包打开）
function SeasonCardModel.S2C_OpenCardBag(code, data)
    log.log("SeasonCardModel.S2C_OpenCardBag the code data is ", code, data)
    if code == RET.RET_SUCCESS then 
        this:OpenCardBagSucc(data)
    else
        this:OpenCardBagFail(code)
        log.log("消息返回异常 SeasonCardModel.S2C_OpenCardBag code is ", code)
    end
    this.openCardPackageParams = nil
end

--获取指定赛季卡册信息
function SeasonCardModel.S2C_CardGroupList(code, data)
    log.log("SeasonCardModel.S2C_CardGroupList the code data is ", code, data)
    if code == RET.RET_SUCCESS then
        --[[测试，强制开启新赛季
        this:TestOpenNewSeason(data)
        --]]
        this.sourceBaseUrl = data.sourceBaseUrl
        this.seasonAlbumList = this.seasonAlbumList or {}
        this:HandleSimplifiedAlbumList(data.albums)
        this:ActiveAlbumData(data.seasonId)
        local album = this:HandleSeasonAlbumData(data.curAlbum)
        this.seasonAlbumList[data.seasonId] = album
        if data.curSeasonId == data.seasonId then
            this.curSeasonId = data.seasonId
            this.curSeasonAlbum = album
            this.hasNecessaryData = true
            this:SetUnopenedPackageInfo(album.unopenedPackages)

            if this:IsActivityValid() then
                this:StartCounting()
            end

            local bundle = {}
            bundle.seasonId = data.seasonId
            Facade.SendNotification(NotifyName.SeasonCard.ReceiveAlbumWholeData, bundle)
        end

        --[[undo wait delete test data
        this:GenTestData(data)
        --]]
    else
        log.log("消息返回异常 SeasonCardModel.S2C_CardGroupList code is ", code)
    end

    if this.watingEnterSystem then
        this.S2C_ResponseEnterSystem(code, data)
    elseif this.waitingSwitchAlbum then
        this.S2C_ResponseSwitchAlbum(code, data)
    end
end

--获取指定赛季卡册信息-进入系统部分
function SeasonCardModel.S2C_ResponseEnterSystem(code, data)
    if code == RET.RET_SUCCESS then
        if data.curSeasonId == data.seasonId then
            this:EnterSystem()
            this.watingEnterSystem = false
        else
            log.log("消息返回-数据有问题 SeasonCardModel.S2C_ResponseEnterSystem ", data.curSeasonId, data.seasonId)
            this:C2S_CardGroupList(0)
        end
    else
        log.log("消息返回异常 SeasonCardModel.S2C_ResponseEnterSystem code is ", code)
        this.watingEnterSystem = false
    end
end

--获取指定赛季卡册信息-切换卡册部分
function SeasonCardModel.S2C_ResponseSwitchAlbum(code, data)
    if code == RET.RET_SUCCESS then
        if this.requestSeasonWholdDataCb then
            this.requestSeasonWholdDataCb(true)
        end
    else
        if this.requestSeasonWholdDataCb then
            this.requestSeasonWholdDataCb(false)
        end
        log.log("消息返回异常 SeasonCardModel.S2C_ResponseSwitchAlbum code is ", code)
    end

    this.waitingSwitchAlbum = false
    this.requestSeasonWholdDataCb = nil
end

--[[
--获取赛季卡组详情(卡片列表)
function SeasonCardModel.S2C_CardGroupDetail(code, data)
    if code == RET.RET_SUCCESS then 
        this.stageReward = data.reward
        this.cardList = data.cardList
        this.isStageReward = data.isRewarded
        this.isStageCompleted = data.isCompleted
    else
        log.log("消息返回异常 SeasonCardModel.S2C_CardGroupDetail code is ", code)
    end
end
--]]

--[[
--获取赛季兑换宝箱列表
function SeasonCardModel.S2C_ExchangeBoxList(code, data)
    if code == RET.RET_SUCCESS then 
    end
end
--]]

--领取卡片系统内奖励
function SeasonCardModel.S2C_ReceiveAward(code, data)
    log.log("SeasonCardModel:S2C_ReceiveAward", data)
    if code == RET.RET_SUCCESS then 
        if data.type == this.Consts.RewardType.album then
            this:HandleAlbumReward(data)
        elseif data.type == this.Consts.RewardType.group then
            this:HandleGroupReward(data)
        elseif data.type == this.Consts.RewardType.card then
            this:HandleCardReward(data)
        elseif data.type == this.Consts.RewardType.treasureBox then
            this:HandleTreasureBoxReward(data)
        end

        if data.type ~= this.Consts.RewardType.treasureBox then
            local bundle = {}
            bundle.id = data.id
            bundle.type = data.type
            bundle.seasonId = data.seasonId
            Facade.SendNotification(NotifyName.SeasonCard.SeasonRewardStateChange, bundle)
        end
    else

    end
end

--重置卡箱兑换cd时间
function SeasonCardModel.S2C_ResetBoxCD(code, data)
    if code == RET.RET_SUCCESS then 
        local boxInfo = this.curSeasonAlbum.boxMap[data.boxId]
        if boxInfo then
            boxInfo.cd = 0
        end
        local bundle = {}
        bundle.boxId = data.boxId
        bundle.seasonId = data.seasonId
        bundle.succ = true
        Facade.SendNotification(NotifyName.SeasonCard.ReceiveClearBoxCdResult, bundle)
    else
        log.log("消息返回异常 SeasonCardModel.S2C_ResetBoxCD code is ", code)
        local bundle = {}
        bundle.errorCode = code
        bundle.succ = false
        Facade.SendNotification(NotifyName.SeasonCard.ReceiveClearBoxCdResult, bundle)
    end
end

--通知服务端打了某卡组,用于重置此卡组的红点
function SeasonCardModel.S2C_OpenCardGroup(code, data)
    if code == RET.RET_SUCCESS then 
        --已经提前处理
    end
end

--用小丑卡兑换指定的卡片
function SeasonCardModel.S2C_ClownCardExchange(code, data)
    if code == RET.RET_SUCCESS then 
        this:UpdateGroupRewardState(data.completeGroups, data.seasonId)
        this:UpdateAlbumRewardState(data.isAlbumComplete, data.seasonId)
        --这里需要增量，服务给的是总量，已知当前固定增量为1
        data.cardInfo.collectNum = 1
        this:AddCard(data.cardInfo, data.seasonId)
        this:SyncClownCard(data.jokerCards)
        local bundle = {}
        bundle.cardInfo = this:GetCardInfo(data.cardInfo.cardId, data.seasonId)
        if ViewList.SeasonCardFeatureView:IsShowing() then
            Facade.SendNotification(NotifyName.SeasonCard.ReceiveClownCardExchangeResult, bundle)
        else
            bundle.purpose = ViewList.SeasonCardFeatureView.PurposeType.playAnimation
            bundle.seasonId = data.seasonId
            ViewList.SeasonCardFeatureView:SetData(bundle)
            Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardFeatureView)
        end
    else
        log.log("消息返回异常 SeasonCardModel.S2C_ClownCardExchange code is ", code)
        if code == RET.RET_SEASON_CARD_JOKER_CARD_EXPIRED then
            UIUtil.show_common_popup(
                30092, 
                true,
                function()
                    
                end
            )
        end
    end

    local bundle = {}
    Facade.SendNotification(NotifyName.SeasonCard.ClownCardCountChange, bundle)
end

--当前赛季是否已经过期
function SeasonCardModel.S2C_SeasonSwitchCheck(code, data)
    if code == RET.RET_SUCCESS then 
        if data.seasonId == data.curSeasonId then
            log.log("dghdgh007 S2C_SeasonSwitchCheck 未过期")
            this:StartCounting(1)
        else
            log.log("dghdgh007 S2C_SeasonSwitchCheck 已经过期")
            
            this:ExpireAlbumData(data.seasonId)
            this.sourceBaseUrl = data.sourceBaseUrl

            this.seasonAlbumList = this.seasonAlbumList or {}
            this:HandleSimplifiedAlbumList(data.albums)
            this:ActiveAlbumData(data.curSeasonId)
            local album = this:HandleSeasonAlbumData(data.curAlbum)
            this.seasonAlbumList[data.curSeasonId] = album
            this.curSeasonId = data.curSeasonId
            this.curSeasonAlbum = album
            this.hasNecessaryData = true
            this:SetUnopenedPackageInfo(album.unopenedPackages)

            if this:IsActivityValid() then
                this:StartCounting()
            end

            Facade.SendNotification(NotifyName.SeasonCard.SeasonOver, {oldSeasonId = data.seasonId, newSeasonId = data.curSeasonId})
            local bundle = {}
            bundle.seasonId = data.curSeasonId
            Facade.SendNotification(NotifyName.SeasonCard.ReceiveAlbumWholeData, bundle)
        end
    end
end
-------------------------------------------------消息返回-------------------------------------------------End
-------------------------------------------------网络消息-------------------------------------------------End

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_FETCH_SEASON_CARD_ACTIVITY_INFO, func = this.S2C_SeasonInfo},
    {msgid = MSG_ID.MSG_SEASON_CARD_BAG_OPEN, func = this.S2C_OpenCardBag},
    {msgid = MSG_ID.MSG_FETCH_SEASON_CARD_ALBUM_INFO, func = this.S2C_CardGroupList},
    -- {msgid = MSG_ID.MSG_SEASON_CARD_GROUP_DETAIL, func = this.S2C_CardGroupDetail},
    -- {msgid = MSG_ID.MSG_SEASON_CARD_BOX_FETCH, func = this.S2C_ExchangeBoxList},
    {msgid = MSG_ID.MSG_SEASON_CARD_RECEIVE_AWARD, func = this.S2C_ReceiveAward},
    {msgid = MSG_ID.MSG_SEASON_CARD_CLEAR_BOX_CD, func = this.S2C_ResetBoxCD},
    {msgid = MSG_ID.MSG_SEASON_CARD_GROUP_OPEN, func = this.S2C_OpenCardGroup},
    {msgid = MSG_ID.MSG_SEASON_CARD_JOKER_CARD_EXCHANGE, func = this.S2C_ClownCardExchange},
    {msgid = MSG_ID.MSG_SEASON_CARD_SEASON_SWITCH_CHECK, func = this.S2C_SeasonSwitchCheck},
}

-------------------------------------------------测试数据-------------------------------------------------begin
function SeasonCardModel:GenTestData(data)
    --self:GenTestData1(data)
    --self:GenTestData2(data)
end

function SeasonCardModel:GenTestData1(data)
    local albums = {
        {
            expireTime = 1727568000,
            isCompleted = false,
            hasNewSeasonCard = false,
            isRewarded = false,
            seasonId = 1,
            bags = {},
            jokerCards = {},
            boxes = {},
            groups = {},
            isSeasonCardOpen = false,
            createTime = 1688256000,
            reward = {}
        },
    }

    for i = 2, 30 do
        albums[i] = deep_copy(albums[1])
        albums[i].seasonId = 2
    end
    this:HandleSimplifiedAlbumList(albums)
end

function SeasonCardModel:GenTestData2(data)
    local newData = deep_copy(data)
    newData.seasonId = 1
    newData.curAlbum.groups[1].progress = 0
    newData.curAlbum.groups[1].totalCardNum = 0
    newData.curAlbum.groups[2].progress = 3
    newData.curAlbum.groups[2].totalCardNum = 3
    newData.curAlbum.groups[3].progress = 4
    newData.curAlbum.groups[3].totalCardNum = 4

    this:ActiveAlbumData(newData.seasonId)
    local album = this:HandleSeasonAlbumData(newData.curAlbum)
    this.seasonAlbumList[newData.seasonId] = album
end

function SeasonCardModel:TestSeasonSwitch()
    local data = TestData.msg3813_1.data
    self.S2C_SeasonSwitchCheck(0, data)
end

function SeasonCardModel:TestPushSeasonOpen()
    local data = TestData.msg3801_1.data
    self.S2C_SeasonInfo(0, data)
end

--进入卡包打开界面
function SeasonCardModel:TestOpenCardBagView()
    local bagList = {
        {
            bagId = 50101008,
            cardIds = {10000000, 10102006, 10102007},
            seasonId = 1,
        },
        {
            bagId = 50501001,
            cardIds = {10000000},
            seasonId = 1,
        },

        {
            bagId = 50101008,
            cardIds = {10000000, 10102006, 10102007},
            seasonId = 1,
        },

        {
            bagId = 50101008,
            cardIds = {10000000, 10102006, 10102007},
            seasonId = 2,
        },
        {
            bagId = 50501001,
            cardIds = {10000000},
            seasonId = 2,
        },
    }
    ViewList.SeasonCardOpenPackageView:SetData(bagList)
    Facade.SendNotification(NotifyName.ShowUI, ViewList.SeasonCardOpenPackageView)
end


function SeasonCardModel:TestOpenNewSeason(data, seasonId)
    seasonId = seasonId or data.seasonId + 1
    data.curSeasonId = seasonId
    data.seasonId = seasonId
    table.insert(data.albums, 1, 
        {
            expireTime = 1718236800,
            isDiamondGroupUnlock = false,
            isCompleted = false,
            hasNewSeasonCard = false,
            isRewarded = false,
            seasonId = seasonId,
            diamondGroupUnlockTime = 0,
            bags = {},
            version = 1,
            jokerCards = {},
            boxes = {},
            groups = {},
            isSeasonCardOpen = false,
            createTime = 1710115200,
            reward = {}
        }
    )
    data.curAlbum.seasonId = seasonId
end
-------------------------------------------------测试数据-------------------------------------------------end

return this
