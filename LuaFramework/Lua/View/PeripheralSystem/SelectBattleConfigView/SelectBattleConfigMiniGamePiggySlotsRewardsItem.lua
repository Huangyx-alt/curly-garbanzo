
local view = require("View/PeripheralSystem/SelectBattleConfigView/SelectBattleConfigRewardsItem")

local SelectBattleConfigMiniGamePiggySlotsRewardsItem = view:New()
local this = SelectBattleConfigMiniGamePiggySlotsRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

function SelectBattleConfigMiniGamePiggySlotsRewardsItem:RefreshItem()
    local num = self.cacheData.chips_putin[self.betIndex] or 0
    if num == 0 then
        self.textNum.text = ""
    else
        self.textNum.text = num
    end
    Cache.SetImageSprite("ItemAtlas","IconBonusGame",self.icon)
end

function SelectBattleConfigMiniGamePiggySlotsRewardsItem:CheckValueChangeState(data,isInitItem,cardNum,betIndex)
    local nowNum = data.chips_putin[betIndex] or 0
    if isInitItem then
        return BingoBangEntry.selectBattleConfigItemValueChange.InitItem,nowNum
    end
    local beforeNum = self.cacheData.chips_putin[self.betIndex] or 0
    if beforeNum > nowNum then
        return BingoBangEntry.selectBattleConfigItemValueChange.Decrease,nowNum
    elseif  beforeNum < nowNum then
        return BingoBangEntry.selectBattleConfigItemValueChange.Increase,nowNum
    else
        return BingoBangEntry.selectBattleConfigItemValueChange.Same,nowNum
    end
end

function SelectBattleConfigMiniGamePiggySlotsRewardsItem:ShowLockState()
    --永远有个箱子
end




return this
