local HallofFameModel = BaseModel:New("HallofFameModel")
local this = HallofFameModel

local _isActivityAvailable
local _reward
local _claimReward
local my_level
local _rankInfo        --用于积分显示
local serverRankInfo            --服务器下发的排名信息
local _playerInfo
local _settleInfo  --用于结算
local totalTrophyTypeNum  ----总共段位数量
local rankInfoRefreshInterval
local rankListMinDataNum = 5   --排行榜列表内数据个数最少5个
local isShowBlackGoldBG = false --是否展示黑金版周榜
local isTrueGoldUser = false --是否是真金用户
local blackTier = 14--黑金段位
local RewardIndicate = { claimReward = 0, serverPush = 1 }

function HallofFameModel:InitData()

end

--是否开启了活动
function HallofFameModel:IsActivityAvailable()
    return _isActivityAvailable
end

function HallofFameModel:OnWeeklyEntrance(data)
    _isActivityAvailable = data.type == 1
    this.openTime = data.fameOpenTime
    this.closeTime = data.weeklyOpenTime
    this.StartAvailableTimer()

    --处理banner
    if not _isActivityAvailable then
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.halloffame_gold)
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.halloffame)
    end
end

--开启活动结束倒计时
function HallofFameModel.StartAvailableTimer()
    if this.availableTimer then
        this.availableTimer:Stop()
        this.availableTimer = nil
    end
    
    if not _isActivityAvailable then
        return
    end
    
    this.availableTimer = Timer.New(function()
        local curServerTime = ModelList.PlayerInfoModel.get_cur_server_time()
        if curServerTime >= this.closeTime then
            this.availableTimer:Stop()
            this:C2S_RequestEntrance()
            
            --结算
            --this:StartSettleTimer()
        end
    end, 1, -1)
    this.availableTimer:Start()
end

---请求结算数据，直到返回正确数据
function HallofFameModel:StartSettleTimer()
    if this.settleTimer then
        this.settleTimer:Stop()
        this.settleTimer = nil
    end
    
    this.settleTimer = Timer.New(function()
        this:C2S_RequestRewardInfo(0)
    end, 5, -1)
    this.settleTimer:Start()
end

---活动剩余时间
function HallofFameModel:GetRemainTime()
    if this.closeTime then
        local curServerTime = ModelList.PlayerInfoModel.get_cur_server_time()
        return this.closeTime - curServerTime
    end
    
    return 0
end

---到活动下一次开启的秒数
function HallofFameModel:GetTimeToNextOpen()
    if this.openTime then
        local curServerTime = ModelList.PlayerInfoModel.get_cur_server_time()
        return this.openTime - curServerTime
    end
    
    return 604800
end

--是否是真金用户
function HallofFameModel:CheckIsTrueGoldUser()
    return isTrueGoldUser --是否是真金用户
end

--修改用户真金状态
function HallofFameModel:ChangeIsBlackGoldUser(state)
    ModelList.PlayerInfoModel:SetIsTrueGoldUser(state)
    
    isTrueGoldUser = state
    if isTrueGoldUser then
        --更新真金用户的Banner
        Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.halloffame_gold)
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.halloffame)
    else
        --普通用户的Banner
        Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.halloffame)
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.halloffame_gold)
    end
end

function HallofFameModel:IsFameClimbRank(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex]
            and _settleInfo.rankList[rankIndex].showRankList then
        return #_settleInfo.rankList[rankIndex].showRankList > 4
    end
    return false
end

function HallofFameModel:GetSettleClimbList(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex]
            and _settleInfo.rankList[rankIndex].showRankList then
        return _settleInfo.rankList[rankIndex].showRankList
    end
    return nil
end

function HallofFameModel:GetSettleClimbData(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex]
    end
    return nil
end

function HallofFameModel:IsClimbRank(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].lastSectionIndex - _settleInfo.rankList[rankIndex].mySectionIndex > 0
    end
    return false
end

function HallofFameModel:GetSettleClimbPreviousOrder(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].lastSectionIndex
    end
    return 0
end

function HallofFameModel:GetSettleClimbCurrentOrder(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].mySectionIndex
    end
    return 0
end

function HallofFameModel:GetSettleClimbPreviousTier(rankIndex)
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return math.max(_settleInfo.rankList[rankIndex].lastTier or 0, 1), math.max(_settleInfo.diff or 0, 1)
    end
    return 1, 1
end

function HallofFameModel:GetSettleClimbCurrentTier(rankIndex)
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return math.max(1, _settleInfo.rankList[rankIndex].myTier or 0, 1), math.max(_settleInfo.diff or 0, 1)
    end
    return 1, 1
end

function HallofFameModel:GetSettleClimbPreviousScore(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].lastScore
    end
    return 0
end

function HallofFameModel:GetSettleClimbCurrentScore(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].myScore
    end
    return 0
end

function HallofFameModel:IsChangeTier(rankIndex)
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].myTier ~= _settleInfo.rankList[rankIndex].lastTier
    end
    return false
end

function HallofFameModel:GetSettleClimbDifficulty()
    if _settleInfo then
        return _settleInfo.diff
    end
    return 1
end

function HallofFameModel:GetPlayerInfo()
    return _playerInfo
end

function HallofFameModel:GetTiers()
    if my_level then
        --return 2,my_level.difficulty
        return my_level.tiers, my_level.difficulty
    end
    return 1, 1
end

function HallofFameModel:IsGetReward()
    return _reward ~= nil and _reward.reward ~= nil and #_reward.reward > 0
end

function HallofFameModel:GetRewardTier()
    if _reward then
        return _reward.tiers, _reward.difficulty
    end
    if _claimReward and _claimReward.info then
        return _claimReward.info.tiers, _claimReward.info.difficulty
    end
    return 1, 1
end

function HallofFameModel:GetRewardOrder()
    if _reward then
        return _reward.weekRankNo
    end
    if _claimReward and _claimReward.info then
        return _claimReward.info.weekRankNo
    end
    return 0
end

function HallofFameModel:GetRewardList()
    if _claimReward and _claimReward.info and _claimReward.info.reward then
        return _claimReward.info.reward
    end
    return nil
end

function HallofFameModel:IsWeekRankInfoTimeOut()
    local interval = os.time() - (rankInfoRefreshInterval or 0)
    if interval >= 10 then
        rankInfoRefreshInterval = os.time()
        return true
    end
    return false
end

--显示的离自己最近的5个排名
function HallofFameModel:GetRankInfoPlayerList()
    if _rankInfo then
        return _rankInfo.showRankList
    end
    return nil
end

function HallofFameModel:IsRankInfoAvailable()
    return _rankInfo and _rankInfo.showRankList and (#_rankInfo.showRankList >= 5)
end

function HallofFameModel:GetflushUnixTime()
    if my_level then
        return my_level.flushUnix
    end
    if _rankInfo then
        return _rankInfo.flushUnix
    end
    if _settleInfo then
        return _settleInfo.flushUnix
    end
    return 0
end

function HallofFameModel:SetLoginData(data)
    if data and data.normalActivity
            and data.normalActivity.fameRankState
            and data.normalActivity.fameRankState.recordId
            and data.normalActivity.fameRankState.recordId ~= 0 then
        local replaceData = this:ReplaceRewardData(data.normalActivity.fameRankState)
        _reward = deep_copy(replaceData)
    end
end

--得到排名区间 如：{600，3000，6000}
function HallofFameModel:GetSection()
    local section = nil
    if _settleInfo then
        section = _settleInfo.section
    elseif _rankInfo then
        section = _rankInfo.section
    end
    return section or { 2000, 3500, 5000 }
end

function HallofFameModel:CleartSettleInfo()
    _settleInfo = nil
end

----------------------------消息请求-----------------------------------

function HallofFameModel:Login_C2S_RequestEntrance()
    return MSG_ID.MSG_WEEKLY_ENTRANCE, Base64.encode(Proto.encode(MSG_ID.MSG_WEEKLY_ENTRANCE,{}))
end

function HallofFameModel:C2S_RequestEntrance()
    this.SendMessage(MSG_ID.MSG_WEEKLY_ENTRANCE, {})
end

function HallofFameModel:C2S_RequestMyInfo()
    this.SendMessage(MSG_ID.MSG_FAME_MY_RANK, {})
end

function HallofFameModel:C2S_RequestMyJoinInfo()
    this.SendMessage(MSG_ID.MSG_FAME_RANK, {})
end

function HallofFameModel.C2S_RequestRankInfo(noNeedRespone)
    if this:IsWeekRankInfoTimeOut() then
        this.SendMessage(MSG_ID.MSG_FAME_RANK, {}, noNeedRespone)
    else
        Facade.SendNotification(NotifyName.HallofFame.FameResphoneRankInfo)
    end
end

function HallofFameModel.C2S_RequestPlayerInfo(userId, robot)
    this.SendMessage(MSG_ID.MSG_FAME_PERSON, { uid = userId, robot = robot })
end

function HallofFameModel:C2S_RequestRewardInfo(receive)
    this.SendMessage(MSG_ID.MSG_FAME_REWARD, { receive = receive or 1 })
end

function HallofFameModel.C2S_RequestSettleInfo()
    this.SendMessage(MSG_ID.MSG_FAME_SETTLE, {})
end

function HallofFameModel:Login_C2S_RequestMyInfo()
    return MSG_ID.MSG_FAME_MY_RANK, Base64.encode(Proto.encode(MSG_ID.MSG_FAME_MY_RANK, {}))
end

function HallofFameModel:Login_C2S_RequestMyJoinInfo()
    return MSG_ID.MSG_FAME_RANK, Base64.encode(Proto.encode(MSG_ID.MSG_FAME_MY_RANK, {}))
end

----------------------------消息返回-----------------------------------

function HallofFameModel.HandleNextMessage(data)
    table.each(data and data.nextMessages,function(v)
        local body = Base64.decode(v.msgBase64)
        local ret = Proto.decode(v.msgId, body)
        log.w("Handle NextMessage"..tostring(v.msgId).." bodystr "..tostring(v.msgBase64))
        Message.DispatchMessage(v.msgId, v.code, ret)
    end)
end

function HallofFameModel.S2C_OnWeeklyEntrance(code, data)
    if code == RET.RET_SUCCESS and data then
        this:OnWeeklyEntrance(data)
        ModelList.TournamentModel:OnWeeklyEntrance(data)
        this.HandleNextMessage(data)
        Facade.SendNotification(NotifyName.OnWeeklyEntrance)
    end
end

function HallofFameModel.S2C_OnMyRanktInfo(code, data)
    log.log("HallofFameModel.S2C_OnMyRanktInfo 7514 code, data is ", code, data)
    if code == RET.RET_SUCCESS and data then
        my_level = deep_copy(data)
        Facade.SendNotification(NotifyName.HallofFame.FameReqRefreshIcon)
    end
end

function HallofFameModel.S2C_OnRankInfo(code, data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.isShowBlackGoldBG)

        serverRankInfo = deep_copy(data.showRankList)

        local checkRankList = nil
        if this.CheckBlackGoldRemoveTopOneData(data.showRankList, data.isShowBlackGoldBG) then
            --是黑金周榜背景 列表里面包含了第一名 先删除第一名数据
            checkRankList = this.RemoveBlackGoldRemoveTopOneData(data.showRankList)
        else
            checkRankList = data.showRankList
        end
        local showRankList = this.ReplaceRankNumber(checkRankList)

        data.showRankList = showRankList
        _rankInfo = deep_copy(data)
        ----log.log("周榜调整 固定排名调整 " ,_rankInfo )
        Facade.SendNotification(NotifyName.HallofFame.FameResphoneRankInfo)
    end
end

function HallofFameModel.ReplaceRankNumber(showRankList)
    local currentRankIndex = nil
    local myUid = ModelList.PlayerInfoModel.GetUid()
    local totalNum = GetTableLength(showRankList)
    for i = 1, totalNum do
        local memberData = showRankList[i]
        if not currentRankIndex and memberData.uid == myUid then
            --先找到玩家自己的位置 然后根据这个位置 缩减数量
            currentRankIndex = i
            break
        end
    end

    if not currentRankIndex then
        return showRankList
    end

    local showRankList = this.ReplaceRankListDataDown(showRankList, currentRankIndex, totalNum)
    local showRankList = this.ReplaceRankListDataUp(showRankList, currentRankIndex)
    return showRankList
end

function HallofFameModel.S2C_OnPlayerInfo(code, data)
    if code == RET.RET_SUCCESS and data then
        _playerInfo = deep_copy(data)
        Facade.SendNotification(NotifyName.HallofFame.FameResphonePlayerInfo)
    end
end

function HallofFameModel.S2C_OnRewardInfo(code, data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.info.isShowBlackGoldBG)
        local replaceData = this:ReplaceRewardData(data.info)
        data.info = replaceData
        this:FinsihSettleReqRefreshIcon()
        if data.type == RewardIndicate.serverPush then
            if data.hasWeekRankReward == 1 then
                _reward = deep_copy(data.info)

                if this.settleTimer then
                    this.settleTimer:Stop()
                    this.settleTimer = nil
                end
                
                ----log.log("强制修改的参数" , _reward)
                Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder, PopupOrderOccasion.forcePopup)
            end
        elseif data.type == RewardIndicate.claimReward then
            _reward = nil
            _claimReward = deep_copy(data)
            this:ReplaceMySectionIndex(0)
            -- Facade.SendNotification(NotifyName..ResphoneRewardRequest)     
            Event.Brocast(NotifyName.HallofFame.FameResphoneRewardRequest)
        end
    else
        Facade.SendNotification(NotifyName.HallofFame.FameReqWeekSettleError)
    end
end

function HallofFameModel.S2C_OnSettleInfo(code, data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.isShowBlackGoldBG)
        data = this.ReplaceBingoResultData(data)
        _settleInfo = deep_copy(data)
    end
end

--非黑金用户拆分
function HallofFameModel.ReplaceBingoResultData(data)
    if not data or not data.rankList then
        return data
    end

    local rankListNum = GetTableLength(data.rankList)

    local nextRankLastTier = nil
    local nextRankCurrentTier = nil
    for index = rankListNum, 1, -1 do
        local v = data.rankList[index]
        local rankList = nil

        local isHasTopOneData, topOneData = this.CheckBlackGoldRemoveTopOneData(v.showRankList, false, v.lastTier)
        if isHasTopOneData then
            v.fakeTopOneData = topOneData
            rankList = this.RemoveBlackGoldRemoveTopOneData(v.showRankList)
        else
            rankList = v.showRankList
        end
        local lastIndex = v.lastSectionIndex
        local newIndex = v.mySectionIndex
        v = this.ReplaceBingoResultDataDown(rankList, lastIndex)
        v = this.ReplaceBingoResultDataUp(rankList, newIndex)

        data.rankList[index].showRankList = v
    end
    return data
end

--判断黑金玩家数据中删除排名第一玩家
function HallofFameModel.CheckBlackGoldRemoveTopOneData(showRankList, isShowBlackGoldBG, tier)
    if this:CheckIsBlackTire(tier) and (isShowBlackGoldBG or this:CheckIsTrueGoldUser()) then
        if showRankList and showRankList[1] and showRankList[1].order == 1 then
            return true, showRankList[1]
        end
    end
    return false
end

--判断自己是黑金段位
function HallofFameModel:CheckIsBlackTire(tier)
    tier = tier or ModelList.HallofFameModel:GetTiers()
    return tier == blackTier
end

--黑金玩家数据中删除排名第一玩家
function HallofFameModel.RemoveBlackGoldRemoveTopOneData(showRankList)
    table.remove(showRankList, 1)
    return showRankList
end

function HallofFameModel.ReplaceBingoResultDataDown(rankList, lastIndexFake)
    local lastIndex = 0 --上次排名序号

    local totalNum = GetTableLength(rankList)
    if totalNum <= rankListMinDataNum then
        return rankList
    end

    for k, v in pairs(rankList) do
        if v.order == lastIndexFake then
            lastIndex = k
            break
        end
    end

    return this.ReplaceRankListDataDown(rankList, lastIndex, totalNum)
end

--currentRankIndex 是最下面的自己的序号
function HallofFameModel.ReplaceRankListDataDown(rankList, currentRankIndex, totalNum)
    totalNum = totalNum or GetTableLength(rankList)
    local limitMaxDeleteNum = totalNum - rankListMinDataNum  --最多允许删除数量
    ----log.log("周榜调整 最大允许删除数量 down" , limitMaxDeleteNum)
    local downMinNum = 2 --保持中间位置
    local downOtherNum = totalNum - currentRankIndex   --玩家自身下面有多少个NPC

    --先移除下面的
    local needDeleteDownNum = 0
    if downOtherNum > downMinNum then
        needDeleteDownNum = downOtherNum - downMinNum
    else
        needDeleteDownNum = 0
    end

    if needDeleteDownNum > 0 then
        for deleteIndex = totalNum, currentRankIndex, -1 do
            if limitMaxDeleteNum <= 0 then
                break
            end
            limitMaxDeleteNum = limitMaxDeleteNum - 1

            if needDeleteDownNum > 0 then
                rankList[deleteIndex] = nil
            end
            if deleteIndex ~= currentRankIndex then
                needDeleteDownNum = needDeleteDownNum - 1
            end
        end
    end
    return rankList

end

--爬榜数据调整 避免显示出问题
--上次排名从地
function HallofFameModel.ReplaceBingoResultDataUp(rankList, newIndexFake)
    local newIndex = 0  --现在的排名序号

    local totalNum = GetTableLength(rankList)
    if totalNum <= rankListMinDataNum then
        return rankList
    end
    for k, v in pairs(rankList) do
        if v.order == newIndexFake then
            newIndex = k
            break
        end
    end
    return this.ReplaceRankListDataUp(rankList, newIndex, totalNum)
end

function HallofFameModel.ReplaceRankListDataUp(rankList, currentRankIndex, totalNum)
    totalNum = totalNum or GetTableLength(rankList)
    local limitMaxDeleteNum = totalNum - rankListMinDataNum  --最多允许删除数量
    ----log.log("周榜调整 最大允许删除数量 up" , limitMaxDeleteNum)
    local upMaxNum = 4 --玩家上面最多容纳4个其他玩家
    local upMinNum = 2 --玩家上面最好容纳2个其他玩家
    local upOtherNum = currentRankIndex - 1

    local needDeleteUpNum = 0
    if upOtherNum > upMinNum then
        needDeleteUpNum = upOtherNum - upMinNum
    else
        needDeleteUpNum = 0
    end

    if needDeleteUpNum > 0 then
        local deleteTable = {}
        for deleteIndex = 1, totalNum do
            if limitMaxDeleteNum <= 0 then
                break
            end
            limitMaxDeleteNum = limitMaxDeleteNum - 1
            if needDeleteUpNum > 0 then
                table.insert(deleteTable, 1, deleteIndex)
            end
            needDeleteUpNum = needDeleteUpNum - 1
        end

        for index = 1, GetTableLength(deleteTable) do
            table.remove(rankList, deleteTable[index])
        end
    end
    return rankList
end

--是否未第一名
function HallofFameModel:GetRankIsFirst()
    if _rankInfo then
        return _rankInfo.mySectionIndex == 1
    end
    return false
end

--获取有下一阶段奖励
function HallofFameModel:GetRankNextReward()
    if _rankInfo then
        return _rankInfo.nextReward
    end
    return nil
end

function HallofFameModel:GetRankNextTiersNeedScore()
    if _rankInfo then
        return _rankInfo.nextTiersNeedScore
    end
    return nil
end

function HallofFameModel:GetRankNextTiersPer()
    if _rankInfo then
        return _rankInfo.nextTiersPer
    end
    return nil
end

--获取自己的排名
function HallofFameModel:GetRankMySectionIndex()
    if _rankInfo then
        return _rankInfo.mySectionIndex
    end
    return 0
end

function HallofFameModel:GetTrophyAddCoinValue(tierIndex, difficulty)
    if not this:CheckOpen() then
        return 0
    end
    if not tierIndex and not difficulty then
        tierIndex, difficulty = ModelList.HallofFameModel:GetTiers()
    end

    local csvData = ModelList.HallofFameModel.GetCsvData()
    for index, value in ipairs(csvData) do
        if value.difficulty == difficulty and value.ranking_section == 2 then
            local tiers_id = value.tiers_id
            if value.daily_reward and tierIndex == tiers_id then
                return value.daily_reward
            end
        end
    end

    return 0
end

function HallofFameModel:CheckOpen()
    if not this:CheckLvOpen() or not this:CheckJoin() then
        --未达到开启条件
        return false
    end
    return true
end

--后台数据符合开启条件
function HallofFameModel:CheckJoin()
    if this:GetRankMySectionIndex() > 0 then
        return true
    end
    return false
end

--等级符合开启条件
function HallofFameModel:CheckLvOpen()
    local openLevel = this:GetUnlockLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    return myLevel >= openLevel
end

function HallofFameModel:GetResultNextOpenTime()
    if _reward and _reward.openWeekRankTime then
        return math.max(0, _reward.openWeekRankTime - os.time())
    end
    if _rankInfo and _rankInfo.openWeekRankTime then
        return math.max(0, _rankInfo.openWeekRankTime - os.time())
    end
    return 0
end

function HallofFameModel:GetResultTopPlayerData()
    if _reward == nil then
        return nil
    end
    return _reward.weeklyRankTop or {}
end

function HallofFameModel:GetResultTopPlayerReward(index)
    if _reward and _reward.weeklyRankTop and _reward.weeklyRankTop[index] then
        return _reward.weeklyRankTop[index]
    end
    return nil
end

function HallofFameModel:GetMyRewardItem()
    if _reward == nil then
        return nil
    end
    return _reward.reward or {}
end

function HallofFameModel:GetMyRank()

    if _reward == nil then
        return nil
    end
    return _reward.weekRankNo or 6000
end

function HallofFameModel:GetMyTrophy()
    if _reward == nil then
        return nil
    end
    return _reward.tiers or 1
end

--获取总共的段位数量
function HallofFameModel:GetTotalTrophy()
    if totalTrophyTypeNum then
        return totalTrophyTypeNum
    else
        local rewardItemList = {}
        local totalNum = 0
        local tiers, difficulty = ModelList.HallofFameModel:GetTiers()
        local csvData = ModelList.HallofFameModel.GetCsvData()
        for index, value in ipairs(csvData) do
            if value.difficulty == difficulty and value.ranking_section == 2 then
                totalNum = totalNum + 1
            end
        end

        totalTrophyTypeNum = totalNum
    end
    return totalTrophyTypeNum
end

--是否是最高段位
function HallofFameModel:CheckIsMaxTrophy()
    local tiers, difficulty = this:GetTiers()
    if this:CheckTargetMaxTrophy(tiers) then
        return true
    end
    return false
end

--是否是最高段位
function HallofFameModel:CheckTargetMaxTrophy(trophy)
    local totalNum = this:GetTotalTrophy()
    if trophy == totalNum then
        return true
    end
    return false
end

--获取自己的排名区间的下限值 如 5959 则返回6000
function HallofFameModel:GetUseSection()
    local sectionTable = this:GetSection()
    local mySectionIndex = this:GetRankMySectionIndex()
    local useSection = 6000
    for k, v in pairs(sectionTable) do
        if mySectionIndex <= v then
            useSection = v
        end
    end
    return useSection
end

--是否有下一阶段奖励
function HallofFameModel:CheckHasNextReward()
    local nextReward = this:GetRankNextReward()
    if nextReward and GetTableLength(nextReward) > 0 then
        return true
    end
    return false
end

function HallofFameModel:ReplaceMySectionIndex(sectionIndex)
    if _rankInfo then
        _rankInfo.mySectionIndex = sectionIndex
    end
end

function HallofFameModel:ReplaceNextNeedScore(myScore, nextTiersScore)
    if _rankInfo then
        _rankInfo.nextTiersNeedScore = nextTiersScore - myScore
        _rankInfo.nextTiersPer = nextTiersScore - myScore
    end
end

function HallofFameModel:FinsihSettleReqRefreshIcon()
    this.C2S_RequestMyInfo()
end

function HallofFameModel:UpdateShowNextTrophyScore(roundInfo)
    if not _rankInfo or not roundInfo then
        return -1
    end

    local lastScore = roundInfo.lastScore
    local myScore = roundInfo.myScore
    local nextTiersNeedScore = roundInfo.nextTiersScore or -999999999999999
    local mySectionIndex = roundInfo.mySectionIndex

    local totalScore = nextTiersNeedScore + myScore

    local newPer = math.floor(myScore / totalScore * 100)
    _rankInfo.nextTiersNeedScore = nextTiersNeedScore          --修改model数据
    _rankInfo.nextTiersPer = newPer                    --修改model数据
    _rankInfo.mySectionIndex = mySectionIndex                    --修改model数据
end

--从 bingo游戏结算后的 7206数据 替换本地的周榜数据
function HallofFameModel:UpdateShowNextTrophyScoreByIndex(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return this:UpdateShowNextTrophyScore(_settleInfo.rankList[rankIndex])
    end
end

--获取第一名升段需要的总分数
function HallofFameModel:GetFirstTotalScore()
    if _rankInfo then
        return _rankInfo.nextTiersScore
    end
    return 0
end

function HallofFameModel:GetChangeMyRank(rankIndex)
    if _settleInfo and
            _settleInfo.rankList and
            _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].mySectionIndex
    end
    return false
end

function HallofFameModel:GetClimbTiers(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and
            _settleInfo.rankList and
            _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].lastTier
    end
    return false
end

--判断是否爬升排名
--如果bingo结算后排名反而降低了 就不展示
function HallofFameModel:IsClimbToUp()
    -- if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[1]  and _settleInfo.rankList[1].lastSectionIndex > _settleInfo.rankList[1].mySectionIndex then
    --     return true
    -- end
    -- --log.log("周榜调整 排名降低了 不展示")
    -- return false
    return true
end

function HallofFameModel:ReplaceRewardData(data)
    local rankData = data.weeklyRankTop
    local replaceRankData = {}
    for k, v in pairs(rankData) do
        replaceRankData[v.order] = v
    end
    data.weeklyRankTop = replaceRankData
    return data
end

function HallofFameModel.GetCsvData()
    return Csv.fame_list
end

function HallofFameModel:GetSettleClimbIsFirst(rankIndex)
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].mySectionIndex == 1
    end
    return false
end

--获取7501第一名数据
function HallofFameModel:GetRankInfoTopOneData()
    if _rankInfo then
        return _rankInfo.topOnePlayerData
    end
end

function HallofFameModel:GetTrouamentClimbRankTopOneData(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].topOnePlayerData
    end
    return {}
end

function HallofFameModel:GetTrouamentClimbRankFakeTopOneData(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].fakeTopOneData
    end
    return {}
end

--获取自己的数据
function HallofFameModel:GetMyRankData(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and _settleInfo.rankList and _settleInfo.rankList[rankIndex].showRankList then
        local myUid = ModelList.PlayerInfoModel.GetUid()
        for k, v in pairs(_settleInfo.rankList[rankIndex].showRankList) do
            if v.uid == myUid then
                return v
            end
        end
    end
    return {}
end

function HallofFameModel:GetSettleClimbCurrentOrder(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and
            _settleInfo.rankList and
            _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex].mySectionIndex
    end
    return 0
end

--获取下一段段位第一名奖励
function HallofFameModel:GetNextTopOneReward(rankIndex)
    rankIndex = rankIndex or 1
    if _settleInfo and
            _settleInfo.rankList and
            _settleInfo.rankList[rankIndex] then
        return _settleInfo.rankList[rankIndex]
    end
    return nil
end

function HallofFameModel:CheckShowNormalBanner()
    if this:CheckIsTrueGoldUser() then
        return false
    end
    if not _isActivityAvailable then
        return false
    end
    if this:CheckLvOpen() then
        return true
    end
    return false
end

function HallofFameModel:CheckShowGoldBanner()
    if not this:CheckIsTrueGoldUser() then
        return false
    end
    if not _isActivityAvailable then
        return false
    end
    if this:CheckLvOpen() then
        return true
    end
    return false
end

--获取周榜解锁等级
function HallofFameModel:GetUnlockLv()
    if this:CheckIsTrueGoldUser() then
        --黑金周榜解锁等级
        return Csv.GetLevelOpenByType(15, 0)
    else
        --普通周榜结算等级
        return Csv.GetLevelOpenByType(8, 0)
    end
end

function HallofFameModel:GetSprintBuffIds()
    return SprintBuffIds
end

function HallofFameModel:HasSprintBuff()
    local buffRemainTime = ModelList.WinZoneModel:GetDoubleBuffRemainTime()
    return buffRemainTime > 0
end

function HallofFameModel:GetSprintBuffDes()
    local text = Csv.GetData("description", 1099, "description")
    return text
end

--根据段位和难度获取第一名的奖励
function HallofFameModel:GetFirstAward(tiers, difficulty)
    local csvData = this.GetCsvData()
    for index, value in ipairs(csvData) do
        if tiers == value.tiers_id and difficulty == value.difficulty and 1 == value.ranking[1] then
            if isShowBlackGoldBG then
                return value.reward_gold;
            else
                return value.reward;
            end
        end
    end
    return nil;
end

--根据段位和难度获取最后一名的奖励
function HallofFameModel:GetRankLastAward(tiers, difficulty)
    local csvData = this.GetCsvData()
    for index, value in ipairs(csvData) do
        if tiers == value.tiers_id and difficulty == value.difficulty and 3 == value.ranking_section then
            if isShowBlackGoldBG then
                return value.reward_gold
            else
                return value.reward
            end
        end
    end

    return nil
end

--检查配置表
local function CheckRanking(rankingList)
    if rankingList and rankingList[1] and rankingList[1] == 1 and not rankingList[2] then
        return true
    end
    return false
end

--获取段位积分的下限和上限
--@return {下限，上限}
function HallofFameModel:GetScoreRangeByTiers(tiers)
    local tier, difficulty = self:GetTiers();
    local csvData = this.GetCsvData();
    for index, value in ipairs(csvData) do
        if value.difficulty == difficulty and value.tiers_id == tiers and
                value.ranking_section == 1 and CheckRanking(value.ranking) then
            return value.tiers_range;
        end
    end
    return { 0, 0 };
end

--获取自己的排名信息
function HallofFameModel:GetMyRankInfo()
    local rankInfoList = self:GetServerRankInfo();
    local myUid = ModelList.PlayerInfoModel:GetUid();
    if rankInfoList then
        for key, value in pairs(rankInfoList) do
            if myUid == value.uid then
                return value;
            end
        end
    end
    return nil;
end

--获取自己周榜的积分
function HallofFameModel:GetMayRankScore()
    local data = self:GetMyRankInfo();
    if data then
        return data.score;
    end
    return 0;
end

--根据积分获取段位
function HallofFameModel:GetTierByScore(score)
    for i = 1, blackTier do
        local range = ModelList.HallofFameModel:GetScoreRangeByTiers(i)
        if score >= range[1] and score < range[2] then
            return i;
        end
        if i == blackTier and score >= range[2] then
            return i;
        end
    end
end

--获取段位阶段信息
function HallofFameModel:GetStageInfo(tiers)
    if _rankInfo then
        for i, v in ipairs(_rankInfo.allTierStage) do
            if v.tier == tiers then
                return v;
            end
        end
    end
    return nil
end

--根据段位获取每个阶段所需的分数
function HallofFameModel:GetAllStageNeedScore(tiers)
    local scoreList = {};
    if _rankInfo then
        for i, v in ipairs(_rankInfo.allTierStage) do
            if v.tier == tiers then
                for j, stage in ipairs(v.stageList) do
                    table.insert(scoreList, 1, stage.score);
                end
                break ;
            end
        end
    end
    return scoreList
end

--获取服务器下发的排名信息
function HallofFameModel:GetServerRankInfo()
    return serverRankInfo;
end

--检查是否有阶段奖励未领取
function HallofFameModel:CheckHasStateAward()
    if _rankInfo then
        for i, v in ipairs(_rankInfo.allTierStage) do
            for j, info in ipairs(v.stageList) do
                if info.status == 1 then
                    return true;
                end
            end
        end
    end
    return false;
end

--获取能领取阶段奖励的积分
function HallofFameModel:GetStateAwardScore()
    if _rankInfo then
        for i, v in ipairs(_rankInfo.allTierStage) do
            for j, info in ipairs(v.stageList) do
                --if i == 10 then
                --return info.minScore,i;
                --end
                if info.status == 1 then
                    return info.minScore, i;
                end
            end
        end
    end
    return nil, nil;
end

function HallofFameModel:C2S_RequestStageReward()
    this.SendMessage(MSG_ID.MSG_FAME_STAGE_REWARD, {});
end

function HallofFameModel.S2C_OnStageReward(code, data)
    --log.log("周榜调整 协议 09 " , code,data)
    local stateAwardInfo = {};
    if code == RET.RET_SUCCESS and data then
        --刷新阶段奖励领取状态
        if _rankInfo then
            for i, v in ipairs(_rankInfo.allTierStage) do
                for j, info in ipairs(v.stageList) do
                    if info.status == 1 then
                        info.status = 2;
                        table.insert(stateAwardInfo, { tier = v.tier, stage = j, score = v.score })
                    end
                end
            end
        end
        Facade.SendNotification(NotifyName.HallofFame.FameReqStageReward, data, stateAwardInfo)
    else
        Facade.SendNotification(NotifyName.HallofFame.FameReqWeekSettleError)
    end
end

this.MsgIdList = {
    { msgid = MSG_ID.MSG_WEEKLY_ENTRANCE, func = this.S2C_OnWeeklyEntrance },
    { msgid = MSG_ID.MSG_FAME_MY_RANK, func = this.S2C_OnMyRanktInfo },
    { msgid = MSG_ID.MSG_FAME_RANK, func = this.S2C_OnRankInfo },
    { msgid = MSG_ID.MSG_FAME_PERSON, func = this.S2C_OnPlayerInfo },
    { msgid = MSG_ID.MSG_FAME_REWARD, func = this.S2C_OnRewardInfo },
    { msgid = MSG_ID.MSG_FAME_SETTLE, func = this.S2C_OnSettleInfo },
    { msgid = MSG_ID.MSG_FAME_STAGE_REWARD, func = this.S2C_OnStageReward },
}

return this

