-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_TaskInfo.proto",

 PB_TaskNewNotify_Req  =  {
}

 PB_TaskNewNotify_Res  =  {
    mainTask  =  1,--	repeated PB_TaskInfo ,--主线任务组
    quickTask  =  2,--	repeated PB_TaskInfo ,--限时任务组
    dailyTask  =  3,--	repeated PB_TaskInfo ,--日常任务组
    weeklyTask  =  4,--	repeated PB_TaskInfo ,--周常任务组
    taskPassTask  =  5,--	repeated PB_TaskInfo ,--短令牌任务
    playId  =  6,--	int32 playId , --玩法Id 短令牌任务更新时有返回
}