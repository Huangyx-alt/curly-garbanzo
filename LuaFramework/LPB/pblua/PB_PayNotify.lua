-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_PayNotify_Req  =  {
    pid  =  1,-- string pid , --内部订单号
    orderId  =  2,-- string orderId , --外部订单号
    payChannel  =  3,-- int32 payChannel , --支付渠道
    payParams  =  4,-- string payParams , --支付参数
}

 PB_PayNotify_Res  =  {
    pid  =  1,-- string pid , --内部订单号
    channel  =  2,-- int32 channel , --支付渠道
    index  =  3,-- string index , --商品索引
    sku  =  4,-- string sku , --商品sku
    itemId  =  5,-- string itemId , --物品ID
    count  =  6,-- int32 count , --获得物品数量
    reward  =  7,-- repeated PB_ItemInfo ,--获取的奖励--做展示用
}