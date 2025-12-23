--auto generate by unity editor
local new_function_icon = {
[1] = {1,"FunctionIconTournament","FunctionIconTournamentView",1,0,1},
[2] = {2,"FunctionIconBingopass","FunctionIconBingopassView",1,0,2},
[3] = {3,"FunctionIconTask","FunctionIconTaskView",1,0,3},
[4] = {4,"FunctionIconClub","FunctionIconClubView",2,0,1},
[5] = {5,"FunctionIconSeasonCard","FunctionIconSeasonCardView",2,4,2},
[6] = {6,"FunctionIconCarQuest","FunctionIconCarQuestView",2,0,3},
[7] = {7,"FunctionIconVolcanoMission","FunctionIconVolcanoMissionView",2,0,4},
}

local keys = {id = 1,prefab_name = 2,component_name = 3,location = 4,activity_type = 5,weight = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_function_icon) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_function_icon
