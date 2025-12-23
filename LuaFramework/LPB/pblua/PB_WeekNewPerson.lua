-- syntax =  "proto3",
-- import"PB_WeekTiersMedal.proto",
-- packageGPBClass.Message,

 PB_WeekNewPerson_Req  =  {
    uid  =  1,-- int32 uid ,--uid or robot id
    robot  =  2,-- int32 robot ,--普通用户0    机器人1
}

 PB_WeekNewPerson_Res  =  {
    uid                                =  1,-- int32  uid ,--uid
    nickname                           =  2,-- string nickname ,--昵称
    avatar                             =  3,-- string avatar ,--头像
    score                              =  4,-- int32  score ,--分数
    tiers                              =  5,-- int32  tiers ,--段位
    level                              =  6,--	int32  level ,--等级
    exp                                =  7,--	int32  exp ,--经验
    fullExp                            =  8,--	int32  fullExp ,--当前级满需要经验
    info                               =  9,--	string info ,--描述
    ext                                =  1,--	string ext 0,--拓展
    tiersMedal   =  1,-- repeated PB_WeekTiersMedal 1,--段位奖章累计
    frame                                =  1,--	string frame 2,--头像框
}