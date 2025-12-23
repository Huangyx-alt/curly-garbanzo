-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_ShortSeasonPassReceiveReward_Req  =  {
    playId  =  1,-- int32 playId , -- 玩法Id
}

 PB_ShortSeasonPassReceiveReward_Res  =  {
    reward  =  1,-- repeated PB_ItemInfo ,--奖励数值
    nowSeason  =  2,-- bool nowSeason ,--是否当前赛季奖励 true 是，false 否
    code  =  3,-- int32 code ,--错误码  0成功  1失败
    string   =  4,--错误提示
}