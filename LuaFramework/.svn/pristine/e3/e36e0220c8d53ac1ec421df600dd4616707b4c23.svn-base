-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_ExtraItemInfo.proto",

 PB_ShopBuyItem_Req  =  {
    shopItemId  =  1,-- int32  shopItemId , --商店商品id
}

 PB_ShopBuyItem_Res  =  {
    shopItemId  =  1,-- int32  shopItemId ,
    index  =  2,-- int32  index ,
    sku  =  3,-- string sku , --商品sku
    itemData  =  4,-- repeated PB_ItemInfo ,--最终 获取的物品或资源 id,数量
    count  =  5,-- int64 count , --购买数量
    payType  =  6,-- int32 payType , --支付类型
    price  =  7,-- double price , --商品价格
    pid  =  8,-- string pid , --订单号
    baseItem  =  9,-- repeated PB_ItemInfo ,--基础 获取的物品或资源 id,数量
    extraItem  =  1,-- repeated PB_ExtraItemInfo 0,--额外获取的 物品或资源 id,数量
    payExtra  =  1,-- string payExtra 1, -- 额外参数
}