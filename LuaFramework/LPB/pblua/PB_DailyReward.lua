-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ResourceInfo.proto",
 PB_DailyReward_Req  =  {
    dailyRewardType  =  1,-- int32 dailyRewardType , --登录每日奖励类型登录时返回 1-免费用户 2-付费用户
}

 PB_DailyReward_Res  =  {
    canReceive  =  1,-- int32 canReceive ,--  1可以领奖,0不可以
    reward  =  2,-- repeated PB_ResourceInfo ,--领奖结果
}