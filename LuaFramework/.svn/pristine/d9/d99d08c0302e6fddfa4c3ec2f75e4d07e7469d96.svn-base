--auto generate by unity editor
local new_bingo_rule = {
[1] = {1,1,1,{{1,2,3,4,5,6,7,8,9,10,11,12,13}},{0}},
[2] = {2,2,2,{{1041}},{0}},
[3] = {3,3,5,{{231001,1},{231002,1},{231003,1}},{0}},
[4] = {4,3,5,{{261001,4},{261002,1},{261003,1}},{0}},
[5] = {5,3,5,{{141001,1},{141002,1},{141003,1},{141004,1},{141005,1}},{0}},
[6] = {6,3,5,{{141006,1},{141007,1},{141008,1},{141009,1},{141010,1}},{0}},
}

local keys = {id = 1,type = 2,clienttype = 3,params = 4,wish_item = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_bingo_rule) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_bingo_rule
