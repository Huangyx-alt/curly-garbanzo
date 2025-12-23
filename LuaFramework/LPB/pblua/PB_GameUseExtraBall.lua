-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_MessageBase64List.proto",

 PB_GameUseExtraBall_Req  =  {
    gameId      =  1,-- string gameId ,    --游戏id
    index        =  2,-- int32 index ,    --索引，-1 表示结束
}

 PB_GameUseExtraBall_Res  =  {
    index  =  1,-- repeated int32  , --完成的索引
    nextMessages  =  2,-- repeated PB_MessageBase64List ,--附带其它-推送协议
}
