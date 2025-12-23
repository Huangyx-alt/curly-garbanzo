--auto generate by unity editor
local new_game_music = {
[1] = {1,{"0"},{"luaprefab_sound_bingo_joker"},"kick_call",1,"0"},
[2] = {2,{"luaprefab_sound_bingo_grandheist"},{"luaprefab_sound_bingo_joker"},"piggybankkickcall",0,"powerup_cd4"},
[3] = {3,{"luaprefab_sound_bingo_grandheist"},{"luaprefab_sound_bingo_joker"},"drinkingkickcall",0,"powerup_cd4"},
[4] = {4,{"luaprefab_sound_bingo_pirate"},{"luaprefab_sound_bingo_joker"},"piratekickcall",0,"powerup_cd4"}
}

local keys = {id = 1,music = 2,joker_music = 3,kick = 4,need_common_bingo = 5,power_cd = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_game_music) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_game_music
