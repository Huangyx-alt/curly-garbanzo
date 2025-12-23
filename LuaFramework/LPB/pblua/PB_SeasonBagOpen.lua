-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_SeasonBagOpen_Res  =  {
    seasonBoxList  =  1,-- repeated PB_SeasonBoxInfo , -- 打开卡包列表
}

 PB_SeasonBoxInfo  =  {
    bagID  =  1,-- string bagID , -- 卡包id
    cardList  =  2,-- repeated PB_CardInfo , -- 卡片列表
}

 PB_CardInfo  =  {
    num  =  1,-- int32 num , --卡片数量
    cardID  =  2,-- string cardID , -- 卡片ID
}