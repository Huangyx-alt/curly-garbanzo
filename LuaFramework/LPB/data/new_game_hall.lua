--auto generate by unity editor
local new_game_hall = {
[1] = {1,"HallMainView","HallMainView"},
[2] = {2,"PiggyBankHallView","PiggyBankHallView"},
[3] = {3,"DrinkingFrenzyHallView","DrinkingFrenzyHallView"},
[4] = {4,"PirateShipHallView","PirateShipHallView"}
}

local keys = {id = 1,application_guide_ui_name = 2,guide_ui_name = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_hall) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_hall
