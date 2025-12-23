-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_TaskInfo  =  {
    taskType  =  1,-- int32 taskType , --任务类型
    taskGroup  =  2,--	int32 taskGroup , --任务组别
    taskSubType  =  3,--	int32 taskSubType , --任务事件
    taskId  =  4,-- int32 taskId , --任务ID
    taskDesc  =  5,-- string taskDesc , --任务描述
    createTime  =  6,-- int64 createTime , --领取时间
    expireTime  =  7,-- int64 expireTime , --过期时间
    process  =  8,-- string process , --任务进度
    target  =  9,-- string target , --任务目标
    completed  =  1,-- bool completed 0, --是否已达成
    rewarded  =  1,-- bool rewarded 1, --是否已领奖
    failed  =  1,-- bool failed 2, --是否已失败
    oldProcess  =  1,-- string oldProcess 3, --老的任务进度
    reward  =  1,-- repeated PB_ItemInfo 4,--完成任务可获得的奖励
    icon  =  1,-- string icon 5, --任务icon
    city  =  1,-- int32 city 6, --日常任务所属城市
    isDifficult  =  1,-- bool isDifficult 7, --是否困难任务
    order  =  1,-- int32 order 8, --任务顺序
}