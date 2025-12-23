-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SevenSign.proto",
-- import"PB_SevenSignProgress.proto",
-- import"PB_ItemInfo.proto",

 PB_SevenSignState  =  {
    sevenSignList                  =  1,-- repeated PB_SevenSign ,--七天签到状态数据 前端据此可计算是否有签到奖励
    sevenSignProgressList  =  2,--	repeated PB_SevenSignProgress ,--七天签到进度目标数据 前端据此可计算是否有进度奖励
    sevenSignProgress                              =  3,--	int32 sevenSignProgress ,--进度累计值
    hasHistoryReward                               =  4,--	int32 hasHistoryReward ,--是否有未领取的历史奖励 0-没有【默认值】  1-有
    historyReward                            =  5,--	repeated PB_ItemInfo ,--未领取的历史奖励
}

