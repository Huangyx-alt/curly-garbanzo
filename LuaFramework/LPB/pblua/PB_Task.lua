-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_TaskInfo.proto",
-- import"PB_StageRewardInfo.proto",
 PB_Task_Req  =  {
    type  =  1,-- int32 type , --类型，0-全部,1-主线任务 2-限时任务 3-日常任务 
}

 PB_Task_Res  =  {
    mainTask  =  1,--	repeated PB_TaskInfo ,--主线任务组
    quickTask  =  2,--	repeated PB_TaskInfo ,--限时任务组
    dailyTask  =  3,--	repeated PB_TaskInfo ,--日常任务组
    weeklyTask  =  4,--	repeated PB_TaskInfo ,--周常任务组
    dailyStage  =  5,--	repeated PB_StageRewardInfo ,--日常阶段奖励
    weeklyStage  =  6,--	repeated PB_StageRewardInfo ,--周常阶段奖励
    dailyEndTime  =  7,--	int32 dailyEndTime ,
    weeklyEndTime  =  8,--	int32 weeklyEndTime ,
}