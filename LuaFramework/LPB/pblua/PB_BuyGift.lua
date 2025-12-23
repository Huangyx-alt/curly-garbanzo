-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_ExtraItemInfo.proto",

 PB_BuyGift_Req  =  {
    giftId  =  1,-- int32  giftId , --大礼包id
    id  =  2,-- int32  id , --小礼包id
}

 PB_BuyGift_Res  =  {
    giftId  =  1,-- int32  giftId , --大礼包id
    id  =  2,-- int32  id , --小礼包id
    itemData  =  4,-- repeated PB_ItemInfo ,--最终 获取的物品或资源 id,数量
    --int64 count  =  5, --购买数量
    payType  =  6,-- int32 payType , --支付类型
    price  =  7,-- double price , --商品价格
    pid  =  8,-- string pid , --订单号
    baseItem  =  9,-- repeated PB_ItemInfo ,--基础 获取的物品或资源 id,数量
    extraItem  =  1,-- repeated PB_ExtraItemInfo 0,--额外获取的 物品或资源 id,数量
    int32step  =  1,-- int32	step 1, --无限礼包步数
    payExtra  =  1,-- string payExtra 2, -- 额外参数
}