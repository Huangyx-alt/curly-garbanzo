-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsgPackage.proto",
-- import"PB_ClubChatMsg.proto",
-- import"PB_ClubPacket.proto",
-- import"PB_ResourceAskItems.proto",
-- import"PB_Club.proto",
-- import"PB_ClubWeeklyLeader.proto",

-- 查询公会房间内容
 PB_ClubFetchRoomInfo_Req  =  {
    clubId  =  1,-- int32 clubId ,--
}
 PB_ClubFetchRoomInfo_Res  =  {
    resourceAskCdTime  =  1,-- int32 resourceAskCdTime ,-- 资源请求CD时间
    seasonCardAskCdTime  =  2,-- int32 seasonCardAskCdTime ,-- 卡牌请求CD时间
    msgPackage  =  3,-- PB_ClubChatMsgPackage msgPackage , -- 聊天包内容
    clubInfo  =  4,-- PB_Club clubInfo ,-- 公会信息
    packetMsg  =  5,-- repeated PB_ClubChatMsg ,-- 置顶礼盒消息
    clubPackets  =  6,-- repeated PB_ClubPacket ,-- 用户公会可发送礼盒列表
    askItems  =  7,-- repeated PB_ResourceAskItems , -- 资源请求列表
    weeklyLeader  =  8,--	repeated PB_ClubWeeklyLeader ,--右上角列表 目前数量仅1个
}
