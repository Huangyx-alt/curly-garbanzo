-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_TaskInfo.proto",

 PB_ShortSeasonPassFetch_Req  =  {

}

 PB_ShortSeasonPassFetch_Res  =  {
    pass  =  1,-- repeated PB_ShortSeasonPassInfo , -- 短令牌通行证
}

 PB_ShortSeasonPassInfo  =  {
    playId  =  1,-- int32 playId ,--玩法Id
    endTime  =  2,-- int32 endTime ,--赛季结束时间，时间戳
    payInfo  =  3,-- repeated PB_PayItem ,--赛季支付信息
    isPay  =  4,-- int32 isPay ,--是否已付费  0未付费  1已付费
    canDiamondUp  =  5,-- int32 canDiamondUp ,--是否可钻石升级  0不可以  1可以
    free  =  6,-- repeated int32  [packed  =  true],--免费奖励可领取，无可领取 即为空  等级ID的集合
    freeReceived  =  7,-- repeated int32  [packed  =  true],--免费奖励已领取，无已领取 即为空  等级ID的集合
    pay  =  8,-- repeated int32  [packed  =  true],--付费奖励可领取，无可领取 即为空  等级ID的集合
    payReceived  =  9,-- repeated int32  [packed  =  true],--付费奖励已领取，无已领取 即为空  等级ID的集合
    code  =  1,-- int32 code 0,--错误码 0成功，其他是吧
    string   =  11,--错误提示
    seasonInfo  =  1,-- PB_seasonInfo seasonInfo 2,--赛季配置内容（前端用）
    tasks  =  1,-- repeated PB_TaskInfo 3, -- 每日任务
}

 PB_PayItem  =  {
    itemId  =  1,-- int32 itemId ,--购买标识id，区分 4.99为1  9.99为2  5.00为3
    isPay  =  2,-- int32 isPay ,--是否已购买  0未购买  1已购买
}
 PB_seasonInfo  =  {
    price  =  1,-- string price ,--购买价格(前端转换一下格式，协议传输会有多位小数)
    productId  =  2,-- int32 productId ,--购买产品id
    priceItem  =  3,-- string priceItem ,--购买内容
}