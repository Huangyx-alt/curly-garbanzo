--auto generate by unity editor
local cookierewardspritename = {
[1] = {1,2,"BIconJl01","BDIconJl01",},
[2] = {2,1,"BIconJl02","BDIconJl02",},
[3] = {3,3,"BIconJl03","BDIconJl03",},
[4] = {4,23,"BIconJl04","BDIconJl04",},
[5] = {5,910814,"BIconJlP01","BDIconJlP01",},
[6] = {6,910815,"BIconJlP02","BDIconJlP02",},
[7] = {7,910816,"BIconJlP03","BDIconJlP03",},
[8] = {8,910817,"BIconJlP04","BDIconJlP04",},
[9] = {9,910818,"BIconJlP05","BDIconJlP05",},
[10] = {10,910819,"BIconJlP06","BDIconJlP06",},
[11] = {11,910820,"BIconJlP07","BDIconJlP07",},
[12] = {12,910821,"BIconJlP08","BDIconJlP08",},
[13] = {13,910822,"BIconJlP09","BDIconJlP09",}
}

local keys = {id = 1,itemid = 2,spritename = 3,doublespritename = 4,说明 = 5}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(cookierewardspritename) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return cookierewardspritename
