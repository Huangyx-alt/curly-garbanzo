
local view = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigRewardsItem")
local SelectBattleConfigTournamentRewardsItem = view:New()
local this = SelectBattleConfigTournamentRewardsItem

function SelectBattleConfigTournamentRewardsItem:RefreshItem()
    Cache.SetImageSprite("ItemAtlas","TkBetReward27",self.icon)
    if self.cacheData.weeklylist_reward == 0 then
        self.textNum.text =  ""
    else
        self.textNum.text =  fun.format_number(self.cardNum * self.cacheData.weeklylist_reward)
    end
end

function SelectBattleConfigTournamentRewardsItem:CheckValueChangeState(data,isInitItem)
    local num = data.weeklylist_reward
    if isInitItem then
        return BingoBangEntry.selectBattleConfigItemValueChange.InitItem,num
    end
    if self.cacheData.weeklylist_reward > num then
        return BingoBangEntry.selectBattleConfigItemValueChange.Decrease,num
    elseif self.cacheData.weeklylist_reward < data.weeklylist_reward then
        return BingoBangEntry.selectBattleConfigItemValueChange.Increase,num
    else
        return BingoBangEntry.selectBattleConfigItemValueChange.Same,num
    end
end

function SelectBattleConfigTournamentRewardsItem:CheckItemRewardEmpty(data)
    
end




return this
