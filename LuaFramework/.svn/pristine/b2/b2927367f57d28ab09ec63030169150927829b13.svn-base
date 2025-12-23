--auto generate by unity editor
local user_layered = {
[1] = {1,25,4,{5,90},{{1,80},{2,85}}},
[2] = {2,20,4,{5,90},{{1,80},{2,85}}},
[3] = {3,15,3,{5,90},{{1,80},{2,85}}},
[4] = {4,10,3,{5,90},{{1,80},{2,85}}},
[5] = {5,5,2,{5,90},{{1,80},{2,85}}}
}

local keys = {id = 1,lost_daub = 2,call_interval = 3,frequency = 4,transition = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(user_layered) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return user_layered
