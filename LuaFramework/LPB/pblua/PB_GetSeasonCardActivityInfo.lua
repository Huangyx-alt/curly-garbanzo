-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_GetSeasonCardActivityInfo_Res  =  {
    createTime                            =  1,-- int32 createTime , --活动开始时间-时间戳
    expireTime                            =  2,-- int32 expireTime , --活动结束时间-时间戳
    isSeasonCardOpen                       =  3,-- bool isSeasonCardOpen , --活动是否开启
    hasNewSeasonCard                       =  4,-- bool hasNewSeasonCard , --是否有新的卡片
    bagList           =  5,-- repeated PB_SeasonBagInfo , --卡包列表
    seasonID                              =  6,-- int32 seasonID , --赛季ID
}

 PB_SeasonBagInfo  =  {
    bagID                               =  1,-- string bagID , --卡包id
    status                               =  2,-- int32 status , --状态 0-未领取，1-已领取
}