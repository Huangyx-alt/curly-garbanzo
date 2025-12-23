local BaseFlyItemEffect = require("View.Bingo.EffectModule.Card.FlyItemEffect.BaseFlyItemEffect")

local MonopolyFlyItemEffect = BaseFlyItemEffect:New("MonopolyFlyItemEffect")
local this = MonopolyFlyItemEffect

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
        local data = Csv.GetData("item", treasureItems.id)
        if 62 == data.result[1] then
            local groupId = treasureItems.id % 10
            CalculateBingoMachine.OnDataChange(cardId, cellIndex, groupId, 1) -- for wish
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

            Event.Brocast(EventName.Event_Logic_Collect_Item, cardId, cellIndex, groupId, 1)
            Event.Brocast(EventName.Event_View_Collect_Item, cardId, groupId)
            --UISound.play("Monopolyxxx")
            -- LuaTimer:SetDelayFunction(1, function()

            -- end, false, LuaTimer.TimerType.BattleUI)
        end
    end
end

return this