--auto generate by unity editor
local new_bingosleft = {
[1] = {1,{0,0},{3,7},{0,4}},
[2] = {2,{1,20},{3,5},{0,5}},
[3] = {3,{21,90},{3,14},{0,5}},
[4] = {4,{91,180},{9,18},{0,6}},
[5] = {5,{180,0},{15,24},{0,8}},
}

local keys = {id = 1,time_range = 2,start_time = 3,start_bingosleft = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_bingosleft) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_bingosleft
