-- syntax =  "proto3",
-- import"PB_WeekRankInfo.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_WeekTierStage.proto",
-- import"PB_WeekRankPlayer.proto",
-- packageGPBClass.Message,

 PB_WeekNewRank_Req  =  {
}

 PB_WeekNewRank_Res  =  {
    section  =  1,-- repeated int32  [packed  =  true],--不同区间数量，前端根据数量计算百分比
    mySectionIndex  =  2,-- int32 mySectionIndex ,--玩家在section中结算之后所属榜单列表下标
    showRankList  =  3,-- repeated PB_WeekRankInfo ,--显示榜单列表
    flushUnix  =  4,-- int32 flushUnix ,--下次刷新榜单时间戳
    isFirst  =  5,-- bool isFirst ,--是否是第一名
    nextReward  =  6,-- repeated PB_ItemInfo ,--下阶段对应奖励
    nextTiersNeedScore  =  7,-- int32 nextTiersNeedScore ,--下一段为需要分数
    nextTiersPer  =  8,-- int32 nextTiersPer ,--下一阶段百分比
    openWeekRankTime  =  9,-- int32 openWeekRankTime ,--下次开启周榜时间
    isShowBlackGoldBG  =  1,-- bool isShowBlackGoldBG 0,--是否展示黑金色背景
    isTrueGoldUser  =  1,-- bool isTrueGoldUser 1 ,--是否是真金周榜用户
    topOnePlayerData  =  1,-- PB_WeekRankInfo topOnePlayerData 2, --第一名玩家数据
    allTierStage  =  1,-- repeated PB_WeekTierStage 3, --阶段奖励数据
    stageBeforePlayers  =  1,-- repeated PB_WeekRankPlayer 4,--和uid同一阶段[前端根据分数区间自己判断]-uid-前面玩家数据【非空直接展示，空-使用stageBeforePlayerNum】
    stageAfterPlayers  =  1,-- repeated PB_WeekRankPlayer 5,--和uid同一阶段[前端根据分数区间自己判断]-uid-后面玩家数据【非空直接展示，空-使用stageAfterPlayerNum】
    stageBeforePlayerNum  =  1,-- int32 stageBeforePlayerNum 6,--和uid同一阶段-uid-前面玩家数量
    stageAfterPlayerNum  =  1,-- int32 stageAfterPlayerNum 7,--和uid同一阶段-uid-后面玩家数量
    level  =  1,-- int32 level 8,--玩家游戏难度
    isNewConf  =  1,-- bool isNewConf 9,--是否使用新配置表
}