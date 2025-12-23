-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ItemInfo.proto",
-- import"PB_StageRewardInfo.proto",
 PB_TaskReceiveStageReward_Req  =  {
    taskType  =  1,--	int32 taskType , --任务类型 1-主线任务 2-限时任务 3-日常任务
    stage  =  2,--	int32 stage , --进度
}

 PB_TaskReceiveStageReward_Res  =  {
    rewared  =  1,-- repeated PB_ItemInfo ,--物品
    dailyStage  =  2,-- repeated PB_StageRewardInfo ,--日常阶段奖励
    weeklyStage  =  3,-- repeated PB_StageRewardInfo ,--周常阶段奖励
}