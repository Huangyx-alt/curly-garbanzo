local JackpotConsoleView = require "View/HallCity/JackpotConsoleView"

local DrinkingFrenzyConsoleView = JackpotConsoleView:New(nil)
local this = DrinkingFrenzyConsoleView

this.ConsoleInActionName = "in"
this.ConsoleInClipName = "jackpot_console_GemQueenin"

function DrinkingFrenzyConsoleView:SetJackpotReward()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    --单卡价格
    local playCardCost = ModelList.CityModel:GetCostCoin(1)
    local BingoReward = Csv.GetBingo4RewardOfPlayid(playId)
    BingoReward = BingoReward / 100 or 0
    local rewardValue = BingoReward * playCardCost
    local curModel = ModelList.BattleModel.GetModelByPlayID(playId)
    self.text_reward:SetValue(rewardValue)
end


function DrinkingFrenzyConsoleView:SetMaxBetRateJackpot()
    if self.go.name == "ultra_jackpot_console" then
        AnimatorPlayHelper.Play(self.anima, { "jackpot_consolein", "ultra_jackpot_consolein" }, false, nil)
    else
        AnimatorPlayHelper.Play(self.anima, { self.ConsoleInActionName, self.ConsoleInClipName }, false, nil)
    end

    self:SetJackpotInfo()
end




function DrinkingFrenzyConsoleView:SetJackpotInfo()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local reward = Csv.GetData("city_play", playId, "jackpot_reward_new")
    if reward then
        self:SetJackpotReward()
        self:SetJackpotImages("HallMainAtlas")
    end

    self:ShowSuperMatchBang()
end


return this