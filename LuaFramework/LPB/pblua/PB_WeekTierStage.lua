-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- import"PB_WeekStageInfo.proto",
-- import"PB_WeekRankPlayer.proto",
-- packageGPBClass.Message,

 PB_WeekTierStage  =  {
    tier                                =  1,-- int32  tier ,--段位
    tierPlayerNum                       =  2,-- int32  tierPlayerNum ,--段位玩家数量
    tierReward            =  3,-- repeated PB_ItemInfo ,--段位奖励
    stageList       =  4,-- repeated PB_WeekStageInfo ,--阶段分割数据
    topPlayers      =  5,-- repeated PB_WeekRankPlayer ,--前3玩家数据
}