-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_CompetitionRoundData.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_CompetitionRankInfo.proto",


 PB_CompetitionInfo  =  {
    id                                    =  1,-- string id , --活动id
    createTime                            =  3,-- int32 createTime , --活动开始时间-时间戳
    expireTime                            =  2,-- int32 expireTime , --活动结束时间-时间戳
    hasRoundData                          =  4,-- int32 hasRoundData , --周期内是否有多轮 0-无多轮，1-有多轮
    roundData    =  5,-- repeated PB_CompetitionRoundData , --周期内有多轮时 如果不为空 取第一个为当前轮子活动数据
    hasHistoryReward                      =  6,-- int32 hasHistoryReward , --0-无 1-有 2-完成无奖励
    competitionRoundReward   =  7,-- repeated PB_ItemInfo ,--杯赛收集奖励
    competitionRankReward   =  8,-- repeated PB_ItemInfo ,--杯赛排行榜奖励
    competitionStartId                     =  9,-- int32 competitionStartId , --奖杯的图标Id
    showRankList   =  1,-- repeated PB_CompetitionRankInfo 0, --排行榜
    hasDoubleReward                     =  1,-- bool hasDoubleReward 1, --是否有双倍奖励
    hasDoubleUnclaimedRewards           =  1,-- bool hasDoubleUnclaimedRewards 2, --日榜结算是否有双倍奖励
    systemOsTime                     =  1,-- int32 systemOsTime 3, --服务器时间
    groupId                          =  1,-- int32 groupId 4, --难度Id
}