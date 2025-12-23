-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_VictoryBeatsExit_Req  =  {
    exitType  =  1,-- int32 exitType , -- 1-用户主动退出 2-系统退出
}

 PB_VictoryBeatsExit_Res  =  {
    reward  =  1,-- repeated PB_ItemInfo ,--奖励数值
}