-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_SlotsGameInfo.proto",

 PB_GameSlotsPiggySpin_Req  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID，为空或不存在对应数据时，重置游戏
}

 PB_GameSlotsPiggySpin_Res  =  {
    totalWin  =  1,-- int64 totalWin ,             -- 总奖励值
    breakTimes  =  2,-- int32 breakTimes ,           -- 可进行 break 的次数
    spinTimes  =  3,-- int32 spinTimes ,            -- 当前的spin次数
    slotsInfo  =  4,-- PB_SlotsGameInfo slotsInfo , -- 当前slots牌面的数据
}
