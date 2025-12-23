--auto generate by unity editor
local function_icon = {
[1] = {1,"FunctionIconTask","FunctionIconTaskView",0,2,5,0,0,0},
[2] = {2,"FunctionIconBingopass","FunctionIconBingopassView",0,2,7,0,0,0},
[3] = {3,"FunctionIconSeasonCard","FunctionIconSeasonCardView",1,2,1,1,4,0},
[4] = {4,"FunctionIconPuzzle","FunctionIconPuzzleView",2,2,4,1,3,0},
[5] = {5,"FunctionIconCoupon","FunctionIconCouponView",4,2,6,0,0,0},
[6] = {6,"FunctionIconGamePass","FunctionIconGamePassView",2,5,8,0,0,0},
[7] = {7,"FunctionIconMagnifyLens","FunctionIconMagnifyLensView",1,1,3,0,0,0},
[8] = {8,"FunctionIconMagnifyLens","FunctionIconMagnifyLensView",2,1,3,0,0,0},
[9] = {9,"FunctionIconMail","FunctionIconMailView",0,1,2,0,0,0},
[10] = {10,"FunctionIconMiniGame","FunctionIconMiniGameView",2,4,8,0,0,0},
[11] = {11,"FunctionIconDiscountAll","FunctionIconDiscountAllView",0,2,6,0,0,0},
[12] = {12,"FunctionIconCuisines","FunctionIconCuisinesView",4,2,1,1,4,0},
[13] = {13,"FunctionIconRegularlyAward","FunctionIconRegularlyAwardView",1,2,9,0,0,0},
[14] = {14,"FunctionIconCarQuest","FunctionIconCarQuestView",0,2,1,0,0,0},
[15] = {15,"FunctionIconVolcanoMission","FunctionIconVolcanoMissionView",0,2,9,0,0,0},
[16] = {16,"FunctionIconPuzzle","FunctionIconPuzzleView",3,2,4,1,3,0},
[17] = {17,"FunctionIconMoneyMansion","FunctionIconMoneyMansionView",2,2,10,0,0,32}
}

local keys = {id = 1,prefab_name = 2,component_name = 3,belong_to = 4,location = 5,genre = 6,sole_city = 7,activity_type = 8,belong_play = 9}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(function_icon) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return function_icon
