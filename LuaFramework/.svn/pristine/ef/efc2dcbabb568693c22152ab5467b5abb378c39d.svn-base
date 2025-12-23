-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_NumberItemInfo.proto",
-- import"PB_ItemEffectData.proto",

 PB_BingoGameCardInfo  =  {
    cardId                                    =  1,-- int32 cardId , -- 卡牌ID
    numbers                          =  2,-- repeated int32  , -- 顺序-从左上角向下遍历-再向右同理 25个号码
    beginMarkedPos                   =  3,-- repeated int32  , -- 初始已经盖章坐标数组
    cardReward                 =  4,-- repeated PB_ItemInfo , -- 卡牌角标奖励
    cardNumberReward     =  5,-- repeated PB_NumberItemInfo , -- 奖励绑定，号码
    beginEffectData     =  6,-- repeated PB_BeginEffectData , -- 初始物品效果数据
}

 PB_BeginEffectData  =  {
    number                                    =  1,-- int32 number , -- 对应数字
    effectData           =  2,-- repeated PB_ItemEffectData , -- 效果数据
}