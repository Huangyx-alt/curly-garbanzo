-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SeasonCardAlbumInfo.proto",

 PB_SeasonCardSeasonSwitchCheck_Req  =  {
    seasonId  =  1,-- int32 seasonId , -- 赛季卡Id
}

 PB_SeasonCardSeasonSwitchCheck_Res  =  {
    seasonId                  =  1,-- int32 seasonId , -- 传参的赛季Id
    curSeasonId               =  2,-- int32 curSeasonId , -- 当前赛季Id
    curAlbum             =  3,-- PB_SeasonCardAlbumInfo curAlbum , -- 当前赛季卡信息
    albums   =  4,-- repeated PB_SeasonCardAlbumInfo , -- 卡册列表，如果有seasonId传参,不返回数据
    sourceBaseUrl                     =   5,-- string sourceBaseUrl , -- 资源Base Url ep: https:--d24rbv31oqc5gm.cloudfront.net/SeasonCard/，拼接url为 ep: 1/1.zip 01card.png...
}
