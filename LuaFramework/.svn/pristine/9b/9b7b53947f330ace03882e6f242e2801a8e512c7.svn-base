local BetConfigModel = BaseModel:New("BetConfigModel")
local this = BetConfigModel
local betFreeConfig = {} --免费用户bet配置
local betPayConfig = {} --付费用户bet配置
local puzzleRewardConfig = {} --拼图奖励配置
local saveBetIndexString = "saveBetIndexString"
local saveCardNumString = "saveCardNumString"
local saveLastPlayCityId = "saveLastPlayCityIdString"

function BetConfigModel:SetLoginData(data)
    this.InitBetConfig()
    this.InitPuzzleConfig()
end

function BetConfigModel.GetTournamentItemRewardConfig(betRate)
    local data = nil
    for k ,v in ipairs(Csv.new_weeklylist_putin) do
        if v.bet_value == betRate then
            data = v
            break
        end
    end
    return data
end

function BetConfigModel.GetCookieItemRewardConfig(betRate)
    local level = ModelList.PlayerInfoModel:GetLevel()
    if level < 8 then
        --饼干活动8级开启
        return nil
    end
    local data = nil
    for k ,v in ipairs(Csv.new_cookie_putin) do
        if v.bet_value == betRate then
            data = v
            break
        end
    end
    return data
end

function BetConfigModel.GetChesetItemRewardConfig(betRate)
    local data = nil
    for k ,v in ipairs(Csv.new_chest_putin) do
        for z ,w in pairs(v) do
            if betRate >= v.bet_value[1] and betRate <= v.bet_value[2] then
                data = v
                break
            end
        end
    end
    return data
end


function BetConfigModel.GetPiggySlotTicketItemRewardConfig(betRate,cardNum,betNum)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if playId <= 1 then
        return nil
    end
    local data = nil
    for k ,v in ipairs(Csv.new_minigame_putin) do
        if v.bet_num == betNum and v.card_num == cardNum then
            data = v
            break
        end
    end
    return data
end

function BetConfigModel.GetSeasonPassRewardConfig(betRate,cardNum,betNum)
    local level = ModelList.PlayerInfoModel:GetLevel()
    if level < 11 then
        --赛季令牌11级开启
        return nil
    end
    local data = nil
    for k ,v in ipairs(Csv.new_season_pass_putin) do
        if v.bet_num == betNum and v.card_num == cardNum then
            data = v
            break
        end
    end
    return data
end


function BetConfigModel.GetItemRewardConfig(betRate,cardNum,betNum)
    local rewardData = {}
    local chestRewardData = this.GetChesetItemRewardConfig(betRate)
    local cookieRewardData = this.GetCookieItemRewardConfig(betRate)
    --local tournamentRewardData = this.GetTournamentItemRewardConfig(betRate)
    local piggySlotsTicket = this.GetPiggySlotTicketItemRewardConfig(betRate,cardNum,betNum)
    local seasonPassData = this.GetSeasonPassRewardConfig(betRate,cardNum,betNum)
    rewardData[BingoBangEntry.selectBattleReward.Cheset] = chestRewardData
    rewardData[BingoBangEntry.selectBattleReward.Cookie] = cookieRewardData
    --rewardData[BingoBangEntry.selectBattleReward.Tournament] = tournamentRewardData
    rewardData[BingoBangEntry.selectBattleReward.SeasonPass] = seasonPassData
    rewardData[BingoBangEntry.selectBattleReward.PiggySlotsTicket] = piggySlotsTicket
    --log.log("选择投放奖励 total " ,  rewardData)
    return rewardData
end

function BetConfigModel.InitPuzzleConfig()
    puzzleRewardConfig = {}
    for k ,v in pairs(Csv.new_puzzle_putin) do
        puzzleRewardConfig[v.card_num] = puzzleRewardConfig[v.card_num] or {}
        puzzleRewardConfig[v.card_num][v.bet_num] = v.puzzle_putin
    end
    log.log("拼图基础数据 " , puzzleRewardConfig)
end

function BetConfigModel.GetPuzzleConfig()
    return puzzleRewardConfig
end

function BetConfigModel.InitBetConfig()
    betFreeConfig = {}
    betPayConfig = {}
    for k ,v in ipairs(Csv.new_city_play_bet) do
        betFreeConfig[v.bet_group] = betFreeConfig[v.bet_group] or {}
        betFreeConfig[v.bet_group][v.level] = { curBet = v.bet_seq_free, nextBet = v.bet_unlock_free or {} }
        
        betPayConfig[v.bet_group] = betPayConfig[v.bet_group] or {}
        betPayConfig[v.bet_group][v.level] = { curBet = v.bet_seq_pay, nextBet = v.bet_unlock_pay or {}  }
    end
    --log.log("配置数据检查 free " , betFreeConfig)
    --log.log("配置数据检查 pay " , betPayConfig)
end

function BetConfigModel.GetUseBetConfig()
    local gameType = ModelList.CityModel.GetPlayIdByCity() --1是主要玩法 >1是特殊玩法
    local isFirstPurchase = ModelList.PlayerInfoModel:GetFirstPurchase()
    local betUse = nil
    if isFirstPurchase then
        --免费用户
        betUse = this.ResolveConfig(betFreeConfig[BingoBangEntry.machineType.Main])
        if gameType == BingoBangEntry.machineType.Main then
            betUse = this.ResolveConfig(betFreeConfig[BingoBangEntry.machineType.Main])
        else
            betUse = this.ResolveConfig(betFreeConfig[BingoBangEntry.machineType.Special])
        end
    else
        --付费用户
        if gameType == BingoBangEntry.machineType.Main then
            betUse = this.ResolveConfig(betPayConfig[BingoBangEntry.machineType.Main])
        else
            betUse = this.ResolveConfig(betPayConfig[BingoBangEntry.machineType.Special])
        end
    end
    return betUse
end

function BetConfigModel.ResolveConfig(config)
    local level = ModelList.PlayerInfoModel:GetLevel()
    if config[level] then
        return config[level]
    end
    return nil
end

function BetConfigModel.SaveSelectBattleConfig(betIndex,cardNum)
    local gameType = ModelList.CityModel.GetPlayIdByCity()
    local saveTypeString = ""
    if gameType == BingoBangEntry.machineType.Main then
        saveTypeString = "normalMachine"
    else
        saveTypeString = "vipMachine"
    end
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local saveBetString = string.format("%s_%s_%s",saveBetIndexString,saveTypeString,myUid)
    local saveCardNum = string.format("%s_%s_%s",saveCardNumString,saveTypeString,myUid)
    fun.save_value(saveBetString , betIndex )
    fun.save_value(saveCardNum, cardNum )
end

function BetConfigModel.ReadSelectBattleIndex()
    local gameType = ModelList.CityModel.GetPlayIdByCity()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local saveString = ""
    if gameType == BingoBangEntry.machineType.Main then
        saveString = string.format("%s_%s_%s",saveBetIndexString,"normalMachine",myUid)
    else
        saveString = string.format("%s_%s_%s",saveBetIndexString,"vipMachine",myUid)
    end
    local betIndex = fun.read_value(saveString, 1)
    return betIndex
end

function BetConfigModel.ReadSelectCardNum()
    local gameType = ModelList.CityModel.GetPlayIdByCity()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local saveString = ""
    if gameType == BingoBangEntry.machineType.Main then
        saveString = string.format("%s_%s_%s",saveCardNumString,"normalMachine",myUid)
    else
        saveString = string.format("%s_%s_%s",saveCardNumString,"vipMachine",myUid)
    end
    local cardNum = fun.read_value(saveString , 2)
    return cardNum
end

function BetConfigModel.CheckIsNormalGame()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if playId == 1 then
        return true
    end
    return false
end

function BetConfigModel.SaveLastPlayCity()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local gameType = ModelList.CityModel:GetPlayIdByCity()

    local saveData = ""
    if gameType == BingoBangEntry.machineType.Main then
        --上次玩的是城市机台
        local cityGameData = ModelList.CityModel:GetCity()
        saveData = string.format("%s_%s" , BingoBangEntry.machineType.Main , cityGameData)
    elseif gameType == BingoBangEntry.machineType.Special then
        --上次玩的是 vip机台
        saveData = string.format("%s_%s" , BingoBangEntry.machineType.Special , gameType)
    end
    log.log("机台玩过数据 save " , saveData)
    fun.save_value(saveLastPlayCityId .. myUid , saveData )
end

function BetConfigModel.ReadLastPlayCity()
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local data = fun.read_value(saveLastPlayCityId .. myUid, nil)
    if data then
        local splitData = Split(data,"_")
        local gameType = tonumber(splitData[1])
        local cityIndex = tonumber(splitData[2])
        log.log("分解的数据 " ,splitData)
        if gameType and cityIndex then
            return gameType , cityIndex
        end
    end
    local curCityIndex = ModelList.NewPuzzleModel:GetNewUnlockScene()
    return BingoBangEntry.machineType.Main, curCityIndex
end

function BetConfigModel.ClearGameData()
    betFreeConfig = {} --免费用户配置
    betPayConfig = {} --付费用户配置
end

this.MsgIdList = {
}


return this
