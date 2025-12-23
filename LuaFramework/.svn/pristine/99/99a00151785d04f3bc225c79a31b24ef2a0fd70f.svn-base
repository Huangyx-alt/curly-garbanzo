--auto generate by unity editor
local feature_enter = {
[1] = {1,5,3,0,0,0,1,1,"0","Jweijiuicon","tesplayPop","Jweijiuposter","0"},
[2] = {2,6,1,0,0,0,2,1,"christmasPopinmain","Shengdanicon","shengdanPop","shengdanposter","0"},
[3] = {3,7,1,0,0,0,3,1,"stpatrickPopinmain","LeetouManIcon","LeetoleManPop","LeetouManposter","0"},
[4] = {4,8,1,0,0,0,4,1,"werewolfPopinmain","SingleWolf","SinglewolfPop","SingleWolfposter","0"},
[5] = {5,9,4,0,0,0,5,1,"0","EasterEgg","0","0","0"},
[6] = {6,12,3,0,0,0,9,1,"queencharmsPopinmain","GemQueemIcon","GemQueemPop","GemQueemposter","GemQueenFeatureAtlas"},
[7] = {7,13,3,0,0,0,10,1,"candysweetsPopinmain","CandyIcon","CandyPop","Candyposter","CandyFeatureAtlas"},
[8] = {8,16,2,0,0,0,13,1,"newchristmasPopinmain","NewChristmasIcon","NewChristmasPop","NewChristmasposter","NewChristmasFeatureAtlas"},
[9] = {9,18,2,0,0,0,15,1,"goldenpigPopinmain","GoldenPigIcon","GoldenPigPop","GoldenPigposter","GoldenPigFeatureAtlas"},
[10] = {10,19,2,0,0,0,16,1,"dragonPopinmain","DragonFortuneIcon","DragonFortunePop","DragonFortuneposter","DragonFortuneFeatureAtlas"},
[11] = {11,20,2,0,0,0,17,1,"newleetolemanpopinmain","NewLeetoleManIcon","NewLeetoleManPop","NewLeetoleManposter","NewLeetoleManFeatureAtlas"},
[12] = {12,21,2,0,0,0,18,1,"easterpopinmain","EasterIcon","EasterPop","Easterposter","EasterFeatureAtlas"},
[13] = {13,22,2,0,0,0,19,1,"lavapopinmain","VolcanoIcon","VolcanoPop","Volcanoposter","VolcanoFeatureAtlas"},
[14] = {14,23,2,0,0,0,20,1,"piratepopinmain","PirateShipIcon","PirateShipPop","PirateShipposter","0"},
[15] = {15,24,2,0,0,0,21,1,"thievespopinmain","ThievesIcon","ThievesPop","Thievesposter","0"},
[16] = {16,26,2,0,0,0,23,1,"minerpopinmain","MoleMinerIcon","MoleMinerPop","MoleMinerposter","MoleMinerFeatureAtlas"},
[17] = {17,27,2,0,0,0,24,1,"bisonpopinmain","BisonIcon","BisonPop","Bisonposter","0"},
[18] = {18,28,2,0,0,0,25,1,"horseracingpopinmain","HorseRacingIcon","HorseRacingPop","HorseRacingposter","HorseRacingFeatureAtlas"},
[19] = {19,29,2,0,0,0,26,1,"scratchwinnerpopinmain","ScratchWinnerIcon","ScratchWinnerPop","ScratchWinnerposter","ScratchWinnerFeatureAtlas"},
[20] = {20,30,2,0,0,0,27,1,"goldentrainPopinmain","GoldenTrainIcon","GoldenTrainPop","GoldenTrainposter","GoldenTrainFeatureAtlas"},
[21] = {21,31,2,0,0,0,28,1,"ChristmasSynthesisPopinmain","ChristmasSynthesisIcon","ChristmasSynthesisPop","ChristmasSynthesisposter","ChristmasSynthesisFeatureAtlas"},
[22] = {22,32,2,0,0,0,29,1,"gotyoupopinmain","GotYouIcon","GotYouPop","GotYouposter","GotYouFeatureAtlas"},
[23] = {23,33,2,0,0,0,30,1,"letemrollpopinmain","LetemRollIcon","LetemRollPop","LetemRollposter","LetemRollFeatureAtlas"},
[24] = {24,34,2,0,10,0,31,1,"piggybankpopinmain","PiggyBankIcon","PiggyBankPop","PiggyBankposter","PiggyBankFeatureAtlas"},
[25] = {25,35,2,0,40,0,32,1,"solitairepopinmain","SolitaireIcon","SolitairePop","Solitaireposter","SolitaireFeatureAtlas"},
[26] = {26,36,2,1,50,1,33,1,"monopolypopinmain","MonopolyIcon","MonopolyPop","Monopolyposter","MonopolyFeatureAtlas"},
[27] = {27,37,2,0,0,0,34,1,"drinkingpopinmain","DrinkingFrenzyIcon","DrinkingFrenzyPop","DrinkingFrenzyposter","DrinkingFrenzyFeatureAtlas"}
}

local keys = {id = 1,city_play = 2,featured_type = 3,featured_entrance = 4,featured_banner = 5,featured_pop = 6,modular_id = 7,modular_type = 8,pop_sound = 9,modular_icon = 10,modular_pop = 11,modular_poster = 12,modular_atlas = 13}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(feature_enter) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return feature_enter
