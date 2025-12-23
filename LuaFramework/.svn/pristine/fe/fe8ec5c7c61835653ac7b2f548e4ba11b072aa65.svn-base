-- syntax =  "proto3",
-- packageGPBClass.Message,

 PB_SeasonMain_Req  =  {
}

 PB_SeasonMain_Res  =  {
    seasonId                       = 1,-- int32 seasonId ,--赛季ID，根据这个来读取支付信息
    endTime                        = 2,-- int32 endTime ,--赛季结束时间，时间戳
    payInfo             = 3,-- repeated PayItem ,--赛季支付信息
    isPay                          = 4,-- int32 isPay ,--是否已付费  0未付费  1已付费
    canDiamondUp                   = 5,-- int32 canDiamondUp ,--是否可钻石升级  0不可以  1可以
    free                  = 6,-- repeated int32  ,--免费奖励可领取，无可领取 即为空  等级ID的集合
    freeReceived          = 7,-- repeated int32  ,--免费奖励已领取，无已领取 即为空  等级ID的集合
    pay                   = 8,-- repeated int32  ,--付费奖励可领取，无可领取 即为空  等级ID的集合
    payReceived           = 9,-- repeated int32  ,--付费奖励已领取，无已领取 即为空  等级ID的集合
    code                           = 1,-- int32 code 0,--错误码 0成功，其他是吧
    string                        = 11,--错误提示
    seasonInfo                = 1,-- seasonInfo seasonInfo 2,--赛季配置内容（前端用）
    isSeasonOpen                 = 1,-- bool isSeasonOpen 3,--赛季是否开启
    isNTF                       = 1,-- bool isNTF 4,--是否是推送消息
    booster                    = 1,-- int32 booster 5,--经验加成
}

 PayItem  =  {
    itemId                    = 1,-- int32 itemId ,--购买标识id，区分 4.99为1  9.99为2  5.00为3
    isPay                     = 2,-- int32 isPay ,--是否已购买  0未购买  1已购买
}
 seasonInfo  =  {
    price1                    = 1,-- string price1 ,--购买价格1(前端转换一下格式，协议传输会有多位小数)
    productId1                 = 2,-- int32 productId1 ,--购买产品id1
    priceItem1                = 3,-- string priceItem1 ,--购买内容1
    price2                    = 4,-- string price2 ,--购买价格2(前端转换一下格式，协议传输会有多位小数)
    productId2                 = 5,-- int32 productId2 ,--购买产品id2
    priceItem2                = 6,-- string priceItem2 ,--购买内容2
    payDifference             = 7,-- string payDifference ,--购买价格3(前端转换一下格式，协议传输会有多位小数)
    productDifference          = 8,-- int32 productDifference ,--购买产品id3
    priceItem3                = 9,-- string priceItem3 ,--购买内容3
    description1               = 1,-- int32 description1 0,--付费令牌值多少钱
    description2               = 1,-- int32 description2 1,--付费令牌增加多少等级
    offTime                    = 1,-- int32 offTime 2,--配置打折时间（小时）
}