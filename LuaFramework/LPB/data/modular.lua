--auto generate by unity editor
local modular = {
[1] = {1,5,1,"HAWAII"},
[2] = {2,6,1,"CHRISTMAS"},
[3] = {3,7,1,"LeetoleMan"},
[4] = {4,8,1,"SingleWolf"},
[5] = {5,9,1,"DRAGON"},
[6] = {6,10,3,"Play10"},
[7] = {7,11,3,"Play11"},
[8] = {8,0,2,"Club"},
[9] = {9,12,1,"GemQueen"},
[10] = {10,13,1,"Candy"},
[11] = {11,14,3,"Play14"},
[12] = {12,15,3,"Play15"},
[13] = {13,16,1,"NewChristmas"},
[14] = {14,17,1,"WinZone"},
[15] = {15,18,1,"GoldenPig"},
[16] = {16,19,1,"DragonFortune"},
[17] = {17,20,1,"NewLeetoleMan"},
[18] = {18,21,1,"Easter"},
[19] = {19,22,1,"Volcano"},
[20] = {20,23,1,"PirateShip"},
[21] = {21,24,1,"Thieves"},
[22] = {22,25,3,"Play25"},
[23] = {23,26,1,"MoleMiner"},
[24] = {24,27,1,"Bison"},
[25] = {25,28,1,"HorseRacing"},
[26] = {26,29,1,"ScratchWinner"},
[27] = {27,30,1,"GoldenTrain"},
[28] = {28,31,1,"ChristmasSynthesis"},
[29] = {29,32,1,"GotYou"},
[30] = {30,33,1,"LetemRoll"},
[31] = {31,34,1,"PiggyBank"},
[32] = {32,35,1,"Solitaire"},
[33] = {33,36,1,"Monopoly"},
[34] = {34,37,1,"DrinkingFrenzy"}
}

local keys = {id = 1,city_play_id = 2,modular_type = 3,modular_name = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(modular) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return modular
