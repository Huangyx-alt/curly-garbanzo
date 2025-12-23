-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_SeasonRewardReceive_Req  =  {
    index  =  1,-- int32 index ,            -- 领取节点索引，0-全部
    type  =  2,-- int32 type ,             -- 领取类型，0-全部 1-免费 2-付费
}

 PB_SeasonRewardReceive_Res  =  {
    reward           =  1,-- repeated PB_ItemInfo ,--奖励数值
    nowSeason                        =  2,-- bool nowSeason ,--是否当前赛季奖励 true 是，false 否
    code                            =  3,-- int32 code ,--错误码  0成功  1失败
    string                         =  4,--错误提示
}