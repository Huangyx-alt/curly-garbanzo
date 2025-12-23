-- syntax =  "proto3",
-- import"PB_WeekRankInfo.proto",
-- packageGPBClass.Message,

 PB_WeekNewRankSettle_Req  =  {
}

 PB_WeekNewRankSettle_Res  =  {
    section  =  1,-- repeated int32  [packed  =  true],--不同区间数量，前端根据数量计算百分比
    rankList  =  2,-- repeated PB_NewRankSettle ,--升段前后榜单列表，未升段列表就只有1个，有升段就有多个
    diff  =  3,-- int32 diff ,--玩家游戏难度
    flushUnix  =  4,-- int32 flushUnix ,--下次刷新榜单时间戳
    isShowBlackGoldBG  =  5,-- bool isShowBlackGoldBG ,--是否展示黑金色背景
    isTrueGoldUser  =  6,-- bool isTrueGoldUser  ,--是否是真金周榜用户
    level  =  7,-- int32 level ,--玩家游戏难度
    isNewConf  =  8,-- bool isNewConf ,--是否使用新配置表
}

 PB_NewRankSettle  =  {
    mySectionIndex  =  1,-- int32 mySectionIndex ,--玩家游戏结算之后所属榜单列表下标    未升段 结算后排名 / 有升段  =  {升段前 1，升段后 结算后排名}
    lastSectionIndex  =  2,-- int32 lastSectionIndex ,--玩家游戏结算之前所属榜单列表下标    未升段 结算前排名 / 有升段  =  {升段前 结算前排名，升段后 结算后排名}
    myTier  =  3,-- int32 myTier ,--玩家游戏结算之后所属段位           未升段 升段后段位 / 有升段  =  {升段前 结算后段位，升段后 结算后段位}
    lastTier  =  4,-- int32 lastTier ,--玩家游戏结算之前所属段位           未升段 升段前段位 / 有升段  =  {升段前 结算前段位，升段后 结算后段位}
    myScore  =  5,-- int32 myScore ,--结算后积分
    lastScore  =  6,-- int32 lastScore ,--结算前积分
    showRankList  =  7,-- repeated PB_WeekRankInfo ,--显示榜单列表（动画展示）
    nextTiersScore  =  8,-- int32 nextTiersScore ,--到达下一个段位需要的积分值
    topOnePlayerData  =  9,-- PB_WeekRankInfo topOnePlayerData , --第一名玩家数据
}