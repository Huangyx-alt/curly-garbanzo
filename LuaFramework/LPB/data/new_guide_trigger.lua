--auto generate by unity editor
local new_guide_trigger = {
[2] = {2,"GameBingoView","第一场战斗(BingoBang也使用)","0","0",1,20,"0","0","0","0","0",0,"4",1,1},
[7] = {7,"HallMainView","Bet切卡引导(BingoBang新增)","finish#2","0",1,30,"0","0","0","0","0",0,"4",1,1}
}

local keys = {triggerid = 1,view = 2,descripe = 3,startcondition = 4,endcondition = 5,isforce = 6,behaviorstep = 7,follwstep = 8,type = 9,path = 10,content = 11,contentparam = 12,ispause = 13,param = 14,controltype = 15,client = 16}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_guide_trigger) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_guide_trigger
