-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",

-- 请求资源
 PB_ClubRoomResourceAsk_Req  =  {
    clubId  =  1,-- int32 clubId ,-- 公会ID
    askId  =  2,-- int32 askId ,-- 资源请求ID
}

 PB_ClubRoomResourceAsk_Res  =  {
    cdTime  =  1,-- int32 cdTime ,-- CD结束时间
    chatMsg  =  2,-- PB_ClubChatMsg chatMsg , -- 可以考虑直接下发消息
}