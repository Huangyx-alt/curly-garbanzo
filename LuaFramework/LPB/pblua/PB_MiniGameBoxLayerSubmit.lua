-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_MiniGameBoxLayerSubmit_Req  =  {
    miniGameId                                =  1,-- int32 miniGameId  ,--miniGameId
    fullUnix                                  =  2,--	int32 fullUnix  ,--miniGameId 满进度开始时间戳-以区分
    type                                      =  3,-- int32 type  ,--type:0-openBox【开奖励箱子（后端提前定，前端只改顺序展示），非小偷会触发后端推送新的当前层数据】,1-collect&quit【收集所有打开的宝箱累计奖励】,2-give up【开到小偷后选择中途退出】,3-赶走小偷【开到小偷后--非广告方式赶走小偷，广告走通用8002】
    subType                                   =  4,--	int32 subType  ,--附加参数: 当type = 0 时选择打开的箱子下标从0开始【基于PB_MiniGameBoxLayerState--groupReward】, 当type = 1 时 0-领取层奖励 1-领取大奖grandPrize, 当type = 3 时 赶走小偷 的消耗方式【基于PB_MiniGameBoxLayerState--banishThiefMethod】
    doubleReward                               =  5,--	bool doubleReward  ,--是否有双倍奖励 当 type = 1的时候 前端显示标签有双倍 则为true，否则为false  后端简单校验【有双倍标签 且和截至时间相差允许范围内就算双倍】
}

 PB_MiniGameBoxLayerSubmit_Res  =  {
    miniGameId                                =  1,-- int32 miniGameId  ,--miniGameId
    layerNo                                   =  2,-- int32 layerNo  ,--submit的时候在第几层
    status                                   =  3,--	int32  status  ,--0-还未点击 1-已经点击
    isEnd                                     =  4,--	bool  isEnd  ,--是否最后一个
    ifStole                                   =  5,--	bool  ifStole  ,--是否被小偷偷走
    collectReward              =  6,--	repeated PB_ItemInfo  ,--累计收集奖励
    fullUnix                                  =  7,--	int32 fullUnix  ,--miniGameId 满进度开始时间戳-以区分
    doubleReward                               =  8,--	bool doubleReward  ,--一般原样返回，除非请求参数有双倍 但是后端判断没通过
}