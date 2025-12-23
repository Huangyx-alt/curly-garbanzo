-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_ExtraItemInfo.proto",

 PB_BuyGrocery_Req  =  {
    id  =  1,-- int32  id , --杂货铺配置表grocery--商品id
}

 PB_BuyGrocery_Res  =  {
    id  =  1,-- int32  id , --小礼包id
    itemData  =  2,-- repeated PB_ItemInfo ,--最终 获取的物品或资源 id,数量
    payType  =  3,-- int32 payType , --支付类型
    price  =  4,-- double price , --商品价格
    pid  =  5,-- string pid , --订单号
    baseItem  =  6,-- repeated PB_ItemInfo ,--基础 获取的物品或资源 id,数量
    extraItem  =  7,-- repeated PB_ExtraItemInfo ,--额外获取的 物品或资源 id,数量
    payExtra  =  8,-- string payExtra , -- 额外参数
}