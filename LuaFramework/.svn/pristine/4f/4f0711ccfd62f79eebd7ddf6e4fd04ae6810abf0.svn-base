-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_CardPosInfo.proto",
-- import"PB_ItemEffectData.proto",

 PB_BingoGameSettle_Res  =  {
    gameId                                =  1,-- string gameId , -- 游戏ID
    chips                                  =  2,-- int32 chips , -- 最终奖励数量，金币
    settleType                             =  3,-- int32 settleType , -- 结束模式 0-正常结束，1-主动提前结束
    cardInfo          =  4,-- repeated PB_SettleCardInfo , -- 结算卡牌信息
    luckyBang                   =  5,-- PB_LuckyBangInfo luckyBang , -- LuckyBang 数据
    cardReward      =  6,-- repeated PB_SettleCardReward , -- 卡牌奖励数据
    chestReward          =  7,-- repeated PB_ChestReward , -- 宝箱奖励数据
    allItemReward           =  8,-- repeated PB_ItemInfo , -- 所有物品奖励，无双倍数据
    showItemReward          =  9,-- repeated PB_ItemInfo , -- 展示物品信息，无双倍数据
    doubleReward    =  1,-- repeated PB_DoubleItemReward 0, -- 双倍奖励信息
    pieceReward             =  1,-- repeated PB_ItemInfo 1, -- 拼图碎片信息
    extra                                 =  1,-- string extra 2, -- 额外拓展数据 json格式
}

-- 结算卡牌数据
 PB_SettleCardInfo  =  {
    cardId                                 =  1,-- int32 cardId , -- 卡牌ID
    numbers                       =  2,-- repeated int32  , -- 顺序-从左上角向下遍历-再向右同理 25个号码
    beginMarkedPos                =  3,-- repeated int32  , -- 初始已经盖章坐标数组
    cardPos              =  4,-- repeated PB_CardPosInfo , -- 卡牌位置数据
    cardReward              =  5,-- repeated PB_ItemInfo , -- 卡牌角标奖励
    effectData      =  6,-- repeated PB_SettleEffectData , -- 物品效果数据
}

-- 结算效果数据
 PB_SettleEffectData  =  {
    number                                 =  1,-- int32 number , -- 对应数字
    effectData        =  2,-- repeated PB_ItemEffectData , -- 效果数据
}

-- LuckyBang 数据
 PB_LuckyBangInfo  =  {
    numbers                       =  1,-- repeated int32  , -- 对局奖励叫号
    extraNumbers                  =  2,-- repeated int32  , -- 额外触发的奖励叫号
}

-- 结算奖励
 PB_SettleCardReward  =  {
    cardId                                 =  1,-- int32 cardId , -- 卡牌ID
    daubCoins                              =  2,-- int32 daubCoins , -- 盖章奖励金币
    bingoAwards     =  3,-- repeated PB_SettleBingoAward , -- bingo 奖励
}

 PB_SettleBingoAward  =  {
    bingoNum                               =  1,-- int32 bingoNum , -- Bingo 数量
    content                                =  2,-- int32 content , -- 奖励数值
    layerNum                               =  3,-- int32 layerNum , -- 层度，用于特殊场景下，某个递进关系
}

-- 宝箱奖励
 PB_ChestReward  =  {
    chestId                                =  1,-- int32 chestId , -- 宝箱ID
    chestLevel                             =  2,-- int32 chestLevel , -- 宝箱等级
    reward                  =  3,-- repeated PB_ItemInfo , -- 奖励信息
}

-- 双倍物品触发奖励更新
 PB_DoubleItemReward  =  {
    itemId                                 =  1,-- int32 itemId , -- 双倍物品ID
    reward                           =  2,-- PB_ItemInfo reward , -- 更新后的奖励数据
}