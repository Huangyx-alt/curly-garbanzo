-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_Material.proto",

 PB_ReceiveTaskReward_Req  =  {
    taskId  =  1,-- int32 taskId , --任务Id
    taskType  =  2,--	int32 taskType , --任务类型 1-主线任务 2-限时任务 3-日常任务
}

 PB_ReceiveTaskReward_Res  =  {
    reward  =  1,-- PB_Material reward ,--奖励物资集合
    updated  =  2,--	PB_Material updated ,--更新结果集合
    nextTaskId  =  3,--	int32 nextTaskId , --下一个任务Id 0表示该组任务结束
}