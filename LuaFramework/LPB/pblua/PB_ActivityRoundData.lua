-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_ActivityRoundData  =  {
    id                                =  1,-- int32 id , --多轮-子活动-id
    order                             =  2,-- int32 order , --多轮-子活动-第几轮 从1开始
    progress                          =  3,-- int32 progress , --多轮-子活动-进度
    target                            =  4,-- int32 target , --多轮-子活动-完成目标
    createTime                        =  5,-- int32 createTime , --多轮-子活动-开始时间-时间戳
    expireTime                        =  6,-- int32 expireTime , --多轮-子活动-结束时间-时间戳
    completed                          =  7,-- bool completed , --多轮-子活动-是否完成
    rewarded                           =  8,-- bool rewarded , --多轮-子活动-是否领取奖励
    failed                             =  9,-- bool failed , --多轮-子活动-是否失败
    icon                             =  1,-- string icon 0, --多轮-子活动-icon
    oldProgress                       =  1,-- int32 oldProgress 1, --多轮-子活动-第几轮 登录查询的时候与progress一致 变化推送的时候 为0或<progress
    reward             =  1,-- repeated PB_ItemInfo 2, --子活动-奖励数据
    extraReward        =  1,-- repeated PB_ItemInfo 3, --子活动-额外奖励数据
    extraRewardContinue               =  1,-- int32 extraRewardContinue 4, --子活动-如果额外奖励非空 额外奖励持续时间-基于子活动开始时间 前端展示倒计时需要比较子活动结束时间
    isFirst                            =  1,-- bool isFirst 5, --多轮-子活动-是否第一轮
    isLast                             =  1,-- bool isLast 6, --多轮-子活动-是否最后一轮
}
