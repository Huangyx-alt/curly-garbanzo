--auto generate by unity editor
local personalise_edge = {
[1] = {1,"SystemFrames01",0,1,101023,{15}},
[2] = {2,"SystemFrames02",0,1,101024,{25}},
[3] = {3,"SystemFrames03",0,1,101025,{35}},
[8] = {8,"SystemFramesTop",1,1,101030,{1}}
}

local keys = {id = 1,icon = 2,default_icon = 3,unlock_type = 4,description = 5,unlock_value = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(personalise_edge) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return personalise_edge
