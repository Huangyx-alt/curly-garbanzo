--ultra bet 活动
local UltraBetModel = BaseModel:New("UltraBetModel")
local this = UltraBetModel

function UltraBetModel:InitData()
    self.isOpen = false
    self.expire = 0
    self.maxBetRecord = {}
    self.betStatus = {}
    self.betStatusMap = {}
end

--当前活动是否有效
function UltraBetModel:IsActivityValid(playId)
    playId = playId or ModelList.CityModel.GetPlayIdByCity()
    if not playId then
        log.log("UltraBetModel:IsActivityValid error! playId is nil")
        return false
    end

    if self.betStatusMap[playId] then
        return true
    else
        return false
    end
end

local CheckPlayTypes = {
    PLAY_TYPE.PLAY_TYPE_VICTORY_BEATS,
}
--当前活动是否对当前玩法有效
function UltraBetModel:IsActivityValidForCurPlay(playId)
    --不受UltraBet影响的玩法
    local checkPlayType = false
    table.each(CheckPlayTypes, function(playType)
        checkPlayType = checkPlayType or ModelList.CityModel.CheckCurTypeIs(playType)
    end)
    if checkPlayType then
        return false
    end
    
    return self:IsActivityValid(playId)
end

function UltraBetModel:IsCurPlaySupportUltra()
    local checkPlayType = false
    table.each(CheckPlayTypes, function(playType)
        checkPlayType = checkPlayType or ModelList.CityModel.CheckCurTypeIs(playType)
    end)
    if checkPlayType then
        return false
    end
    
    return true
end

--当前活动是否为新开启的
function UltraBetModel:IsActivityNewlyOpen()
    --return self.isOpen and self:GetPopupPosterTimes() < 1
    return false
end

function UltraBetModel:GetActivityExpireTime()
    return self.expire or 0
end

function UltraBetModel:GetPopupPosterTimes()
    local showedTimes = UnityEngine.PlayerPrefs.GetInt("ULTRA_BET_POSTER_SHOWED_TIMES_", 0)
    return showedTimes
end

function UltraBetModel:GetLocalUid()
    local uid = UnityEngine.PlayerPrefs.GetInt("ULTRA_BET_UID", 0)
    return uid
end

function UltraBetModel:SetLocalUid()
    UnityEngine.PlayerPrefs.SetInt("ULTRA_BET_UID", self.expire)
end

function UltraBetModel:UpdatePopupPosterTimes()
    local showedTimes = UnityEngine.PlayerPrefs.GetInt("ULTRA_BET_POSTER_SHOWED_TIMES_", 0)
    UnityEngine.PlayerPrefs.SetInt("ULTRA_BET_POSTER_SHOWED_TIMES_", showedTimes + 1)
end

function UltraBetModel:GetCurrentTime()
    return ModelList.PlayerInfoModel.get_cur_server_time()
end

function UltraBetModel:GetActivityLevel()
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local ultraLevel= self.betStatusMap[playid] or 1
    return ultraLevel
end

-- --开始计时
-- function UltraBetModel:StartCounting()
--     local currentTime = self:GetCurrentTime()
--     local expireTime = self:GetActivityExpireTime()
--     local duration = expireTime - currentTime
--     self:RemoveCountDownTimer()
--     if duration > 0 then
--         local instance = self
--         self.countDownTimer = LuaTimer:SetDelayFunction(duration, function()
--             instance:RemoveCountDownTimer()
--             instance.C2S_RequestUltraBetInfo()
--         end)
--     end
-- end

--开始活动
function UltraBetModel:StartActivity(data)
    if data then
        self.betStatusMap[data.playId] = data.betHard
    end
    Facade.SendNotification(NotifyName.UltraBet.ActivityStart, data)
    --Event.Brocast(NotifyName.HallCityBanner.AddBannerItem, hallCityBannerType.ultraBet)
    self:TryOpenPoster()
end

--结束活动
function UltraBetModel:EndActivity(data)
    local playId = data and data.playId
    if playId then
        self.betStatusMap[playId] = nil
    end
    Facade.SendNotification(NotifyName.UltraBet.ActivityEnd, playId)
end

--[[
function UltraBetModel:RemoveCountDownTimer()
    if self.countDownTimer then
        LuaTimer:Remove(self.countDownTimer)
        self.countDownTimer = nil
    end
end
--]]

function UltraBetModel:GetBetMultiple()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local ultraBet = Csv.GetData("bet_ultra", playId, "ultra_bet")
    local multiple = 1
    if ultraBet then
        local betrate = ModelList.CityModel:GetBetRate() or 1
        local ultraLevel= self.betStatusMap[playId] or 1
        local tempMul = ultraBet[ultraLevel][betrate] or 100
        multiple = tempMul / 100
    end

    return multiple
end

function UltraBetModel:GetSingleCardCostByBet(betRate)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local ultraBet = Csv.GetData("bet_ultra", playId, "ultra_bet_new")
    if ultraBet then
        betRate = betRate or ModelList.CityModel:GetBetRate() or 1
        local ultraLevel= self.betStatusMap[playId] or 1
        local cost = ultraBet[ultraLevel][betRate]
        return cost
    else
        log.r(string.format("GetSingleCardCostByBet Cant Find bet_ultra Cfg, playId is: %s, ", playId))
    end
end

function UltraBetModel:CanPropMultiple(propIds)
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local items = Csv.GetData("bet_ultra", playId, "item")

    if type(propIds) == "table" then
        for i, v in ipairs(propIds) do
            if IsValueInList(v, items) then
                return true
            end
        end
    else
        return IsValueInList(propIds, items)
    end
end

function UltraBetModel:NeedChange2MaxBet(playId)
    playId = playId or ModelList.CityModel.GetPlayIdByCity()
    if not self:IsActivityValid() then
        return false
    end

    if self.maxBetRecord and not self.maxBetRecord[playId] then
        return true
    end

    return false
end

function UltraBetModel:RecordChange2MaxBet(playId)
    playId = playId or ModelList.CityModel.GetPlayIdByCity()
    if self.maxBetRecord and not self.maxBetRecord[playId] then
        self.maxBetRecord[playId] = true
    end
end

function UltraBetModel:SetEncouragement()
    self.hasEncouragement = true
end

function UltraBetModel:ClearEncouragement()
    self.hasEncouragement = nil
end

function UltraBetModel:HasEncouragement()
    return self.hasEncouragement
end

function UltraBetModel:ClaimEncouragementReward()
    this.SendMessage(MSG_ID.MSG_GET_ULTRA_BET_REWARD, {})
end

function UltraBetModel:TryOpenPoster()
    local isNeedPopup = ModelList.UltraBetModel:GetPopupPosterTimes() < 1
    --isNeedPopup = false --for test wait delete
    if isNeedPopup then
        Facade.SendNotification(NotifyName.ShowUI, ViewList.UltraBetPosterView)
        ModelList.UltraBetModel:UpdatePopupPosterTimes()
    end
end

function UltraBetModel.S2C_NtfEncouragementStatus(code, data)
    if code == RET.RET_SUCCESS then
        if data.isPrize then
            this:SetEncouragement()
        else
            this:ClearEncouragement()
        end
    end
end

function UltraBetModel.S2C_OnClaimEncouragementReward(code, data)
    log.log("S2C_OnClaimEncouragementReward", code, data)
    if code == RET.RET_SUCCESS then
        Event.Brocast(EventName.Event_registerReward, data.reward)
    else
        Event.Brocast(EventName.Event_registerReward, nil)
    end
    this:ClearEncouragement()
end

function UltraBetModel.C2S_RequestUltraBetInfo()
    log.log("C2S_RequestUltraBetInfo send ")
    this.SendMessage(MSG_ID.MSG_NTF_ULTRA_BET_INFO, {})
end

function UltraBetModel.LoginC2S_RequestUltraBetInfo()
    log.log("LoginC2S_RequestUltraBetInfo send ")
  --  this.SendMessage(MSG_ID.MSG_ULTRA_BET_ALL_STATUS, {})
    return MSG_ID.MSG_ULTRA_BET_ALL_STATUS,Base64.encode(Proto.encode(MSG_ID.MSG_ULTRA_BET_ALL_STATUS,{}))
end

function UltraBetModel.C2S_RequestUltraBetOpen(playId)
    log.log("C2S_RequestUltraBetOpen send ", playId)
    this.SendMessage(MSG_ID.MSG_ULTRA_BET_OPEN, {playId = playId})
end

function UltraBetModel.C2S_RequestUltraBetClose(playId)
    log.log("C2S_RequestUltraBetClose send ", playId)
    this.SendMessage(MSG_ID.MSG_ULTRA_BET_CLOSE, {playId = playId})
end

--[[
function UltraBetModel.S2C_ReceiveUltraBetInfo(code, data)
    ----log.log("S2C_ReceiveUltraBetInfo  receive data is ", code, data)
    if code == RET.RET_SUCCESS then
        local previousOpenState = this.isOpen
        local localUid = this:GetLocalUid()
        this.isOpen = data.isOpen
        this.expire = data.expire

        --data.isPopup
        if localUid ~= data.expire then
            UnityEngine.PlayerPrefs.SetInt("ULTRA_BET_POSTER_SHOWED_TIMES_", 0)
        end
        if previousOpenState ~= data.isOpen then
            if data.isOpen then
                this:StartActivity()
            else
                this:EndActivity()
            end
        end

        if data.isPrize then
            this:SetEncouragement()
        else
            this:ClearEncouragement()
        end

        if this:IsActivityValid() then
            this:StartCounting()
        end
        this:SetLocalUid()
    end
end
--]]

function UltraBetModel.S2C_UltraBetOpen(code, data)
    log.log("S2C_UltraBetOpen", code, data)
    if code == RET.RET_SUCCESS then
        this:StartActivity(data)
    else

    end
end

function UltraBetModel.S2C_UltraBetClose(code, data)
    log.log("S2C_UltraBetClose", code, data)
    if code == RET.RET_SUCCESS then
        this:EndActivity(data)
    else

    end
end

function UltraBetModel.S2C_UltraBetStatus(code, data)
    log.log("S2C_UltraBetStatus", code, data)
    
    if code == RET.RET_SUCCESS then
        this.betStatus = data.betStatus or {}
        for i, v in ipairs(this.betStatus) do
            this.betStatusMap[v.playId] = v.betHard
            if v.betHard > 5 then
                this.betStatusMap[v.playId] = 5
            end
        end
    else

    end
end

this.MsgIdList =
{
    -- {msgid = MSG_ID.MSG_NTF_ULTRA_BET_INFO,func = this.S2C_ReceiveUltraBetInfo},
    {msgid = MSG_ID.MSG_ULTRA_BET_REWARD_STATUS,func = this.S2C_NtfEncouragementStatus},
    {msgid = MSG_ID.MSG_GET_ULTRA_BET_REWARD,func = this.S2C_OnClaimEncouragementReward},

    {msgid = MSG_ID.MSG_ULTRA_BET_OPEN,func = this.S2C_UltraBetOpen},
    {msgid = MSG_ID.MSG_ULTRA_BET_CLOSE,func = this.S2C_UltraBetClose},
    {msgid = MSG_ID.MSG_ULTRA_BET_ALL_STATUS,func = this.S2C_UltraBetStatus},
}

return this