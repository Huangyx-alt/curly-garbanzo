-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_CardRocket  =  {
    cardId  =  1,-- int32 cardId ,                     --卡牌ID
    pos  = 2,-- repeated int32  ,  --小火箭直接盖章坐标集合
    extraPos  = 3,-- repeated int32  ,--无固定图案宠物技能-坐标额外盖章坐标集合 int 前两位为投放坐标-后面两位两位截取作为额外盖章坐标集合

}