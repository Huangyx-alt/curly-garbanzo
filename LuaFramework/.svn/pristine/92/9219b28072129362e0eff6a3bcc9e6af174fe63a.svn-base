-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ResourceInfo.proto",

--*******获取/推送 倒计时、奖励、可能操作***********--
 PB_HangUpReceiveCountdown_Req  =  {
}
 PB_HangUpReceiveCountdown_Res  =  {
    countdown  =  1,-- int32 countdown , 				           --倒计时为0时客户端可以进行领取奖励 -1表示该等级没有配置离线奖励不显示倒计时和奖励显示
    totalRewardShow  =  1,-- repeated PB_ResourceInfo 4, --离线挂机收益展示 目前仅一个元素 取第一个展示即可 id用于取对应资源图标，value显示数字
    useTypes  =  2,-- repeated int32  ,     --可能的操作 0-默认等待间隔cd 1-cd期看广告AD_EVENT_OFFLINE_KIP_CD跳过cd 2-非cd期看广告AD_EVENT_OFFLINE_MORE_REWARD之后领取更多金币 3-cd期消耗钻石跳过cd 4-非cd期消耗钻石获取更多奖励
}