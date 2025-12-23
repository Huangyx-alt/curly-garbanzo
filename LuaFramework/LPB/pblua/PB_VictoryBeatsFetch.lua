-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_MessageBase64List.proto",
-- import"PB_VictoryBeatsRoundInfo.proto",

 PB_VictoryBeatsFetch_Req  =  {
}

 PB_VictoryBeatsFetch_Res  =  {
    openLevel  =  1,-- int32 openLevel ,--开启等级
    vipOpenLevel  =  2,-- int32 vipOpenLevel , --VIP等级要求
    rounds  =  3,-- repeated PB_VictoryBeatsRoundInfo , --可选轮制
    nextMessages  =  4,-- repeated PB_MessageBase64List ,   --附带其它-推送协议
    payOpenLevel  =  5,-- int32 payOpenLevel , --付费用户开启等级
}
