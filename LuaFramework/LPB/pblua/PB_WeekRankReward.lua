-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- import"PB_WeekRankInfo.proto",
-- packageGPBClass.Message,

 PB_WeekRankReward  =  {
    reward                 =  1,--	repeated PB_ItemInfo ,--奖励数值
    weekRankNo                            =  2,--	int32 weekRankNo ,--周榜排名
    tiers                                 =  3,--	int32 tiers ,--段位
    difficulty                            =  4,--	int32 difficulty ,--所属难度
    recordId                              =  5,--	int32 recordId ,--奖励记录ID,便于区分多次奖励领取
    openWeekRankTime                      =  6,--	int32 openWeekRankTime ,--开启周榜时间
    weeklyRankTop     =  7,--	repeated PB_WeekRankInfo ,--前三名
}