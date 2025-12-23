--auto generate by unity editor
local client_bingo_rule = {
[1] = {1,{{1,6,11,16,21},{2,7,12,17,22},{3,8,13,18,23},{4,9,14,19,24},{5,10,15,20,25},{1,2,3,4,5},{6,7,8,9,10},{11,12,13,14,15},{16,17,18,19,20},{21,22,23,24,25},{1,7,13,19,25},{21,17,13,9,5},{1,5,21,25}},}
}

local keys = {id = 1,content = 2,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(client_bingo_rule) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return client_bingo_rule
