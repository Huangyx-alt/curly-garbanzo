-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_VictoryBeatsRoundInfo.proto",

 PB_VictoryBeatsReward_Req  =  {
}

 PB_VictoryBeatsReward_Res  =  {
    reward  =  1,-- repeated PB_ItemInfo ,--奖励数值
    rounds  =  3,-- repeated PB_VictoryBeatsRoundInfo , --可选轮制
}