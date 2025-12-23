-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_MiniGameBoxLayerList.proto",


 PB_MiniGameBoxLayerState  =  {
    miniGameId                                =  1,-- int32 miniGameId  ,--miniGameId
    layerNo                                   =  2,-- int32 layerNo  ,--当前第几层
    status                                   =  3,--	int32  status  ,--0-还未点击 1-已经点击
    isEnd                                     =  4,--	bool  isEnd  ,--是否最后一个
    groupReward                =  5,--	repeated PB_ItemInfo  ,--显示奖励列表-多选一
    hitGroupRewardIndex                       =  6,--	int32 hitGroupRewardIndex  ,--显示奖励中: 前置给出命中下标0-X
    grandPrize                                =  7,--	int32 grandPrize  ,--程序计算的最终额外大奖【后端计算得出数值-固定金币】-只有开完最后一层【非小偷】才可以领取
    banishThiefMethod          =  8,--	repeated PB_ItemInfo  ,--可选的 驱逐小偷方式： 空-无法驱赶,子值id：0-广告，1-钻石,-1-免费  value 表示花费数值
    extraReward                =  9,--	repeated PB_ItemInfo  ,--额外奖励
    layerList      =  1,--	repeated PB_MiniGameBoxLayerList 0 ,--全部层展示
    collectReward              =  1,--	repeated PB_ItemInfo 1 ,--累计收集奖励
    rewarded                                  =  1,--	bool  rewarded 2 ,--是否已领取层奖励
    fullUnix                                  =  1,--	int32 fullUnix 3 ,--miniGameId 完成进度的时间戳 以区分多次不同时间 完成进度进入box
    isStole                                   =  1,--	bool  isStole 4 ,--是否被偷
    bigRewarded                               =  1,--	bool  bigRewarded 5 ,--是否已领取大奖奖励【到最后一层 才会用到grandPrize】
    hasNextRound                              =  1,--	bool  hasNextRound 6 ,--是否有下一轮
    layerGreatRewardIndex                     =  1,--	int32 layerGreatRewardIndex 7 ,--当前层哪个奖励是great-groupReward里面的下标
	
    
}