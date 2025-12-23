--auto generate by unity editor
local vip_description = {
[1] = {1,501,5011,"shop_added"},
[2] = {2,502,5031,"daily_reward"},
[3] = {3,504,5041,"reward_interval"}
}

local keys = {id = 1,name = 2,description = 3,vip = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(vip_description) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return vip_description
