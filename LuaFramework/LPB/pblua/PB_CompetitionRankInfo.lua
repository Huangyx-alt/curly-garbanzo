-- syntax =  "proto3",
-- packageGPBClass.Message,

 PB_CompetitionRankInfo  =  {
    order      =  1,-- int32  order ,--排名
    uid        =  2,-- int32  uid ,--uid or robotId
    robot      =  3,-- int32  robot ,--普通用户0    机器人1
    nickname   =  4,-- string nickname ,--昵称
    avatar     =  5,-- string avatar ,--头像
    score      =  6,-- int32  score ,--奖杯数量
    gameProps    =  7,-- repeated int32  ,--游戏加成道具
}

