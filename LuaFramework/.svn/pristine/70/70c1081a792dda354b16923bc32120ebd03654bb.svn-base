--auto generate by unity editor
local volcano_revival = {
[1] = {1,1,1,0.99,61,"huoshanfuhuo1"},
[2] = {2,2,2,1.99,62,"huoshanfuhuo2"},
[3] = {3,3,3,2.99,63,"huoshanfuhuo3"}
}

local keys = {id = 1,revival_times = 2,revivalcoin_num = 3,price = 4,product_difference = 5,cehuakan = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(volcano_revival) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return volcano_revival
