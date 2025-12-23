local TournamentModel = BaseModel:New("TournamentModel")
local this = TournamentModel

local tournament_reward = nil
local tournament_claimReward = nil
local my_tournament_level = nil
local tournament_rankInfo = nil		--用于积分显示
local serverRankInfo = nil;			--服务器下发的排名信息

local tournament_playerInfo = nil

local tournament_settleInfo = nil  --用于结算
local totalTrophyTypeNum = nil  ----总共段位数量

local RewardIndicate = {claimReward = 0,serverPush = 1}

local useNewProtocal = false   --默认使用旧版周榜协议

local rankInfoRefreshInterval;

local rankListMinDataNum = 5   --排行榜列表内数据个数最少5个

local isShowBlackGoldBG = false --是否展示黑金版周榜
local isTrueGoldUser = false --是否是真金用户
local _isActivityAvailable
local blackTier = 14--黑金段位

local SprintBuffIds = {1051, 1052}

local isNewConf = nil --是否换配置表

function TournamentModel:InitData()

end

function TournamentModel:SetTestData()
end

function TournamentModel:OnWeeklyEntrance(data)
    --_isActivityAvailable = data.type == 2
    --this.openTime = data.weeklyOpenTime
    --this.closeTime = data.fameOpenTime

    --this.StartAvailableTimer()
    --
    ----处理banner
    --if not _isActivityAvailable then
    --    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.tournamentTrueGoldUnlock)
    --    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.tournamentTrueGoldLock)
    --end
end

--开启活动结束倒计时
function TournamentModel.StartAvailableTimer()
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
            ModelList.HallofFameModel:C2S_RequestEntrance()
            
            --结算
            --this:StartSettleTimer()
        end
    end, 1, -1)
    this.availableTimer:Start()
end

---请求结算数据，直到返回正确数据
function TournamentModel:StartSettleTimer()
    if this.settleTimer then
        this.settleTimer:Stop()
        this.settleTimer = nil
    end

    this.settleTimer = Timer.New(function()
        this:C2S_RequestTournamentRewardInfo(0)
    end, 5, -1)
    this.settleTimer:Start()
end

function TournamentModel:IsActivityAvailable()
   return _isActivityAvailable 
end

function TournamentModel:IsTrouamentClimbRank(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and 
    tournament_settleInfo.rankList[rankIndex] and
    tournament_settleInfo.rankList[rankIndex].showRankList then
        return #tournament_settleInfo.rankList[rankIndex].showRankList > 4
    end
    return false
end

function TournamentModel:GetSettleClimbList(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] and 
    tournament_settleInfo.rankList[rankIndex].showRankList then
        return tournament_settleInfo.rankList[rankIndex].showRankList
    end
    return nil
end

function TournamentModel:GetSettleClimbData(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex]  then
        return tournament_settleInfo.rankList[rankIndex]
    end
    return nil
end

function TournamentModel:IsClimbRank(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and
    tournament_settleInfo.rankList and 
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].lastSectionIndex - tournament_settleInfo.rankList[rankIndex].mySectionIndex > 0
    end
    return false
end

function TournamentModel:GetSettleClimbPreviousOrder(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].lastSectionIndex
    end
    return 0
end

function TournamentModel:GetSettleClimbCurrentOrder(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].mySectionIndex
    end
    return 0
end

function TournamentModel:GetSettleClimbPreviousTier(rankIndex)
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return math.max(tournament_settleInfo.rankList[rankIndex].lastTier or 0,1),math.max(tournament_settleInfo.diff or 0,1)
    end
    return 1,1
end

function TournamentModel:GetSettleClimbCurrentTier(rankIndex)
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return math.max(1,tournament_settleInfo.rankList[rankIndex].myTier or 0, 1) , math.max(tournament_settleInfo.diff or 0,1)
    end
    return 1,1
end

function TournamentModel:GetSettleClimbPreviousScore(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].lastScore
    end
    return 0
end

function TournamentModel:GetSettleClimbCurrentScore(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].myScore
    end
    return 0
end

function TournamentModel:IsChangeTier(rankIndex)
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].myTier ~= tournament_settleInfo.rankList[rankIndex].lastTier
    end
    return false
end

function TournamentModel:GetSettleClimbDifficulty()
    if tournament_settleInfo then
        return tournament_settleInfo.diff
    end
    return 1
end

function TournamentModel:GetPlayerInfo()
    return tournament_playerInfo
end

function TournamentModel:GetTiers()
    if my_tournament_level then
		--return 2,my_tournament_level.difficulty
		return my_tournament_level.tiers,my_tournament_level.difficulty
    end
    return 1,1
end

function TournamentModel:IsTournamentGetReward()
    return tournament_reward ~= nil and
           tournament_reward.reward ~= nil and
           #tournament_reward.reward > 0
end

function TournamentModel:GetTournamentRewardTier()
    if tournament_reward then
        return tournament_reward.tiers,tournament_reward.difficulty
    end
    if tournament_claimReward and tournament_claimReward.info then
        return tournament_claimReward.info.tiers,tournament_claimReward.info.difficulty
    end
    return 1,1
end

function TournamentModel:GetTournamentRewardOrder()
    if tournament_reward then
        return tournament_reward.weekRankNo
    end
    if tournament_claimReward and tournament_claimReward.info then
        return tournament_claimReward.info.weekRankNo
    end
    return 0
end

function TournamentModel:GetTournamentRewardList()
    if tournament_claimReward and 
    tournament_claimReward.info and 
    tournament_claimReward.info.reward then
        return tournament_claimReward.info.reward
    end
    return nil
end

function TournamentModel:IsWeekRankInfoTimeOut()
    local interval = os.time() - (rankInfoRefreshInterval or 0)
    if interval >= 10 then
        rankInfoRefreshInterval = os.time()
        return true
    end
    return false
end
--显示的离自己最近的5个排名
function TournamentModel:GetRankInfoPlayerList()
    if tournament_rankInfo then
        return tournament_rankInfo.showRankList
    end
    return nil
end

function TournamentModel:IsRankInfoAvailable()
    return tournament_rankInfo and 
    tournament_rankInfo.showRankList and 
    (#tournament_rankInfo.showRankList >= 5)
end

function TournamentModel:GetRemainTime()
    if my_tournament_level then
        return math.max(0,my_tournament_level.flushUnix - os.time())
    end
    if tournament_rankInfo then
        return math.max(0,tournament_rankInfo.flushUnix - os.time())
    end
    if tournament_settleInfo then
        return math.max(0,tournament_settleInfo.flushUnix - os.time())
    end
    return 0
end



function TournamentModel:GetflushUnixTime()
    if my_tournament_level then
        return my_tournament_level.flushUnix
    end
    if tournament_rankInfo then
        return tournament_rankInfo.flushUnix
    end
    if tournament_settleInfo then
        return tournament_settleInfo.flushUnix
    end
    return 0
end

function TournamentModel:SetLoginData(data)
    if data and data.normalActivity and data.normalActivity.weekRankState and data.normalActivity.weekRankState.recordId and data.normalActivity.weekRankState.recordId ~= 0 then
        --log.log("周榜调整 协议登录 " , data.normalActivity.weekRankState)
        local replaceData = this:ReplaceRewardData(data.normalActivity.weekRankState)
        tournament_reward = deep_copy(replaceData)
    end

    if data and data.useNewWeekRank then
        useNewProtocal = data.useNewWeekRank
        -- useNewProtocal = false  --测试用
        ----log.log("周榜调整 协议登录 区分使用条件 " , data.useNewWeekRank)
    end
end
--得到排名区间 如：{600，3000，6000}
function TournamentModel:GetSection()
    local section = nil
    if tournament_settleInfo then
        section = tournament_settleInfo.section
    elseif tournament_rankInfo then
        section = tournament_rankInfo.section
    end
    return section or {2000,3500,5000}
end

function TournamentModel:CleartSettleInfo()
    tournament_settleInfo = nil
end

function TournamentModel:C2S_RequestMyTournamentInfo()
    if this:CheckUseNewProtocal() then
        this.SendMessage(MSG_ID.MSG_WEEK_NEW_MYRANK,{})
    else
        this.SendMessage(MSG_ID.MSG_WEEK_MYRANK,{})
    end
end

function TournamentModel:Login_C2S_RequestMyTournamentInfo()
    if this:CheckUseNewProtocal() then
        return MSG_ID.MSG_WEEK_NEW_MYRANK,Base64.encode(Proto.encode(MSG_ID.MSG_WEEK_NEW_MYRANK,{}))
       -- this.SendMessage(MSG_ID.MSG_WEEK_NEW_MYRANK,{})
    else
        return MSG_ID.MSG_WEEK_MYRANK,Base64.encode(Proto.encode(MSG_ID.MSG_WEEK_NEW_MYRANK,{}))
      --  this.SendMessage(MSG_ID.MSG_WEEK_MYRANK,{})
    end
end

function TournamentModel:C2S_RequestMyTournamentJoinInfo()
    if this:CheckUseNewProtocal() then
        this.SendMessage(MSG_ID.MSG_WEEK_NEW_RANK,{})
    else
        this.SendMessage(MSG_ID.MSG_WEEK_RANK,{})
    end
end

function TournamentModel:Login_C2S_RequestMyTournamentJoinInfo()
    if this:CheckUseNewProtocal() then
        return MSG_ID.MSG_WEEK_NEW_RANK,Base64.encode(Proto.encode(MSG_ID.MSG_WEEK_NEW_MYRANK,{}))
       -- this.SendMessage(MSG_ID.MSG_WEEK_NEW_MYRANK,{})
    else
        return MSG_ID.MSG_WEEK_RANK,Base64.encode(Proto.encode(MSG_ID.MSG_WEEK_NEW_MYRANK,{}))
      --  this.SendMessage(MSG_ID.MSG_WEEK_MYRANK,{})
    end
end

function TournamentModel.S2C_OnMyTournamentInfo(code,data)
    log.log("周榜测试数据X 协议 7204" , code , data)
    --log.log("周榜调整 协议04 " , code,data)
    if code == RET.RET_SUCCESS and data then
        my_tournament_level = deep_copy(data)
        Facade.SendNotification(NotifyName.Tournament.ReqRefreshIcon)    
    elseif code == RET.RET_NEED_USE_NEW  then
        this.ChangeUseNewProtocal()
    end
end


function TournamentModel.S2C_OnMyTournamentInfoNew(code,data)
    log.log("周榜测试数据 协议 7504" , code , data)
    isNewConf = data.isNewConf
    this.ChangeUseNewProtocal()
    this.S2C_OnMyTournamentInfo(code, data)
end

function TournamentModel.C2S_RequestTournamentRankInfo(noNeedRespone, cb)
    if this:IsWeekRankInfoTimeOut() then
        this.RequestTournamentRankInfoCb = cb
        if this:CheckUseNewProtocal() then
            this.SendMessage(MSG_ID.MSG_WEEK_NEW_RANK,{},noNeedRespone)
        else
            this.SendMessage(MSG_ID.MSG_WEEK_RANK,{},noNeedRespone)
        end
    else
        Facade.SendNotification(NotifyName.Tournament.ResphoneRankInfo) 
        fun.SafeCall(cb)
    end
end

function TournamentModel.S2C_OnTournamentRankInfo(code,data)
    --log.log("周榜调整 协议01 " , code,data)
    log.log("周榜测试数据X 协议 7201" , code , data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.isShowBlackGoldBG)
        this:ChangeIsTrueGoldUser(data.isTrueGoldUser)
        
		serverRankInfo = deep_copy(data.showRankList);
		
		local checkRankList = nil
        if this.CheckBlackGoldRemoveTopOneData(data.showRankList , data.isShowBlackGoldBG) then
            --是黑金周榜背景 列表里面包含了第一名 先删除第一名数据
            checkRankList = this.RemoveBlackGoldRemoveTopOneData(data.showRankList)
        else
            checkRankList = data.showRankList
        end
        local showRankList = this.ReplaceRankNumber(checkRankList)
		
			
        data.showRankList = showRankList
        tournament_rankInfo = deep_copy(data)
        ----log.log("周榜调整 固定排名调整 " ,tournament_rankInfo )
        Facade.SendNotification(NotifyName.Tournament.ResphoneRankInfo)
    elseif code == RET.RET_NEED_USE_NEW  then
        this.ChangeUseNewProtocal()
    end
    
    fun.SafeCall(this.RequestTournamentRankInfoCb)
    this.RequestTournamentRankInfoCb = nil
end

local isAutoTest = true
function TournamentModel.S2C_OnTournamentRankInfoNew(code,data)
    log.log("周榜测试数据 协议 7501" , code , data)
    
    if isAutoTest then
        isAutoTest = false
    else
     --    data = this:Gettest7501data()
    log.log("周榜测试数据 协议 7501 手动数据变更", data)
    end

    isNewConf = data.isNewConf
    this.ChangeUseNewProtocal()
    this.S2C_OnTournamentRankInfo(code, data)
end

function TournamentModel.ReplaceRankNumber(showRankList)
    local currentRankIndex = nil
    local myUid = ModelList.PlayerInfoModel.GetUid()
    local totalNum = GetTableLength(showRankList)
    for i = 1 , totalNum do
        local memberData = showRankList[i]
        if not currentRankIndex and  memberData.uid == myUid then
            --先找到玩家自己的位置 然后根据这个位置 缩减数量
            currentRankIndex = i
            break
        end
    end

    if not currentRankIndex then
        return showRankList
    end

    local  showRankList = this.ReplaceRankListDataDown(showRankList  , currentRankIndex  ,totalNum )
    local  showRankList = this.ReplaceRankListDataUp(showRankList  , currentRankIndex )
    return showRankList
end

function TournamentModel.C2S_RequestPlayerTournamentInfo(userId,robot)
    if this:CheckUseNewProtocal() then
        this.SendMessage(MSG_ID.MSG_WEEK_NEW_PERSON,{uid = userId,robot = robot})
    else
        this.SendMessage(MSG_ID.MSG_WEEK_PERSON,{uid = userId,robot = robot})
    end
end

function TournamentModel.S2C_OnPlayerTournamentInfo(code,data)
    log.log("周榜测试数据X 协议 7202" , code , data)
    --log.log("周榜调整 协议02 " , code,data)
    if code == RET.RET_SUCCESS and data then
        tournament_playerInfo = deep_copy(data)
        Facade.SendNotification(NotifyName.Tournament.ResphonePlayerInfo)
    elseif code == RET.RET_NEED_USE_NEW  then
        this.ChangeUseNewProtocal()
    end
end

function TournamentModel.S2C_OnPlayerTournamentInfoNew(code,data)
    log.log("周榜测试数据 协议 7502" , code , data)
    this.ChangeUseNewProtocal()
    this.S2C_OnPlayerTournamentInfo(code, data)
end

function TournamentModel:C2S_RequestTournamentRewardInfo(receive)
    if this:CheckUseNewProtocal() then
        this.SendMessage(MSG_ID.MSG_WEEK_NEW_RANK_REWARD,{receive = receive or 1 })
    else
        this.SendMessage(MSG_ID.MSG_WEEK_RANK_REWARD,{})
    end
end

function TournamentModel.S2C_OnTournamentRewardInfo(code,data)
    --log.log("周榜调整 协议05 " , code,data)
    log.log("周榜测试数据X 协议 7205" , code , data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.info.isShowBlackGoldBG)
        this:ChangeIsTrueGoldUser(data.info.isTrueGoldUser)
        local replaceData = this:ReplaceRewardData(data.info)
        data.info = replaceData
        this:FinsihSettleReqRefreshIcon()
        if data.type == RewardIndicate.serverPush then
            if data.hasWeekRankReward == 1 then
                tournament_reward = deep_copy(data.info)
                
                if this.settleTimer then
                    this.settleTimer:Stop()
                    this.settleTimer = nil
                end
                
                ----log.log("强制修改的参数" , tournament_reward)
                Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder,PopupOrderOccasion.forcePopup)
            end
        elseif data.type == RewardIndicate.claimReward then
            tournament_reward = nil
            tournament_claimReward = deep_copy(data)
            this:ReplaceMySectionIndex(0)
            -- Facade.SendNotification(NotifyName.Tournament.ResphoneRewardRequest)     
            Event.Brocast(NotifyName.Tournament.ResphoneRewardRequest)
        end
    elseif code == RET.RET_NEED_USE_NEW  then
        this.ChangeUseNewProtocal()
    else
        Facade.SendNotification(NotifyName.Tournament.ReqWeekSettleError)
    end
end

function TournamentModel.S2C_OnTournamentRewardInfoNew(code,data)
    log.log("周榜测试数据 协议 7505" , code , data)

    this.ChangeUseNewProtocal()
    this.S2C_OnTournamentRewardInfo(code, data)
end

function TournamentModel.C2S_RequestTournamentSettleInfo()
    if this:CheckUseNewProtocal() then
        this.SendMessage(MSG_ID.MSG_WEEK_NEW_RANK_SETTLE,{})
    else
        this.SendMessage(MSG_ID.MSG_WEEK_RANK_SETTLE,{})
    end
end

function TournamentModel.S2C_OnTournamentSettleInfo(code,data)
    --log.log("周榜调整 协议06 " , code,data)
    log.log("周榜测试数据x 协议 7206" , code , data)
    if code == RET.RET_SUCCESS and data then
        this:ChangeIsBlackGoldUser(data.isShowBlackGoldBG)
        this:ChangeIsTrueGoldUser(data.isTrueGoldUser)
        data =  this.ReplaceBingoResultData(data)
        tournament_settleInfo = deep_copy(data)
        --log.log("周榜调整  结算拆分" , data)
    elseif code == RET.RET_NEED_USE_NEW  then
        this.ChangeUseNewProtocal()
    end
end

function TournamentModel.S2C_OnTournamentSettleInfoNew(code,data)
    log.log("周榜测试数据 协议 7506" , code , data)
--     data = this:Gettest7506data()
    isNewConf = data.isNewConf
    this.ChangeUseNewProtocal()
    this.S2C_OnTournamentSettleInfo(code,data)
end

--非黑金用户拆分
function TournamentModel.ReplaceBingoResultData(data)
    if not data or not data.rankList then
        return data
    end

    local rankListNum = GetTableLength(data.rankList)

    local nextRankLastTier = nil
    local nextRankCurrentTier = nil
    for index = rankListNum , 1 , -1 do
        local v = data.rankList[index]
        local rankList = nil
      
        local isHasTopOneData , topOneData = this.CheckBlackGoldRemoveTopOneData(v.showRankList , false , v.lastTier)
        if  isHasTopOneData then
            v.fakeTopOneData = topOneData
            rankList = this.RemoveBlackGoldRemoveTopOneData(v.showRankList)
        else
            rankList = v.showRankList
        end
        local lastIndex = v.lastSectionIndex
        local newIndex = v.mySectionIndex
        v = this.ReplaceBingoResultDataDown(rankList , lastIndex )
        v = this.ReplaceBingoResultDataUp(rankList  , newIndex)

        data.rankList[index].showRankList = v
    end
    return data 
end

--判断黑金玩家数据中删除排名第一玩家
function TournamentModel.CheckBlackGoldRemoveTopOneData(showRankList,isShowBlackGoldBG, tier)
    if this:CheckIsBlackTire(tier) and (isShowBlackGoldBG or this:CheckIsBlackGoldUser()) then
        if showRankList and showRankList[1] and showRankList[1].order == 1 then
            return true , showRankList[1]
        end
    end
    return false
end

--判断自己是黑金段位
function TournamentModel:CheckIsBlackTire(tier)
    tier = tier or ModelList.TournamentModel:GetTiers()
    return tier == blackTier
end

--黑金玩家数据中删除排名第一玩家
function TournamentModel.RemoveBlackGoldRemoveTopOneData(showRankList)
    table.remove(showRankList, 1)
    return showRankList
end

function TournamentModel.ReplaceBingoResultDataDown(rankList ,  lastIndexFake )
    local lastIndex = 0 --上次排名序号

    local totalNum = GetTableLength(rankList) 
    if totalNum <= rankListMinDataNum then
        return rankList
    end

    for k , v in pairs(rankList) do
        if v.order == lastIndexFake then
            lastIndex = k
            break
        end
    end

    return this.ReplaceRankListDataDown(rankList , lastIndex , totalNum)
end

--currentRankIndex 是最下面的自己的序号
function TournamentModel.ReplaceRankListDataDown(rankList , currentRankIndex ,totalNum )
    totalNum =  totalNum or GetTableLength(rankList)
    local limitMaxDeleteNum = totalNum - rankListMinDataNum  --最多允许删除数量
    ----log.log("周榜调整 最大允许删除数量 down" , limitMaxDeleteNum)
    local downMinNum = 2 --保持中间位置
    local downOtherNum = totalNum - currentRankIndex   --玩家自身下面有多少个NPC
    
    --先移除下面的
    local needDeleteDownNum = 0
    if downOtherNum > downMinNum then
        needDeleteDownNum =  downOtherNum - downMinNum
    else
        needDeleteDownNum = 0
    end

    if needDeleteDownNum > 0 then
        for deleteIndex = totalNum , currentRankIndex , - 1 do
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
function TournamentModel.ReplaceBingoResultDataUp(rankList  , newIndexFake)
    local newIndex = 0  --现在的排名序号

    local totalNum = GetTableLength(rankList)
    if totalNum <= rankListMinDataNum then
        return rankList
    end
    for k , v in pairs(rankList) do
        if v.order == newIndexFake then
            newIndex = k
            break
        end
    end
    return this.ReplaceRankListDataUp(rankList  , newIndex  ,totalNum )
end

function TournamentModel.ReplaceRankListDataUp(rankList , currentRankIndex ,totalNum )
    totalNum =  totalNum or GetTableLength(rankList)
    local limitMaxDeleteNum = totalNum - rankListMinDataNum  --最多允许删除数量
    ----log.log("周榜调整 最大允许删除数量 up" , limitMaxDeleteNum)
    local upMaxNum = 4 --玩家上面最多容纳4个其他玩家
    local upMinNum = 2 --玩家上面最好容纳2个其他玩家
    local upOtherNum = currentRankIndex - 1
    
    local needDeleteUpNum = 0
    if upOtherNum > upMinNum then
        needDeleteUpNum =  upOtherNum - upMinNum
    else
        needDeleteUpNum = 0
    end

    if needDeleteUpNum > 0 then
        local deleteTable = {}
        for deleteIndex = 1 , totalNum do
            if limitMaxDeleteNum <= 0 then
                break
            end
            limitMaxDeleteNum = limitMaxDeleteNum - 1
            if needDeleteUpNum > 0 then
                table.insert(deleteTable , 1 ,deleteIndex)
            end
            needDeleteUpNum = needDeleteUpNum - 1
        end

        for index = 1 , GetTableLength(deleteTable) do
            table.remove(rankList , deleteTable[index])
        end
    end
    return rankList
end

--是否未第一名
function TournamentModel:GetRankIsFirst()
    if tournament_rankInfo then
        return tournament_rankInfo.mySectionIndex == 1
    end
    return false
end
--获取有下一阶段奖励
function TournamentModel:GetRankNextReward()
    if tournament_rankInfo then
        return tournament_rankInfo.nextReward
    end
    return nil
end

function TournamentModel:GetRankNextTiersNeedScore()
    if tournament_rankInfo then
        return tournament_rankInfo.nextTiersNeedScore
    end
    return nil
end

function TournamentModel:GetRankNextTiersPer()
    if tournament_rankInfo then
        return tournament_rankInfo.nextTiersPer
    end
    return nil
end
--获取自己的排名
function TournamentModel:GetRankMySectionIndex()
    if tournament_rankInfo then
        return tournament_rankInfo.mySectionIndex
    end
    return 0
end

function TournamentModel:GetTrophyAddCoinValue(tierIndex, difficulty)
    if not this:CheckOpenTournament() then
        return 0
    end
    if not tierIndex and not difficulty then
        tierIndex , difficulty = ModelList.TournamentModel:GetTiers()
    end

    local csvData = ModelList.TournamentModel.GetTournamentCsvData()
    for index, value in ipairs(csvData) do
        if value.difficulty == difficulty and value.ranking_section == 2  then
            local tiers_id = value.tiers_id
            if value.daily_reward and tierIndex == tiers_id then
                return value.daily_reward
            end
        end
    end

    return 0
end

function TournamentModel:CheckOpenTournament()
    if not this:CheckLvOpenTournament() or not this:CheckJoinTournament() then
        --未达到开启条件
        return false
    end
    return true
end

--后台数据符合开启条件
function TournamentModel:CheckJoinTournament()
    if this:GetRankMySectionIndex() > 0 then
        return true
    end
    return false
end

--等级符合开启条件
function TournamentModel:CheckLvOpenTournament()
    local openLevel = this:GetUnlockTournamentLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    return myLevel >= openLevel
end

function TournamentModel:GetTournamentResultNextOpenTime()
    if tournament_reward and tournament_reward.openWeekRankTime then
        return math.max(0,tournament_reward.openWeekRankTime - os.time())
    end
    if tournament_rankInfo and tournament_rankInfo.openWeekRankTime then
        return math.max(0,tournament_rankInfo.openWeekRankTime - os.time())
    end
    return 0
end



function TournamentModel:GetTournamentResultTopPlayerData()
    if tournament_reward == nil then
        return nil
    end
    return tournament_reward.weeklyRankTop or {}
end

function TournamentModel:GetTournamentResultTopPlayerReward(index)
    if tournament_reward and tournament_reward.weeklyRankTop and tournament_reward.weeklyRankTop[index] then
        return tournament_reward.weeklyRankTop[index]
    end
    return nil
end

function TournamentModel:GetMyTournamentRewardItem()
    if tournament_reward == nil then
        return nil
    end
    return tournament_reward.reward or {}
end

function TournamentModel:GetMyTournamentRank()

    if tournament_reward == nil then
        return nil
    end
    return tournament_reward.weekRankNo or 6000
end


function TournamentModel:GetMyTournamentTrophy()
    if tournament_reward == nil then
        return nil
    end
    return tournament_reward.tiers or 1
end

--获取总共的段位数量
function TournamentModel:GetTotalTournamentTrophy()
    if totalTrophyTypeNum then
        return totalTrophyTypeNum
    else
        local rewardItemList = {}
        local totalNum = 0
        local tiers,difficulty = ModelList.TournamentModel:GetTiers()
        local csvData = ModelList.TournamentModel.GetTournamentCsvData()
        for index, value in ipairs(csvData) do
            if value.difficulty == difficulty and value.ranking_section == 2  then
                totalNum = totalNum + 1
            end
        end

        totalTrophyTypeNum = totalNum
    end
    return totalTrophyTypeNum
end
--是否是最高段位
function TournamentModel:CheckIsMaxTrophy()
    local tiers, difficulty =this:GetTiers()
    if this:CheckTargetMaxTrophy(tiers) then
        return true
    end
    return false
end
--是否是最高段位
function TournamentModel:CheckTargetMaxTrophy(trophy)
    local totalNum = this:GetTotalTournamentTrophy()
    if trophy == totalNum then
        return true
    end
    return false
end
--获取自己的排名区间的下限值 如 5959 则返回6000
function TournamentModel:GetUseSection()
    local sectionTable = this:GetSection()
    local mySectionIndex = this:GetRankMySectionIndex()
    local useSection = 6000
    for k , v in pairs(sectionTable) do
        if mySectionIndex <= v then
            useSection = v
        end
    end
    return useSection
end

--是否有下一阶段奖励
function TournamentModel:CheckHasNextReward()
    local nextReward = this:GetRankNextReward() 
    if nextReward and GetTableLength(nextReward) > 0 then
        return true
    end
    return false
end

function TournamentModel:ReplaceMySectionIndex(sectionIndex)
    if tournament_rankInfo  then
        tournament_rankInfo.mySectionIndex = sectionIndex
    end
end

function TournamentModel:ReplaceNextNeedScore(myScore , nextTiersScore )
    if tournament_rankInfo  then
        tournament_rankInfo.nextTiersNeedScore = nextTiersScore - myScore
        tournament_rankInfo.nextTiersPer = nextTiersScore - myScore
    end
end

function TournamentModel:FinsihSettleReqRefreshIcon()
    this.C2S_RequestMyTournamentInfo()
end

-- function TournamentModel:ReplaceMyScore(lastScore ,myScore )
--     if tournament_rankInfo  then
--         local totalScore = lastScore + tournament_rankInfo.nextTiersNeedScore
--         tournament_rankInfo.nextTiersNeedScore = totalScore - myScore
--         local minPer = math.floor( myScore / totalScore * 100 ) 
--         tournament_rankInfo.nextTiersPer = minPer
--     end
-- end

function TournamentModel:UpdateShowNextTrophyScore(roundInfo)
    if not tournament_rankInfo or not roundInfo then
        return -1
    end

    local lastScore = roundInfo.lastScore
    local myScore = roundInfo.myScore
    local nextTiersNeedScore = roundInfo.nextTiersScore or -999999999999999
    local mySectionIndex = roundInfo.mySectionIndex
    
    local totalScore = nextTiersNeedScore + myScore

    local newPer = math.floor( myScore / totalScore * 100 ) 
    tournament_rankInfo.nextTiersNeedScore = nextTiersNeedScore          --修改model数据
    tournament_rankInfo.nextTiersPer = newPer                    --修改model数据
    tournament_rankInfo.mySectionIndex = mySectionIndex                    --修改model数据
end

--从 bingo游戏结算后的 7206数据 替换本地的周榜数据
function TournamentModel:UpdateShowNextTrophyScoreByIndex(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and tournament_settleInfo.rankList and tournament_settleInfo.rankList[rankIndex] then
        return this:UpdateShowNextTrophyScore(tournament_settleInfo.rankList[rankIndex])
    end
end


--获取第一名升段需要的总分数
function TournamentModel:GetFirstTotalScore()
    if tournament_rankInfo then
        return tournament_rankInfo.nextTiersScore
    end
    return 0
end

function TournamentModel:GetChangeMyRank(rankIndex)
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].mySectionIndex
    end
    return false
end

function TournamentModel:CheckUseNewProtocal()
    return useNewProtocal == true
end
 
function TournamentModel:GetClimbTiers(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and
    tournament_settleInfo.rankList and 
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].lastTier 
    end
    return false
end

--判断是否爬升排名
--如果bingo结算后排名反而降低了 就不展示
function TournamentModel:IsClimbToUp()
    -- if tournament_settleInfo and tournament_settleInfo.rankList and tournament_settleInfo.rankList[1]  and tournament_settleInfo.rankList[1].lastSectionIndex > tournament_settleInfo.rankList[1].mySectionIndex then
    --     return true
    -- end
    -- --log.log("周榜调整 排名降低了 不展示")
    -- return false
    return true
end

function TournamentModel.ChangeUseNewProtocal()
    useNewProtocal = true
end

function TournamentModel:ReplaceRewardData(data)
    local rankData = data.weeklyRankTop
    local replaceRankData = {}
    for k , v in pairs(rankData) do
        replaceRankData[v.order] = v
    end
    data.weeklyRankTop = replaceRankData
    return data
end

function TournamentModel.GetTournamentCsvData()
    if this:CheckUseNewProtocal() then
        if isNewConf == true then
            log.log("dghdgh007 get Csv.weekly_list_main")
            return Csv.weekly_list_main
         else
            log.log("dghdgh007 get Csv.weekly_list_new")
             return Csv.weekly_list_new
         end
    else
        return Csv.weekly_list
    end
end

function TournamentModel:GetSettleClimbIsFirst(rankIndex)
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].mySectionIndex == 1
    end
    return false
end

--判断展示黑金周榜
function TournamentModel:CheckIsBlackGoldUser()
    return isShowBlackGoldBG --是否展示黑金版周榜
end

--修改黑金版周榜用户状态
function TournamentModel:ChangeIsBlackGoldUser(state)
    ModelList.PlayerInfoModel:SetIsTrueGoldUser(state)
    
    isShowBlackGoldBG = state
    if isShowBlackGoldBG then
        --变成了黑金版周榜
        if this:CheckShowUnLockBanner() then
            Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.tournamentTrueGoldUnlock)
        end

        if this:CheckShowLockBanner() then
            Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.tournamentTrueGoldLock)
        end
    else
        --变成了普通周榜
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.tournamentTrueGoldUnlock)
        Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, hallCityBannerType.tournamentTrueGoldLock)
    end
end

--判断是真金用户
function TournamentModel:CheckIsTrueGoldUser()
    return isShowBlackGoldBG --是否是真金用户
end

--修改真金用户状态
function TournamentModel:ChangeIsTrueGoldUser(state)
    isTrueGoldUser = state
end

--获取7501第一名数据
function TournamentModel:GetRankInfoTopOneData()
    if tournament_rankInfo then
        return tournament_rankInfo.topOnePlayerData
    end
end

function TournamentModel:GetTrouamentClimbRankTopOneData(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo  and tournament_settleInfo.rankList and  tournament_settleInfo.rankList[rankIndex]  then
        return tournament_settleInfo.rankList[rankIndex].topOnePlayerData
    end
    return {}
end

function TournamentModel:GetTrouamentClimbRankFakeTopOneData(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo  and tournament_settleInfo.rankList and  tournament_settleInfo.rankList[rankIndex]  then
        return tournament_settleInfo.rankList[rankIndex].fakeTopOneData
    end
    return {}
end

--获取自己的数据
function TournamentModel:GetMyRankData(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and tournament_settleInfo.rankList and tournament_settleInfo.rankList[rankIndex].showRankList then
        local myUid = ModelList.PlayerInfoModel.GetUid()
        for k , v in pairs(tournament_settleInfo.rankList[rankIndex].showRankList) do
            if v.uid == myUid then
                return v
            end
        end
    end
    return {}
end

function TournamentModel:GetSettleClimbCurrentOrder(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex] then
        return tournament_settleInfo.rankList[rankIndex].mySectionIndex
    end
    return 0
end

--获取下一段段位第一名奖励
function TournamentModel:GetNextTopOneReward(rankIndex)
    rankIndex = rankIndex or 1
    if tournament_settleInfo and 
    tournament_settleInfo.rankList and
    tournament_settleInfo.rankList[rankIndex]  then
        return tournament_settleInfo.rankList[rankIndex]
    end
    return nil
end

--判断使用锁定周榜banner
function TournamentModel:CheckShowLockBanner()
    if not this:CheckIsBlackGoldUser() then
        return false
    end
    if this:GetRemainTime() <= 0 then
        return false
    end
    if this:CheckLvOpenTournament() then
        return false
    end
    return true
end

--判断使用解锁banner
function TournamentModel:CheckShowUnLockBanner()
    if not this:CheckIsBlackGoldUser() then
        return false
    end
    if this:GetRemainTime() <= 0 then
        return false
    end
    if this:CheckLvOpenTournament() then
        return true
    end
    return false
end

--获取周榜解锁等级
function TournamentModel:GetUnlockTournamentLv()
    if this:CheckIsBlackGoldUser() then
        --黑金周榜解锁等级
        return Csv.GetLevelOpenByType(15,0)    
    else
        --普通周榜结算等级
        return Csv.GetLevelOpenByType(8,0)    
    end
end

function TournamentModel:GetSprintBuffIds()
    return SprintBuffIds
end

function TournamentModel:HasSprintBuff()
    return self:GetSprintBuffRemainTime() > 0
end

function TournamentModel:GetSprintBuffRemainTime()
    local buffTime = 0
    for idx, id in ipairs(SprintBuffIds) do
        local deadline = ModelList.ItemModel:GetItemNumById(id)
        buffTime = math.max(buffTime, deadline - os.time())
    end

    --buffTime = 300 --test
    return buffTime    
end

function TournamentModel:IsSprintBuffId(id)
    for idx, buffId in ipairs(SprintBuffIds) do
        if id == buffId then
            return true
        end
    end

    return false
end

function TournamentModel:GetSprintBuff()
    local buff = 0
    for idx, id in ipairs(SprintBuffIds) do
        local deadline = ModelList.ItemModel:GetItemNumById(id)
        if deadline > 0 then
            local itemCfg = Csv.GetData("item", id, "result")
            buff = itemCfg[2]
            break
        end
    end

    return buff
end

function TournamentModel:GetSprintBuffDes()
    local buff = self:GetSprintBuff() .. "%"
    local text = string.format(Csv.GetData("description", 1099, "description"), buff)
    return text
end

----计算段位增加的奖励
--function TournamentModel:GetTierAddAwards(tiers)
	----log.log("周榜  " .. tiers)
	--local tier,difficulty = self:GetTiers();
	--if tiers then
		--tier = tiers;
	--end
	--local curAwards = self:GetFirstAward(tier,difficulty);
	--local previousAwards = nil;
	--if tier == 1 then
		----log.data(curAwards);
		--return curAwards;
	--else
		--previousAwards = self:GetFirstAward(tier - 1,difficulty);	
	--end
	--local ret = {};
	--for i, cur in ipairs(curAwards) do
		--local has = false;
		--for k, previous in ipairs(previousAwards) do
			--if previous[1] == cur[1] then
				--has = true;
				--local num = cur[2] - previous[2];
				--table.insert(ret,{previous[1],num});	
				--break;
			--end
		--end
		--if not has then
			--table.insert(ret,cur);
		--end
	--end
	----log.data(ret);
	--return ret;
--end

--根据段位和难度获取第一名的奖励
function TournamentModel:GetFirstAward(tiers,difficulty)
	local csvData = this.GetTournamentCsvData()
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
function TournamentModel:GetRankLastAward(tiers, difficulty)
	local csvData = this.GetTournamentCsvData()
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
function TournamentModel:GetScoreRangeByTiers(tiers)
	local tier,difficulty = self:GetTiers();
	local csvData = this.GetTournamentCsvData();
	for index, value in ipairs(csvData) do
		if value.difficulty == difficulty and value.tiers_id == tiers and
			value.ranking_section == 1 and CheckRanking(value.ranking) then
			return value.tiers_range;
		end
	end
	return {0,0};	
end

--获取自己的排名信息
function TournamentModel:GetMyRankInfo()
	local rankInfoList = self:GetServerRankInfo();
	local myUid = ModelList.PlayerInfoModel:GetUid();
	if rankInfoList then
		for key, value in pairs(rankInfoList) do
			if myUid == value.uid then
				return  value;
			end
		end
	end
	return nil;
end

--获取自己周榜的积分
function TournamentModel:GetMayRankScore()
	local data = self:GetMyRankInfo();
	if data then
		return data.score;
	end
	return 0;
end

--根据积分获取段位
function TournamentModel:GetTierByScore(score)
	for i = 1, blackTier do
		local range = ModelList.TournamentModel:GetScoreRangeByTiers(i);
		if score >= range[1] and score < range[2] then
			return i;
		end
		if i == blackTier and score >= range[2] then
			return i;
		end
	end
end

--获取段位阶段信息
function TournamentModel:GetStageInfo(tiers)
	if tournament_rankInfo then
		for i, v in ipairs(tournament_rankInfo.allTierStage) do
			if v.tier == tiers then
				return v; 
			end
		end
	end
	return nil
end

--根据段位获取每个阶段所需的分数
function TournamentModel:GetAllStageNeedScore(tiers)
	local scoreList = {};
	if tournament_rankInfo then
		for i, v in ipairs(tournament_rankInfo.allTierStage) do
			if v.tier == tiers then
				for j, stage in ipairs(v.stageList) do
					table.insert(scoreList,1,stage.score);
				end
				break;
			end
		end
	end
	return scoreList
end

--获取服务器下发的排名信息
function TournamentModel:GetServerRankInfo()
	return serverRankInfo;
end

--检查是否有阶段奖励未领取
function TournamentModel:CheckHasStateAward()
	if tournament_rankInfo then
		for i, v in ipairs(tournament_rankInfo.allTierStage) do
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
function TournamentModel:GetStateAwardScore()
	if tournament_rankInfo then
		for i, v in ipairs(tournament_rankInfo.allTierStage) do
			for j, info in ipairs(v.stageList) do
				--if i == 10 then
					--return info.minScore,i;
				--end
				if info.status == 1 then
					return info.minScore,i;
				end
			end
		end
	end
	return nil,nil;
end

function TournamentModel:C2S_RequestStageReward()
	this.SendMessage(MSG_ID.MSG_WEEK_NEW_RANK_STAGE_REWARD,{});
end

function TournamentModel.S2C_OnTournamentStageReward(code,data)
    log.log("周榜测试数据 协议 7507" , code , data)
	--log.log("周榜调整 协议 09 " , code,data)
	local stateAwardInfo = {};
	if code == RET.RET_SUCCESS and data then
		--刷新阶段奖励领取状态
		if tournament_rankInfo then
			for i, v in ipairs(tournament_rankInfo.allTierStage) do
				for j, info in ipairs(v.stageList) do
					if info.status == 1 then
						info.status = 2;
						table.insert(stateAwardInfo,{tier = v.tier,stage = j,score = v.score})
					end	
				end
			end
		end
		Facade.SendNotification(NotifyName.Tournament.ReqStageReward,data,stateAwardInfo)
	else
		Facade.SendNotification(NotifyName.Tournament.ReqWeekSettleError)
	end
end

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_WEEK_MYRANK,func = this.S2C_OnMyTournamentInfo},
    {msgid = MSG_ID.MSG_WEEK_RANK,func = this.S2C_OnTournamentRankInfo},
    {msgid = MSG_ID.MSG_WEEK_PERSON,func = this.S2C_OnPlayerTournamentInfo},
    {msgid = MSG_ID.MSG_WEEK_RANK_REWARD,func = this.S2C_OnTournamentRewardInfo},
    {msgid = MSG_ID.MSG_WEEK_RANK_SETTLE,func = this.S2C_OnTournamentSettleInfo},

    --下面是新版本协议 根据useNewProtocal 判断使用旧版/新版协议
    {msgid = MSG_ID.MSG_WEEK_NEW_MYRANK,func = this.S2C_OnMyTournamentInfoNew},
    {msgid = MSG_ID.MSG_WEEK_NEW_RANK,func = this.S2C_OnTournamentRankInfoNew},
    {msgid = MSG_ID.MSG_WEEK_NEW_PERSON,func = this.S2C_OnPlayerTournamentInfoNew},
    {msgid = MSG_ID.MSG_WEEK_NEW_RANK_REWARD,func = this.S2C_OnTournamentRewardInfoNew},
    {msgid = MSG_ID.MSG_WEEK_NEW_RANK_SETTLE,func = this.S2C_OnTournamentSettleInfoNew},
	{msgid = MSG_ID.MSG_WEEK_NEW_RANK_STAGE_REWARD,func = this.S2C_OnTournamentStageReward}
}

return this

