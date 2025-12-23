-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsgPackage.proto",

--拉取消息
 PB_ClubRoomFetchMsg_Req  =  {
    clubId  =  1,-- int32 clubId ,-- 公会ID
    msgId  =  2,-- int32 msgId ,-- 开始查询ID
    history  =  3,-- bool history ,--基于msgId前后 true = 历史数据 或者是 false-最新数据
}

 PB_ClubRoomFetchMsg_Res  =  {
    msgPackage  =  1,-- PB_ClubChatMsgPackage msgPackage , -- 聊天包内容
}