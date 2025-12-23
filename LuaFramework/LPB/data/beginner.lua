--auto generate by unity editor
local beginner = {
[2] = {2,1,1,10,1,{67,47,39,33,7,40,24,75,6,31,56},{0},3,{63,65},{0},2,{27}}
}

local keys = {id = 1,cardid = 2,powerupid = 3,bingosleft = 4,city_play = 5,call_number = 6,call_stop = 7,bingo = 8,luckybang = 9,rocket = 10,finish = 11,finish_step = 12}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(beginner) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return beginner
