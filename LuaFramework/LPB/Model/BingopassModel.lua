BingoPassPayType = {Pay499 = 1,Pay999 = 2,Pay500 = 3}

local BingopassModel = BaseModel:New("BingopassModel")
local this = BingopassModel

local bingopass_info = nil
local bingopass_detail = nil

local requestDetail = nil
local reqDataRefresh = false

local freeReceivedCache = nil
local payReceivedCache = nil

local receiveRewardData = nil

local payId = nil

local priceItem1 = nil
local priceItem2 = nil
local priceItem3 = nil
local waitGetFreeReward = {}
local waitGetPayReward = {}
local reqGetPassInfo = nil

function BingopassModel:InitData()
end

function BingopassModel:SetLoginData(data)
end

function BingopassModel:get_price1()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.price1
    end
    return "0"
end

function BingopassModel:get_productId1()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.productId1
    end
    return 0
end

--获取折扣
function BingopassModel:get_booster()
    if bingopass_detail and bingopass_detail.booster then
        return bingopass_detail.booster
    end
    
    return 100
end 

function BingopassModel:get_priceItem1()
    if bingopass_detail 
    and bingopass_detail.productInfo 
    and priceItem1 == nil then
        priceItem1 = Split(bingopass_detail.productInfo.priceItem1,",")
    end
    return priceItem1 or "0"
end

function BingopassModel:get_price2()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.price2
    end
    return "0"
end

function BingopassModel:get_productId2()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.productId2
    end
    return 0
end

function BingopassModel:get_priceItem2()
    if bingopass_detail 
    and bingopass_detail.productInfo 
    and priceItem2 == nil then
        priceItem2 = {}
        local items = Split(bingopass_detail.productInfo.priceItem2,";")
        if items then
            for index, value in ipairs(items) do
                table.insert(priceItem2,Split(value,","))
            end
        end
    end
    return priceItem2 or "0"
end

function BingopassModel:get_payDifference()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.payDifference
    end
    return "0"
end

function BingopassModel:get_productDifference()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.productDifference
    end
    return 0
end

function BingopassModel:get_priceItem3()
    if bingopass_detail 
    and bingopass_detail.productInfo 
    and priceItem3 == nil then
        priceItem3 = {}
        local items = Split(bingopass_detail.productInfo.priceItem3,";")
        if items then
            for index, value in ipairs(items) do
                table.insert(priceItem3,Split(value,","))
            end
        end
    end
    return priceItem3 or "0"
end

function BingopassModel:get_description1()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.description1
    end
    return 0
end

function BingopassModel:get_description2()
    if bingopass_detail and bingopass_detail.productInfo then
        return bingopass_detail.productInfo.description2
    end
    return 0
end

function BingopassModel:IsBingoPassActivate()
    return bingopass_info ~= nil
end

function BingopassModel:CheckRedDot()
    if bingopass_detail then
        local level = this:GetLevel()
        local isFreeRedDot = level > 0
        while true do
            if 0 == level then
                break
            end
            local received = this:IsFreeReceived(level)
            if received ~= nil then
                isFreeRedDot = not received
                break
            else
                local data = Csv.GetData("season_pass",level,"free_reward")
                if data and data[1] and data[1] > 0 then
                    isFreeRedDot = true
                    break
                end
            end
            level = math.max(0,level - 1)
        end
        if this:GetLevel() == 0 then --如果是零级的情况，是没有免费与支付的
            return false 
        else
            return isFreeRedDot or this:IsPayNoClaim(this:GetLevel())
        end 
    else
        return bingopass_info and bingopass_info.hasReward
    end
end

-- function BingopassModel:GetHasBingoInfoReward()
--     return bingopass_info and bingopass_info.hasReward
-- end

function BingopassModel:GetRemainTime()
    if bingopass_detail then
        return math.max(0,bingopass_detail.endTime - ModelList.PlayerInfoModel.get_cur_server_time())
    end
    return 0
end

--是否在促销时间
function BingopassModel:IsSaleTime()
    if bingopass_detail and bingopass_detail.productInfo then
       
        if bingopass_detail.productInfo.offTime == 0 then 
            return false
        else 
            return  (ModelList.PlayerInfoModel.get_cur_server_time() ) > bingopass_detail.endTime-(bingopass_detail.productInfo.offTime * 3600)
        end 
        return bingopass_detail.productInfo.offTime  - ModelList.PlayerInfoModel.get_cur_server_time() <0 
    end
    return false
end

function BingopassModel:IsPayAccomplish()
    if bingopass_detail then
        local exp = Csv.GetData("season_pass",this:GetLevel() + 1,"exp")
        for key, value in pairs(bingopass_detail.passInfo[1].payInfo) do
            if (value.itemId == BingoPassPayType.Pay499 and 0 == exp) or (value.itemId == BingoPassPayType.Pay999 or 
            value.itemId == BingoPassPayType.Pay500) then
                if value.isPay == 1 then
                    return true
                end
            end
        end
    end
    return false
end

function BingopassModel:IsCompletePay(payType)
    if bingopass_detail then
        for key, value in pairs(bingopass_detail.passInfo[1].payInfo) do
            if value.itemId == payType then
                return value.isPay == 1
            end
        end
    end
    return false
end

function BingopassModel:IsAnyPayment()
    if bingopass_detail then
        for key, value in pairs(bingopass_detail.passInfo[1].payInfo) do
            if value.isPay == 1 then
                return true
            end
        end
    end
    return false
end

function BingopassModel:GetSeasonId()
    if bingopass_detail then
        return bingopass_detail.seasonId
    end
end

function BingopassModel:GetRewardList()
    if receiveRewardData then
        return receiveRewardData.reward
    end
end

function BingopassModel:IsActivateGoldenPass()
    if bingopass_detail then
        return bingopass_detail.passInfo[1].isPay == 1
    end
    return false
end

function BingopassModel:GetLevel()
    if bingopass_info then
        return bingopass_info.level or 0
    end
    return 0
end

function BingopassModel:GetPreviousLevel()
    if bingopass_info then
        return bingopass_info.lastLevel
    end
end

function BingopassModel:GetExp()
    if bingopass_info then
        return bingopass_info.exp 
    end

    return 0
end

function BingopassModel:GetPreviousExp()
    if bingopass_info then
        return bingopass_info.lastExp
    end
end

function BingopassModel:GetExpCount()
    if bingopass_info then
        return bingopass_info.expCount
    end
end

function BingopassModel:IsFreeNoClaim(id)
    if this:GetLevel() >= (id or 0) then
        return not this:IsFreeReceived(id)
    end
end

function BingopassModel:IsFreeReceived(id)
    if freeReceivedCache then
        return freeReceivedCache[id or 0]
    end
end

--是否获得免费奖励
function BingopassModel:IsGetAllFreeReceived(id)
    if freeReceivedCache and freeReceivedCache[id] ~= nil and  freeReceivedCache[id] == true then 
        return true
    end 

    return false 
end

--是否获得付费奖励
function BingopassModel:IsGetAllPayReceived(id)
    if payReceivedCache and payReceivedCache[id] ~= nil and  payReceivedCache[id] == true then 
        return true
    end 

    return false 
end

function BingopassModel:IsPayNoClaim(id)
    

    if this:GetLevel() >= (id or 0) and 
    this:IsActivateGoldenPass() then
        return not this:IsPayReceived(id)
    end
end

function BingopassModel:IsPayReceived(id)
    if payReceivedCache then
        return payReceivedCache[id or 0]
    end
end

function BingopassModel:SetPayInfo()
    --4.99档没有等级变化是没消息返回的，只能强制刷新
    if payId and bingopass_detail then
        bingopass_detail.passInfo[1].isPay = 1
        if bingopass_detail.passInfo[1].payInfo == nil then
            bingopass_detail.passInfo[1].payInfo = {}
            table.insert(bingopass_detail.passInfo[1].payInfo,{itemId = payId,isPay = 1})
        else
            for key, value in pairs(bingopass_detail.passInfo[1].payInfo) do
                if value.itemId == payId then
                    value.isPay = 1
                end
            end    
        end
        payId = nil
    end
end

function BingopassModel:GetEndTime()
    return bingopass_detail and bingopass_detail.endTime or 0
end

function BingopassModel:SaveSeasonUid()
    local seasonUidKey = "BINGO_PASS_SEASON_UID"
    local originalSeasonUid = UnityEngine.PlayerPrefs.GetInt(seasonUidKey, 0)
    local currentSeasonUid = this:GetEndTime()
    if originalSeasonUid ~= currentSeasonUid then
        UnityEngine.PlayerPrefs.SetInt(seasonUidKey, currentSeasonUid)
        UnityEngine.PlayerPrefs.SetInt("BINGO_PASS_SHOWED_TIMES" .. ModelList.PlayerInfoModel:GetUid(), 0)
    end
end

--此赛季是否还有效
function BingopassModel:IsSeasonValid()
    return self:IsSeasonValidV2()
end

--此赛季是否还有效
function BingopassModel:IsSeasonValidV1()
    --玩家等级不够
    if not self:IsPlayerLevelEnough() then
        return false
    end

    --没有赛季的任何数据，认为是过期了
    if not this:IsBingoPassActivate() then
        return false
    end

    --时间上真正过期了
    if this:GetRemainTime() <= 1 then
        return false
    end

    local level = this:GetLevel()
    local level_max = Csv.GetData("season_pass", level, "level_max")

    --在有效间内，已经领取了所有的奖励
    if level_max == 1 and this:IsGetAllPayReceived(level) then
        return false
    end

    return true
end

--此赛季是否还有效
function BingopassModel:IsSeasonValidV2()
    --没有赛季的任何数据，认为是过期了
    if not this:IsBingoPassActivate() then
        return false
    end

    if not self:IsSeasonOpen() then
        return false
    end

    local level = this:GetLevel()
    local level_max = Csv.GetData("season_pass", level, "level_max")

    --在有效间内，已经领取了所有的奖励
    if level_max == 1 and this:IsGetAllPayReceived(level) then
        return false
    end

    return true
end

function BingopassModel:IsSeasonOpen()
    if not bingopass_detail then
        return false
    end

    return bingopass_detail.isSeasonOpen
end

function BingopassModel:IsPlayerLevelEnough()
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(10, 0)
    return nowLevel >= needLevel
end

function BingopassModel:GetPayGoldPassLevel()
    local level = this:GetLevel()
    local exp = this:GetExp()
    local seasonId = this:GetSeasonId()
    local rewardData = this:get_priceItem2()
    local rewardExp = tonumber(rewardData[2][2] or 0)
    while true do
        local needExp = Csv.GetData("season_pass", level + 1, "exp")
        if needExp then
            needExp = needExp - exp
            rewardExp = math.max(0,rewardExp - needExp)
            exp = 0
            level = level + 1
        else
            break
        end
        if rewardExp == 0 then
            break
        end
    end

    return level
end

function BingopassModel:GetAllReward(productType)
    local levelNormal = this:GetLevel()
    local levelGolden = levelNormal
    local rewardNow = {}
    local rewardSoon = {}
    if productType == BingoPassPayType.Pay999 then
        levelGolden = this:GetPayGoldPassLevel()
    end
    for i = 1, #Csv.season_pass do
        local cache_list = nil
        local passData = Csv.GetData("season_pass",i)
        if i <= levelNormal or i <= levelGolden then
            if not this:IsPayReceived(i) then
                cache_list = rewardNow
            end
        else
            if passData.exp == 0 and levelNormal == i - 1 then
                cache_list = rewardNow 
            else
                cache_list = rewardSoon
            end
        end
        if cache_list then
            for key2, value2 in pairs(passData.pay_reward) do
                local key = value2[1]
                local value = value2[2]
                if key and value then
                    cache_list[key] = (cache_list[key] or 0) + value
                end
            end
        else
            --break --这里不可以break
        end
    end

    return rewardNow, rewardSoon
end

function BingopassModel:IsMaxLevel()
    local level = self:GetLevel()
    local maxLevel = 100
    return level >= maxLevel
end

function BingopassModel:C2S_ReqquestBingopassInfo()
    this.SendMessage(MsgIDDefine.PB_SeasonPassUpLevel,{})
end

function BingopassModel.S2C_OnUpdataBingopassInfo(code,data)
    log.log("pass数据检查 协议 7218" , code , data)
    local passUpLevel = data and data.passUpLevel
    data = passUpLevel and passUpLevel[1]
    if code == RET.RET_SUCCESS and data then
        if data.level and data.hasReward then
            local freeRewardConfig = Csv.GetData("season_pass",data.level,"free_reward")
            local payRewardConfig = Csv.GetData("season_pass",data.level,"pay_reward")
            if freeRewardConfig and freeRewardConfig[1] ~= 0 then
                waitGetFreeReward[data.level] = true
            end
            if payRewardConfig and payRewardConfig[1] ~= 0 then
                waitGetPayReward[data.level] = true
            end
    
            local passNum = #Csv.season_pass
            if data.level == passNum - 1 then
                --最底部的奖励 这里后台最多返回到 passNum - 1
                waitGetPayReward[passNum] = true
            end
        else
            waitGetPayReward = {}
            waitGetFreeReward = {}
        end
        log.log("pass数据检查 协议 7218 重置 waitGetFreeReward" , waitGetFreeReward)
        log.log("pass数据检查 协议 7218 重置 waitGetPayReward" , waitGetPayReward)
        bingopass_info = deep_copy(data)
        if payId then
            this:C2S_RequestBingopassDetail()
        else
            Facade.SendNotification(NotifyName.BingoPass.UpdataBingoPassInfo)
        end
        Event.Brocast(EventName.Event_BingoPass_UpdateLevel) --
        Facade.SendNotification(NotifyName.BingoPass.UpdateCollectAllButton)
    end
end

function BingopassModel:C2S_RequestBingopassDetail()
    if not requestDetail then
        requestDetail = true
        this.SendMessage(MsgIDDefine.PB_SeasonPassInfo,{})
    end
end

-- function BingopassModel:C2S_RequestBingopassDetail2()
--     requestDetail = nil 
--     this.SendMessage(MsgIDDefine.PB_SeasonPassInfo,{})
-- end

function BingopassModel:TimeExpired_C2S_RequestBingopassDetail()
    requestDetail = false
    reqDataRefresh = true
    this.SendMessage(MsgIDDefine.PB_SeasonPassUpLevel,{})
    this.SendMessage(MsgIDDefine.PB_SeasonPassInfo,{})
end

function BingopassModel:Login_C2S_RequestBingopassDetail()
    requestDetail = nil 
    return MsgIDDefine.PB_SeasonPassInfo,Base64.encode(Proto.encode(MsgIDDefine.PB_SeasonPassInfo,{}))
end 


function BingopassModel.S2C_OnReceiveBingopassDetail(code,data)
    log.log("pass数据检查 协议 7215" , code , data)
    if code == RET.RET_SUCCESS and data then
        if data.isNTF then --单独处理推送过来的消息
            this.S2C_OnNtfBingopassDetail(data)
            return
        end

        bingopass_detail = deep_copy(data)
        freeReceivedCache = {}
        for key, value in pairs(bingopass_detail.passInfo[1].freeReceived) do
            freeReceivedCache[value] = true
        end
        payReceivedCache = {}
        for key, value in pairs(bingopass_detail.passInfo[1].payReceived) do
            payReceivedCache[value] = true
        end
        bingopass_detail.passInfo[1].free = nil
        bingopass_detail.passInfo[1].freeReceived = nil
        bingopass_detail.passInfo[1].pay = nil
        bingopass_detail.passInfo[1].payReceived = nil
        -- bingopass_detail.booster -- 相关的系数
        if requestDetail then
            Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "BingoPassView", true)
        end
        requestDetail = false
        if payId then
            payId = nil
            Facade.SendNotification(NotifyName.BingoPass.UpdataBingoPassInfo)
        end
        waitGetFreeReward = {}
        local isHasFreeReward = false
        for k , v in pairs(data.passInfo[1].free) do
            waitGetFreeReward[v] = true
            isHasFreeReward = true
        end

        if isHasFreeReward then
            waitGetPayReward = deep_copy(waitGetFreeReward)
        end
        
        for k , v in pairs(data.passInfo[1].pay) do
            waitGetPayReward[v] = true
        end

        if reqDataRefresh then
            reqDataRefresh = false
            local bundle = {}
            bundle.componentName = "FunctionIconBingopassView"
            bundle.callback = function(iconView) 
                log.log("完成图片重新添加")
                Event.Brocast(EventName.Event_BingoPass_UpdateActivity)
            end
            Event.Brocast(EventName.Event_Add_Function_Icon, bundle)
        end
    
        log.log("pass数据检查 协议 7215 重置 bingopass_detail " , bingopass_detail)

        log.log("pass数据检查 协议 7215 重置 waitGetFreeReward " , waitGetFreeReward)
        log.log("pass数据检查 协议 7215 重置 waitGetPayReward " , waitGetPayReward)
        this:SaveSeasonUid()
    else
        if reqDataRefresh then
            reqDataRefresh = false
            Event.Brocast(EventName.Event_BingoPass_ErrorActivity, bundle)
        end
    end
end

--单独处理推送过来的消息
function BingopassModel.S2C_OnNtfBingopassDetail(data)
    log.log("dghdgh0007 ntf detail data is ", data)
    if requestDetail then
        return
    end

    if payId then
        return
    end

    --只处理之前没有开启，通知开启的情况
    if (not bingopass_detail or (bingopass_detail and not bingopass_detail.isSeasonOpen)) and data.isSeasonOpen then
        bingopass_detail = deep_copy(data)
        
        freeReceivedCache = {}
        for key, value in pairs(bingopass_detail.passInfo[1].freeReceived) do
            freeReceivedCache[value] = true
        end
        payReceivedCache = {}
        for key, value in pairs(bingopass_detail.passInfo[1].payReceived) do
            payReceivedCache[value] = true
        end
        bingopass_detail.passInfo[1].free = nil
        bingopass_detail.passInfo[1].freeReceived = nil
        bingopass_detail.passInfo[1].pay = nil
        bingopass_detail.passInfo[1].payReceived = nil
        
        this:SaveSeasonUid()

        local bundle = {}
        bundle.componentName = "FunctionIconBingopassView"
        Event.Brocast(EventName.Event_Add_Function_Icon, bundle)
    end
end

function BingopassModel.C2S_RequestDiamondUplevel(level)
    this.SendMessage(MsgIDDefine.PB_SeasonPassDiamondUp,{})
end

function BingopassModel.S2C_OnDiamondUplevel(code,data)
    log.log("pass数据检查 协议 7216" , code , data)

    if code ~= RET.RET_SUCCESS then
        Facade.SendNotification(NotifyName.BingoPass.Expired)
    end
end

function BingopassModel:C2S_RequestClaimReward(index,rewardType)
    log.log("点击这里了 请求领奖 index" , index )
    log.log("点击这里了 请求领奖 rewardType"  , rewardType)
    if not index then
        index = 0
    end
    if not rewardType then
        rewardType = 0
    end
    reqGetPassInfo = 
    {
        index = index,
        rewardType = rewardType
    }
    this.SendMessage(MsgIDDefine.PB_SeasonPassReceive,{index = index , type = rewardType})
end

function BingopassModel.S2C_OnRespondClaimReward(code,data)
    log.log("pass数据检查 协议 7217" , code , data)
    log.log("pass数据检查 协议 7217 waitGetFreeReward " ,waitGetFreeReward)
    log.log("pass数据检查 协议 7217 waitGetPayReward" ,waitGetPayReward)
    if code == RET.RET_SUCCESS and data then
        receiveRewardData = deep_copy(data)
        if data.nowSeason then
            if reqGetPassInfo then
                if reqGetPassInfo.rewardType == PassRewardType.Free then
                    if waitGetFreeReward[reqGetPassInfo.index] then
                        freeReceivedCache[reqGetPassInfo.index] = true
                        waitGetFreeReward[reqGetPassInfo.index] = nil
            log.log("pass数据检查 协议 7217 reqGetPassInfo free" , freeReceivedCache)
                    end
                elseif reqGetPassInfo.rewardType == PassRewardType.Purchase then
                    if waitGetPayReward[reqGetPassInfo.index] then
                        payReceivedCache[reqGetPassInfo.index] = true
                        waitGetPayReward[reqGetPassInfo.index] = nil
            log.log("pass数据检查 协议 7217 reqGetPassInfo pay" , payReceivedCache)
                    end
                else
                    freeReceivedCache = {}
                    local level = this:GetLevel()
                    for i = 1, level do
                        freeReceivedCache[i] = true
                    end
                    if this:IsActivateGoldenPass() then
                        payReceivedCache = deep_copy(freeReceivedCache)
                        for k , v in pairs(waitGetPayReward) do
                            payReceivedCache[k] = true
                        end
                        if this:IsActivateGoldenPass() then
                            waitGetPayReward = {}
                        end
                    end
                    waitGetFreeReward = {}
                end
            end
            log.log("pass数据检查 协议 7217 reqGetPassInfo" , reqGetPassInfo)
            log.log("pass数据检查 协议 7217 waitGetFreeReward" , waitGetFreeReward)
            log.log("pass数据检查 协议 7217 waitGetPayReward" , waitGetPayReward)
            
            Facade.SendNotification(NotifyName.BingoPass.ReceiveReward)
            --因为领奖，是不发升级消息，所以前端维护此奖励
            if bingopass_info and bingopass_info.hasReward then 
                bingopass_info.hasReward = false 
            end 
        end
    end
    log.log("pass数据检查 协议 7217 重置" , freeReceivedCache)
end

function BingopassModel:RequestActivateGoldenPass(passId)
    payId = passId
    ModelList.MainShopModel.C2S_RequestActivityPay(passId,"season")
end

function BingopassModel:RecordBettleRound()
    local round = UnityEngine.PlayerPrefs.GetInt("BETTLE_ROUND", 0)
    UnityEngine.PlayerPrefs.SetInt("BETTLE_ROUND", round + 1)
end

function BingopassModel.GetBettleRound()
    local round = UnityEngine.PlayerPrefs.GetInt("BETTLE_ROUND", 0)
    return round
end

function BingopassModel:ResetBettleRound()
    UnityEngine.PlayerPrefs.SetInt("BETTLE_ROUND", 0)
end

function BingopassModel:CheckWaitGetReward()
    waitGetFreeReward = waitGetFreeReward or {}
    local state = false
    local freeRewardCount, payRewardCount = 0, 0
    for k , v in pairs(waitGetFreeReward) do
        if v then
            freeRewardCount = freeRewardCount + 1
            state = true
        end
    end
    
    if this:IsActivateGoldenPass() then
        waitGetPayReward = waitGetPayReward or {}
        for k ,v in pairs(waitGetPayReward) do
            if k then
                payRewardCount = payRewardCount + 1
                state = true
            end
        end
    end
    
    return state, freeRewardCount + payRewardCount
end


this.MsgIdList = 
{
    {msgid = MsgIDDefine.PB_SeasonPassUpLevel,func = this.S2C_OnUpdataBingopassInfo},
    {msgid = MsgIDDefine.PB_SeasonPassInfo,func = this.S2C_OnReceiveBingopassDetail},
    {msgid = MsgIDDefine.PB_SeasonPassDiamondUp,func = this.S2C_OnDiamondUplevel},
    {msgid = MsgIDDefine.PB_SeasonPassReceive,func = this.S2C_OnRespondClaimReward}
}

return this