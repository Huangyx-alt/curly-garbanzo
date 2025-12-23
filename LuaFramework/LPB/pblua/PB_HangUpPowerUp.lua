-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_PowerCardInfo.proto",
 PB_HangUpPowerUp_Req  =  {
    gameId  =  1,-- int64 gameId , --gameid
    id  =  2,-- int32 id ,--后端发过来的从0开始的原powerUps列表索引
    extra  =  3,-- repeated PB_PowerCardInfo ,--影响数字
    index  =  4,-- int32 index ,
}

 PB_HangUpPowerUp_Res  =  {
    nums  =  1,-- repeated int32 ,
    bingoIds  =  2,-- repeated int32  ,             --关联left
    index  =  3,-- int32 index ,
}
