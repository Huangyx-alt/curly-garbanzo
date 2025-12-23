local NewPuzzleModel = BaseModel:New("NewPuzzleModel")
local this = NewPuzzleModel
local GuideCompleteKey = "IsGuidedPuzzleComplete"

function NewPuzzleModel:SetLoginData(data)
    --log.r("NewPuzzleModel data：" , data)
end

function NewPuzzleModel:InitData()
    this.allData = {}
end

--取最新解锁的城市ID
function NewPuzzleModel:GetNewUnlockScene()
    local ret = 0
    --取没领奖的一个
    table.walk(this.allData, function(v, sceneId)
        if v.isUnlock and v.isCompleted and not v.isRewarded then
            if not this:IsGuidedPuzzleComplete(sceneId) then
                ret = sceneId
            end
        end
    end)

    if ret == 0 then
        table.walk(this.allData, function(v, sceneId)
            if v.isUnlock and not v.isCompleted then
                ret = sceneId
            end
        end)
    end
    
    return ret > 0 and ret or 1
end

function NewPuzzleModel:IsScenePuzzleUnlock(sceneId)
    if not sceneId then
        return
    end

    local data = this:GetScenePuzzlesData(sceneId)
    return data and data.isUnlock
end

function NewPuzzleModel:GetPuzzleCollectData(sceneId)
    if not sceneId then
        return
    end
    
    local data = this:GetScenePuzzlesData(sceneId)
    if data then
        return data.collectNum, data.puzzleNum
    else
        return
    end
end

--城市拼图奖励是否已经领取
function NewPuzzleModel:IsGuidedPuzzleComplete(sceneId)
    if not sceneId then
        return
    end
    
    local key = string.format("%s-%s-%s", GuideCompleteKey, ModelList.PlayerInfoModel:GetUid(), sceneId)
    local v = fun.get_int(key, 0)
    if v == 0 then
        fun.save_int(key, 1)
        return true
    end
    return false
end

function NewPuzzleModel:IsScenePuzzleComplete(sceneId)
    if not sceneId then
        return
    end

    local data = this:GetScenePuzzlesData(sceneId)
    return data and data.isUnlock and data.isCompleted
end

function NewPuzzleModel:IsScenePuzzleRewarded(sceneId)
    if not sceneId then
        return
    end

    local data = this:GetScenePuzzlesData(sceneId)
    return data and data.isUnlock and data.isCompleted and data.isRewarded
end

--城市拼图奖励是否可以领取
function NewPuzzleModel:IsScenePuzzleCanReward(sceneId)
    if not sceneId then
        return
    end
    
    local data = this:GetScenePuzzlesData(sceneId)
    return data and data.isUnlock and data.isCompleted and not data.isRewarded 
end

function NewPuzzleModel:GetScenePuzzlesData(sceneId)
    sceneId = sceneId or ModelList.CityModel:GetCity()
    local data = this.allData[sceneId]
    return data
end

function NewPuzzleModel:Login_C2S_Fetch()
    return this:SendDataToBase64(MsgIDDefine.PB_BingoGameFetchScenes, { sceneId = 0 })
end

function NewPuzzleModel:C2S_FetchScenesPuzzleInfo(sceneId)
    log.r("[NewPuzzleModel] C2S_FetchScenesPuzzleInfo sceneId:", sceneId)
    --sceneId == 0 ，返回所有场景的拼图数据
    sceneId = sceneId or 0
    this.SendMessage(MsgIDDefine.PB_BingoGameFetchScenes, { sceneId = sceneId, })
end

--new_city_play_scene
function NewPuzzleModel.Res_FetchScenesPuzzleInfo(code, data)
    log.r("[NewPuzzleModel] Res_FetchScenesPuzzleInfo:", data)
    if code == RET.RET_SUCCESS then
        table.walk(data and data.bingoScenes, function(v)
            this.allData[v.sceneId] = v
        end)
    end
end

--拼图领奖
function NewPuzzleModel:C2S_BingoGamePuzzleReward(sceneId)
    log.r("[NewPuzzleModel] C2S_BingoGamePuzzleReward sceneId:", sceneId)
    if not sceneId then
        return
    end
    this.reqRewardSceneId = sceneId
    this.SendMessage(MsgIDDefine.PB_BingoGamePuzzleReward, { sceneId = sceneId, })
end
function NewPuzzleModel.Res_BingoGamePuzzleReward(code, data)
    log.r("[NewPuzzleModel] Res_BingoGamePuzzleReward:", data)
    if code == RET.RET_SUCCESS then
        Facade.SendNotification(NotifyName.PuzzleView.ReceivePuzzleReward, data)
        
        local puzzleData = this:GetScenePuzzlesData(this.reqRewardSceneId)
        if puzzleData then
            puzzleData.isRewarded = true
        end
        this.SendMessage(MsgIDDefine.PB_BingoGameFetchScenes, { sceneId = 0, })
    else
        this.reqRewardSceneId = nil
    end
end

this.MsgIdList = {
    { msgid = MsgIDDefine.PB_BingoGameFetchScenes, func = this.Res_FetchScenesPuzzleInfo },
    { msgid = MsgIDDefine.PB_BingoGamePuzzleReward, func = this.Res_BingoGamePuzzleReward },
}

return this