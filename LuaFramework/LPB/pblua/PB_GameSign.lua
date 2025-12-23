-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_SignItemInfo.proto",
--*******Bingo签章(5005)***********--
 PB_GameSign_Req  =  {
    cardId  =  1,-- int32 cardId ,						--卡牌ID
    number  =  2,--	int32 number ,						--号码
    gameId  =  3,--	int64 gameId ,						--游戏ID
    index  =  4,--	int32 index ,
}
 PB_GameSign_Res  =  {
    rewards  =  1,-- repeated PB_SignItemInfo , 					--  道具奖励
    bingoIds  =  2,-- repeated int32  ,             --关联left
    index  =  3,-- int32 index ,
}





