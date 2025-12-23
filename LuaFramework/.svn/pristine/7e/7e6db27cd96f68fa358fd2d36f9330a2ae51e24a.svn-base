--auto generate by unity editor
local city_message = {
[1] = {1,1,301},
[2] = {2,2,302},
[3] = {3,3,303}
}

local keys = {id = 1,message_type = 2,description = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(city_message) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return city_message
