-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubPlayerRankData.proto",
-- import"PB_ClubTeamRankData.proto",

--club榜单查询
 PB_ClubTypeQuery_Req  =  {
    type = 1,-- int32 type ,--0-全部 1-前N名player数据列表 2-前N名club数据列表
}

 PB_ClubTypeQuery_Res  =  {
    topPlayers = 1,-- repeated PB_ClubPlayerRankData ,--用户所属club成员数据列表
    topClubs = 2,-- repeated PB_ClubTeamRankData ,--全部club数据列表
}