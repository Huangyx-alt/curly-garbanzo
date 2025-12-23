-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_Marked.proto",
-- import"PB_SettleRank.proto",
-- import"PB_SettleAward.proto",
-- import"PB_GroupSettleReward.proto",
-- import"PB_CardRocket.proto",
-- import"PB_ItemIdShowDouble.proto",
-- import"PB_CardMarkedPos.proto",

 PB_GameCommonPreSettle_Req  =  {
    gameId  =  1,-- string gameId ,
}
--*******Bingo游戏预结算***********--
 PB_GameCommonPreSettle_Res  =  {
    gameId  =  1,-- string gameId , 						          --游戏ID
    chips  =  2,-- int32 chips , 						          --标题显示总奖励数量
    reward  =  3,-- repeated PB_ItemInfo  ,		          --游戏获取的最终全部奖励-不包括bingo框【tips】-快速奖励框【fastMarkReward】-完美奖励框【perfectMarkReward】
    fastMarkReward  =  4,-- repeated PB_ItemInfo  ,		  --快速点击奖励
    perfectMarkReward  =  5,-- repeated PB_ItemInfo  ,      --完美点击奖励
    ranks  =  6,-- repeated PB_SettleRank ,			      --结算排名
    tips  =  7,-- repeated PB_SettleAward ,			      --bingo奖励提示
    settleType  =  8,-- int32 settleType ,							  --结束模式 0正常结束  1 主动提前结束
    marked  =  9,-- repeated PB_Marked ,                    --涂抹数字
    totalBingoCount  =  1,-- int32 totalBingoCount 0,					      --总bingo数量
    groupSettleReward  =  1,-- PB_GroupSettleReward groupSettleReward 1,	  --分组奖励展示
    cardRocket  =  1,-- repeated PB_CardRocket 2,           --区分卡-小火箭盖章坐标数据
    rocketCanUse  =  1,-- repeated int32 3 ,   --0-看广告,1-钻石,9-小火箭--1.8新版本不再使用
    showDouble  =  1,-- repeated PB_ItemIdShowDouble 4,     --itemId是否有double标识
    rocketAdCanUseUnix  =  1,-- int32 rocketAdCanUseUnix 5,					  --小火箭可用时间戳 当前时间> = 此 表明过了cd期
    cardRocket2  =  1,-- repeated PB_CardRocket 6,          --区分卡-2次小火箭盖章坐标数据
    rocketCanUse2  =  1,-- repeated int32 7 ,  --1-钻石,9-小火箭--1.8新版本不再使用
    rocketAddItemPos  =  1,-- repeated RocketMarkPos 8,     --小火箭盖章 每张卡的 坐标+材料，有新材料投放才有数据
    rocketUseMethod  =  1,-- repeated PB_ItemInfo 9 ,		  --可使用小火箭的方式以及对应的花费数值【等价，只算单个方式的花费】 空-无法使用,子值id：0-广告,1-钻石,2-金币,9-小火箭  value 表示花费数值
    rocketUseMethod2  =  2,-- repeated PB_ItemInfo 0 ,      --可使用小火箭的方式以及对应的花费数值【等价，只算单个方式的花费】 空-无法使用,子值id：0-广告,1-钻石,2-金币,9-小火箭  value 表示花费数值
    ext  =  2,-- string ext 1, 						          --额外拓展数据 json格式
    bonusesReward  =  2,-- repeated PB_ItemInfo 2 ,         --bonuses区域奖励
    hasJokerMoreCoins  =  2,-- bool hasJokerMoreCoins 3,					  --是否获取到joker更多【双倍】金币
    rocketDiscount  =  2,-- repeated PB_ItemInfo 4,					  --小火箭折扣券信息，无折扣数据为空
}

 RocketMarkPos  =  {
    cardId  =  1,-- int32 cardId ,						                --卡牌ID
    cardMarkedPos  =  2,-- repeated PB_CardMarkedPos ,            --坐标+材料
}
