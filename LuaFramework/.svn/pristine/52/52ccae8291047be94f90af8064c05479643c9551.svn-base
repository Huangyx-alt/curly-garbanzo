--auto generate by unity editor
local reddotevent = {
[1] = {1,"cuisines_reddot_event",{"CuisinesRedDot"},1,},
[2] = {2,"decals_reddot_event",{"DecalsRedDot"},2,},
[3] = {3,"shop_coinfree_event",{"ShopCoinFreeRedDot"},0,},
[4] = {4,"othercitycuisines_reddot_event",{"OtherCityCuisinesRedDot"},1,},
[5] = {5,"task_reddot_event",{"TaskRedDot"},0,},
[6] = {6,"puzzle_reddot_event",{"PuzzleRedDot"},0,},
[7] = {7,"maincity_auto_event",{"CuisinesRedDot","PuzzleRedDot"},0,},
[8] = {8,"mail_reddot_event",{"MailRedDot"},0,},
[9] = {9,"bingopass_reddot_event",{"BingoPassRedDot"},0,},
[10] = {10,"club_reddot_event",{"ClubRedDot"},0,},
[11] = {11,"game_pass_reddot_event",{"GamePassDot"},0,}
}

local keys = {id = 1,event_name = 2,execute = 3,refresh_type = 4,}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(reddotevent) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return reddotevent
