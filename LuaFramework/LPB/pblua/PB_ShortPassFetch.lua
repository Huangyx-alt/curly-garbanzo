-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_TaskInfo.proto",

 PB_ShortPassFetch_Req  =  {

}

 PB_ShortPassFetch_Res  =  {
    pass  =  1,-- repeated PB_ShortPassInfo , -- 短令牌通行证
    refreshTime  =  2,-- int32 refreshTime , -- 刷新时间
}

 PB_ShortPassInfo  =  {
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
    curPassId  =  1,-- int32 curPassId 3, --当前令牌进度Id
    exp  =  1,-- int32 exp 4, --当前令牌经验值
    tasks  =  1,-- repeated PB_TaskInfo 5, -- 每日任务
    hasReward  =  1,-- bool hasReward 6,--是否有未领取奖励  true有  false无
    rewards  =  1,-- repeated PB_PassRewards 7, --奖励配置下发
}

 PB_PassRewards  =  {
    level  =  1,-- int32 level ,
    exp  =  2,-- int32 exp ,
    sumExp  =  3,-- int32 sumExp ,
    diamond  =  4,-- int32 diamond ,
    freeReward  =  5,-- string freeReward ,
    freeRewardIcon  =  6,-- string freeRewardIcon ,
    payReward  =  7,-- string payReward ,
    payRewardIcon  =  8,-- string payRewardIcon ,
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