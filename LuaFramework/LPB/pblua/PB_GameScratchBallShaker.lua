-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_GameScratchBallShaker_Req  =  {
}

 PB_GameScratchBallShaker_Res  =  {
    gameId                              =  1,-- string gameId ,    --游戏id
    bingoReward        =  2,-- repeated PB_BingoReward ,    --bingo奖励信息
    shakerBall          =  3,-- repeated PB_ShakerBall ,    --叫球顺序
    cardInfo        =  4,-- repeated PB_ShakerCardInfo ,    --卡片信息
}

 PB_BingoReward  =  {
    itemId   =  1,-- int32 itemId ,    --物品Id
    reward  =  2,-- int32 reward ,     --奖励值
}

 PB_ShakerBall  =  {
    index  =  1,-- int32 index ,      --叫球序号
    number  =  2,-- int32 number ,     --出球数字
    spendCoin  =  3,-- int32 spendCoin ,  --花费金币
}

 PB_ShakerCardInfo  =  {
    cardId  =  1,-- int32 cardId ,                               --卡片ID
    numbers  =  2,-- repeated int32 ,        --顺序-从左上角向下遍历-再向右同理 25个号码
    cardItem  =  3,-- repeated PB_ShakerCardNumberItem ,  --卡片元素信息
}

 PB_ShakerCardNumberItem  =  {
    number  =  1,-- int32 number ,                       --数字
    pos  =  2,-- int32 pos ,                          --位置
    cardReward  =  3,-- repeated PB_ItemInfo ,    --奖励信息
    isMarked  =  4,-- bool isMarked ,                      --是否盖章
}