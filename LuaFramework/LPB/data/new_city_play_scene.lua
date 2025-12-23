--auto generate by unity editor
local new_city_play_scene = {
[1] = {1,2001,1,3001,"1.Vegas","CityJz01An","CityJz01","CityJzBig01","CityJzBig01Mh","vegas",601001,25,"pPuzzle001",{{1,100},{2,100}},3},
[2] = {2,2001,2,3002,"2.Egypt","CityJz02An","CityJz02","CityJzBig02","CityJzBig02Mh","egypt",601002,25,"pPuzzle002",{{1,100},{2,100}},3},
[3] = {3,2001,3,3003,"3.Mexico","CityJz03An","CityJz03","CityJzBig03","CityJzBig03Mh","mexico",601003,25,"pPuzzle003",{{1,100},{2,100}},3},
[4] = {4,2001,4,3004,"4.Western","CityJz04An","CityJz04","CityJzBig04","CityJzBig04Mh","western",601004,25,"pPuzzle004",{{1,100},{2,100}},3},
[5] = {5,2001,5,3005,"5.Hawaii","CityJz05An","CityJz05","CityJzBig05","CityJzBig05Mh","hawaii",601005,25,"pPuzzle005",{{1,100},{2,100}},3},
[6] = {6,2001,6,3006,"6.China","CityJz06An","CityJz06","CityJzBig06","CityJzBig06Mh","china",601006,25,"pPuzzle006",{{1,100},{2,100}},3},
[7] = {7,2001,7,3007,"7.Rome","CityJz07An","CityJz07","CityJzBig07","CityJzBig07Mh","rome",601007,25,"pPuzzle007",{{1,100},{2,100}},3},
[8] = {8,2001,8,3008,"8.Cupid's Love","CityJz08An","CityJz08","CityJzBig08","CityJzBig08Mh","cupid",601008,25,"pPuzzle008",{{1,100},{2,100}},3},
[9] = {9,2001,9,3009,"9.Jungle Tarzan","CityJz09An","CityJz09","CityJzBig09","CityJzBig09Mh","jungle",601009,25,"pPuzzle009",{{1,100},{2,100}},3},
}

local keys = {id = 1,scene_group = 2,scene_id = 3,scene_modular = 4,scene_name = 5,scene_icon_lock = 6,scene_icon_unlcok = 7,scene_background = 8,scene_battle_blur = 9,music = 10,puzzle_id = 11,puzzle_num = 12,res_name = 13,reward_description = 14,modular_type = 15}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_city_play_scene) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_city_play_scene
