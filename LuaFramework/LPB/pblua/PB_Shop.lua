-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ShopItems.proto",

 PB_Shop_Req  =  {
    index  =  1,-- int32  index , --商店类型 就是页签 从1开始
}

 PB_Shop_Res  =  {
    index  =  1,-- int32  index ,
    top  =  2,-- repeated PB_ShopItems ,
    main  =  3,-- repeated PB_ShopItems ,
    redDot  =  4,-- int32  redDot ,  -- 红点数量
    promoInfo  =  5,-- PB_PromoInfo promoInfo , -- 促销活动
}

-- 促销活动信息
 PB_PromoInfo  =  {
    promoName  =  1,-- string promoName , -- 促销活动名称
    endTime  =  2,-- int64 endTime ,    -- 促销结束时间
}