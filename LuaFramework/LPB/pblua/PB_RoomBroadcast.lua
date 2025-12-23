-- syntax =  "proto3",

-- packageGPBClass.Message,

--******游戏房间内事件信息同步(5200)*********--
 PB_RoomBroadcast_Req  =  {
}

--******游戏内bingosi同步(5200)*********--
 PB_RoomBroadcast_Res  =  {
    type         =  1,-- int32 type ,--1-bingo 2-jackpot
    uid          =  2,--	int64 uid ,--uid or robotId
    bingoLeft    =  3,--	int32 bingoLeft ,--剩余bingo数量
    msgId        =  4,--	int32 msgId ,--提示id 比如 Double Bingo ……
	
}

