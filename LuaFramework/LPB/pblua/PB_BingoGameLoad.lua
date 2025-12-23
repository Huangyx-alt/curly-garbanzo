-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_CardPos.proto",
-- import"PB_BingoGameCardInfo.proto",
-- import"PB_PowerUpListData.proto",

 PB_BingoGameLoad_Req  =  {
    cardNum             =  1,-- int32 cardNum , -- 卡片数量
    rate                =  2,-- int32 rate , -- 下注档位
    couponId            =  3,-- int32 couponId , -- 优惠券ID
    playId              =  4,-- int32 playId , -- 玩法ID
    hideCardAuto        =  5,-- int32 hideCardAuto , -- 是否自动盖章-额外消耗 0-不开启 1-开启
    sceneId             =  6,-- int32 sceneId , -- 场景ID
}

 PB_BingoGameLoad_Res  =  {
    gameId                                       =  1,-- string gameId ,   -- 游戏id
    cardsInfo             =  2,-- repeated PB_BingoGameCardInfo ,   -- 卡牌列表
    bingoLeft                                     =  3,-- int32 bingoLeft ,   -- 剩余Bingo总数
    systemTime                                    =  4,-- int32 systemTime ,   -- 服务器当前时间戳
    callCd                                        =  5,-- int32 callCd ,   -- 服务器叫号间隔
    publishNumbers                       =  6,-- repeated int32  ,  -- 叫号列表
    mixCallNumbers                       =  7,-- repeated int32  ,  -- 可选混淆叫号
    bingoRuleId                          =  8,-- repeated int32  ,  -- Bingo规则ID
    bingoLeftTick                        =  9,-- repeated int32  ,  -- 扣减时间线 客户端 按照游戏间隔换算 单位：1/100秒
    robotIds                             =  1,-- repeated int32 0 , -- 机器人集合
    cardCallHitPos                  =  1,-- repeated PB_CardPos 1,  -- 卡牌-叫号命中坐标
    cardAllHitPos                   =  1,-- repeated PB_CardPos 2,  -- 卡牌-盖章命中坐标
    bingoMax                                      =  1,-- int32 bingoMax 3,  -- 最大bingo数
    extra                                        =  1,-- string extra 4,  -- 额外数据JSON
    powerUpData                      =  1,-- PB_PowerUpListData powerUpData 5,  -- PU技能数据
}
