-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_GameMoneyMansionSpin_Req  =  {
    rate  =  1,-- int32 rate ,   -- 下注档位
}

 PB_GameMoneyMansionSpin_Res  =  {
    rate  =  1,-- int32 rate ,                   -- 下注档位
    totalBet  =  2,-- int32 totalBet ,               -- 档位消耗钻石值
    totalWin  =  3,-- int64 totalWin ,               -- 总奖励值
    freeSpinTimes  =  4,-- int32 freeSpinTimes ,          -- 免费 Spin 次数
    position  =  5,-- int32 position ,               -- 滚动停止位置
    reward  =  6,-- PB_MoneyMansionReward reward , -- 奖励信息
}

 PB_MoneyMansionReward  =  {
    type  =  1,-- int32 type ,                   -- 奖励类型
    freeSpinTimes  =  2,-- int32 freeSpinTimes ,          -- 新增的免费次数，type  =  =  4
    positions  =  3,-- repeated int32   ,    -- 新的奖励位置，type  =  =  3 / 2
    coinReward  =  4,-- int64 coinReward ,             -- 金币奖励值
}