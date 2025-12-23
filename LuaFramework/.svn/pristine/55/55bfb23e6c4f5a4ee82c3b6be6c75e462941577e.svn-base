local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local ChristmasSynthesisFlyItemEffect = BaseFlyItemEffect:New("ChristmasSynthesisFlyItemEffect")
local this = ChristmasSynthesisFlyItemEffect

function this:Remove()
    --Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    --Event.RemoveListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:Register()
    --Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
    --Event.AddListener(EventName.Event_Show_Skill_Bingo, self.ShowSkillBingo, self)
end

function this:CreateTreasure(cardId, cellIndex)
    if cellIndex == 13 then
        return
    end

    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
end

function this:GetTreasureFlyTime(cardId, fly, itemType)
    return 1
end

--Bingo技能
function this:ShowSkillBingo(cardId, cellIndex)
end

return this
