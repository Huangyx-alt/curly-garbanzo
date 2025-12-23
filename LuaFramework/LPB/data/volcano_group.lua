--auto generate by unity editor
local volcano_group = {
[1] = {{{1}},{0,5},{0,500000},},
[2] = {{{2}},{5,10},{500001,1000000},},
[3] = {{{3}},{10,20},{1000001,2000000},},
[4] = {{{4}},{20,50},{2000001,3000000},},
[5] = {{{5}},{50,80},{3000001,5000000},},
[6] = {{{6}},{80,100},{5000001,8000000},},
[7] = {{{7}},{100,200},{8000001,10000000},},
[8] = {{{8}},{200,99999},{10000001,9999999999},}
}

local keys = {id = 1,pay_range = 2,coin_range = 3,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(volcano_group) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return volcano_group
