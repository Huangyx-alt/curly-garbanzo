local HallofFameShowNextRewardView = {}
local itemView = require("View/CommonView/CollectRewardsItem")

local topOneRewardItem = nil          --榜单第一名奖励节点
local topOneItemList = nil
local myNewRewardItem = nil          --玩家自己最新奖励节点
local myNewRewardList = nil
local climbIndex = nil

local creatTopOneItem = {}
local creatMyNewRewardItem = {}


--奖励位置/旋转组合
local itemGroup = {
    [1] = {
        [1] = { pos = { x = -5, y = 293, z = 0 }, rotate = { x = 0, y = 0, z = 0 } }
    },
    [2] = {
        [1] = { pos = { x = -113, y = 292, z = 0 }, rotate = { x = 0, y = 0, z = 13 } },
        [2] = { pos = { x = 107, y = 292, z = 0 }, rotate = { x = 0, y = 0, z = -13 } },
    },
    [3] = {
        [1] = { pos = { x = -232, y = 250, z = 0 }, rotate = { x = 0, y = 0, z = 27 } },
        [2] = { pos = { x = -5, y = 293, z = 0 }, rotate = { x = 0, y = 0, z = 0 } },
        [3] = { pos = { x = 222, y = 244, z = 0 }, rotate = { x = 0, y = 0, z = -27 } },
    },
    [4] = {
        [1] = { pos = { x = -306, y = 192, z = 0 }, rotate = { x = 0, y = 0, z = 27 } },
        [2] = { pos = { x = -113, y = 293, z = 0 }, rotate = { x = 0, y = 0, z = 13 } },
        [3] = { pos = { x = 107, y = 292, z = 0 }, rotate = { x = 0, y = 0, z = -13 } },
        [4] = { pos = { x = 305, y = 189, z = 0 }, rotate = { x = 0, y = 0, z = -27 } },
    },
}

function HallofFameShowNextRewardView:OnDestroy()
    for k, v in pairs(creatTopOneItem) do
        if v then
            fun.set_active(v, false)
        end
    end
    for k, v in pairs(creatMyNewRewardItem) do
        if v then
            fun.set_active(v, false)
        end
    end
end

function HallofFameShowNextRewardView:OnEnable(params)
    topOneRewardItem = params.topOneRewardItem
    topOneItemList = params.topOneItemList
    myNewRewardItem = params.myNewRewardItem
    myNewRewardList = params.myNewRewardList
    climbIndex = params.climbIndex
    self:InitView()
end

function HallofFameShowNextRewardView:GetMyNewReward()
    local data = ModelList.HallofFameModel:GetSettleClimbData(climbIndex + 1)
    local myLastSectionIndex = data.lastSectionIndex
    local rewardData = nil
    if myLastSectionIndex == 1 and self:CheckIsBlackTier() then
        local topOneData = ModelList.HallofFameModel:GetTrouamentClimbRankTopOneData(climbIndex + 1)
        rewardData = topOneData.reward
    else
        for k, v in pairs(data.showRankList) do
            if v.order == myLastSectionIndex then
                rewardData = v.reward
                break
            end
        end
    end
    return rewardData
end

function HallofFameShowNextRewardView:CheckIsBlackTier()
    local lastTier = ModelList.HallofFameModel:GetClimbTiers(climbIndex + 1)
    if ModelList.HallofFameModel:CheckIsBlackTire(lastTier) then
        return true
    else
        return false
    end
end

function HallofFameShowNextRewardView:InitMyNewReward()
    local myNewRewardData = self:GetMyNewReward()
    for k, v in pairs(myNewRewardData) do
        local grid = fun.get_instance(myNewRewardItem, myNewRewardList)
        local item = itemView:New()
        item:SetReward(v)
        item:SkipLoadShow(grid)
        fun.set_active(grid, true)
        table.insert(creatMyNewRewardItem, grid)
    end
end

-- local testNum = 0
function HallofFameShowNextRewardView:GetTopOneReward()
    local topOnePlayerData = ModelList.HallofFameModel:GetTrouamentClimbRankTopOneData(climbIndex + 1)
    if topOnePlayerData and topOnePlayerData.reward then
        return topOnePlayerData.reward
    end
    log.log("错误缺少第一名奖励数据", topOnePlayerData)
    return {
        [1] = { id = 1, value = 10000 },
        [2] = { id = 3, value = 100 },
    }

end

function HallofFameShowNextRewardView:InitTopOneReward()
    local myNewRewardData = self:GetTopOneReward()
    -- log.log("强制弹出数据 奖励获取检查" , myNewRewardData)
    local itemNum = GetTableLength(myNewRewardData)
    for i = 1, itemNum do
        local itemUiData = self:GetItemUiData(itemNum, i)
        if itemUiData then
            local grid = fun.get_instance(topOneRewardItem, topOneItemList)
            grid.transform.localPosition = itemUiData.pos
            grid.transform.eulerAngles = itemUiData.rotate
            local item = itemView:New()
            item:SetReward(myNewRewardData[i])
            item:SkipLoadShow(grid)
            fun.set_active(grid, true)
            table.insert(creatTopOneItem, grid)
        end
    end
end

function HallofFameShowNextRewardView:InitView()
    self:InitMyNewReward()
    self:InitTopOneReward()
end

function HallofFameShowNextRewardView:GetItemUiData(totalNum, index)
    if itemGroup[totalNum] and itemGroup[totalNum][index] then
        return itemGroup[totalNum][index]
    end
    return nil
end

return HallofFameShowNextRewardView