-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",
-- import"PB_ClubWeeklyLeader.proto",

-- 查询-广播公会房间公共信息
 PB_ClubRoomUpdateInfo_Req  =  {
}
 PB_ClubRoomUpdateInfo_Res  =  {
    clubId  =  1,-- int32 clubId ,--公会id
    packetMsg  =  5,-- repeated PB_ClubChatMsg ,-- 置顶礼盒消息
    weeklyLeader  =  8,--	repeated PB_ClubWeeklyLeader ,--右上角列表 目前数量仅1个
}
