--auto generate by unity editor
local new_minigame = {
[1] = {1,1,"2025/8/20 0:00:00","2027/8/20 0:00:00",{602000,20},602001,"PiggySlotsGameView",}
}

local keys = {id = 1,minigame_id = 2,open_date = 3,close_date = 4,chip_need = 5,ticket_id = 6,minigame_mainview = 7,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_minigame) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_minigame
