--auto generate by unity editor
local config_bind_bi = {
[1] = {1,"victorybeats",{"0"},"0"},
[2] = {2,"victorybeats",{"LPB99903845","LPB99903847"},"1"},
[3] = {3,"victorybeats",{"LPB99903848","LPB99903849"},"2"},
[4] = {4,"powerup_group",{"0"},"powerup_group"},
[5] = {5,"powerup_group",{"LPB99903845","LPB99903847"},"powerup_group_lv1"},
[6] = {6,"powerup_group",{"LPB99903848","LPB99903849"},"powerup_group_lv2"}
}

local keys = {id = 1,file_id = 2,bi_id = 3,file = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(config_bind_bi) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return config_bind_bi
