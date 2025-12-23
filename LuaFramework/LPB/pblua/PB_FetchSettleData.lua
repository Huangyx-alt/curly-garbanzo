-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_MessageBase64List.proto",

 PB_FetchSettleData_Req  =  {
    gameId  =  1,-- string gameId ,    --游戏id
    playType  =  2,-- int32 playType ,  --玩法类型-PLAY_TYPE
}

 PB_FetchSettleData_Res  =  {
    gameId  =  1,--	string gameId , 						          --gameId
    settled  =  2,--	int32 settled , 						          --2-已经完成结算【5307再推送】  1-完成预结算【5306再推送】 0-未生成预结算数据【可能未收到4066】
    settleType  =  3,-- int32 settleType ,							  --结算类型
    nextMessages  =  4,-- repeated PB_MessageBase64List ,   --附带其它-推送协议
}