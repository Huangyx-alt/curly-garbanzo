--auto generate by unity editor
local bingosleft_timeline = {
[1] = {1,{40,60},{0,1}},
[2] = {2,{61,75},{0,1}},
[3] = {3,{76,90},{0,1}},
[4] = {4,{91,100},{1,2}},
[5] = {5,{101,110},{1,2}},
[6] = {6,{111,120},{2,3}},
[7] = {7,{121,125},{2,3}},
[8] = {8,{126,130},{2,3}},
[9] = {9,{131,140},{2,3}},
[10] = {10,{141,150},{3,3}},
[11] = {11,{151,160},{3,3}},
[12] = {12,{161,165},{4,5}},
[13] = {13,{166,170},{6,6}},
[14] = {14,{171,175},{6,6}}
}

local keys = {id = 1,timeline = 2,bingosleft = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(bingosleft_timeline) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return bingosleft_timeline
