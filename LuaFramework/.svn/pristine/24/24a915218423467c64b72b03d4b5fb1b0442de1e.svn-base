local GameModel = require "Model/GameModel"
local bingoJokerMachine = require("Combat.Machine.BingoJokerMachine")

---  宝石皇后玩法
local PiggyBankModel = GameModel:New()
local this = PiggyBankModel
local private = {}

function PiggyBankModel:InitData()
    self:SetSelfGameType(2)
end

function PiggyBankModel:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)
    --父类处理
    local ret = this.__index:RefreshRoundDataByIndex(cardid, cellIndex, signType, need_fly_item, mark)

    --如果盖章触发技能/获得道具，添加sign计时，保证技能、道具动效播完
    --local cell = self.roundData:GetCell(tostring(cardid), cellIndex)
    --if cell and not cell:IsEmpty() then
    --    self.cardSignLogicDelayTime = os.time()
    --end

    return ret
end

function PiggyBankModel:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    this.__index:SetRoundGiftData(card_id, cell_index, new_gift, number, skill_id, self_bingo, powerId, extraPos)
    --if powerId == 192 then
    --    --记录猪技能数据，结束上传
    --    table.insert(self.cachedSkillDataCache, {
    --        cardId = tonumber(card_id),
    --        cellIndex = cell_index,
    --        extraPos = extraPos,
    --    })
    --end
end

function PiggyBankModel:UploadGameData(gameType, quiteType)
    --if self.roundData ~= nil and self.roundData.GetRoundData ~= nil then
    --    self:PreCalcuatePigSkill()
    --end
    this.__index.UploadGameData(self, gameType, quiteType)
end

return this