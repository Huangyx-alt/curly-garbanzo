-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_SeasonCardReceiveAward_Req  =  {
    type  =  1,-- int32 type , -- 1-相册奖励 2-组奖励 3-卡片奖励 4-卡箱奖励
    seasonId  =  2,-- int32 seasonId , -- 赛季ID
    id  =  3,-- int32 id , -- 领取的资源id，领取相册奖励（seasonId）可不传 ep: seasonId | groupId | cardId | boxId
}


 PB_SeasonCardReceiveAward_Res  =  {
    reward                 =  1,-- repeated PB_ItemInfo ,--奖励数值
    type  =  2,-- int32 type , -- 1-相册奖励 2-组奖励 3-卡片奖励 4-卡箱奖励
    id   =  3,-- int32 id , -- 领取的资源id，领取相册奖励（seasonId）可不传 ep: seasonId | groupId | cardId | boxId
    seasonId   =  4,-- int32 seasonId , -- 赛季ID
}

