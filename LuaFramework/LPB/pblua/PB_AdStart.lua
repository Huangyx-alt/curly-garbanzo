-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_AdStart_Req  =  {
    adEvent  =  1,--	int32 adEvent , --广告事件 参考 Common里面的AD_EVENTS
    adType  =  2,--	int32 adType , --广告分类 参考 Common里面的AD_TYPE
    params  =  3,--	string params , --参数-adEvent不足以描述指定奖励事件
    id  =  6,--	int32  id , --广告id 对应 advertise的id 来源于推送广告数据里面的id 用于扣减广告次数时区分
}


 PB_AdStart_Res  =  {
}


