-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemEffectData.proto",

 PB_PowerUpListData  =  {
    powerUpIds                  =  1,-- repeated int32  , -- PUId 列表数据，顺序
    powerUpList        =  2,-- repeated PB_PowerUpInfo , -- PU 列表信息
}

 PB_PowerUpInfo  =  {
    powerUpId                            =  1,-- int32 powerUpId , -- PUId
    diamondUse                           =  2,-- int32 diamondUse , -- 钻石消耗值
    powerUpAcc                           =  3,-- int32 powerUpAcc , -- 充能要求
    cardEffect   =  4,-- repeated PB_PowerUpCardEffect , -- 卡牌效果
}

 PB_PowerUpCardEffect  =  {
    cardId                               =  1,-- int32 cardId , -- 卡牌ID
    effectData               =  2,-- PB_ItemEffectData effectData , -- 效果数据
}

