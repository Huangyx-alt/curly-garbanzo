-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_EndlessGiftClaim_Req  =  {
    giftId  =  1,-- int32 giftId , -- gift_id
    step  =  2,-- int32 step , --领取的阶段，取fetch的返回值
}

 PB_EndlessGiftClaim_Res  =  {
    step  =  1,-- int32 step , --最新step
    reward  =  2,-- repeated PB_ItemInfo ,--奖励数值
}