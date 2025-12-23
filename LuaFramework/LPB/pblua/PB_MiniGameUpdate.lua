-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_MiniGameState.proto",

 PB_MiniGameUpdate_Req  =  {
    miniGameId  =  1,-- int32 miniGameId ,--0或空 查询全部，其它查询指定数据
}

 PB_MiniGameUpdate_Res  =  {
    state  =  2,--	repeated PB_MiniGameState ,
}