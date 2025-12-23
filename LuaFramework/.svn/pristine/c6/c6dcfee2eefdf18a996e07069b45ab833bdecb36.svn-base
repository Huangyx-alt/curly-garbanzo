-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ClubPlayerInfo.proto",

-- 公会消息
 PB_ClubChatMsg  =  {
    type  =  1,-- int32 type , -- 消息类型，CHAT_MESSAGE_TYPE
    msgId  =  2,-- int32 msgId ,-- 消息序号ID
    sendTime  =  3,-- int32 sendTime ,-- 发送时间
    msgBase64  =  4,-- string msgBase64 ,-- base64 编码的 probuf 协议内容，需要跟进消息类型使用不同协议进行解析
    extMsg  =  5,-- string extMsg ,-- 消息额外的 json 数据
    info  =  6,-- PB_ClubPlayerInfo info ,-- 发送者信息，系统消息发送 uid  =  0
    msgUnix  =  7,-- int32  msgUnix ,--消息过期时间 0-不过期
    status  =  8,-- int32 status ,--0-正常 1-撤回 2-过期
}