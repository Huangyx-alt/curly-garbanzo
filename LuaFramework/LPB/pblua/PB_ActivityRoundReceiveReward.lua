-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ItemInfo.proto",

 PB_ActivityRoundReceiveReward_Req  =  {
    activityId    =  1,--	int32 activityId , --活动id（存在子活动）
    roundId       =  2,-- int32 roundId , --活动id下的子活动id 参考 activity_round
    createTime    =  3,-- int32 createTime , --子活动id开始时间-和 activityId roundId 一起确定
    rewardExtra   =  4,-- int32 rewardExtra , --任务额外奖励，0没有 1有 【仅为保持前端表现结果一致 可能废弃】
}

 PB_ActivityRoundReceiveReward_Res  =  {
    reward  =  1,-- repeated PB_ItemInfo ,--奖励物资[不包含多余道具转化]
}
