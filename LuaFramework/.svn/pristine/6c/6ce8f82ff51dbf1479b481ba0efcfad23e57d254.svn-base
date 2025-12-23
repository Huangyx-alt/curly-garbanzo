-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubNormalMsgPackage.proto",

-- 查询消息，前端主动查询，只会返回历史消息，后端主动推送最新消息
 PB_FetchClubMsg_Req  =  {
    msgId  = 1,-- int32 msgId ,-- 开始查询ID
    history  = 2,-- bool history ,--基于msgId前后 true = 历史数据 或者是 false-最新数据
}
 PB_FetchClubMsg_Res  =  {
    msgPackage = 1,-- repeated PB_ClubNormalMsgPackage , -- 聊天包内容
}