-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ItemInfo.proto",

 PB_PuzzleReceiveReward_Req  =  {
    type  =  1,-- int32 type , --玩法类型
    city  =  2,--	int32 city , --城市Id
    puzzle  =  3,--	int32 puzzle , --拼图下标
}

 PB_PuzzleReceiveReward_Res  =  {
    reward  =  2,--	repeated PB_ItemInfo ,--奖励物品
}