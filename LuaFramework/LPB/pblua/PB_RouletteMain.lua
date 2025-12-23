-- syntax =  "proto3",
-- packageGPBClass.Message,

 PB_RouletteMain_Req  =  {
}

 PB_RouletteMain_Res  =  {
    rouletteConfId       =  1,-- repeated int32  ,--转盘配置ID  活动未开启 为[] ,（免费、首次付费）只有1个，（付费后）2个配置
    nextTime                      =  2,-- int32 nextTime ,--下一次可玩游戏时间戳（倒计时结束，可玩游戏），CD结束为0
    string                       =  3,--异常提示
    code                          =  4,-- int32 code ,--接口返回码  0成功  1失败
}