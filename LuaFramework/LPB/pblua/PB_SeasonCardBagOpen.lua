-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SeasonCardInfo.proto",

 PB_SeasonCardBagOpen_Req  =  {

}

 PB_SeasonCardBagOpen_Res  =  {
    seasons  =  1,-- repeated PB_SeasonCardOpenBagSeasonInfo ,
}

 PB_SeasonCardOpenBagSeasonInfo  =  {
    bags  =  1,-- repeated PB_SeasonCardBagOpenInfo , -- 打开卡包列表
    completeGroups  =  2,-- repeated int32  , -- 完成收集的卡组
    isAlbumComplete  =  3,-- bool isAlbumComplete , -- 卡册是否完成收集
    jokerCards          =  4,-- repeated int32  , -- 小丑卡(过期时间戳)
    seasonId  =  5,-- int32 seasonId , -- 赛季卡Id
}

 PB_SeasonCardBagOpenInfo  =  {
    bagId  =  1,-- int32 bagId , -- 卡包id
    cards  =  2,-- repeated PB_SeasonCardInfo , -- 卡片列表
}