-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ResourceInfo.proto",

--*******用户回归收益领取***********--
 PB_UserReturnReward_Req  =  {
}
 PB_UserReturnReward_Res  =  {
    isReceive  =  1,-- bool isReceive , --是否领取奖励，true已领取 ， false未领取
    reward  =  2,-- repeated PB_ResourceInfo , --展示-奖励数据
}