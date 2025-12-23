local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local PiggyBankFlyItemEffect = BaseFlyItemEffect:New("PiggyBankFlyItemEffect")
local this = PiggyBankFlyItemEffect

function this:Remove()
    Event.RemoveListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end 

function this:Register()
    Event.AddListener(EventName.Event_Collect_Item_By_Sign, self.CreateTreasure, self)
end

function this:CreateTreasure(cardId, cellIndex)
    local curModel = ModelList.BattleModel:GetCurrModel()
    local curCell = curModel:GetRoundData(cardId, cellIndex)
    local treasureItems = curCell:Treasure2Item()

    if treasureItems then
        local data = Csv.GetData("new_item", treasureItems.id)
        if 11 == data.result[1] then
            CalculateBingoMachine.OnDataChange(cardId, cellIndex, data.result[3], 1) -- for wish
            local ext = curCell:GetExtInfo()
            local groupCells = ext and ext.groupCells
            if groupCells then
                local isAllSigned = true
                table.each(groupCells, function(cellData)
                    if cellData then
                        isAllSigned = isAllSigned and not (cellData:IsNotSign() or cellData:IsLogicSign())
                    end
                end)
                if not isAllSigned then
                    return
                end
            end

            Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, data.result[3], 1)
            Event.Brocast(EventName.Event_View_Collect_Item, cardId, data.result[3])
            --UISound.play("PiggyBankxxx")
            -- LuaTimer:SetDelayFunction(1, function()

            -- end, false, LuaTimer.TimerType.BattleUI)
        end
    end
end

return this