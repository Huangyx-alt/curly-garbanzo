-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_GameGoldTrainSettle_Req  =  {
}

 PB_GameGoldTrainSettle_Res  =  {
    rewardRange  =  1,-- int32 rewardRange ,                          --结算系数
    settleInfo  =  2,-- repeated PB_TrainSettleInfo ,     --结算数据
    allRewardValue  =  3,-- int32 allRewardValue ,                       --全部奖励总值(系数)
    allRewardCoin  =  4,-- int32 allRewardCoin ,                        --全部奖励总值(金币)
}

 PB_TrainSettleInfo  =  {
    cardId  =  1,-- int32 cardId ,                               --卡片ID
    bingoPath  =  2,-- repeated int32  ,     --达成bingo的ruleId，按照bingo顺序
    markedPos  =  3,-- repeated PB_TrainMarkedPos ,       --已盖章位置
    pathReward  =  4,-- repeated PB_TrainBingoPathReward ,--路径奖励计算
    baseRewardRange  =  5,-- int32 baseRewardRange ,                      --火车头奖励值，最终
    allRewardCoin  =  6,-- int32 allRewardCoin ,                        --当前卡全部奖励总值(金币)
}

 PB_TrainMarkedPos  =  {
    pos   =  1,-- int32 pos ,                                 --格子坐标
    itemReward  =  2,-- repeated PB_ItemInfo ,            --格子奖励，只保留了 双倍与Mini
    rewardValue  =  3,-- int32 rewardValue ,                          --奖励值(系数)
    extRewardValue  =  4,-- int32 extRewardValue ,                       --奖励事件，触发的奖励增值(系数)
}

 PB_TrainBingoPathReward  =  {
    bingoPath  =  1,-- int32 bingoPath ,                            --bingo的ruleId
    rewardValue  =  2,-- int32 rewardValue ,                          --当前ruleId中奖值(系数)
    allRewardValue  =  3,-- int32 allRewardValue ,                       --合并后的全部奖励(系数)
    markedPos  =  4,-- repeated PB_TrainMarkedPos ,       --bonus位置，用于计算
}