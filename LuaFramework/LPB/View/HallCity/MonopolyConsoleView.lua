local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

local MonopolyConsoleView = JackpotConsoleView:New(nil)
local this = MonopolyConsoleView

this.ConsoleInActionName = "in"
this.ConsoleInClipName = "jackpot_console_Candyin"

function MonopolyConsoleView:SetJackpotReward()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    --单卡价格
    local playCardCost = ModelList.CityModel:GetCostCoin(1)
    local BingoReward = Csv.GetBingo4RewardOfPlayid(playId)
    BingoReward = BingoReward / 100 or 0
    local rewardValue = BingoReward * playCardCost
    local curModel = ModelList.BattleModel.GetModelByPlayID(playId)
    if curModel:IsTriggerExtraReward() then
        local factor = Csv.GetData("control", 221, "content")[1][1] or 1
        rewardValue = rewardValue * factor
    end
    self.text_reward:SetValue(rewardValue)
end

return this