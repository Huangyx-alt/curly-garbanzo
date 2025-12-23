-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_SeasonCardGroupInfo.proto",


 PB_GetSeasonCardAlbumInfo_Req  =  {
    seasonID  =  1,-- int32 seasonID , -- 赛季Id，默认当前赛季
}

 PB_GetSeasonCardAlbumInfo_Res  =  {
    reward                 =  1,-- repeated PB_ItemInfo ,--奖励数值
    groupList   =  2,-- repeated PB_SeasonCardGroupInfo , -- 赛季卡组列表
    isRewarded  =  3,-- bool isRewarded , --是否已经领取奖励
    isCompleted  =  4,-- bool isCompleted , -- 是否已经收集完成
    seasonID  =  5,-- int32 seasonID , -- 赛季Id
}

