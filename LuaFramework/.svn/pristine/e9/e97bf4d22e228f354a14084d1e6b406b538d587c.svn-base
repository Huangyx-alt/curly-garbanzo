--auto generate by unity editor
local new_powerup_hit = {
[1] = {1,{1},1,{21,42},},
[2] = {2,{1},2,{24,41},},
[3] = {3,{1},4,{22,56},},
[4] = {4,{2},1,{21,42},},
[5] = {5,{2},2,{24,41},},
[6] = {6,{2},4,{22,56},},
[7] = {7,{3},1,{21,42},},
[8] = {8,{3},2,{24,41},},
[9] = {9,{3},4,{22,56},},
[10] = {10,{4},1,{21,42},},
[11] = {11,{4},2,{24,41},},
[12] = {12,{4},4,{22,56},}
}

local keys = {id = 1,play_id = 2,card_num = 3,pu_hit_range = 4,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_powerup_hit) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_powerup_hit
