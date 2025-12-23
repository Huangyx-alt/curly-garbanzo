-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_CardMarkedPos  =  {
    pos   =  1,-- int32  pos ,                     -- 格子坐标 11,22,33
    itemReward  =  2,-- repeated PB_ItemInfo , -- 格子奖励
    mark   =  3,-- int32  mark ,                    -- 盖章方式 0 = 叫号 powerUpId = powerUp盖章的powerUpId  9 = 小火箭
}


