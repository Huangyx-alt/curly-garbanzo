-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_GameCardInfo.proto",
-- import"PB_PowerUpData.proto",
-- import"PB_CardPos.proto",
-- import"PB_GroupBagOpenItem.proto",
-- import"PB_ItemInfo.proto",

--****** 主玩法-gameLoad *********--
 PB_GameLoadSynthesiseSingle_Req  =  {
    cardNum             =  1,-- int32 cardNum ,--卡片数量
    rate                =  2,-- int32 rate ,--倍率
    cityId              =  3,-- int32 cityId ,--城市ID
    powerUpId           =  4,-- int64 powerUpId ,--powerUpId
    couponId            =  5,-- int32 couponId ,--优惠券id 保留
    useCouponId        =  6,-- string useCouponId ,--使用优惠券的唯一id
    playId              =  7,-- int32 playId ,--城市内玩法入口id = city_play表id
    hideCardAuto        =  8,-- int32 hideCardAuto ,--是否开启隐藏卡牌自动盖章-额外消耗 0-不开启 1-开启
}

 PB_GameLoadSynthesiseSingle_Res  =  {
    gameId                                       =  1,-- string gameId ,--游戏id
    cardsInfo                  =  2,--	repeated PB_GameCardInfo ,--所有bingo棋盘
    jackpot                              =  3,--	repeated int32  ,--每张卡是否可形成jackPot 0,1
    bingoLeft                                     =  4,--	int32 bingoLeft ,--剩余bingos数量
    powerUps                             =  5,--	repeated int32  ,--游戏可用powerUps 暂时保留后续使用-powerUpData
    hintTime                                      =  6,--	int32 hintTime ,--服务器hintTime结束时间戳
    systemTime                                    =  7,--	int32 systemTime ,--服务器当前时间戳
    spendResourceId                               =  8,--	int32 spendResourceId ,--游戏开始所需资源id
    rewardResourceId                              =  9,--	int32 rewardResourceId ,--游戏结算主要产出资源id-第一行和第三行
    callCd                                        =  1,--	int32 callCd 0,--服务器叫号间隔
    collectIds                           =  1,-- repeated int32 1 ,--所有可能收集的物品资源id数组
    publishNumbers                       =  1,--	repeated int32 2 ,--叫号号码-目前客户端不使用
    type                                          =  1,--	int32 type 3,--0是正常游戏，非0为新手引导id
    bingoRuleId                          =  1,--	repeated int32 4 ,--卡面bingo判断规则id
    jackpotRuleId                        =  1,--	repeated int32 5 ,--卡面jackpot判断规则id
    bingoLeftTick                        =  1,--	repeated int32 6 ,--扣减时间线 客户端 按照游戏间隔换算 单位：1/100秒
    robotIds                             =  1,--	repeated int32 7 ,--robotIds集合
    powerUpData                 =  1,--	repeated PB_PowerUpData 8,--所有powerUp数据
    cardCallHitPos                  =  1,--	repeated PB_CardPos 9,--区分卡-所有叫号命中坐标
    cardAllHitPos                   =  2,--	repeated PB_CardPos 0,--区分卡-所有可能命中坐标
    bingoMax                                      =  2,--	int32 bingoMax 1,--最大总bingo数-用于前端随机限制
    powerUpCd                                     =  2,--	float powerUpCd 2,--powerUp使用cd
    powerUpAcc                                    =  2,--	int32 powerUpAcc 3,--powerUp充能满点
    mixCallNumbers                       =  2,--	repeated int32 4 ,--可选混淆叫号
	--int32 hasJackpotReward                            =  25,--是否计算jackpot奖励及特效
    groupBagOpenItem       =  2,--	repeated PB_GroupBagOpenItem 6,--分组所有开美食篮子打开后的奖励,顺序获取-顺序打开
    activityStatus                 =  2,--	repeated PB_ItemInfo 7,--活动状态 id-活动id, value- 0 = 未开启,1 = 开启中
    ext                                          =  2,--	string ext 8,--拓展字段json格式
}
