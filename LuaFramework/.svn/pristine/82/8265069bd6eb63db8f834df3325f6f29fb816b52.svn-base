--auto generate by unity editor
local new_skill = {
[101] = {101,0,{{0,-1},{1,-1},{1,0}},},
[102] = {102,1,{{2}},},
[103] = {103,1,{{2}},},
[104] = {104,0,{{1,1},{2,0},{1,0}},},
}

local keys = {id = 1,skill_type = 2,skill_xyz = 3,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_skill) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_skill
