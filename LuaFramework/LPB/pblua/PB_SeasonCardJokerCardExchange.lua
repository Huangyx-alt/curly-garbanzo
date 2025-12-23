-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SeasonCardInfo.proto",

 PB_SeasonCardJokerCardExchange_Req  =  {
    seasonId  =  1,-- int32 seasonId , -- 赛季卡Id
    cardId  =  2,-- int32 cardId , -- 交换得到的cardId
}

 PB_SeasonCardJokerCardExchange_Res  =  {
    completeGroups  =  1,-- repeated int32  , -- 完成收集的卡组
    isAlbumComplete  =  2,-- bool isAlbumComplete , -- 卡册是否完成收集
    cardInfo  =  3,-- PB_SeasonCardInfo cardInfo , -- 卡片信息
    jokerCards                    =  4,-- repeated int32  , -- 小丑卡(过期时间戳)
    seasonId                  =  5,-- int32 seasonId , -- 赛季卡Id
}
