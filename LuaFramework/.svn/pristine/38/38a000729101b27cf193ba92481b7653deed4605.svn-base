--auto generate by unity editor
local new_guide_step = {
[1] = {1,1,2,0,1,"0",0,"HallMainView","0","0","0","0","0","0",0,10,0,"0",0,"guide_A_1"},
[2] = {2,1,0,0,110,"12#HallMainView/SafeArea/Bottom_Area/Cards/Play2cardView/cards#-300#300",0,"0","0","Let's <color=#941abf>Bingo</color>!","0","0","0","0",0,47,0,"0",0,"guide_A_2"},
[20] = {20,2,21,0,1,"0",0,"GameBingoView","0","0","0","0","0","0",0,10,0,"0",0,"guide_A_3"},
[21] = {21,2,22,0,110,"14#GameBingoView/SafeArea",0,"0","0","0","0","0","0","0",0,47,0,"0",0,"guide_A_4"},
[22] = {22,2,23,0,111,"0#1#2#1#0#0#0#5#0#0#0#0#0#47#3",0,"0","12#128#-273","<color=#941abf>Tap to daub</color> the numbers as they are called.","0","0","0","0",45,10,0,"0",0,"guide_A_5"},
[23] = {23,2,24,0,111,"0#1#2#1#0#0#0#5#0#0#0#0#0#33#3",0,"0","13#147#-260","<color=#941abf>Power-ups</color>  can give you <color=#941abf>more daubs!</color>","0","0","0","0",45,10,0,"0",0,"guide_A_6"},
[24] = {24,2,25,0,1,"0",0,"GameSettleView/SettleLuckyBang","0","0","0","0","0","0",0,10,0,"0",0,"guide_A_7"},
[25] = {25,2,26,0,110,"13#GameSettleView/SettleLuckyBang/SafeArea#147#-260",0,"0","0","Whoa! You got<color=#941abf> LuckyBang</color>! Check it out!","0","0","0","0",0,10,0,"0",0,"guide_A_8"},
[26] = {26,2,27,0,3,"0#1#13#1#0#0#0#1#0.5",0,"GameSettleView/SettleLuckyBang/SafeArea/SpinOrdinary/Bottom_Area/dish/btn_spin_speed/spin","11#GameSettleView/SettleLuckyBang/SafeArea/SpinOrdinary/Bottom_Area/dish/btn_spin_speed/spin#0#420","Tap to get a random <color=#941abf>bonus call</color>!","0","0","0","0",0,10,0,"0",0,"guide_A_9"},
[27] = {27,2,28,0,1,"0",0,"GameSettleView/SettleDetail","0","0","0","0","0","0",0,10,0,"0",0,"guide_A_10"},
[28] = {28,2,0,1,3,"0#1#31#1#0#0#0#1#0.5",0,"GameSettleView/SettleDetail/Root/btn_continue","0","0","0","0","0","0",0,10,0,"0",0,"guide_A_11"},
[30] = {30,7,31,0,1,"0",0,"HallMainView","0","0","0","0","3","0",0,10,0,"0",0,"guide_hallmain_1"},
[31] = {31,7,32,0,3,"0#1#11#1#0#0#0#1#0.5",0,"HallMainView/SafeArea/Bottom_Area/btn_play","11#HallMainView/SafeArea/Bottom_Area/btn_play#335#391","Want to play with <color=#941abf>more cards</color>?","0","0","3","0",0,10,0,"0",0,"guide_hallmain_2"},
[32] = {32,7,33,0,1,"0",0,"SelectBattleConfigView","0","0","0","0","3","0",0,10,0,"0",0,"guide_hallmain_3"},
[33] = {33,7,0,1,3,"0#1#0#1#0#0#0#1#0.5",0,"SelectBattleConfigView/SafeArea/bingoCard/control/btn_increase_card","11#SelectBattleConfigView/SafeArea/bingoCard/control/btn_increase_card#300#-260","Try <color=#941abf>4</color> cards here.","0","0","3","0",0,10,0,"0",0,"guide_hallmain_4"},
[55] = {55,2,26,0,6,"13#GameSettleView/SettleLuckyBang/SafeArea#147#-260#3",0,"0","0","<color=#941abf>LuckyBang</color> randomly awards <color=#FFD700>1</color> extra call!","0","0","0","0",0,10,0,"0",0,"guide_A_8"}
}

local keys = {id = 1,guideid = 2,nextid = 3,needsync = 4,controltype = 5,param = 6,cmd = 7,path = 8,contentparam = 9,content = 10,skipparam = 11,satisfyparam = 12,skiptrigger = 13,award = 14,before_setguidepanel = 15,after_setguidepanel = 16,starthere = 17,finishparam = 18,finish_action = 19,report = 20}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_guide_step) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_guide_step
