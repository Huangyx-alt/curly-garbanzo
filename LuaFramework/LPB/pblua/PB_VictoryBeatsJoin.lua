-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_VictoryBeatsRoleInfo.proto",

 PB_VictoryBeatsJoin_Req  =  {
    roundType  =  1,-- int32 roundType ,  --轮制类型
}

 PB_VictoryBeatsJoin_Res  =  {
    allRound  =  1,-- int32 allRound , -- 总局数
    curRound  =  2,-- int32 curRound , -- 当前局
    players  =  3,-- repeated PB_VictoryBeatsJoinList , -- 集结列表
    lastPlayTime  =  4,-- int32 lastPlayTime , -- 最后的 play 开启时间
}

-- 集合列表
 PB_VictoryBeatsJoinList  =  {
    joinTime  =  1,-- int32 joinTime , --加入时间
    role  =  2,-- PB_VictoryBeatsRoleInfo role , -- 集结用户信息
}