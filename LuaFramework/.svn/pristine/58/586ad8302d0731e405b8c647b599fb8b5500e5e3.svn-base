local ActivityModel = BaseModel:New("ActivityModel")
local this = ActivityModel

local activity_list = nil

local firstOpen_list = nil



this.waitingShowIconBeDoubleIdList = {}

function ActivityModel.GetPrefsKey(id)
    return string.format("Acitivity_prefs%s",id)
end

function ActivityModel.GetPrefsInt(id)
    return UnityEngine.PlayerPrefs.GetInt(this.GetPrefsKey(id),-1)
end

function ActivityModel.SetPrefsInt(id,value)
    UnityEngine.PlayerPrefs.SetInt(this.GetPrefsKey(id),value)
end

function ActivityModel:SetLoginData(data)
    self:InitDoubleActivityData()
    if data and data.activityInfo then
        self:SetActivityData(data.activityInfo)
        self:CheckDoubleOpen()

        Facade.SendNotification(NotifyName.Activety.refreshActiveDoble, nil, nil)
        
    end
end


function ActivityModel:SetActivityData(data,isUpdate)
    if data then
        if not activity_list then
            activity_list = {}
            firstOpen_list = {}
        end
        for key, value in pairs(data) do
            activity_list[value.id] = deep_copy(value)
            ---活动过期，是双倍就要关闭icon双倍效果
            if isUpdate then
                Event.Brocast(EventName.Event_Check_Double_Activity,value.id, not self:IsActivityExpire(value.expireTime) )
            end
            local prefabs = this.GetPrefsInt(value.id)
            if prefabs ~= value.createTime then
                this.SetPrefsInt(value.id,value.createTime)
                firstOpen_list[value.id] = true
            end
        end
    end
end

function ActivityModel.S2C_ReceiptActivityInfo(code,data)
    if code == RET.RET_SUCCESS then
        this:SetActivityData(data.activityInfo)
        Facade.SendNotification(NotifyName.HallCity.EnterCityPopupOrder,PopupOrderOccasion.forcePopup)
    end
end

function ActivityModel.S2C_UpdateActiveInfo(code,data)
    if code == RET.RET_SUCCESS then
        this:SetActivityData(data.state,true)
    end
end

function ActivityModel.C2S_SubmitActivity_old(activityId)
    if activityId then
        this.SendMessage(MSG_ID.MSG_ACTIVITY_HISTORY_RECEIVE_REWARD,{activityId = activityId})
    end
end

function ActivityModel.C2S_SubmitActivity_new(activityId,roundId,createTime,rewardExtra)
    if activityId then
        this.SendMessage(MSG_ID.MSG_ACTIVITY_ROUND_RECEIVE_REWARD,{activityId = activityId,roundId = roundId,createTime = createTime,rewardExtra = rewardExtra})
    end
end

function ActivityModel.S2C_ReceiveActivityReward(code,data)
    if code == RET.RET_SUCCESS then
        -- body
    end
    Event.Brocast(EventName.Event_Activity_ReceiveReward)
end

function ActivityModel:GetActivityInfo(id)
    if activity_list then
        return activity_list[id]
    end
    return nil
end

function ActivityModel:GetActivityExpireTime(id)
    if activity_list and activity_list[id] then
        return activity_list[id].expireTime
    end
    return 0
end

function ActivityModel:GetActivityCreatTime(id)
    if activity_list and activity_list[id] then
        return activity_list[id].createTime
    end
    return 0
end

function ActivityModel:IsActivityAvailable(id)
    if activity_list and activity_list[id] then
        if activity_list[id].hasRoundData == 1 then
            --只能一层层的判断，服务端不能保证数据的有效性 then
            if activity_list[id].roundData and
            activity_list[id].roundData[1] and 
            activity_list[id].roundData[1].id then
                return activity_list[id].expireTime - os.time() > 0
            end
        else
            return activity_list[id].expireTime - os.time() > 0
        end
    end
    return false
end

function ActivityModel:GetAnyActivity()
    if activity_list then
        for key, value in pairs(activity_list) do
            if value.expireTime - os.time() > 0 then
                return key
            end 
        end
    end
    return -1
end

function ActivityModel:IsActivityFirstOpen(id)
    return firstOpen_list and firstOpen_list[id]
end

function ActivityModel:IsAnyFirstOpen()
    if firstOpen_list then
        for key, value in pairs(firstOpen_list) do
            if value then
                return true,key
            end
        end
    end
    return false
end

function ActivityModel:IsFirstOpen(id)
    if firstOpen_list then
        return firstOpen_list[id]
    end
    return false
end

function ActivityModel:CutdownFirstPopup(id)
    if firstOpen_list then
        firstOpen_list[id] = false
    end
end

function ActivityModel:GetQuickTaskActive()
    local quickTask = nil
    local quickTaskActive = this:GetActivityInfo(ActivityTypes.quickTask)
    if quickTaskActive then
        for key, value in pairs(quickTaskActive.roundData) do
            if quickTask == nil or value.id > quickTask.id then
                quickTask = value
            end
        end
    end
    return quickTask,quickTaskActive
end




function ActivityModel:InitDoubleActivityData()
    ---登录就要弹或者需要触发的活动列表
    this.needShowOpenList = {ActivityTypes.doublePuzzle,ActivityTypes.doubleFood,ActivityTypes.doubleCookies}
    this.waitingShowIconBeDoubleIdList = {false,false,false,false,false,false,false,false,false,false}
end


---移除登录弹窗列表
function ActivityModel:RemoveLoginOpenActivity(id)
    this:CutdownFirstPopup(id)
    if this.needShowOpenList  and #this.needShowOpenList>0 then
        fun.remove_table_item(this.needShowOpenList,id)
    end
end

function ActivityModel:IsActivityLoginOpen(id)
    return this.needShowOpenList and fun.is_include(id, this.needShowOpenList) and this:IsActivityAvailable(id)
end

---激活过的双倍
function ActivityModel:IsActiveAndDuringDouble(id)
    local activityId = Csv.GetData("function_icon",id,"activity_type")
    if not this.waitingShowIconBeDoubleIdList[activityId] and this:IsActivityAvailable(activityId) then
        return true
    end
    return false
end


function ActivityModel:IsActivityExpire(expireTime)
    return expireTime -os.time() <= 0
end


function ActivityModel:CheckDoubleOpen()
    for i = 1, #this.needShowOpenList do
        if self:IsActivityLoginOpen(this.needShowOpenList[i])  and self:IsActivityAvailable(this.needShowOpenList[i]) then
            this.waitingShowIconBeDoubleIdList[this.needShowOpenList[i]] = true
        end
    end
end

function ActivityModel:IsWaitingShowChangeDouble(id)
    return this.waitingShowIconBeDoubleIdList[id]
end

function ActivityModel:HadShowChangeDouble(id)
    this.waitingShowIconBeDoubleIdList[id] = false
    this:CutdownFirstPopup(id)
end


this.MsgIdList = 
{
    {msgid = MSG_ID.MSG_ACTIVITY, func = this.S2C_ReceiptActivityInfo},
    {msgid = MSG_ID.MSG_ACTIVITY_UPDATE,func = this.S2C_UpdateActiveInfo},
    {msgid = MSG_ID.MSG_ACTIVITY_HISTORY_RECEIVE_REWARD,func = this.S2C_ReceiveActivityReward},
    {msgid = MSG_ID.MSG_ACTIVITY_ROUND_RECEIVE_REWARD,func = this.S2C_ReceiveActivityReward}
}

return this