-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_MainMiniGameTime_Req  =  {
}

 PB_MainMiniGameTime_Res  =  {
    openTime  =  1,-- int64 openTime ,     -- 开启时间
    closeTime  =  2,-- int64 closeTime ,    -- 关闭时间
    miniGameId  =  3,-- int32 miniGameId ,   -- 小游戏ID
    enPlayIds  =  4,-- repeated int32  ,   -- 启用玩法ID
}