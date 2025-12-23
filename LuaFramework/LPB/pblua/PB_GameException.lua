-- syntax =  "proto3",

-- packageGPBClass.Message,
 PB_GameException_Req  =  {
}
--******收到游戏战斗中请求 出现异常-统一协议推送错误码 *********--
 PB_GameException_Res  =  {
    code  =  1,-- int32  code , 					    --错误码 RET
    data  =  2,-- string data , 					    --空或json字符串-需要参数的客户端进行解析
}
