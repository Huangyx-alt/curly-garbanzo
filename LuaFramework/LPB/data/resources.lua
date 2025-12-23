--auto generate by unity editor
local resources = {
[1] = {1,"diamond","0","icondiamondm","b_bingo_xz","icon_diamond","cGems05more","LBGEMS01","xianshiicon008"},
[2] = {2,"coins","0","icon_goldBig","b_bingo_xz","icon_gold","cCoins03more","LBCoins01","xianshiicon001"},
[3] = {3,"hintTime","0","b_bingo_find","b_bingo_xz","b_bingo_find","cItems01more","0","xianshiicon002"},
[4] = {4,"cityXp","city","cityxp","b_bingo_xz","cityxp","0","0","0"},
[5] = {5,"exp","0","gj_icon05","b_bingo_xz","gj_icon05","0","0","0"},
[6] = {6,"cherry","0","gj_icon04","b_bingo_xz","gj_icon04","0","0","0"},
[7] = {7,"tickets","0","powerup_icon_005","b_bingo_xz","0","0","0","0"},
[8] = {8,"autoTickets","0","autoTickets","b_bingo_xz","0","0","0","0"},
[9] = {9,"rocket","0","iconxhjBig","b_bingo_xz","iconxhj","cRocket03more","LBRockets01","xianshiicon009"},
[10] = {10,"vipPts","0","c_vipexpbig","b_bingo_xz","c_vipexpbig","0","0","0"},
[11] = {11,"star","0","star","b_bingo_xz","0","0","0","0"},
[12] = {12,"passEXP","0","lpFlash","b_bingo_xz","lpFlashBig","0","0","0"},
[13] = {13,"AutocityXp","autocity","cityxp","b_bingo_xz","cityxp","0","0","0"},
[14] = {14,"doubleCookie","0","d_Cookie","b_bingo_xz","d_Cookie","0","0","0"},
[15] = {15,"doubleHat","0","Hat","b_bingo_xz","d_Hat","0","0","0"},
[16] = {16,"doubleHat_reward","0","Hat","b_bingo_xz","0","0","0","0"},
[17] = {17,"double_cookie","0","0","0","0","0","0","0"},
[18] = {18,"double_cookie_reward","0","0","0","0","0","0","0"},
[19] = {19,"week_cup","0","ZBJbSz","b_bingo_xz","0","0","0","0"},
[20] = {20,"dailycoins_bonus","0","ZBDailyIcon","0","0","0","0","0"},
[21] = {21,"profile_picture","0","0","0","0","0","0","0"},
[22] = {22,"profile_box","0","0","0","0","0","0","0"},
[23] = {23,"double_competition","0","BsCookieJlBuff01","0","0","0","0","0"},
[24] = {24,"double_competition_reward","0","BsCookieJlBuff02","0","0","0","0","0"},
[25] = {25,"competition","0","0","0","0","0","0","0"},
[26] = {26,"powerball","0","0","0","0","0","0","0"},
[27] = {27,"season_card_star","0","0","0","0","0","0","0"},
[28] = {28,"racingEXP","0","0","b_bingo_xz","0","0","0","0"},
[29] = {29,"extraracing","0","CarJc01","b_bingo_xz","0","0","0","0"},
[30] = {30,"racingreward","0","CarJc02","b_bingo_xz","0","0","0","0"},
[31] = {31,"musicalnote","0","iconWinzoneYf01","b_bingo_xz","0","iconWinzoneYfH01","0","0"},
[32] = {32,"revivalCoin","0","0","0","0","0","0","0"},
[33] = {33,"double_notes","0","winzonelibaoTfSb","0","0","winzonelibaoTfSb","0","0"},
[34] = {34,"taskpoint","0","GreenLPicon","0","0","GreenLPicon","GreenLPicon","0"},
[35] = {35,"volcano_doublebuff","0","0","0","0","0","0","0"},
[36] = {36,"volcano_keybuff","0","0","0","0","0","0","0"},
[37] = {37,"volcano_basicprop","0","0","0","0","0","0","0"},
[38] = {38,"volcano_revivalcoin","0","0","0","0","0","0","0"},
[39] = {39,"powerup_season","0","0","0","0","0","0","0"},
[40] = {40,"supermatch_ticket","0","SuperMatchIcon","0","0","0","0","xianshiicon014"}
}

local keys = {id = 1,name = 2,belong = 3,icon = 4,box_type = 5,big_icon = 6,more_icon = 7,pop_up = 8,competition_icon = 9}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(resources) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return resources
