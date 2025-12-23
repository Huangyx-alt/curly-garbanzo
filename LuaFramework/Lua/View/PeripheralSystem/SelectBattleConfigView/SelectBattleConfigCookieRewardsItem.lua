
local view = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigRewardsItem")

local SelectBattleConfigCookieRewardsItem = view:New()
local this = SelectBattleConfigCookieRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function SelectBattleConfigCookieRewardsItem:RefreshItem()
    Cache.SetImageSprite("ItemAtlas","TkBetReward25",self.icon)
    if self.cacheData.cookie_reward == 0 then
        self.textNum.text =  ""
    else
        self.textNum.text =  fun.format_number(self.cacheData.cookie_reward)
    end
end

function SelectBattleConfigCookieRewardsItem:CheckValueChangeState(data,isInitItem)
    local nowNum = data.cookie_reward
    if isInitItem then
        return BingoBangEntry.selectBattleConfigItemValueChange.InitItem,nowNum
    end
    if self.cacheData.cookie_reward > data.cookie_reward then
        return BingoBangEntry.selectBattleConfigItemValueChange.Decrease,nowNum
    elseif self.cacheData.cookie_reward < data.cookie_reward then
        return BingoBangEntry.selectBattleConfigItemValueChange.Increase,nowNum
    else
        return BingoBangEntry.selectBattleConfigItemValueChange.Same,nowNum
    end
end

function SelectBattleConfigCookieRewardsItem:ShowLockState()
end




return this
