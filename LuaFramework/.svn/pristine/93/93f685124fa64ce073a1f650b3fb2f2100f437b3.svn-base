
local view = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigRewardsItem")

local SelectBattleConfigSeasonPassRewardsItem = view:New()
local this = SelectBattleConfigSeasonPassRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function SelectBattleConfigSeasonPassRewardsItem:RefreshItem()
    local num = self.cacheData.season_pass_putin[self.betIndex] or 0
    if num == 0 then
        self.textNum.text = ""
    else
        self.textNum.text = num
    end
    Cache.SetImageSprite("ItemAtlas","TkBetReward27",self.icon)
end

function SelectBattleConfigSeasonPassRewardsItem:CheckValueChangeState(data,isInitItem,cardNum,betIndex)
    local nowNum = data.season_pass_putin[betIndex] or 0
    if isInitItem then
        return BingoBangEntry.selectBattleConfigItemValueChange.InitItem,nowNum
    end
    local beforeNum = self.cacheData.season_pass_putin[self.betIndex] or 0
    if beforeNum > nowNum then
        return BingoBangEntry.selectBattleConfigItemValueChange.Decrease,nowNum
    elseif  beforeNum < nowNum then
        return BingoBangEntry.selectBattleConfigItemValueChange.Increase,nowNum
    else
        return BingoBangEntry.selectBattleConfigItemValueChange.Same,nowNum
    end
end

function SelectBattleConfigSeasonPassRewardsItem:ShowLockState()
    --永远有个箱子
end




return this
