-- syntax =  "proto3",
-- import"PB_WeekRankInfo.proto",
-- packageGPBClass.Message,

 PB_WeekRank_Req  =  {
}

 PB_WeekRank_Res  =  {
    section  =  1,-- repeated int32  [packed  =  true],--不同区间数量，前端根据数量计算百分比
    mySectionIndex  =  2,-- int32 mySectionIndex ,--玩家在section中结算之后所属榜单列表下标
    showRankList  =  3,-- repeated PB_WeekRankInfo ,--显示榜单列表
    flushUnix  =  4,-- int32 flushUnix ,--下次刷新榜单时间戳
}