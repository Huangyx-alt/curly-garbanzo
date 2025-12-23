-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_CardPosInfo  =  {
    pos                               =  1,-- int32 pos , -- 格子坐标 11,22,33
    itemReward         =  2,-- repeated PB_ItemInfo , -- 格子奖励
    markState                         =  3,-- int32 markState , -- 盖章状态，0-没盖章，1-叫号盖章，puId-对应的puId
}