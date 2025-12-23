-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_SeasonCardBoxInfo.proto",
-- import"PB_SeasonCardGroupInfo.proto",

-- 卡册信息
 PB_SeasonCardAlbumInfo  =  {
    seasonId                              =  1,-- int32 seasonId , --赛季ID，也是卡册ID
    isSeasonCardOpen                       =  2,-- bool isSeasonCardOpen , --卡册是否开启
    createTime                            =  3,-- int32 createTime , --活动开始时间-时间戳
    expireTime                            =  4,-- int32 expireTime , --活动结束时间-时间戳
    hasNewSeasonCard                       =  5,-- bool hasNewSeasonCard , --是否有新的卡片
    reward                 =  6,-- repeated PB_ItemInfo ,--奖励数值
    isRewarded                             =  7,-- bool isRewarded , --是否已经领取奖励
    isCompleted                            =  8,-- bool isCompleted , -- 是否已经收集完成
    groups      =  9,-- repeated PB_SeasonCardGroupInfo , -- 卡组信息
    bags          =  1,-- repeated PB_SeasonCardBagInfo 0, -- 未打开的卡包列表
    boxes          =  1,-- repeated PB_SeasonCardBoxInfo 1, -- 宝箱列表
    jokerCards                    =  1,-- repeated int32 2 , -- 小丑卡(过期时间戳)
    version                                =  1,-- int32 version 3, -- 压缩包版本号，检查压缩包是否有更新
}

 PB_SeasonCardBagInfo  =  {
    bagId  =  1,-- int32 bagId , -- 卡包Id,
    num  =  2,-- int32 num , --数量
}