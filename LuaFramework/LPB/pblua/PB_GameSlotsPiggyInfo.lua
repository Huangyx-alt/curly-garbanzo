-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_SlotsGameInfo.proto",

 PB_GameSlotsPiggyInfo_Req  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID
}

 PB_GameSlotsPiggyInfo_Res  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID
    totalWin  =  2,-- int64 totalWin ,             -- 总奖励值
    breakTimes  =  3,-- int32 breakTimes ,           -- 可进行 break 的次数
    spinTimes  =  4,-- int32 spinTimes ,            -- 当前的spin次数
    slotsInfo  =  5,-- PB_SlotsGameInfo slotsInfo , -- 当前slots牌面的数据
}

