--auto generate by unity editor
local game_hall = {
[1] = {1,"HallMainView","HallMainView"},
[2] = {2,"HallMainView","HallMainView"},
[3] = {3,"HallMainView","HallMainView"},
[4] = {4,"Play4HallView","Play4HallView"},
[5] = {5,"HawaiiHallView","HawaiiHallView"},
[6] = {6,"ChristmasHallView","ChristmasHallView"},
[7] = {7,"LeetoleManHallView","LeetoleManHallView"},
[8] = {8,"SingleWolfHallView","SingleWolfHallView"},
[10] = {10,"HallMainView","HallMainView"},
[11] = {11,"HallMainView","HallMainView"},
[14] = {14,"HallMainView","HallMainView"},
[15] = {15,"HallMainView","HallMainView"},
[12] = {12,"GemQueenHallView","GemQueenHallView"},
[13] = {13,"CandyHallView","CandyHallView"},
[16] = {16,"NewChristmasHallView","NewChristmasHallView"},
[17] = {17,"HallMainView","HallMainView"},
[18] = {18,"GoldenPigHallView","GoldenPigHallView"},
[19] = {19,"DragonFortuneHallView","DragonFortuneHallView"},
[20] = {20,"NewLeetoleManHallView","NewLeetoleManHallView"},
[21] = {21,"EasterHallView","EasterHallView"},
[22] = {22,"VolcanoHallView","VolcanoHallView"},
[23] = {23,"PirateShipHallView","PirateShipHallView"},
[24] = {24,"ThievesHallView","ThievesHallView"},
[25] = {25,"HallMainView","HallMainView"},
[26] = {26,"MoleMinerHallView","MoleMinerHallView"},
[27] = {27,"BisonHallView","BisonHallView"},
[28] = {28,"HorseRacingHallView","HorseRacingHallView"},
[29] = {29,"ScratchWinnerHallView","ScratchWinnerHallView"},
[30] = {30,"GoldenTrainHallView","GoldenTrainHallView"},
[31] = {31,"ChristmasSynthesisHallView","ChristmasSynthesisHallView"},
[32] = {32,"GotYouHallView","GotYouHallView"},
[33] = {33,"LetemRollHallView","LetemRollHallView"},
[34] = {34,"PiggyBankHallView","PiggyBankHallView"},
[35] = {35,"SolitaireHallView","SolitaireHallView"},
[36] = {36,"MonopolyHallView","MonopolyHallView"},
[37] = {37,"DrinkingFrenzyHallView","DrinkingFrenzyHallView"}
}

local keys = {id = 1,application_guide_ui_name = 2,guide_ui_name = 3}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(game_hall) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return game_hall
