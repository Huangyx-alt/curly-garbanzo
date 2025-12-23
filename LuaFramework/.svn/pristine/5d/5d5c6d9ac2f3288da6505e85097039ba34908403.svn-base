--auto generate by unity editor
local window={
[2]={2,6,{1,3,6},-1,1,0,0,1,1,{1,3,6},"Popup7dayRewardOrder",},
[7]={7,10,{1,2,3,4,6},-1,0,0,0,0,0,{2,3,4,6},"PopupDoubleCookieOrder",},
[8]={8,11,{3,4,1,6,7},1,1,0,0,0,1,{3,4,1,6,7},"PopupGiftOrder",},
[12]={12,14,{3,4,6},-1,0,0,0,1,1,{3,4,6},"PopupCompetitionOrder",},
[18]={18,42,{1,3,6},1,0,0,0,1,1,{1,3,6},"PopupMailOrder",},
[20]={20,45,{1,2,3,4,6},-1,0,0,0,1,1,{2,3,4,6},"PopupDownloadOrder",},
[21]={21,46,{1,2,3,4,5,6},3,0,0,0,0,0,{0},"PopupEvluateUsOrder",},
[22]={22,47,{1,6},-1,0,0,0,1,1,{6},"PopupMiniGameOrder",},
[24]={24,100,{6},-1,1,0,0,0,0,{0},"PopupInterstitialOrder",},
[26]={26,101,{1,2,3,4,100,6},-1,0,0,0,1,1,{2,3,4,100,6},"PopupLevelUpOrder",},
[29]={29,104,{1,2,3,6},-1,0,0,0,1,1,{1,2,3,6},"PopupRegisterRewardOrder",},
[30]={30,109,{1,2},-1,0,0,0,0,0,{0},"PopupRouletteOrder",},
[32]={32,110,{2,3,4,6},-1,0,0,0,0,1,{2,3,4,6},"PopupTaskTipOrder",},
[33]={33,111,{3,6},-1,1,0,0,1,1,{0},"PopupGameHelpOrder",},
[36]={36,114,{2,3,4,5,6},-1,0,259200,2,0,0,{0},"PopupBingoPassOrder",},
[37]={37,115,{2,3,4,5,6},-1,0,0,0,0,1,{2,3,4,5,6},"PopupUnlockAvatarOrFrameOrder",},
[48]={48,99997,{1,2,3,6},-1,0,0,0,1,1,{1,2,3,6},"PopupGuideOrder",},
[49]={49,99998,{3,4,6},-1,0,0,0,1,1,{3,4,6},"PopupShowJackpot",},
[50]={50,100000,{1},-1,0,14400,4,1,1,{1},"PopupNewPlayTypeOrder",},
}

local keys={id=1,priority=2,occasion=3,max_num=4,interruption=5,pop_cd=6,pop_times=7,user_return_login=8,user_return_enable=9,user_return_occasion=10,execute=11,}
local mt={__index=function(t,k) local id=keys[k] if id then return t[id] end return nil end}for _,t in pairs(window)do setmetatable(t,mt)end mt.__metatable=false

return window
