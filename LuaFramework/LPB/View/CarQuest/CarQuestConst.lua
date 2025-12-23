local M = {}

M.EnmuCarGrade = {
    low = 1,
    high = 2,
}

M.EnmuPlayerType = {
    myself = 1,
    enemy = 2,
}

M.CarCount = 5      --车数量
M.TrackCount = 5    --车道数量
M.MyTrackNum = 3    --玩家车道
M.TrackWidth = 188  --车道宽度

M.CarNormalSpeed = 0
M.CarLowSpeed = -1
M.CarHighSpeed = 1
M.CarStartingSpeed = 200
M.CarSprintSpeed = 1000

M.RoadUnitCount = 3             --总共有几段路组成
M.RoadUnitLength = 2649         --一段路长度
M.RoadLowSpeed = 10
M.RoadHighSpeed = 40

M.MoveTime = 5                  --车子移动时长（斑马线移动时长）
M.CarStartingTime = 2
M.CarSprintTime = 2

M.ZebraStripesWidth = 90        --斑马线宽度
M.PlayerCarPosInScreen = -200   --玩家车子与屏幕中心的距离

M.PropHeight = 160              --道具尺寸
M.MaxPropDensity = 6            --一屏最多显示多个道具（一条赛道上）

M.CalculateMoveParams = function(raceConfig, sceenHeight, startFuelVolume, endFuelVolume)
    local totalLength = 0
    local stageLength = 0
    local stagePointList = {}
    for i, v in ipairs(raceConfig) do
        stageLength = v[2] * sceenHeight / 4
        stagePointList[i] =  totalLength + stageLength
        totalLength = stagePointList[i]
    end

    local startIdx = 0
    local endIdx = 0
    for i, v in ipairs(raceConfig) do
        if v[3] > startFuelVolume and startIdx == 0 then
            startIdx = i
        end

        if v[3] > endFuelVolume and endIdx == 0 then
            endIdx = i
        end
    end

    if startIdx == 0 then
        log.log("CarQuestConst.CalculateMoveParams 已经完成比赛1", startFuelVolume, endFuelVolume)
        startIdx =  #raceConfig
    end

    if endIdx == 0 then
        log.log("CarQuestConst.CalculateMoveParams 已经完成比赛2", startFuelVolume, endFuelVolume)
        endIdx = #raceConfig
    end

    local target = 0
    local offset = 0
    if startIdx > 1 then
        target = raceConfig[startIdx][3] - raceConfig[startIdx - 1][3]
        offset = startFuelVolume - raceConfig[startIdx - 1][3]
    else
        target = raceConfig[startIdx][3]
        offset = startFuelVolume
    end

    local stageStartPos = offset / target * raceConfig[startIdx][2] * sceenHeight / 4
    local traveledDistance = 0
    if startIdx > 1 then
        traveledDistance = stagePointList[startIdx - 1] + stageStartPos
    else
        traveledDistance = stageStartPos
    end

    local length1 = 0
    if startIdx < endIdx then
        length1 = raceConfig[startIdx][2] * sceenHeight / 4 - stageStartPos
    else
        length1 = -stageStartPos
    end

    local length2 = 0
    for i = startIdx + 1, endIdx - 1 do
        length2 = length2 + raceConfig[i][2] * sceenHeight / 4
    end

    if endIdx > 1 then
        target = raceConfig[endIdx][3] - raceConfig[endIdx - 1][3]
        offset = endFuelVolume - raceConfig[endIdx - 1][3]
    else
        target = raceConfig[endIdx][3]
        offset = endFuelVolume
    end

    if offset > target then
        offset = target
    end

    local length3 = offset / target * raceConfig[endIdx][2] * sceenHeight / 4
    local targetMoveDistance = length1 + length2 + length3 

    local params = {}
    params.startIdx = startIdx
    params.endIdx = endIdx
    params.traveledDistance = traveledDistance
    params.targetMoveDistance = targetMoveDistance
    params.stagePointList = stagePointList
    return params
end

--计算道具的分布情况
M.CalculatePropArrange = function(raceConfig, sceenHeight, extraRewards)
    if not extraRewards or #extraRewards < 1 then
        log.log("M.CalculatePropArrange extraRewards 数据为空 ")
        return false
    end
    local totalLength = 0
    local stageLength = 0
    local stagePointList = {}
    for i, v in ipairs(raceConfig) do
        stageLength = v[2] * sceenHeight / 4
        stagePointList[i] =  totalLength + stageLength
        totalLength = stagePointList[i]
    end

    local propList = {}
    local count = 0
    for i1, v1 in ipairs(raceConfig) do
        local startPosY = stagePointList[i1 - 1] or 0
        local endPosY = stagePointList[i1]
        local stageLength = endPosY - startPosY
        local subStageNum = v1[6]--可能配0
        if subStageNum > 0 then
            local subStageLength = stageLength / subStageNum
            for i2 = 1, subStageNum do
                count = count + 1
                local item = {}
                item.stageIdx = i1
                item.subStageIdx = i2
                item.totalIdx = count
                if count <= #extraRewards then
                    item.rewards = extraRewards[count].reward
                    item.score = extraRewards[count].score
                else
                    item.rewards = extraRewards[#extraRewards].reward
                    item.score = extraRewards[#extraRewards].score
                end

                if i2 == subStageNum then
                    item.pos = endPosY
                else
                    item.pos = startPosY + i2 * subStageLength
                end
                table.insert(propList, item)
            end
        end
    end

    if count > #extraRewards then
        log.log("M.CalculatePropArrange 数据不批配1 count > #extraRewards", count, #extraRewards)
        return false
    elseif count < #extraRewards then
        log.log("M.CalculatePropArrange 数据不批配2 count < #extraRewards", count, #extraRewards)
        return false
    end

    return true, propList
end

M.CalculatePropParams = function(propList, startFuelVolume, endFuelVolume)
    local startIdx = 0
    local endIdx = 0
    for i, v in ipairs(propList) do
        if v.score > startFuelVolume and startIdx == 0 then
            startIdx = i
        end

        if v.score > endFuelVolume and endIdx == 0 then
            endIdx = i
        end
    end

    if startIdx == 0 then
        log.log("CarQuestConst.CalculatePropParams 已经完成比赛1", startFuelVolume, endFuelVolume)
        startIdx = #propList
    end

    if endIdx == 0 then
        log.log("CarQuestConst.CalculatePropParams 已经完成比赛2", startFuelVolume, endFuelVolume)
        endIdx = #propList
    end
    local params = {}
    params.startIdx = startIdx
    params.endIdx = endIdx
    return params
end

M.EnterMode = {
    afterAlternative = 1,   --二选一之后
    manualClick = 2,        --手动点击
    afterBattle = 3,        --战斗后
    beforeRewardResend = 4, --补发奖励之前
}

M.CarStates = {
    none = 0,
    stop = 1,
    starting = 2,
    startingFinish = 3,
    moving = 4,
    movingFinish = 5,
    sprinting = 6,
    sprintingFinish = 7,
}

M.ControlId1 = 179
-------------------------------------
local function parseItemRewardCommon(config)
    local d = {}
    if config ~= "" then
        local arr = Split(config, ";")
        for i, v in ipairs(arr) do
            local vArr = Split(v, ",")
            if vArr[1] ~= nil and vArr[2] ~= nil then
                table.insert(d, {id = tonumber(vArr[1]), value = tonumber(vArr[2])})
            end
        end
    end
    return d
end

function M.ParseRankReward(rewardInfoStr)
    local reward = {}
    local rewards = Split(rewardInfoStr, "-")
    for i, value in ipairs(rewards) do
        local rankReward = Split(value, ":")
        reward[tonumber(rankReward[1])] = parseItemRewardCommon(rankReward[2])
    end
    return reward
end

return M