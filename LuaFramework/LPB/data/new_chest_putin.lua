--auto generate by unity editor
local new_chest_putin = {
[1] = {1,{1},{0,49},1,"TkBetReward01",1,815101},
[2] = {2,{1},{50,99},2,"TkBetReward02",1,815102},
[3] = {3,{1},{100,999},3,"TkBetReward03",1,815103},
[4] = {4,{1},{1000,2999},4,"TkBetReward04",1,815104},
[5] = {5,{1},{3000,5999},5,"TkBetReward05",1,815105},
[6] = {6,{1},{6000,9999},6,"TkBetReward06",1,815106},
[7] = {7,{1},{10000,29999},7,"TkBetReward07",1,815107},
[8] = {8,{1},{30000,49999},8,"TkBetReward08",1,815108},
[9] = {9,{1},{50000,79999},9,"TkBetReward09",1,815109},
[10] = {10,{1},{80000,119999},10,"TkBetReward10",1,815110},
[11] = {11,{1},{120000,200000},11,"TkBetReward11",1,815111},
[12] = {12,{2,3,4},{0,49},1,"TkBetReward01",1,815201},
[13] = {13,{2,3,4},{50,99},2,"TkBetReward02",1,815202},
[14] = {14,{2,3,4},{100,999},3,"TkBetReward03",1,815203},
[15] = {15,{2,3,4},{1000,2999},4,"TkBetReward04",1,815204},
[16] = {16,{2,3,4},{3000,5999},5,"TkBetReward05",1,815205},
[17] = {17,{2,3,4},{6000,9999},6,"TkBetReward06",1,815206},
[18] = {18,{2,3,4},{10000,29999},7,"TkBetReward07",1,815207},
[19] = {19,{2,3,4},{30000,49999},8,"TkBetReward08",1,815208},
[20] = {20,{2,3,4},{50000,79999},9,"TkBetReward09",1,815209},
[21] = {21,{2,3,4},{80000,119999},10,"TkBetReward10",1,815210},
[22] = {22,{2,3,4},{120000,200000},11,"TkBetReward11",1,815211}
}

local keys = {id = 1,play_id = 2,bet_value = 3,chest_level = 4,chest_icon = 5,putin_num = 6,chest_id = 7}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_chest_putin) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_chest_putin
