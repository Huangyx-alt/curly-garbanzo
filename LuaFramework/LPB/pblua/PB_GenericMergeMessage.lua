-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_MessageBase64List.proto",
 PB_GenericMergeMessage_Req  =  {
    reqMsg  =  1,-- repeated PB_RequestBase64 , -- 请求数据
    isLogin  =  2,-- bool isLogin , -- 是否为登录时的请求，会附带登录时，其他非主动请求消息
}
 PB_GenericMergeMessage_Res  =  {
    dealMsgIds  =  1,-- repeated int32 , -- 成功处理的消息ID
    nextMessages  =  2,-- repeated PB_MessageBase64List , -- 额外消息
}

 PB_RequestBase64  =  {
    msgId  =  1,-- int32 msgId ,        -- 请求消息ID
    msgBase64  =  2,-- string msgBase64 ,   -- 请求消息 base64 MSG
}