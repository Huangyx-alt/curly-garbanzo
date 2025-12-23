-- syntax =  "proto3",

-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_AdFinishReward_Req  =  {
    deviceId  =  1,--	string deviceId , --设备ID
    adId  =  2,--	string adId , --前端广告ID
    adSp  =  3,--	string adSp , --广告供应商
    adEvent  =  4,--	int32 adEvent , --广告事件 参考 Common里面的AD_EVENTS
    platform  =  5,--	int32  platform , --用户所属平台
    idfa  =  6,--	string idfa , --广告追踪ID
    version  =  7,-- string version , --客户端版本号
    params  =  8,--	string params , --参数-adEvent不足以描述指定奖励事件
    adType  =  9,--	int32  adType , --广告分类 参考 Common里面的AD_TYPE
    id  =  1,--	int32  id 0, --广告id 对应 advertise的id
}


 PB_AdFinishReward_Res  =  {
    adId  =  1,-- string adId , --前端广告ID
    adEvent  =  2,--	int32 adEvent , --广告事件
    rewarded  =  3,--	bool rewarded ,--是否获取奖励 实际奖励结果 主动推送方式进行
    reward  =  4,--	repeated PB_ItemInfo ,--奖励--前端展示用
    adType  =  9,--	int32  adType , --广告分类 参考 Common里面的AD_TYPE
}


