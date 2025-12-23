-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_CompetitionCupInfo  =  {
    id                                      =  1,-- string id , --活动id
    createTime                               =  2,-- int32 createTime , --活动开始时间-时间戳
    hasRoundData                             =  3,-- int32 hasRoundData , --周期内是否有多轮 0-无多轮，1-有多轮
    roundData     =  4,-- repeated PB_CompetitionCupRound , --周期内有多轮时 如果不为空 取第一个为当前轮子活动数据
    hasHistoryReward                         =  5,-- int32 hasHistoryReward , --0-无 1-有 2-完成无奖励
    competitionRoundReward   =  6,-- repeated PB_ItemInfo , --杯赛收集奖励
    hasDoubleReward                           =  7,-- bool hasDoubleReward , --是否有双倍奖励
    systemOsTime                             =  8,-- int32 systemOsTime , --服务器时间
    groupId                                  =  9,-- int32 groupId , --难度Id
    resetCompetition                          =  1,-- bool resetCompetition 0, --重置游戏数据
    resetTime                                =  1,-- int32 resetTime 1, --重置游戏时间，为 0 则不重置
}

 PB_CompetitionCupRound  =  {
    id                                =  1,-- int32 id , --多轮-id
    order                             =  2,-- int32 order , --多轮-第几轮 从1开始
    progress                          =  3,-- int32 progress , --多轮-进度
    target                            =  4,-- int32 target , --多轮-完成目标
    createTime                        =  5,-- int32 createTime , --多轮-开始时间-时间戳
    expireTime                        =  6,-- int32 expireTime , --多轮-结束时间-时间戳
    completed                          =  7,-- bool completed , --多轮-是否完成
    rewarded                           =  8,-- bool rewarded , --多轮-是否领取奖励
    failed                             =  9,-- bool failed , --多轮-是否失败
    oldProgress                       =  1,-- int32 oldProgress 0, --多轮-子活动-第几轮 登录查询的时候与progress一致 变化推送的时候 为0或 < progress
    reward             =  1,-- repeated PB_ItemInfo 1, --子活动-奖励数据
    extraReward        =  1,-- repeated PB_ItemInfo 2, --子活动-额外奖励数据
    extraRewardContinue               =  1,-- int32 extraRewardContinue 3, --子活动-如果额外奖励非空 额外奖励持续时间-基于子活动开始时间 前端展示倒计时需要比较子活动结束时间
}