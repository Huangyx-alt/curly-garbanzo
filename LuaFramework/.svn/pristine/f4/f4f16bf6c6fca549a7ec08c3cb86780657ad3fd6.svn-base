
local RegularlyAwardModel = BaseModel:New("RegularlyAwardModel")
local this = RegularlyAwardModel

local matureTimePoint = nil
local awardInfo = nil
local m_userTypes = nil

function RegularlyAwardModel.C2S_FetchRegularlyAwardInfo()
    -- if loginCb then
    --     loginCallBack = loginCb
    -- end
    this.SendMessage(MSG_ID.MSG_HANGUP_RECEIVE_COUNTDOWN,{})
end

function RegularlyAwardModel.Login_C2S_FetchRegularlyAwardInfo()
   
    return MSG_ID.MSG_HANGUP_RECEIVE_COUNTDOWN,Base64.encode(Proto.encode(MSG_ID.MSG_HANGUP_RECEIVE_COUNTDOWN,{}))
   
end

function RegularlyAwardModel.S2C_ResponeRegularlyAwardInfo(code,data)
    if code == RET.RET_SUCCESS and data then
        local updata = matureTimePoint ~= nil
        matureTimePoint = data.countdown + os.time()
        --log.r("=========================================>>S2C_ResponeRegularlyAwardInfo " .. data.countdown)
        awardInfo = data.totalRewardShow[1]
        m_userTypes = data.useTypes
      
        if updata then
            Facade.SendNotification(NotifyName.RegularlyAwardInfoView.UpDataRegularlyAwardInfo)
        end
        
        RedDotManager:Refresh(RedDotEvent.shop_coinfree_event) --刷新下红点
    end
end

function RegularlyAwardModel.C2S_RequestRegularlyAwardCommit()
    --log.r("==============================>>C2S_RequestRegularlyAwardCommit ")
    this.SendMessage(MSG_ID.MSG_HANGUP_RECEIVE_REWARD,{})
end

function RegularlyAwardModel.S2C_ResponeRegularlyAwardCommit(code,data)
    --log.r("==============================>>S2C_ResponeRegularlyAwardCommit " .. code)
    if code == RET.RET_SUCCESS and data then
        matureTimePoint = data.countdown + os.time()
        awardInfo = data.rewards[1]
        Facade.SendNotification(NotifyName.RegularlyAwardInfoView.CliamRewardRespone)
    end
end

function RegularlyAwardModel:GetRemainTime()
    if matureTimePoint then
        return math.max(0,matureTimePoint - os.time())
    end
    return 0
end

function RegularlyAwardModel:IsRegularlyAwardMature()
    if matureTimePoint then
        return matureTimePoint - os.time() <= 0
    end
    return false
end

function RegularlyAwardModel:GetRewardItemId()
    if awardInfo then
        return awardInfo.id
    end
    return Resource.coin
end

function RegularlyAwardModel:GetRewardNum()
    if awardInfo then
        return awardInfo.value
    end
    return 0
end

function RegularlyAwardModel:CheckUserTypes(userTypes)
    userTypes = userTypes or USertypes.useDiamon
    if m_userTypes then
        for key, value in pairs(m_userTypes) do
            if value == userTypes then
                return true
            end
        end
    end
    if ModelList.PlayerInfoModel:GetUserType() and UserTypeBigR ==  ModelList.PlayerInfoModel:GetUserType() then
        return true
    end
    return false
end

function RegularlyAwardModel.C2S_GetMoreReward()
    this.SendMessage(MSG_ID.MSG_HANGUP_MORE_OFFLINE_REWARD,{})
end

function RegularlyAwardModel.S2C_GetMoreReward(code,data)
    if code == RET.RET_SUCCESS and data then
        
    end
end

this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_HANGUP_RECEIVE_COUNTDOWN,func = this.S2C_ResponeRegularlyAwardInfo},
    {msgid = MSG_ID.MSG_HANGUP_RECEIVE_REWARD,func = this.S2C_ResponeRegularlyAwardCommit},
    {msgid = MSG_ID.MSG_HANGUP_MORE_OFFLINE_REWARD,func = this.S2C_GetMoreReward}
}

return this