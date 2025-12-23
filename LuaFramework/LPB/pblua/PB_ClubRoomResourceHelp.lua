-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",
-- import"PB_ItemInfo.proto",

-- 帮助资源
 PB_ClubRoomResourceHelp_Req  =  {
    clubId  =  1,-- int32 clubId ,-- 公会ID
    msgId  =  2,-- int32 msgId ,-- 消息ID
}

 PB_ClubRoomResourceHelp_Res  =  {
    chatMsg  =  1,-- PB_ClubChatMsg chatMsg ,-- 消息修改结果，帮助结果
    reward  =  2,-- repeated PB_ItemInfo , -- 奖励信息，帮助后会会获得一定的资源奖励
}