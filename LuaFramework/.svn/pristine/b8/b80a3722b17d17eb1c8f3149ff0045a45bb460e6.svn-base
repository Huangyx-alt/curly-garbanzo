--auto generate by unity editor
local achievement = {
[1] = {1,1,"0",601},
[2] = {2,0,"SystemIcon01",602},
[3] = {3,2,"SystemIcon02",603},
[4] = {4,3,"SystemIcon03",604},
[5] = {5,0,"SystemIcon04",605},
[6] = {6,0,"SystemIcon05",606},
[7] = {7,0,"SystemIcon06",607},
[8] = {8,0,"SystemIcon07",608},
[9] = {9,0,"SystemIcon08",609},
[10] = {10,4,"SystemIcon09",610},
[11] = {11,0,"SystemIcon10",611},
[12] = {12,0,"SystemIcon011",612},
[13] = {13,0,"SystemIcon012",613},
[14] = {14,0,"SystemIcon013",614},
[15] = {15,0,"SystemIcon014",615},
[16] = {16,0,"SystemIcon015",616},
[17] = {17,5,"SystemIcon016",617},
[18] = {18,0,"SystemIcon017",618},
[19] = {19,0,"SystemIcon018",619},
[20] = {20,0,"SystemIcon019",620},
[21] = {21,0,"SystemIcon020",621},
[22] = {22,0,"SystemIcon021",622}
}

local keys = {id = 1,sequence = 2,icon = 3,description = 4}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(achievement) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return achievement
