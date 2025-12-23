local base = require "GamePlayShortPass/Base/BasePassDataComponent"
local PassDataComponent = class("PassDataComponent", base)
local this = PassDataComponent

function PassDataComponent:GetAllReward(productType)
    return self:GetAllRewardV2(productType)
end

function PassDataComponent:GetAllRewardV1(productType)
    local levelNormal = self:GetLevel()
    local levelGolden = levelNormal
    local rewardNow = {}
    local rewardSoon = {}
    -- if productType == BingoPassPayType.Pay999 then
    --     levelGolden = self:GetPayGoldPassLevel()
    -- end
    levelGolden = self:GetPayGoldPassLevel()

    local cout = self:GetShowRewardDataCout()
    for i = 1, cout do
        local cache_list = nil
        local passData = self:GetRewardDataById(i) --Csv.GetData(csv_data_name,i)
        if i <= levelNormal or i <= levelGolden then
            if not self:IsPayReceived(i) then
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

function PassDataComponent:GetAllRewardV2(productType)
    local rewardNow = {}
    local rewardSoon = {}
    
    local cout = self:GetShowRewardDataCout()
    for i = 1, cout do
        local cache_list = rewardNow
        local passData = self:GetRewardDataById(i) --Csv.GetData(csv_data_name,i)
        if passData and passData.free_reward then
            local key = passData.free_reward[1]
            local value = passData.free_reward[2]
            if key and value then
                cache_list[key] = (cache_list[key] or 0) + value
            end
        end

        if passData and passData.pay_reward then
            for key2, value2 in pairs(passData.pay_reward) do
                local key = value2[1]
                local value = value2[2]
                if key and value then
                    cache_list[key] = (cache_list[key] or 0) + value
                end
            end
        end
    end

    return rewardNow, rewardSoon
end

function PassDataComponent:GetPayGoldPassLevel()
    local level = self:GetLevel()
    local upgradeLevel = self:GetPayUpgradeLevel()

    level = level + upgradeLevel
    if level > self:GetShowRewardDataCout() then
        level = self:GetShowRewardDataCout()
    end

    return level
end

function PassDataComponent:GetPayUpgradeLevel()
    local cfg = Csv.GetControlByName("task_pass_lv")
    local upgradeLevel = cfg and cfg[1] and cfg[1][1] or 0

    return upgradeLevel
end

function PassDataComponent:GetMoreExtraNum(payID)
    local cfgLength = Csv.GetDataLength("task_pass_pay")
    local more = nil
    for i = 1, cfgLength do
        if payID == Csv.GetData("task_pass_pay",i,"product1_id") then
            more = Csv.GetData("task_pass_pay",i,"bonus")
            break
        end
    end
    return more
end

return this 