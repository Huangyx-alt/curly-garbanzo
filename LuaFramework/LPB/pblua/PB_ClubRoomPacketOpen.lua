-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",

-- 打开礼盒
 PB_ClubRoomPacketOpen_Req  =  {
    clubId  = 1,-- int32 clubId ,-- 公会ID
    msgId  = 2,-- int32 msgId ,-- 消息ID
}

 PB_ClubRoomPacketOpen_Res  =  {
    chatMsg  = 1,-- PB_ClubChatMsg chatMsg ,-- 消息修改结果，帮助结果
}