-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",

-- 帮助-季赛卡包
 PB_ClubRoomSeasonCardHelp_Req  =  {
    clubId  = 1,-- int32 clubId ,-- 公会ID
    msgId  =  2,-- int32 msgId  ,--
    seasonId  =  3,-- int32 seasonId  ,-- 卡包赛季Id
}
 PB_ClubRoomSeasonCardHelp_Res  =  {
    chatMsg = 1,-- PB_ClubChatMsg chatMsg , -- 消息修改结果，帮助结果
}