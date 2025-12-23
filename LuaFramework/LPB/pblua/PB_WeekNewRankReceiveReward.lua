-- syntax =  "proto3",
-- import"PB_WeekNewRankReward.proto",
-- import"PB_WeekRankInfo.proto",
-- packageGPBClass.Message,

 PB_WeekNewRankReceiveReward_Req  =  {
    receive  =  1,-- int32 receive , -- 0查询 1领取周榜奖励，默认为1
}

 PB_WeekNewRankReceiveReward_Res  =  {
    info                 =  1,--	PB_WeekNewRankReward info ,--奖励数据
    hasWeekRankReward                =  2,--	int32 hasWeekRankReward ,--有奖励时值为1 否则为0
    type                             =  3,--	int32 type ,--成功领取奖励后返回值为0，推送有奖励时值为1
    weeklyRankTop  =  4,--	repeated PB_WeekRankInfo ,--周榜top前三
    openWeekRankTime  =  5,--	int32 openWeekRankTime ,--下次开启周榜时间
}