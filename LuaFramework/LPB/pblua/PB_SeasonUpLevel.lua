-- syntax =  "proto3",
-- packageGPBClass.Message,

 PB_SeasonUpLevel_Req  =  {
}

 PB_SeasonUpLevel_Res  =  {
    level                            =  1,--	int32 level ,--更新后的等级
    exp                              =  2,--	int32 exp ,--更新后的经验值
    lastLevel                        =  3,--	int32 lastLevel ,--更新前的等级
    lastExp                          =  4,--	int32 lastExp ,--更新前的经验值
    expCount                         =  5,--	int32 expCount ,--更新后的总经验值
    lastExpCount                     =  6,--	int32 lastExpCount ,--更新前的总经验值
    hasReward                         =  7,--	bool hasReward ,--是否有未领取奖励  true有  false无
}