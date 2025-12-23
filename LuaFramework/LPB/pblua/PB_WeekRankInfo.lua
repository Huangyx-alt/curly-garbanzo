-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_WeekRankInfo  =  {
    order      =  1,-- int32  order ,--排名
    uid        =  2,-- int32  uid ,--uid or robotId
    robot      =  3,-- int32  robot ,--普通用户0    机器人1
    nickname   =  4,-- string nickname ,--昵称
    avatar     =  5,-- string avatar ,--头像
    score      =  6,-- int32  score ,--分数
    tiers      =  7,-- int32  tiers ,--段位
    reward      =  8,-- repeated PB_ItemInfo ,--对应奖励
    frame      =  9,-- string  frame , --头像框
    buffs      =  1,-- repeated PB_ItemInfo 0,--buff列表
}