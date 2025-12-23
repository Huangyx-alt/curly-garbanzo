--auto generate by unity editor
local config_system = {
[1] = {1,"level",1,2}
}

local keys = {id = 1,name = 2,android = 3,ios = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(config_system) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return config_system
