--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 11:00:03
]]

----玩法活动passmodel管理 ，每个玩法都对应不同pass


local VolcanoMissionModel = BaseModel:New("VolcanoMissionModel")
local this = VolcanoMissionModel
local _mapData = nil
local _newMapData = nil

local _lastMapData = nil 

local _stepMembers = nil

local saveKey = "VolanoLocalStep"

local _dieCount = 0 --已失败的玩家数

local _count = 0 -- 总玩家数量 

local rewardedRecStep = nil   --记录当前开箱位置 

local _levelUpData=nil   --用于保存每个升级节点数据   key step, value 0,1  0表示未播放，1表示播放完成 
----------------------------对外-----------------------------------------------------

local debug= false 
local VolcanoMission_LOCAL_SAVE_KEY = "VolcanoMission_LOCAL_SAVE_KEY"

local activityId = 6

local isLastPrize = false 

function VolcanoMissionModel:SaveLastPrizeTag()
    isLastPrize = true
end

function VolcanoMissionModel:CleanLastPrizeTag()
    isLastPrize = nil
end


function VolcanoMissionModel:IsLastPrize()
   return isLastPrize
end



function VolcanoMissionModel:IsFristStep()
    return  _mapData.step==_mapData.lastStep and _mapData.lastStep==0
end


function VolcanoMissionModel:isCurStepHasReward( )

    local stepId = this.GetCurStepId() 
    local isFind = false 
    for i = rewardedRecStep, stepId do
        local hasReward = this:HasRewardByStepId(i)
        if(hasReward)then 
            isFind = hasReward
            break
        end
    end 
    return isFind 

end


function VolcanoMissionModel:HasRewardByStepId(id)
    local ret = false 
    local isFind = false 
    local hasBuffer = this:HasBoxBuffer()
    if(id==rewardedRecStep)then 
        return false 
    end
    
    if(id<rewardedRecStep and hasBuffer)then 
        return false
    end
    
    for k,v in pairs(_mapData.stepRewards) do
        if(v.step==id)then  
            isFind = true 
            break 
        end
    end
    
    for k,v in pairs(_mapData.rewardSteps) do
        if(v==id and v<=rewardedRecStep)then  
            isFind = false
            break 
        end
    end


    for k,v in pairs(_mapData.lastRewardSteps) do
        if(v==id)then  
            isFind = false  
            break 
        end
    end

    return isFind 
end

function VolcanoMissionModel:GetRemainTime()
    if not _newMapData or not _newMapData.endTime then
        local ret = ModelList.ActivityModel:GetActivityExpireTime(activityId)
        ret = math.max(0,tonumber(ret) - ModelList.PlayerInfoModel.get_cur_server_time())
        log.r("lxq GetRemainTime",ret)
        return ret
 
    end
    local ret = math.max(0,_newMapData.endTime - ModelList.PlayerInfoModel.get_cur_server_time())

    if ret <= 0 then
        ret = ModelList.ActivityModel:GetActivityExpireTime(activityId)
        ret = math.max(0,tonumber(ret) - ModelList.PlayerInfoModel.get_cur_server_time())
        if ret > 0 then
            log.r("lxq GetRemainTime CleanUserData ",ret)
            self:CleanUserData()
        end
    end
    log.r("lxq GetRemainTime",ret)
    return ret
end

function VolcanoMissionModel:GetRoundInfo()
    return _mapData.round,_mapData.totalRound 
end

function VolcanoMissionModel:GetCollectInfo()
    return _mapData.resource,_mapData.totalResource 
end

--活动是否有效
function VolcanoMissionModel:IsActivityAvailable()
    local remainTime = this:GetRemainTime()
    return remainTime > 0
end

--玩家等级是否达到开启条件
function VolcanoMissionModel:IsPlayerLevelEnough()
    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(21, 0)
    return playerLevel >= needLevel
end

--[[
    @desc: 返回关卡数据     1/7    1当前关卡，7总数
    author:{author}
    time:2024-03-25 11:02:14
    @return:
]]
function VolcanoMissionModel:GetLevelInfo()
    return  this:GetMapId(),this:GetMapCount()
end

--[[
    @desc:返回当前玩家存活信息    78/100    失败，总数
    author:{author}
    time:2024-03-25 11:08:48
    @return:
]]
function VolcanoMissionModel:GetPlayerInfo()

    return  _dieCount,_count+1 
end



function VolcanoMissionModel:GetNewMapDataPlayInfo()
    local npcs,count, die= this:GetStempMemberInfo(_newMapData)
    return count+1,die
end

--[[
    @desc: 是否需要播放动画 ，只有本地数据跟服务器数据不一致时才播放，播放完成后，再调用 UpdateStep保存本地数据，活动结束需要清理
    author:{author}
    time:2024-03-25 11:03:48
    @return:
]]
function VolcanoMissionModel:NeedShowMain()
    return UserData.get(saveKey,-1) == 1
end

--- @desc: 重置活动状态 0 不需要  1有变化
function VolcanoMissionModel:ResetShowMainStatu(statu)
    UserData.set(saveKey, statu)
end

function VolcanoMissionModel:GetReliveTimes()
    return _newMapData.reliveTimes or 0
end


function VolcanoMissionModel:GetNpcCountByStepId(id)
    local stepData =  _stepMembers[id]

    return GetTableLength(stepData)
end

--[[
    @desc: 获取台阶存在的玩家,
    author:{author}
    time:2024-03-25 11:04:59
    --@stepId: 台阶id
    ---@isPart:是否是部分？   
    @return:
]]
function VolcanoMissionModel:GetMapPlayerByStep(stepId,count) 
    local maxCount = this:GetStepCount()
    local ret = {}
    local _count = maxCount
    local idx = 0
    while (maxCount>0) do 
        local stepData =  _stepMembers[stepId]
        if(stepData)then 
            for k,v in pairs(stepData) do
                table.insert(ret,v)
                idx = idx+1
                if(idx>=count and count~=-1)then 
                    break
                end
            end
        end 

        if(ret and GetTableLength(ret)>=count)then 
            return ret 
        end
        stepId = (stepId+1) %_count  --endy 找 
        maxCount = maxCount-1
    end 
    return ret
end



function VolcanoMissionModel:GetDieNpc(allNpcs) 
    local _step,count,diecount = this:GetStempMemberInfo(_newMapData)
    local stepData =  _stepMembers[-1]
    local count = 2

    if(_levelUpData==nil)then 
        count = 0
    else
        local levelDataCount = math.min(GetTableLength(_levelUpData),3) --策划要求最大数据只支撑跳3个台阶，每个死2个
        count = levelDataCount*2
    end


    if(stepData)then  
        for k,v in pairs(stepData) do
            table.insert(allNpcs,v) 
            count = count-1 
            if(count <=0)then 
                break 
            end 
        end
    end
    return allNpcs
end


function VolcanoMissionModel:UpdateStepMember()
    -- _stepMembers = {}
    -- local dieCount = 0
    -- local count = 0
    -- for k,v in pairs(_mapData.members) do
    --     if(_stepMembers[v.step]==nil)then 
    --         _stepMembers[v.step] = {}
    --     end
    --     local stepData =  _stepMembers[v.step] 
    --     table.insert(stepData,v)
    --     _stepMembers[v.step] = stepData
    --     if(v.step == -1)then 
    --         dieCount = dieCount+1
    --     end 
    --     count = count+1
    -- end
    -- _count = count
    -- _dieCount = dieCount


    _stepMembers,_count,_dieCount = this:GetStempMemberInfo(_mapData)
end


function VolcanoMissionModel:GetStempMemberInfo(mapData)
    local _stepMembers = {}
    local dieCount = 0
    local count = 0
    for k,v in pairs(mapData.members) do
        if(_stepMembers[v.step]==nil)then 
            _stepMembers[v.step] = {}
        end
        local stepData =  _stepMembers[v.step] 
        table.insert(stepData,v)
        _stepMembers[v.step] = stepData
        if(v.step == -1)then 
            dieCount = dieCount+1
        end 
        count = count+1
    end
    -- _count = count
    -- _dieCount = dieCount

    return _stepMembers,count,dieCount
end

function VolcanoMissionModel:GetGroupId()
    return _mapData and _mapData.groupId or 1
end

function VolcanoMissionModel:GetMapId()
    return _mapData and _mapData.mapId or 1
end

--当前地图的所有npc数据
function VolcanoMissionModel:GetMapMembers()
    return _mapData and _mapData.members
end

function VolcanoMissionModel:GetCurStepId() 
    --return self:GetLevelUpdateCurrStep()
    return  math.min(_mapData.step,_mapData.stepCount),_mapData.stepCount --最后一个节点达到会超过stepCount
end

function VolcanoMissionModel:IsDifferentStep()
    return self:GetCurStepId() > self:GetLastStepId()
end

function VolcanoMissionModel:GetCurstepCount()
    --return self:GetLevelUpdateCurrStep()
    return  math.min(_mapData.step,_mapData.stepCount),_mapData.stepCount --最后一个节点达到会超过stepCount
end

function VolcanoMissionModel:GetMapCount()
    return _mapData.mapCount
end


function VolcanoMissionModel:GetLastStepId()
    return _mapData.lastStep
end

function VolcanoMissionModel:GetRoundInfo()
    return _mapData.round,_mapData.totalRound
end

function VolcanoMissionModel:GetResourceProgress()
    return _mapData.resource,_mapData.totalResource
end

function VolcanoMissionModel:GetMapReward()
    return _mapData.stepRewards
end

--是否刚到达最后一张地图
function VolcanoMissionModel:IsReachLastMap()
    if not _mapData then
        return
    end
    local curMapID, lastMapID, totalMapCount = _mapData.mapId, _mapData.lastMapId, _mapData.mapCount
    local check = curMapID == totalMapCount and lastMapID ~= curMapID
    return check
end

--是否在重复玩最后一张地图
function VolcanoMissionModel:IsLoopLastMap()
    if not _mapData then
        return
    end
    local curMapID, lastMapID, totalMapCount = _mapData.mapId, _mapData.lastMapId, _mapData.mapCount
    local check = curMapID == totalMapCount and lastMapID == curMapID
    return check
end

--[[
    @desc:获取当前步骤剩余人数
    author:nuts
    time: 2024-04-15 11:57
    @return:
]]
function VolcanoMissionModel:GetAlivePersonCount(stepid)
    if _newMapData.members then
        local dieCount = 0
        local newDieCount = 0
        for i = 1, #_newMapData.members do
            if _newMapData.members[i].step == -1 then
                if _newMapData.members[i].deadStep< stepid then
                    dieCount = dieCount + 1
                end
                if _newMapData.members[i].deadStep == stepid-1 then
                    newDieCount = newDieCount + 1
                end
            end
        end
        return #_newMapData.members - dieCount +(self:IsFaild() and 0 or 1)  ,#_newMapData.members+1,newDieCount
    end
    return 0,0,0,0
end

--[[
    @desc:计算当前步骤死亡人数
    author:nuts
    time: 2024-04-15 12:10
    @return:
]]
function VolcanoMissionModel:GetDiePersonCount(stepid)
    if _mapData.members then
        local dieCount = 0
        for i = 1, #_mapData.members do
            if _mapData.members[i].step == -1 and _mapData.members[i].deadStep == stepid then
                dieCount = dieCount + 1
            end
        end
        return dieCount
    end
end


function VolcanoMissionModel:IsFaild()
    if _newMapData and (_newMapData.round == _mapData.totalRound)then
        return true 
    end 
 
    return false 
end

function VolcanoMissionModel:GetStepCount()
    return _mapData.stepCount or 13
end


function VolcanoMissionModel:_DataIsChange(data)
    local ret = false  
    if(_mapData==nil)then 
        return true 
    end 
    for k ,v in pairs (data) do 
        if type(v)=="table" then 
            local itemData = v 
            local sData = _mapData[k] 
            if(GetTableLength(itemData)~=GetTableLength(sData))then 
                return true 
            end

            for _childDataKey,childValue in pairs(itemData)  do 
                if type(childValue)~="table" and sData[_childDataKey]~=childValue then 
                    return true  
                end 
            end  
        else
            if(_mapData[k]~=v)then 
                return true  
            end
        end
    end 
    return ret 
end


function VolcanoMissionModel:IsDataChange()
    return this:_DataIsChange(_newMapData)
end

--[[
    @desc:检查是否需要跳格子
    author:nuts
    time: 2024-04-12 10:42
    @return:
]]
function VolcanoMissionModel:IsJumpLevelUp()
    if _levelUpData then
        for _,v in pairs(_levelUpData) do
            if v == 0 then
                return true
            end
        end
    end
    return false
end


function VolcanoMissionModel:IsLevelUp()

    if not _levelUpData or GetTableLength(_levelUpData) == 0 then
        return false
    end

    if(self:IsFinalStep() and _mapData.step==_newMapData.stepCount)then 
        --已经是最后一步，不用升级
        return false 
    end

    if self:IsJumpLevelUp() then
        return true
    end

    if(_mapData.step ~= _newMapData.step and _newMapData.step>_mapData.step  and _mapData.step<= _mapData.stepCount)then 
        return true 
    end 

    if(_newMapData.mapId ~= _mapData.mapId and _newMapData.mapId>_mapData.mapId)then 
        return true   
    end 
    return false 
end


function VolcanoMissionModel:GetLevelUpTarget()

    --if(_newMapData.step>_mapData.step and _newMapData.mapId == _mapData.mapId)then
    --    return   math.min( _newMapData.step ,_mapData.stepCount)
    --end
    --
    --return _newMapData.step

    if _levelUpData then
        local key = 10000
        for k,v in pairs(_levelUpData) do
            if v == 0 then
                key = math.min(key, k)
            end
        end
        if key~= 10000 then
            return key
        end
    end
    log.e("VolcanoMissionModel:GetLevelUpTarget() 未找到升级节点,采用跳跃方式")
    if(_newMapData.step>_mapData.step and _newMapData.mapId == _mapData.mapId)then
        log.e(math.min( _newMapData.step ,_mapData.stepCount))
        return   math.min( _newMapData.step ,_mapData.stepCount)
    end
    log.e(_newMapData.step)
    return _newMapData.step

end

function VolcanoMissionModel:GetLevelUpTarget2()

    if(_newMapData.step>_mapData.step and _newMapData.mapId == _mapData.mapId)then
        --- 最后一步,取最大
        if(_newMapData.step>_newMapData.stepCount)then
            return _newMapData.step
        end
        return   math.min( _newMapData.step ,_mapData.stepCount)
    end

    return _newMapData.step
end


function VolcanoMissionModel:IsRoundDataChange()
    if(_newMapData) then
        if(_newMapData.step ~= _mapData.step)then
            return true ,_mapData.round,math.min(_mapData.round+1,_mapData.totalRound)
        end
        --- round 回合数
        if(_newMapData.round ~= _mapData.round)then
            return true  ,_mapData.round,_newMapData.round
        end
    end
    return false 
end


function VolcanoMissionModel:IsCollectChange()
    if(self:IsLevelUp() and not self:IsFinalStep())then --正常升级，但是没有跳到最后
        return true  ,_mapData.resource,_newMapData.resource,_mapData.totalResource
    end

    if(self:IsFinalStep())then --正常升级，但是没有跳到最后
        return true  ,_mapData.resource,_mapData.totalResource,_mapData.totalResource
    end
    if(_newMapData.resource ~= _mapData.resource)then 
        return true   ,_mapData.resource,_newMapData.resource,_mapData.totalResource
    end

    return false 
end


function VolcanoMissionModel:IsRevive()
    return true 
end
local _isInit = nil

--只有流程结束才需调用 这个接口，将数据覆盖
function VolcanoMissionModel:UpdateData() 
     _mapData = _newMapData
     this.UpdateStepMember() 
    --  UserData.set(VolcanoMission_LOCAL_SAVE_KEY,_mapData)
end


function VolcanoMissionModel:IsInit()
   return _isInit
end

--[[
    @desc: 是否有宝箱buffer
    author:{author}
    time:2024-03-28 18:59:30
    @return:
]]
function VolcanoMissionModel:HasBoxBuffer()
    
    return this:GetMoreRewardBuffTime()>0 
end
 
function VolcanoMissionModel:GetStepNeedResourcesById(id)
    local data = _mapData.stepNeeds[id]

    if(data)then 
        return data
    end
    
    return nil
end
--[[
    @desc: 是否有宝箱Tips buffer
    author:{author}
    time:2024-03-28 18:59:30
    @return:
]]
function VolcanoMissionModel:IsShowBoxTips()
    local isShowFirstShowTipsTag = "isShowFirstShowTipsTag"
    local mark = UserData.get(isShowFirstShowTipsTag)
    if not mark then
        UserData.set(isShowFirstShowTipsTag, "false")
        return true
    end
    local boxData = ModelList.VolcanoMissionModel.GetAllStepBoxData()
    local boxCount = GetTableLength(boxData)
    if (boxCount > 1) then
        --宝箱大于1
        log.r(" todo IsShowBoxTips    true   " .. boxCount)
        return true
    end

    return false
end

--[[
    @desc:清理首次进入的标签
    author:nuts
    time: 2024-04-16 15:57
    @return:
]]
function VolcanoMissionModel:CleanShowBoxTips()
    local isShowFirstShowTipsTag = "isShowFirstShowTipsTag"
    UserData.set(isShowFirstShowTipsTag,nil)
end


function VolcanoMissionModel:IsFinalStep()
    if(_newMapData.step>_newMapData.stepCount)then 
        return true 
    end
  
    return false 
end
 


function VolcanoMissionModel:GetAllStepBoxData()
    local allboxData = {} 
    local ret = {}
    local curStep = this.GetCurStepId()


    for k,v in pairs(_newMapData.stepRewards) do
        if(v.step<=curStep)then  
            local isOpened = false 
            for k1,v1 in pairs(_newMapData.lastRewardSteps) do
                if(v.step==v1)then 
                    isOpened = true 
                    break
                end
            end

            if(isOpened==false)then 
                table.insert(ret,v) 
            end
         
        end
    end

 

    return ret 
end

---双倍道具buff剩余时间
function VolcanoMissionModel:GetDoubleItemBuffTime()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_VOLCANO_DOUBLE_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    return remainTime
end

---金钥匙buff剩余时间
function VolcanoMissionModel:GetMoreRewardBuffTime()
    local expireTime = ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_VOLCANO_REWARD_BUFF)
    local remainTime = math.max(0, expireTime - os.time())
    return remainTime
end

function VolcanoMissionModel:IsOpenActivity()
    local isOpen = this:IsActivityAvailable(activityId)
    return isOpen and this.IsMissionOpen()
end

function VolcanoMissionModel.IsMissionOpen()
    local openLevel = Csv.GetData("level_open",31,"openlevel")
    local pay_openlevel = Csv.GetData("level_open",31,"pay_openlevel")

    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local myLabel = ModelList.PlayerInfoModel:GetUserType()
    if myLabel and myLabel > 0 then
        if nowLevel and pay_openlevel then
            return nowLevel >= pay_openlevel
        else
            return false
        end
    else
        if nowLevel and openLevel then
            return nowLevel >= openLevel
        else
            return false
        end
    end
end

--玩家是否开始了活动
function VolcanoMissionModel:IsStartActivity()
    local isOpen = this.IsOpenActivity()
    return isOpen and _isInit
end

-- function VolcanoMissionModel:OnActivityDataChange()
--     if(this:IsOpenActivity())then 
--         this:Login_C2S_UpdateMissionData()
--     end
-- end

function VolcanoMissionModel:RecordBattleCollectItemType(collectItemType)
    self.collectItemType = collectItemType
end

function VolcanoMissionModel:GetBattleCollectItemType()
    return self.collectItemType or 1
end

function VolcanoMissionModel:CleanBattleCollectItemType()
    self.collectItemType = nil
end

----------------------------重载接口-----------------------------------
function VolcanoMissionModel:InitData()
    _mapData = nil  
    -- Event.RemoveListener(EventName.Event_Activity_Data_Change,self.OnActivityDataChange,self)
    -- Event.AddListener(EventName.Event_Activity_Data_Change,self.OnActivityDataChange,self)  
end



----------------------------消息请求-----------------------------------

function VolcanoMissionModel:Login_C2S_UpdateMissionData() 
    if(this:IsOpenActivity())then 
        this.SendMessage(MSG_ID.MSG_VOLCANO_FETCH, {})  --debug
    end
end


function VolcanoMissionModel:C2S_PlayeMatch(cb) 
    this.playMatchCb = cb
    this.SendMessage(MSG_ID.MSG_VOLCANO_MATCH, {})  --debug
end




--[[
    @desc: 开宝箱--废弃
    author:{author}
    time:2024-03-29 09:55:38
    @return:
]]
function VolcanoMissionModel:C2S_ReqRewardBox() 
 
    this.SendMessage(MSG_ID.MSG_VOLCANO_REWARD_BOX, {step=1})  --setp=1不用传兼容协议，后端默认全开
end

function VolcanoMissionModel:C2S_ReqVolcanoRevival() 
    this.SendMessage(MSG_ID.MSG_VOLCANO_RELIVE, {})
end

----------------------------消息返回-----------------------------------

local isChange = true  


function VolcanoMissionModel.InitMapData(data)
     if(_mapData==nil)then  
          --取本地数据 
          _mapData = UserData.get(VolcanoMission_LOCAL_SAVE_KEY,{})

          if(GetTableLength(_mapData)<=0)then 
               _mapData = nil 
          end
     end

     if(_mapData==nil)then  
          _mapData = data  
      end 
      this:UpdateStepMember()
end


function VolcanoMissionModel:SetCurBoxPos(isLocal)


        local data = nil 
        
        if(_newMapData)then 
            data =  _newMapData.rewardSteps
        else
            data =  _mapData.rewardSteps
        end
         
        local maxStep = 0
        for k,v in pairs(data) do
            if(v>maxStep)then 
                maxStep = v
            end
        end 
        rewardedRecStep = maxStep
        -- if(isLocal)then 
        --     rewardedRecStep = rewardedRecStep+1   --如果当前买了宝箱再打开，这个时间没有向服务器刷新数据
        -- end
end


function VolcanoMissionModel.S2C_UpdateMissionData(code,data)
    --if(true)then
    --    local data = require("View/VolcanoMission/VolcanoMissionDebug")
    --    local oldData,newData = data.GetDebugData()
    --    _mapData = oldData
    --    this:SetCurBoxPos()
    --    this:UpdateStepMember()
    --    _newMapData = newData
    --    _isInit = true
    --    return
    --end

    if (code == RET.RET_SUCCESS) then
        if (data == nil) then
            log.e("mission data is nil ")
            return
        end
        -- this.InitMapData(data)
        if (_mapData == nil) then
            _mapData = data
            this:SetCurBoxPos()
            this:UpdateStepMember()
            --this:UpdateStep()
        elseif (_mapData.step ~= data.step) or (_mapData.mapId ~= data.mapId)  then
            this:ResetShowMainStatu(1)
        end

        _newMapData = data
        _isInit = true
        Facade.SendNotification(NotifyName.VolcanoMission.UpdateData)
    elseif code == RET.RET_VOLCANO_NO_GAME_INFO then
        _isInit = false
    end 
end

function VolcanoMissionModel.S2C_VolcanoMatch(code,data)
    if (code == RET.RET_SUCCESS) then
        this.CleanUserData()
        this.S2C_UpdateMissionData(code, data)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionMatchView)

        if this.playMatchCb then
            this.playMatchCb()
            this.playMatchCb = nil
        end
    else
        this.CleanUserData()
        _isInit = false
        this.playMatchCb = nil
    end
end

function VolcanoMissionModel.CleanUserData()
    -- UserData.set(VolcanoMission_LOCAL_SAVE_KEY,{})
    log.r("CleanUserData")
    _newMapData = {}
    _mapData = {}
    
   _newMapData = nil 
   _mapData = nil  
   rewardedRecStep = nil
    _isInit =false
    this:ResetShowMainStatu(0)
end


function VolcanoMissionModel.S2C_RecRewardBox(code,data)
    if(code == RET.RET_SUCCESS)then
        -- Facade.SendNotification(NotifyName.ShowUI, ViewList.VolcanoMissionMatchView)
        -- this.S2C_UpdateMissionData(code,data)
        Facade.SendNotification(NotifyName.VolcanoMission.OpenBox,data)
    else
        Facade.SendNotification(NotifyName.VolcanoMission.OpenBox,nil)
    end
end


function DebugVolcanoMissionModel(funcName)
    if(this[funcName])then 
        this[funcName]()
    end
end



function VolcanoMissionModel.S2C_VolcanoRevival(code, data)
	log.log("VolcanoMissionModel.S2C_VolcanoRevival(code, data)", code, data)
    if code == RET.RET_SUCCESS then
        local reliveTimes = data.reliveTimes
		--undo 联调可能需要处理这里
		-- if this.settleData then
        --     this.settleData.isDisuse = false
        --     this.settleData.canRelive = false
        -- end
        -- if this.playerList then
        --     for i, v in ipairs(this.playerList) do
        --         if this:IsSelf(v.uid) then
        --             v.status = Const.PlayerStates.relive
        --         end
        --     end
        -- end
        Facade.SendNotification(NotifyName.VolcanoMission.ReliveSucc)
    else
		local bundle = {errorCode = code}
        Facade.SendNotification(NotifyName.VolcanoMission.ReliveFail, bundle)
    end
end

--获得玩家复活币数量
function VolcanoMissionModel:GetReliveCoinCount()
	local reliveCoinId = 38
    local count = ModelList.ItemModel.getResourceNumByType(reliveCoinId) or 0
    return count
end

--获得第几次复活的相关配置
function VolcanoMissionModel:_GetReliveCfg(reliveTimes)
    if not Csv.volcano_revival then
        log.log("VolcanoMissionModel:GetReliveCfg(reliveTime, totalRound) volcano_revival 配置表Error", reliveTimes)
        return
    end

    for i, v in ipairs(Csv.volcano_revival) do
        if v.revival_times == reliveTimes then
            return v
        end
    end

	log.log("VolcanoMissionModel:GetReliveCfg(reliveTime, totalRound) 未找到对应配置", reliveTimes)
end




function VolcanoMissionModel:CanRelive()
   local mapId = this.GetMapId()
   local step = math.min(_newMapData.lastStep+1,_newMapData.stepCount)
 
   
   for i, v in pairs(Csv.volcano_round)do  
        if(v and v.map == mapId and v.steps==step)then 
            return v.player_revival>0
        end
   end

   return false 
end


--请求购买复活币
function VolcanoMissionModel:GetReliveCfg()
    local reliveTimes =  this:GetReliveTimes()+1
    local cfg = this:_GetReliveCfg(reliveTimes)
    return cfg 
end


--[[
    @desc: 初始化生成数据
    author:{author}
    time:2024-04-11 11:06:58
    @return:
]]

function VolcanoMissionModel:InitLevelUpdate()
    if(_levelUpData==nil) or GetTableLength(_levelUpData) == 0 then
        _levelUpData = {}
        local newStep = this:GetLevelUpTarget2()
        for i = _mapData.step+1, newStep do
            _levelUpData[i] = 0
        end
    end 
end

function VolcanoMissionModel:RefreshLevelUpdate(stepId)
    if(_levelUpData)then
        if stepId  then
            if not _levelUpData[stepId] then
                log.e("RefreshLevelUpdate 未找到对应数据  "..stepId)
            else
                _levelUpData[stepId] = 1
                local isAllFinish = true
                for k,v in pairs(_levelUpData) do
                    if v == 0 then
                        isAllFinish = false
                        break
                    end
                end
                if isAllFinish then
                    _levelUpData = { }
                    _levelUpData = nil
                end
            end
        else
            local key = 10000
            for _,v in ipairs(_levelUpData) do
                if v == 0 then
                    key = math.min(key, _)
                end
            end
            if _levelUpData[key] then
                _levelUpData[key] = 1
                log.e("RefreshLevelUpdate  "..key)
            end

        end
    end
end

function VolcanoMissionModel:IsLastRoundStep()
    if not _levelUpData then
        return true
    end
    local zeroCount = 0
    for k,v in pairs(_levelUpData) do
        if v == 0 then
            zeroCount = zeroCount + 1
        end
    end
    return zeroCount == 1
end


function VolcanoMissionModel:GetLevelUpdateCurrStep()
    --if(_levelUpData)then
    --    for k,v in pairs(_levelUpData) do
    --        if v == 0 then
    --            return k-1
    --        end
    --    end
    --end


    return math.min(_mapData.step,_mapData.stepCount),_mapData.stepCount --最后一个节点达到会超过stepCount
end


-- function VolcanoMissionModel:GetLevelUpTarget()

--     if(_newMapData.step>_mapData.step and _newMapData.mapId == _mapData.mapId)then 
--         return   math.min( _newMapData.step ,_mapData.stepCount)      
--     end 
 
--     return _newMapData.step  
-- end



--请求购买复活币
function VolcanoMissionModel:PurchaseReliveCoin(itemId)
    ModelList.MainShopModel.C2S_RequestActivityPay(itemId, "volcano")
end

--清除跳台阶数据
function VolcanoMissionModel:ResetLevelData()
    _levelUpData = nil
end

this.MsgIdList = { 
    --- pass的事件监听，等待后端提供
    -- MSG_VOLCANO_FETCH
    {msgid = MSG_ID.MSG_VOLCANO_REWARD_BOX, func = this.S2C_RecRewardBox},
    {msgid = MSG_ID.MSG_VOLCANO_FETCH, func = this.S2C_UpdateMissionData},
    {msgid = MSG_ID.MSG_VOLCANO_MATCH, func = this.S2C_VolcanoMatch},
	{msgid = MSG_ID.MSG_VOLCANO_RELIVE, func = this.S2C_VolcanoRevival},

	
}

return this 
