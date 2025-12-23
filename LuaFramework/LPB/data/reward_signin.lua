--auto generate by unity editor
local reward_signin = {
[1] = {1,1,{2,99999},{{2,80}},{{"2","80"}},100,"qSevenIcon05"},
[2] = {2,2,{2,99999},{{2,120}},{{"2","120"}},100,"qSevenIcon02"},
[3] = {3,3,{2,99999},{{2,140}},{{"2","140"}},100,"qSevenIcon02"},
[4] = {4,4,{2,99999},{{2,160}},{{"2","160"}},100,"qSevenIcon07"},
[5] = {5,5,{2,99999},{{2,180}},{{"2","180"}},100,"qSevenIcon05"},
[6] = {6,6,{2,99999},{{2,200}},{{"2","200"}},100,"qSevenIcon08"},
[7] = {7,7,{2,99999},{{2,50},{1,30},{910804,2}},{{"2","50"},{"1","30"},{"910804","2"}},100,"qSevenIcon04"}
}

local keys = {id = 1,day = 2,level = 3,reward = 4,reward_description = 5,coefficient = 6,icon = 7}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(reward_signin) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return reward_signin
