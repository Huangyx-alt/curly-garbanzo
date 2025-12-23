-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_SlotsGameInfo.proto",

 PB_GameSlotsPiggyBreak_Req  =  {
    gameId  =  1,-- string gameId ,              -- 游戏ID，为空或不存在对应数据时，重置游戏
    isGoAway  =  2,-- bool isGoAway ,              -- 是否离开
}

 PB_GameSlotsPiggyBreak_Res  =  {
    totalWin  =  1,-- int64 totalWin ,             -- 总奖励值
    breakTimes  =  2,-- int32 breakTimes ,           -- 可进行 break 的次数
    gameReward  =  3,-- repeated PB_SlotsGameReward , -- 奖励数据
    spinTimes  =  4,-- int32 spinTimes ,            -- 当前的spin次数
    slotsInfo  =  5,-- PB_SlotsGameInfo slotsInfo , -- 当前slots牌面的数据
}

 PB_SlotsGameReward  =  {
    col  =  1,-- int32 col ,                  -- 元素所在列
    row  =  2,-- int32 row ,                  -- 元素所在行
    pigType  =  3,-- int32 pigType ,              -- 元素类型，1-1*1 2-1*2 3-1*3 4-2*3
    winCoin  =  4,-- int32 winCoin ,              -- 奖励金币值
    wheelItems  =  5,-- repeated PB_BonusWheelItem ,   -- 转盘列表
    wheelIndex  =  6,-- int32 wheelIndex ,           -- 转盘奖励ID
}

 PB_BonusWheelItem  =  {
    index  =  1,-- int32 index ,                -- wheel 索引
    winCoin  =  2,-- int64 winCoin ,              -- 奖励金币值
    isJackpot  =  3,-- bool isJackpot ,             -- 是否为 jackpot
}