-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_EndlessGiftFetch_Req  =  {
    giftId  =  1,-- int32 giftId , -- gift_id
}

 PB_EndlessGiftFetch_Res  =  {
    gift_id  =  1,-- int32 gift_id , -- 对应pop_up_infinite里的gift_id
    step  =  2,-- int32 step , -- 对应pop_up_infinite里的step
    status  =  3,-- int32 status , -- 0不能领取（需要购买） 1可领取
    expire_time  =  4,-- int32 expire_time , -- 礼包过期时间（对应配置里的结束时间）
}