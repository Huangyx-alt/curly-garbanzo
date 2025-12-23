-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_Reward.proto",
-- import"PB_Material.proto",
-- import"PB_TaskInfo.proto",

 PB_TaskReceiveReward_Req  =  {
    params  =  1,--	repeated PB_TaskReceiveReward ,
}

 PB_TaskReceiveReward_Res  =  {
    reward  =  1,-- PB_Reward reward ,--奖励物资
    convertReward  =  2,--	PB_Reward convertReward ,--多余道具转化资源
    updated  =  3,--	PB_Material updated ,--更新结果集合
    nextTaskId  =  4,--	int32 nextTaskId , --下一个任务Id 0表示该组任务结束
    nextTask  =  5,--	PB_TaskInfo nextTask ,--下一个任务参数
    taskType  =  6,--	int32 taskType , --任务类型
    taskGroup  =  7,--	int32 taskGroup , --任务组id
}


 PB_TaskReceiveReward  =  {
    taskType  =  1,-- int32 taskType , --任务类型 1-主线任务 2-限时任务 3-日常任务 4-周任务 7-短令牌每日任务
    taskGroup  =  2,--	int32 taskGroup , --任务组id
    taskId  =  3,--	int32 taskId , --任务Id
    createTime  =  4,--	int32 createTime , --任务id领取时间-区分同一轮多次
    rewardExtra  =  5,--	int32 rewardExtra , --任务额外奖励，0没有1有
    playId  =  6,--	int32 playId , --玩法Id 短令牌任务必须
}