-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SeasonCardAlbumInfo.proto",

-- 查询赛季信息
 PB_FetchSeasonCardAlbumInfo_Req  =  {
    seasonId                           =  1,-- int32 seasonId , --查询赛季信息，为空默认当前赛季
}
 PB_FetchSeasonCardAlbumInfo_Res  =  {
    seasonId                           =  1,-- int32 seasonId , -- 当前赛季信息，或者查询赛季ID
    curSeasonId                           =  2,-- int32 curSeasonId , -- 当前赛季信息
    curAlbum             =  3,-- PB_SeasonCardAlbumInfo curAlbum , -- 当前赛季卡信息
    albums   =  4,-- repeated PB_SeasonCardAlbumInfo , -- 卡册列表，如果有seasonId传参,不返回数据
    sourceBaseUrl                     =   5,-- string sourceBaseUrl , -- 资源Base Url ep: https:--d24rbv31oqc5gm.cloudfront.net/SeasonCard/，拼接url为 ep: 1/1.zip 01card.png...
}

