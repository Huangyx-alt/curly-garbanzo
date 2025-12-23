-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ActivityRoundData.proto",

 PB_ActivityInfo  =  {
    id                                    =  1,-- int32 id , --活动id
    createTime                            =  3,-- int32 createTime , --活动开始时间-时间戳
    expireTime                            =  2,-- int32 expireTime , --活动结束时间-时间戳
    hasRoundData                          =  4,-- int32 hasRoundData , --周期内是否有多轮 0-无多轮，1-有多轮
    roundData    =  5,-- repeated PB_ActivityRoundData , --周期内有多轮时 如果不为空 取第一个为当前轮子活动数据
    hasHistoryReward                      =  6,-- int32 hasHistoryReward , --0-无 1-有 是否有历史未领取奖励,优先弹框发PB_ActivityHistoryReceiveReward领取【有邮件后也可以点击邮件发PB_ActivityHistoryReceiveReward领取】

}
