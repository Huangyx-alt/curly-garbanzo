local CarQuestModel = BaseModel:New("CarQuestModel")
local this = CarQuestModel
this.racingData = {}

activity_list = {}

function CarQuestModel:IsActivityAvailable()
    if this.racingData then
        if this.racingData.isOver and  this.racingData.isOver == 1 then
            return false
        end

        local remainTime = self:GetActivityRemainTime()
        return remainTime > 0
    end
end

--获取自身名次
function CarQuestModel:GetRacingRankToporder()
    if this.racingData and  this.racingData.showRankList then 
        for _ , v in pairs(this.racingData.showRankList) do
            if v.uid == ModelList.PlayerInfoModel:GetUid() then 
                return v.order
            end 
        end 
    end 
    return 0 -- 不是第一名也不是第二名 
end 

--自己比赛数据
function CarQuestModel:GetSelfRacingRankInfo()
    local racingData = this:GetRacingData()
    if racingData and racingData.showRankList then 
        for _ , v in pairs(racingData.showRankList) do
            if v.uid == ModelList.PlayerInfoModel:GetUid() then
                return v
            end
        end
    end
end


--判断前三名是否完整 完整弹 CompetitionQuestRankView ，不完整弹 CompetitionQuestRank2View
function CarQuestModel:GetIsRacingRankTop()
    local index = 0;
    if (this.racingData and this.racingData.showRankList ) then 
        for _,v in pairs(this.racingData.showRankList) do 
            if v.order == 1 or v.order == 2 or v.order == 3 then 
                index = index +1
            end 
        end 
    end 
    
    return index == 3 
end 

function CarQuestModel.GetCurrConfig()
    local dependentFile = require("View.DailyCompetition.CompetitionDependentFile")
    local info = dependentFile:GetDenpendentInfo()
    return info
end

function CarQuestModel:GetActivityRemainTime()
    if this.racingData and this.racingData.expireTime then
        local diff = this.racingData.expireTime - os.time()
        return diff
    end

    return 0
end

---取当前的排名数据
function CarQuestModel:GetRankData()
    return this.racingData and this.racingData.showRankList or {}
end

--获得比赛数据
function CarQuestModel:GetRacingData()
    return this.racingData  or {}
end

function CarQuestModel:GetRacingGroupID()
    local data = self:GetRacingData()
    return data and data.groupId or 1
end

function CarQuestModel:GetRacingConfig(groupId)
    local list = {}
    local cfg = Csv.competition_racing_round
    if cfg then
        for i, v in ipairs(cfg) do
            if v.racing_id == groupId then
                table.insert(list, v)
            end
        end
    end

    return list
end

function CarQuestModel:RecordOilDrumCollect(collectList)
    self.oilDrumCollect = collectList
end

function CarQuestModel:GetOilDrumCollectRecord()
    return self.oilDrumCollect
end

function CarQuestModel:GetOilDrumCollectRecordChange()
    return self.oilDrumCollect and #self.oilDrumCollect> 0 or false
end

function CarQuestModel:CleanOilDrumCollectRecord()
    self.oilDrumCollect = nil
end

---道具投放buff剩余时间
function CarQuestModel:GetMoreItemBuffTime()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    return remainTime
end

---额外奖励buff剩余时间
function CarQuestModel:GetMoreRewardBuffTime()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    return remainTime
end

--更新最新的名次，并计算上一次的名次
function CarQuestModel:CalculateRanks()
    local rankInfoList = this.racingData and this.racingData.showRankList
    if rankInfoList then
        --计算上次分数变化时每个人的排名
        table.sort(rankInfoList, function(a, b)
            return a.lastScore > b.lastScore
        end)
        table.each(rankInfoList, function(info, k)
            info.lastRank = k
        end)
        
        --计算当前每个人的排名
        table.sort(rankInfoList, function(a, b)
            if a.order > 0 and b.order > 0 then
                return a.order < b.order
            elseif a.order > 0 and b.order == 0 then
                return true
            elseif b.order > 0 and a.order == 0 then
                return false
            else
                return a.score > b.score
            end
        end)
        table.each(rankInfoList, function(info, k)
            info.rank = k
        end)
        
        --每次更新数据后，检查是否需要展示排名变化
        local check = false
        table.each(rankInfoList, function(info, k)
            check = check or (info.rank ~= info.lastRank)
        end)
        this.needShowRankChange = check
    end
end

--获得礼包相关数据
function CarQuestModel:GetGiftPackInfo()
    local gift_info = ModelList.GiftPackModel:GetOpenedGift()
    local start_time = ModelList.PlayerInfoModel.get_cur_server_time()
    local limitCount =  Csv.GetData("control", 158, "content")[1][1] or 2
    local limitIndex = nil -- 如果后面需求有修改，确定
    local tmp_limitPack = {} --被遗弃 的礼包不用显示出来 
    local tmp_limitPack2 = {} -- 放破冰礼包的
    if gift_info then 
        local tempWeight = 0
        for _, v in ipairs(gift_info) do
            local xls = Csv.GetData("pop_up", v.giftInfo[1].id)
            if xls and xls.type_id[1] == 2 and xls.type_id[2] == 2 then 
                tmp_limitPack[v.pId] = xls.gift_weight
            end 

            if xls and xls.type_id[1] == 1 and xls.type_id[2] == 1  then --破冰礼包只能有一个
                if  xls.gift_weight[1] > tempWeight then 
                    tempWeight = xls.gift_weight[1]
                    limitIndex = v.pId
                end
                tmp_limitPack2[v.pId] = true
            end  
        end 
    end 

    if limitIndex ~= nil then
        tmp_limitPack2[limitIndex] = nil
    end

    for i = 1 ,limitCount do
        local tmpNum = 0
        local tmpkey = 0
        for k, v in pairs(tmp_limitPack) do
            if v ~= nil and v[1] > tmpNum then
                tmpkey = k
                tmpNum = v[1]
            end
        end
        if tmpkey > 0 then
            tmp_limitPack[tmpkey] = nil
        end
    end 

    if gift_info then
        local find = false
        for _, v in ipairs(gift_info) do
            local xls = Csv.GetData("pop_up", v.giftInfo[1].id)
            
            if xls and xls.pop_type then
                for k = 1, #xls.pop_type do
                    if xls.pop_type[k]== 17 then
                        find = true
                        break
                    end
                end
            end
            
            if find then
                if not tmp_limitPack[v.pId] and not tmp_limitPack2[v.pId] then
                    local endTime = v.giftInfo[1].expireTime
                    local canBuyCount = false
                    for i = 1, #v.giftInfo do
                        if v.giftInfo[i].canBuyCount >0 then
                            canBuyCount = true
                            break
                        end
                    end

                    return {leftTime = endTime - start_time, canBuy = canBuyCount, detail = v}
                else
                    break
                end
            end
        end
    end
end

function CarQuestModel:OnLevelChange(value)
    local selfLevel = ModelList.PlayerInfoModel:GetLv()
    local needLevel = 0 -- Csv.GetLevelOpenByType(19,0)
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    if myLabel and myLabel > 0 then
        needLevel = Csv.GetData("level_open",29,"pay_openlevel")
    else
        needLevel = Csv.GetData("level_open",29,"openlevel")
    end

    if selfLevel == needLevel then
        ModelList.CarQuestModel.Login_C2S_RacingFetch()
    end
end

----------------------------------C2S-------------------------------------------------------------------
function CarQuestModel.Login_C2S_RacingFetch()

    this.SendMessage(MSG_ID.MSG_COMPETITION_RACING_FETCH, {})
end


---赛车活动数据
function CarQuestModel.ReqRacingFetch(cb,play)
    this.racingFetchCb = cb
    if not play then play = 0 end
    this.SendMessage(MSG_ID.MSG_COMPETITION_RACING_FETCH, {play= play})
end

---赛车进度奖励领取
function CarQuestModel.ReqRacingRoundReward()
    this.SendMessage(MSG_ID.MSG_COMPETITION_RACING_ROUND_REWARD, {})
end

---赛车排行榜奖励领取
function CarQuestModel.ReqRacingRankReward()
    this.SendMessage(MSG_ID.MSG_COMPETITION_RACING_RANK_REWARD, {},false,true)
end

--------------------------------------------------------------------------------------------------------

----------------------------------S2C-------------------------------------------------------------------

---赛车活动数据（可通知）
function CarQuestModel.ResRacingFetch(code, data)
    if code == RET.RET_SUCCESS then
        this.racingData = data and data.competitionInfo or {}
        this:CalculateRanks()
    elseif  code ==  RET.RET_ACTIVITY_NOT_START then -- 活动未开始
        this.racingData = {}
    else
        this.racingData = {}
    end
    
    --赛车结束了，后端数据不会删除，要前端自己删除
    local isAvailable = this:IsActivityAvailable()
    if not isAvailable then
        ModelList.GiftPackModel:RemoveQuestPack()
    end
    if data and data.noResponeNotify == nil  then
        Facade.SendNotification(NotifyName.Competition.ResphoneNotify)
    end
    
    if this.racingFetchCb then
        this.racingFetchCb(code)
        this.racingFetchCb = nil
    end
end

--- 赛车进度奖励领取
function CarQuestModel.ResRacingRoundReward(code, data)
    if code == RET.RET_SUCCESS then
        
        --需要清除赛车的活动数据，手动开启活动选择界面
    end
    
    Facade.SendNotification(NotifyName.CarQuest.GetRoundReward)
end

--- 赛车排行榜奖励领取
function CarQuestModel.ResRacingRankReward(code, data)
    if code == RET.RET_SUCCESS then
        --需要发送领取奖励是多少，且开启下一轮赛车

    end
    Facade.SendNotification(NotifyName.CarQuest.GetRankReward)
end

--- 赛车机器人数据变化通知 --领奖界面用，如果结束就显示领奖结束  
--- 无论是第一名还是第二名，
function CarQuestModel.ResRacingShortNotify(code, data)
    if code == RET.RET_SUCCESS then
        this.racingData = data and data.competitionInfo or {}
        this:CalculateRanks()
    elseif  code ==  RET.RET_ACTIVITY_NOT_START then -- 活动未开始
        this.racingData = {}
    else
        this.racingData = {}
    end
end

--------------------------------------------------------------------------------------------------------

this.MsgIdList = {
    { msgid = MSG_ID.MSG_COMPETITION_RACING_FETCH, func = this.ResRacingFetch },
    { msgid = MSG_ID.MSG_COMPETITION_RACING_ROUND_REWARD, func = this.ResRacingRoundReward },
    { msgid = MSG_ID.MSG_COMPETITION_RACING_RANK_REWARD, func = this.ResRacingRankReward },
    { msgid = MSG_ID.MSG_COMPETITION_RACING_SHORT_NOTIFY, func = this.ResRacingShortNotify },
}

return this
