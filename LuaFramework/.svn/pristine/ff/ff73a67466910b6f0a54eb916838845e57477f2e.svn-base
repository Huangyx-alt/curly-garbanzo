-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_GameMoneyMansionInfo_Req  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID，为空或不存在对应数据时，重置游戏
    gameRate  =  2,-- int32 gameRate ,             -- 游戏对局档位
    playId  =  3,-- int32 playId ,               -- 玩法ID
}

 PB_GameMoneyMansionInfo_Res  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID，可为空，为空重置游戏
    curRate  =  2,-- int32 curRate ,              -- 当前使用的档位
    freeSpinTimes  =  3,-- int32 freeSpinTimes ,        -- 免费 Spin 次数
    totalBetList  =  4,-- repeated PB_MoneyMansionBetList ,    -- totalBet 列表
    totalWin  =  5,-- int64 totalWin ,             -- 总奖励值
}

 PB_MoneyMansionBetList  =  {
    rate  =  1,-- int32 rate ,                 -- 档位
    totalBet  =  2,-- int32 totalBet ,             -- 档位消耗钻石值
}