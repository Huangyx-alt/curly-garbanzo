--auto generate by unity editor
local minigame = {
[1] = {1,1,15,16,{1,2,3,10,11,14,15,25},{1,17},{{"5-1","1"},{"2","1"},{"4","2"},{"6","2"},{"8","3"}},{{"1","0","80"},{"1","20-2","0","70"},{"1","20"},{"2","10-4","0","60"},{"1","20"},{"2","12"},{"3","8"}},10,100,0,{{1,13},{2,8}},"开箱子"}
}

local keys = {id = 1,game_type = 2,double_collection = 3,double_reward = 4,city_play = 5,collect_type = 6,collect = 7,collect_cards = 8,collect_count = 9,collect_enter = 10,collect_reward = 11,steal_min_level = 12,game_name = 13}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(minigame) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return minigame
