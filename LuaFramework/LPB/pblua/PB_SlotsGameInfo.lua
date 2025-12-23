-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_SlotsGameInfo  =  {
    elements  =  1,-- repeated PB_SlotsElement , --命中的元素列表
    spinSpend  =  2,-- repeated PB_SlotsSpinSpend , -- spin消耗资源
    jackpotWinCoin  =  3,-- int64 jackpotWinCoin ,       -- Jackpot 奖励值
    winList  =  4,-- repeated PB_PigTypeWinCoin ,   -- 奖励列表
}

 PB_SlotsElement  =  {
    col  =  1,-- int32 col ,                  --元素所在列
    row  =  2,-- int32 row ,                  --元素所在行
    value  =  3,-- string value ,               --附带值（可能包含多个值，逗号分隔）
    elementId  =  4,-- int32 elementId ,            --元素ID
}

 PB_SlotsSpinSpend  =  {
    index  =  1,-- int32 index ,                -- spin索引
    consume  =  2,-- int32 consume ,              -- 消耗值
}

 PB_PigTypeWinCoin  =  {
    pigType  =  1,-- int32 pigType ,              -- 元素类型，1-1*1 2-1*2 3-1*3 4-2*3
    winCoin  =  2,-- int32 winCoin ,              -- 奖励金币值
}