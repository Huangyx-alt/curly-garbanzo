-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_CompetitionRacingInfo  =  {
    id                                    =  1,-- string id , --活动id
    createTime                            =  2,-- int32 createTime , --活动开始时间-时间戳
    expireTime                            =  3,-- int32 expireTime , --活动结束时间-时间戳
    hasHistoryReward                      =  4,-- int32 hasHistoryReward , --0-无 1-有 2-完成无奖励
    roundReward   =  5,-- repeated PB_ItemInfo ,--收集奖励
    rankReward   =  6,-- repeated PB_ItemInfo ,--排行榜奖励
    isOver                     =  7,-- int32 isOver , --是否已结束当前轮次
    showRankList   =  8,-- repeated PB_RacingCarRankInfo , --排行榜
    extraRewards   =  9,-- repeated PB_RacingCarExtraReward , --额外奖励
    firstReward   =  1,-- repeated PB_RacingCarFirstReward 0, --首冲奖励
    systemOsTime                     =  1,-- int32 systemOsTime 1, --服务器时间
    groupId                          =  1,-- int32 groupId 2, --难度Id
    isOpen                          =  1,-- bool isOpen 3, --活动是否开启
    stepRewards   =  1,-- repeated PB_RacingCarStepReward 4, --阶段奖励（随机取好配置下发客户端）
}

 PB_RacingCarFirstReward  =  {
    step  =  1,-- int32 step , -- round表的step 取reward_first
    uid  =  2,-- int32 uid ,
}

 PB_RacingCarExtraReward  =  {
    score  =  1,-- int32 score ,
    reward  =  2,-- PB_ItemInfo reward ,
}

 PB_RacingCarStepReward  =  {
    step  =  1,-- int32 step ,
    reward  =  2,-- PB_ItemInfo reward ,
}

 PB_RacingCarRankInfo  =  {
    order      =  1,-- int32  order ,--排名 (有排名的时候给，没有的时候为0，0的时候拿分数排序)
    uid        =  2,-- int32  uid ,--uid or robotId
    robot      =  3,-- int32  robot ,--普通用户0    机器人1
    nickname   =  4,-- string nickname ,--昵称
    avatar     =  5,-- string avatar ,--头像
    score      =  6,-- int32  score ,--分数
    gameProps    =  7,-- repeated int32  ,--游戏加成道具
    lastScore  =  8,-- int32  lastScore ,--上次分数
}
