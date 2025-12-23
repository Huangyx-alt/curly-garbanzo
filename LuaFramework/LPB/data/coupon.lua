--auto generate by unity editor
local coupon = {
[6001] = {6001,1,{3},20,1,28800,100,0,"tTJQYFourCardsFree",920,954,1,"tSmallCupDaiFont02","tTJQYFourCardsEnt",},
[6002] = {6002,1,{3},10,1,28800,20,0,"tTJQYFourCards5off",921,955,1,"tSmallCupDaiFont04","tTJQYFourCardsEnt",},
[6003] = {6003,2,{7},49,1,28800,100,0,"tTJQYPowerupCardsFree",922,956,0,"tSmallCupDaiFont01","tTJQYPowerupCards5Ent",},
[6004] = {6004,2,{7},30,1,28800,20,0,"tTJQYPowerupCards5off",923,957,0,"tSmallCupDaiFont03","tTJQYPowerupCards5Ent",},
[6005] = {6005,2,{8},60,1,28800,100,0,"tTJQYPowerupCardsFree2",924,958,0,"tSmallCupDaiFont01","tTJQYPowerupCards5Ent",},
[6006] = {6006,2,{8},50,1,28800,20,0,"tTJQYPowerupCards5off2",925,959,0,"tSmallCupDaiFont03","tTJQYPowerupCards5Ent",},
[6007] = {6007,1,{2,3,4,5},70,1,28800,20,0,"tTJQY2and4Cards5off",926,960,1,"tSmallCupDaiFont04","tTJQYFourCardsEnt",},
[6008] = {6008,1,{2,3},80,1,28800,100,0,"tTJQY2and4CardsFree",927,961,1,"tSmallCupDaiFont02","tTJQYFourCardsEnt",},
[6009] = {6009,1,{4,5},90,1,28800,20,0,"tTJQYAutoCards5off",928,962,2,"tSmallCupDaiFont04","tTJQYFourCardsEnt",},
[6010] = {6010,1,{4,5},80,1,28800,100,0,"tTJQYAutoCardsFree",929,963,2,"tSmallCupDaiFont02","tTJQYFourCardsEnt",},
[6011] = {6011,3,{9},100,0,28800,0,10,"tTJQYjackpotUp",930,964,0,"tSmallCupDaiFont05","tTJQYFourCardsEnt",},
[6012] = {6012,2,{6},15,1,28800,20,0,"tTJQYPowerupCards5off2",966,967,0,"0","tTJQYPowerupCards5Ent",},
[6013] = {6013,2,{7},40,1,28800,20,0,"tTJQYPowerupCards5off",923,957,0,"0","tTJQYPowerupCards5Ent",},
[6014] = {6014,2,{8},59,1,28800,20,0,"tTJQYPowerupCards5off2",925,959,0,"0","tTJQYPowerupCards5Ent",},
[6015] = {6015,2,{6},16,1,28800,100,0,"tTJQYPowerupCardsFree",922,965,0,"0","tTJQYPowerupCards5Ent",},
[6016] = {6016,2,{7},41,1,28800,100,0,"tTJQYPowerupCardsFree",922,956,0,"0","tTJQYPowerupCards5Ent",},
[6017] = {6017,2,{8},60,1,28800,100,0,"tTJQYPowerupCardsFree2",922,958,0,"0","tTJQYPowerupCards5Ent",},
[6018] = {6018,2,{6,7,8},110,1,28800,100,0,"tTJQYFourCardsFree",920,958,0,"0","tTJQYPowerupCards5Ent",},
[6019] = {6019,2,{6,7,8},110,1,28800,100,0,"tTJQYFourCardsFree",920,954,2,"0","tTJQYPowerupCards5Ent",},
[6020] = {6020,2,{8},59,1,345600,20,0,"tTJQYPowerupCards5off2",925,959,0,"0","tTJQYPowerupCards5Ent",},
[6021] = {6021,2,{10},111,1,86400,20,0,"tTJQYPowerupCards5off3",1311,1313,0,"0","tTJQYPowerupCards5off3",},
[6022] = {6022,2,{10},125,1,28800,100,0,"tTJQYPowerupCardsFree3",1310,1312,0,"0","tTJQYPowerupCardsFree3",},
[6029] = {6029,2,{7},124,1,28800,50,0,"tTJQYPowerupCards50off",1310,1312,0,"0","tTJQYPowerupCards50off",},
[6030] = {6030,2,{8},126,1,28800,50,0,"tTJQYPowerupCards50off2",1310,1312,0,"0","tTJQYPowerupCards50off2",},
[6031] = {6031,2,{10},127,1,28800,50,0,"tTJQYPowerupCards50off3",1310,1312,0,"0","tTJQYPowerupCards50off3",},
[6032] = {6032,5,{12},128,0,0,0,0,"tTJQYPowerupCards5off4",0,8078,0,"0","tTJQYPowerupCards5off4",}
}

local keys = {id = 1,item_type = 2,new_coupon_type = 3,weights = 4,frequency = 5,cd = 6,saleoff = 7,jackpot_up = 8,icon = 9,description_skyreward = 10,description_icon = 11,application = 12,slogan = 13,icon_function = 14,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(coupon) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return coupon
