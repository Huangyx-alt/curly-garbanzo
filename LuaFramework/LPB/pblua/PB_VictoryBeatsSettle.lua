-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_VictoryBeatsRoleInfo.proto",
-- import"PB_ItemInfo.proto",

 PB_VictoryBeatsSettle_Res  =  {
    allRound  =  1,-- int32 allRound , -- 总局数
    curRound  =  2,-- int32 curRound , -- 当前局
    roles  =  3,-- repeated PB_VictoryBeatsRoleInfo , -- 当前轮数玩家列表
    isDisuse  =  4,-- bool isDisuse , -- 是否淘汰
    canRelive  =  5,-- bool canRelive , -- 是否可复活
    reward  =  6,-- repeated PB_ItemInfo ,--当前可奖励内容
    reliveTimes  =  7,-- int32 reliveTimes , -- 复活次数
    reliveNeedCoin  =  8,-- int32 reliveNeedCoin , -- 复活所需复活币
    lastPlayTime  =  9,-- int32 lastPlayTime , -- 最后的 play 开启时间
    isAtGameOver  =  1,-- bool isAtGameOver 0, -- 是否为对局结束的数据，告知前端状态
    roundResult  =  1,-- repeated PB_UserRoundResult 1, -- 结算排名数据
}

 PB_UserRoundResult  =  {
    round  =  1,-- int32 round ,  -- 对应局数
    rank  =  2,-- int32 rank ,   -- 排名
    status  =  3,-- int32 status , -- 用户状态0-ready 1-晋级 2-淘汰 3-复活
    noteNum  =  4,-- int32 noteNum ,  -- 获得音符数量
}