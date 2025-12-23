
local MiniGameModel = BaseModel:New("MiniGameModel")
local this = MiniGameModel

local _miniGameTicketsInfoList = nil
local _boxLayerInfoList = nil

local _current_activate_miniGame = nil

local receive_cunt = 0

ExpelThief = {free = -1,ad = 0,diamond = 1}
local ProtoLoader = require "Net.ProtoLoader" --用做静态类了,

local reqMiniGameStartCallBack = nil

local miniGameData = {}
local miniGameConfig = {}
function MiniGameModel:InitData()
    this:InitConfig()
    reqMiniGameStartCallBack = nil
    miniGameData = {}
end

function MiniGameModel:InitConfig()
    for k ,v in pairs(Csv.new_minigame) do
        miniGameData[v.id] = v
    end
end

function MiniGameModel:SetLoginData(data)
    _miniGameTicketsInfoList = {}
    if data and data.normalActivity
        and data.normalActivity.miniGameState then
        this.OnMiniGameUpdate(RET.RET_SUCCESS,{state = data.normalActivity.miniGameState})
    end
end

function MiniGameModel:GetTicketsInfoById(id,params)
    if not _miniGameTicketsInfoList or GetTableLength(_miniGameTicketsInfoList) == 0 then
        this:ReqMiniGameData()
        Event.Brocast(NotifyName.MiniGame01.DataErrorForceClose)
        --数据错误 异常处理
        return
    end
    if params then
        return _miniGameTicketsInfoList[id or this:GetActivateMiniGameId()][params]
    else
        return _miniGameTicketsInfoList[id or this:GetActivateMiniGameId()]    
    end
end

function MiniGameModel:GetBoxLayerInfoById(id,params)
    if params then
        return _boxLayerInfoList[id or this:GetActivateMiniGameId()][params]
    else
        return _boxLayerInfoList[id or this:GetActivateMiniGameId()]    
    end
end

function MiniGameModel.OnMiniGameUpdate(code,data)
    if code == RET.RET_SUCCESS and data then
        if not _miniGameTicketsInfoList then
            _miniGameTicketsInfoList = {}
        end
        for key, value in pairs(data.state) do
            _miniGameTicketsInfoList[value.id] = deep_copy(value)
        end
        Event.Brocast(NotifyName.MiniGame01.MiniGameUpdateInfo)
    end
end

function MiniGameModel:CheckMiniGameAvailable(id)
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(13,0)
    _current_activate_miniGame = nil
    if _miniGameTicketsInfoList and nowLevel >= needLevel then
        if id then
            local info = _miniGameTicketsInfoList[id]
            if info and info.complete and info.fullUnix then
                _current_activate_miniGame = info
            end
        else
            for key, value in pairs(_miniGameTicketsInfoList) do
                if value.complete and value.fullUnix then
                    _current_activate_miniGame = value
                end
            end
        end
    end
    return _current_activate_miniGame
end

function MiniGameModel:GetMiniGameInfo(id)
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(13,0)
    if _miniGameTicketsInfoList and nowLevel >= needLevel then
        return _miniGameTicketsInfoList[id]
    end
    return nil
end

function MiniGameModel:GetActivateMiniGameId()
    if _current_activate_miniGame then
        return _current_activate_miniGame.id
    end
    return nil
end

function MiniGameModel:GetActivateMiniGameProgress()
    if _current_activate_miniGame then
        return _current_activate_miniGame.progress
    end
    return 0
end

function MiniGameModel:GetActivateMiniGameTarget()
    if _current_activate_miniGame then
        return _current_activate_miniGame.target
    end
    return 1
end

function MiniGameModel:GetLayerInfoList()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            return layerInfo.layerList
        end
    end
    return nil
end

function MiniGameModel:GetAllAcquiredReward()
    local collect_rewards = {}
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            local func = function(rewardList)
                for key, value in pairs(rewardList) do
                    if collect_rewards[value.id] then
                        collect_rewards[value.id].value = collect_rewards[value.id].value + value.value
                    else
                        collect_rewards[value.id] = value
                    end
                end
            end
            func(layerInfo.collectReward)
            -- func(layerInfo.extraReward) --extraReward 不做展示
        end
    end
    return collect_rewards
end

function MiniGameModel:GetCollectRewardById(id,isValue)
    local collect_rewards = this:GetAllAcquiredReward()
    if collect_rewards then
        local rewards = collect_rewards[id or 1]
        local reward_item = ((rewards and isValue) and {rewards["value"]} or {rewards})[1]
        return reward_item
    end
    return 1,0
end

function MiniGameModel:GetLayerInfo(layer)
    layer = layer or this:GetCurrentLayerNum()
    local layerList = this:GetLayerInfoList()
    if layerList then
        if layerList[layer] and layerList[layer].layNo == layer then
            return layerList[layer]
        end
        for index, value in ipairs(layerList) do
            if value.layNo == layer then
                return value
            end
        end
    end
    return nil
end

function MiniGameModel:GetCurrentLayerNum()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            return layerInfo.layerNo
        end
    end
    return 1
end

function MiniGameModel:GetExtraLayer(extraLayerData)
    if not extraLayerData then
        extraLayerData = {}
    end
    local curLayerNum = this:GetCurrentLayerNum()
    if extraLayerData[1] ~= curLayerNum then
        local layerIndex = nil
        local layerList = this:GetLayerInfoList()
        for index, value in ipairs(layerList) do
            if 0 == value.background and value.layNo > curLayerNum then
                layerIndex = math.min(layerIndex or value.layNo,value.layNo)
            end
        end
        extraLayerData[1] = curLayerNum
        extraLayerData[2] = layerIndex or 1
    end
    return extraLayerData
end

function MiniGameModel:GetOpenBoxReward()
    local reward = {}
    local hitReward = nil
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            for index, value in ipairs(layerInfo.groupReward) do
                if index == layerInfo.hitGroupRewardIndex + 1 then
                    hitReward = value
                else
                    table.insert(reward,value)
                end
            end
        end
    end
    return reward,hitReward
end

function MiniGameModel:CheckExpelThiefMethod(expel_type)
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            for index, value in ipairs(layerInfo.banishThiefMethod) do
                if value.id == expel_type then
                    return true,value.value
                end
            end
        end
    end
    return false,nil
end

function MiniGameModel:IsMeetThief()
    local id = this:GetActivateMiniGameId()
    local layerInfo = _boxLayerInfoList[id]
    if layerInfo then
        return  not layerInfo.rewarded and layerInfo.isStole
    end
    return false
end

function MiniGameModel:IsBoxOpen()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            --log.r("=========================>>3410 " .. tostring(layerInfo.rewarded) .. "   " .. tostring(layerInfo.isStole) .. "      " .. layerInfo.status)
            return layerInfo.status == 1
        end
    end
    return false
end

function MiniGameModel:IsTopLayerOpen()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            return layerInfo.isEnd and layerInfo.status == 1
        end
    end
end

function MiniGameModel:IsClaimLayerReward()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            return layerInfo.rewarded
        end
    end
end

function MiniGameModel:IsClaimJackpoReward()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            return layerInfo.bigRewarded
        end
    end
end

function MiniGameModel:RequestMiniGameLayerInfo()
    local id = this:GetActivateMiniGameId()
    this.SendMessage(MSG_ID.MSG_MINI_GAME_BOX_LAYER_DATA,{miniGameId = id or 0})
end

function MiniGameModel.OnMiniGameInfo(code,data)
    --log.r("========================================>>MiniGameModel.OnMiniGameInfo " .. code)
    if code == RET.RET_SUCCESS and data then
        for k , v in pairs(data.state) do
            if k == 1 then
                if v.layerGreatRewardIndex then
                    for z ,w in pairs(v.groupReward) do
                        if z == v.layerGreatRewardIndex + 1 then
                            w.IslayerGreatRewardIndex = true
                        else
                            w.IslayerGreatRewardIndex = false
                        end
                    end
                end
            end
        end
        if not _boxLayerInfoList then
            _boxLayerInfoList = {}
        end
        for key, value in pairs(data.state) do
            _boxLayerInfoList[value.miniGameId] = deep_copy(value)
        end
        Facade.SendNotification(NotifyName.MiniGame01.ResphoneLayerInfo,false)
        receive_cunt = receive_cunt + 1
        if receive_cunt >= 2 then
            receive_cunt = 0
            Facade.SendNotification(NotifyName.MiniGame01.MiniGameSubmitResult,data)
        end
        Event.Brocast(EventName.Event_GetTaskRewardSucceed)
        Event.Brocast(NotifyName.MiniGame01.MiniGamePrepareEnable , true)
    else
        Facade.SendNotification(NotifyName.MiniGame01.ResphoneLayerInfo,true) 
        Event.Brocast(EventName.Event_GetTaskRewardFail)
        Event.Brocast(NotifyName.MiniGame01.MiniGamePrepareEnable , false)
    end
end

function MiniGameModel:RequestSubmitInfo(id,type,subType,fullUnix)
    receive_cunt = 0
    local doubleReward = ModelList.ItemModel.get_doublehatReward() > 0
    this.SendMessage(MSG_ID.MSG_MINI_GAME_BOX_LAYER_SUBMIT,{miniGameId = id,type = type,subType = subType,fullUnix = fullUnix,doubleReward = doubleReward})
end

function MiniGameModel.OnMiniGameSubmit(code,data)
    if code == RET.RET_SUCCESS then
        receive_cunt = receive_cunt + 1
        if receive_cunt >= 2 then
            receive_cunt = 0
            Facade.SendNotification(NotifyName.MiniGame01.MiniGameSubmitResult,data)
        else
            this:RequestMiniGameLayerInfo()
        end
    else
        Facade.SendNotification(NotifyName.MiniGame01.MiniGameSubmitResult,nil)
        if code == RET.RET_REWARD_REPEAT_RECEIVE then
            Event.Brocast(NotifyName.MiniGame01.MiniGameCollectError)
        end
    end
end

--获取帽子当前层数
function MiniGameModel:GetHatNowLayer()
    local layerNo = self:GetBoxLayerInfoById(1, "layerNo")
    return layerNo
end

--获取帽子当前层数
function MiniGameModel:ReqMiniGameData()
    this.SendMessage(MSG_ID.MSG_MINI_GAME_UPDATE,{miniGameId =0})
end

--流程修改 金币大奖和道具一起发放
--bigRewarded 控制分开发放流程
function MiniGameModel:IgnoreBigRewardCollect()
    if _boxLayerInfoList then
        local id = this:GetActivateMiniGameId()
        local layerInfo = _boxLayerInfoList[id]
        if layerInfo then
            layerInfo.bigRewarded = true
        end
    end
end

function MiniGameModel:RaqMiniGameFetch()

    this.SendMessage(MsgIDDefine.PB_MiniGameFetch,{})
end

function MiniGameModel.ReceiveMiniGameFetch(code, data)
    log.log("小游戏数据更新 " , code ,data)
    if code == RET.RET_SUCCESS and data  then
        local gameId = data.gameInfo.miniGameId
        miniGameData[gameId] = data
    end
end

function MiniGameModel:GetMiniGameDataByGameId(miniGameId)
    if miniGameData[miniGameId] then
        return miniGameData[miniGameId]
    end 
    return nil
end

function MiniGameModel:RaqUseMiniGameTick(gameId,callBack)
    reqMiniGameStartCallBack = callBack
    this.SendMessage(MsgIDDefine.PB_MiniGameUseTicket,{miniGameId = gameId})
end

function MiniGameModel:CheckMiniGameOpen(miniGameType)
    if not miniGameData or not miniGameData[miniGameType] then
        return false
    end
    local data = miniGameData[miniGameType]
    local timeNow = os.time()
    if data.closeTime > timeNow and data.openTime < timeNow then
        return true
    end
    return false
end

function MiniGameModel:GetMiniGameId(miniGameType)
    if miniGameData and miniGameData[miniGameType] and miniGameData[miniGameType].gameInfo then
        return miniGameData[miniGameType].gameInfo.miniGameId
    end
    return nil
end

function MiniGameModel:GetMiniGameTicketNum(miniGameType)
    log.log("小游戏数据更新 检查门票数据 ", miniGameData)
    if miniGameData and miniGameData[miniGameType] and miniGameData[miniGameType].gameInfo and miniGameData[miniGameType].gameInfo.ticket then 
        return miniGameData[miniGameType].gameInfo.ticket.value or 0
    end
    return 0
end

function MiniGameModel:GetMiniGameTicketTarget(miniGameType)
    if miniGameData and miniGameData[miniGameType] and miniGameData[miniGameType].gameInfo and miniGameData[miniGameType].gameInfo.target then
        return miniGameData[miniGameType].gameInfo.target or 0
    end
    return 0
end

function MiniGameModel:GetMiniGameTicketProgress(miniGameType)
    if miniGameData and miniGameData[miniGameType] and miniGameData[miniGameType].gameInfo and miniGameData[miniGameType].gameInfo.progress then
        return miniGameData[miniGameType].gameInfo.progress or 0
    end
    return 0
end

function MiniGameModel.OnReceiveUseTicked(code,data)
    log.log("小游戏花费门票  ", code , data)
    if code == RET.RET_SUCCESS and data and data.nextMessages then
        for k ,v in pairs(data.nextMessages) do
            local data = ProtoLoader.decode(v.msgId, Base64.decode(v.msgBase64))
            Message.DispatchMessage(v.msgId, v.code, data)
        end

        if reqMiniGameStartCallBack then
            reqMiniGameStartCallBack()
            reqMiniGameStartCallBack = nil
        end
    end
    
    --local decoded = base64.decode(self.data.msgBase64)
    --if code == RET.RET_SUCCESS then
    --    receive_cunt = receive_cunt + 1
    --    if receive_cunt >= 2 then
    --        receive_cunt = 0
    --        Facade.SendNotification(NotifyName.MiniGame01.MiniGameSubmitResult,data)
    --    else
    --        this:RequestMiniGameLayerInfo()
    --    end
    --else
    --    Facade.SendNotification(NotifyName.MiniGame01.MiniGameSubmitResult,nil)
    --    if code == RET.RET_REWARD_REPEAT_RECEIVE then
    --        Event.Brocast(NotifyName.MiniGame01.MiniGameCollectError)
    --    end
    --end
end


this.MsgIdList = {
    {msgid = MSG_ID.MSG_MINI_GAME_UPDATE,func = this.OnMiniGameUpdate},
    {msgid = MSG_ID.MSG_MINI_GAME_BOX_LAYER_DATA,func = this.OnMiniGameInfo},
    {msgid = MSG_ID.MSG_MINI_GAME_BOX_LAYER_SUBMIT,func = this.OnMiniGameSubmit},
    {msgid = MsgIDDefine.PB_MiniGameUseTicket,func = this.OnReceiveUseTicked},
    {msgid = MsgIDDefine.PB_MiniGameFetch,func = this.ReceiveMiniGameFetch}
    
}

return this