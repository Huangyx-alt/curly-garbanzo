
local view = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigRewardsItem")

local SelectBattleConfigChestRewardsItem = view:New()
local this = SelectBattleConfigChestRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function SelectBattleConfigChestRewardsItem:RefreshItem()
    Cache.SetImageSprite("ItemAtlas",self.cacheData.chest_icon,self.icon)
    self.textNum.text = ""
end

function SelectBattleConfigChestRewardsItem:CheckValueChangeState(data,isInitItem)
    if isInitItem then
        return BingoBangEntry.selectBattleConfigItemValueChange.InitItem,1
    end
    if self.cacheData.chest_icon == data.chest_icon then
        --奖励图标等级无变化
        return
    end
    if self.cacheData.id > data.id then
        return BingoBangEntry.selectBattleConfigItemValueChange.Decrease,1
    elseif self.cacheData.id < data.id then
        return BingoBangEntry.selectBattleConfigItemValueChange.Increase,1
    else
        return BingoBangEntry.selectBattleConfigItemValueChange.Same,1
    end
end

function SelectBattleConfigChestRewardsItem:ShowLockState()
    --永远有个箱子
end




return this
