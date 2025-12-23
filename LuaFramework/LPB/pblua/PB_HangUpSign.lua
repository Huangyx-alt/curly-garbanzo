-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SignItemInfo.proto",

--*******Bingo签章(5105)***********--
 PB_HangUpSign_Req  =  {
    gameId  =  1,-- int64 gameId ,                       --游戏ID
    total  =  2,-- repeated PB_SignHangUpCard ,   --全部卡牌涂抹信息
    index  =  3,-- int32 index ,
}
 PB_HangUpSign_Res  =  {
    rewards  =  1,-- repeated PB_SignItemInfo , 					--  道具奖励
    bingoIds  =  2,-- repeated int32  ,             --关联left
    index  =  3,-- int32 index ,
}

 PB_SignHangUpCard  =  {    
    cardId  =  1,-- int32 cardId ,                       --卡牌ID
    number  =  2,-- int32 number , 							--号码
}
