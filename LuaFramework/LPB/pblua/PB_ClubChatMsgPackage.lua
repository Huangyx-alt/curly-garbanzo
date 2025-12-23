-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatMsg.proto",

-- 公会消息包，定义消息内容，同步前后消息
 PB_ClubChatMsgPackage  =  {
    clubId  =  1,-- int32 clubId , -- 消息包开始消息ID
    beginMsgId  =  2,-- int32 beginMsgId , -- 消息包开始消息ID
    endMsgId  =  3,-- int32 endMsgId ,-- 消息包起始消息ID
    msgNum  =  4,-- int32 msgNum ,-- 消息数量
    maxMsgId  =  5,-- int32 maxMsgId ,--
    hasMore  =  6,-- bool hasMore ,-- 是否有更多的消息
    chatMsg  =  7,-- repeated PB_ClubChatMsg , -- 聊天消息内容
}
