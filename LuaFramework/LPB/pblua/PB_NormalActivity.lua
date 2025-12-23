-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SevenSignState.proto",
-- import"PB_WeekRankReward.proto",
-- import"PB_ActivityRoFyState.proto",
-- import"PB_MiniGameState.proto",
-- import"PB_ItemInfo.proto",

 PB_NormalActivity  =  {
    sevenSignState                            =  1,-- PB_SevenSignState sevenSignState ,--七日签到活动状态数据
    dailyReward                                           =  2,--	int32 dailyReward ,--登录奖励可领取状态
    weekRankState                             =  3,--	PB_WeekRankReward weekRankState ,--上周-周榜奖励状态数据
    roFyState                     =  4,--	repeated PB_ActivityRoFyState ,--天降奇遇状态数据-可同时存在多个天降奇遇
    hasRegisterReward                                     =  5,--	int32 hasRegisterReward ,--是否有未领取的注册奖励 0-无 1-有
    miniGameState                     =  6,--	repeated PB_MiniGameState ,--miniGame状态数据
    unReceivedWeekRankStageReward          =  7,--	repeated PB_ItemInfo ,--未领取的-全部累计的周榜阶段奖励状态数据
    dailyRewardType                                       =  8,--	int32 dailyRewardType ,--登录每日奖励类型 1-免费用户 2-付费用户
    fameRankState                             =  9,--	PB_WeekRankReward fameRankState ,--上周-名人堂奖励状态数据
    unReceivedFameRankStageReward          =  1,--	repeated PB_ItemInfo 0,--未领取的-全部累计的名人堂阶段奖励状态数据

}

