-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_MiniGameFetchGame_Req  =  {
}

 PB_MiniGameFetchGame_Res  =  {
    openTime               =  1,-- int64 openTime , -- 开启时间，当前或者下一个小游戏
    closeTime              =  2,-- int64 closeTime , -- 关闭时间，当前或者下一个小游戏
    miniGameId             =  3,-- int32 miniGameId , -- 小游戏ID
    gameInfo     =  4,-- PB_MiniGameInfo gameInfo , -- 当前小游戏数据
}

 PB_MiniGameInfo  =  {
    miniGameId             =  1,-- int32 miniGameId , -- 当前小游戏ID
    target                 =  2,-- int32 target , -- 当前目标
    progress               =  3,-- int32 progress , -- 当前进度
    chipId                 =  4,-- int32 chipId , -- 收集的筹码ID
    ticket           =  5,-- PB_ItemInfo ticket , -- 可用门票
}