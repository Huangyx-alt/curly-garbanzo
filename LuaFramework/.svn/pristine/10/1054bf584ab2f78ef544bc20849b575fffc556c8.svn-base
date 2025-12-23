-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_CardMarkedPos.proto",
-- import"PB_CardNotMarkedPos.proto",

 PB_FinalCardInfo  =  {
    cardId  =  1,-- int32 cardId ,						                            -- 卡牌ID
    cardMarkedPos  =  2,-- repeated PB_CardMarkedPos ,            -- 盖章格子坐标(11,22,55……) 和 对应 普通道具奖励(id,value)
    cardReward  =  3,-- repeated PB_ItemInfo ,                    -- 卡牌角标-普通道具奖励(id,value) 没有奖励就传空
    cardNotMarkedPos  =  4,-- repeated PB_CardNotMarkedPos ,      -- 未盖章格子坐标(11,22,55……) 和 对应 普通道具奖励(id,value)
    bingoPath  =  6,-- repeated int32  ,             -- 达成bingo的ruleId，按照bingo顺序
}
