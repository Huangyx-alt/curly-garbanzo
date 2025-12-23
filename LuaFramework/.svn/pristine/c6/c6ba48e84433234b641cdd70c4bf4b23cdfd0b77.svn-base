-- syntax =  "proto3",

-- packageGPBClass.Message,

--******游戏内bingosi同步(5004)*********--
 PB_HangUpBingoLeft_Req  =  {    
}


--******游戏内bingosi同步(5004)*********--
 PB_HangUpBingoLeft_Res  =  {    
    gameId   =  1,--	int64 gameId ,						--游戏id
    bingoLeft  =  2,--	int32 bingoLeft  , 					--剩余bingosi数量
    bingoChange  =  3,--	int32 bingoChange  , 				--和上次的改变量
    cardId  =  4,--	int32 cardId ,						--卡牌ID
    bingo  =  5,--	repeated HangUpBingoInfo ,    --bingo号码
    next  =  6,--	int32 next ,                         --下次时间-秒
    bingoId  =  7,--	int32 bingoId ,
    robots  =  8,--	repeated int32  ,--机器人id
}

 HangUpBingoInfo{
    type  =  1,--	int32 type  , 						--类型  1.bingo   2.jackpot
    numbers  =  2,--	repeated int32  ,--bingo号码
    cardId  =  3,--	int32 cardId ,						--卡牌ID
    totolCount  =  4,--	int32 totolCount ,					--总bingo数量
    th  =  5,--	int32 th ,                           --排名
}
