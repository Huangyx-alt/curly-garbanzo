-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_RouletteReward_Req  =  {
}

 PB_RouletteReward_Res  =  {
    recordId                      =  1,-- int32  recordId ,--奖励记录ID
    rewardId             =  2,-- repeated int32  ,--奖励序号ID   正常转盘结算（有值）、登录领奖（为 空）
    reward          =  3,-- repeated PB_ItemInfo ,--奖励内容  id = >数量
    rouletteConfId        =  4,-- repeated int32  ,--转盘配置ID  （免费、首次付费）只有1个，（付费后）2个配置
    nextTime                       =  5,-- int32 nextTime ,--下一次可玩游戏时间戳（倒计时结束，可玩游戏），CD结束为0
}