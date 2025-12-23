-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_Marked.proto",
-- import"PB_SettleRank.proto",
-- import"PB_SettleAward.proto",
-- import"PB_GroupSettleReward.proto",
-- import"PB_ItemIdShowDouble.proto",

 PB_GameCommonSettle_Req  =  {
}
--*******Bingo游戏结算***********--
 PB_GameCommonSettle_Res  =  {
    gameId  =  1,-- string gameId , 						          --游戏ID
    chips  =  2,-- int32 chips , 						          --标题显示总奖励数量
    reward  =  3,-- repeated PB_ItemInfo  ,		          --游戏获取的最终全部奖励-不包括bingo框【tips】-快速奖励框【fastMarkReward】-完美奖励框【perfectMarkReward】
    fastMarkReward  =  4,-- repeated PB_ItemInfo  ,		  --快速点击奖励
    perfectMarkReward  =  5,-- repeated PB_ItemInfo  ,      --完美点击奖励
    ranks  =  6,-- repeated PB_SettleRank ,			      --排名
    tips  =  7,-- repeated PB_SettleAward ,			      --bingo奖励提示
    settleType  =  8,-- int32 settleType ,							  --结束模式 0正常结束  1 主动结束
    marked  =  9,-- repeated PB_Marked ,                    --涂抹数字
    totalBingoCount  =  1,-- int32 totalBingoCount 0,					      --总bingo数量
    groupSettleReward  =  1,-- PB_GroupSettleReward groupSettleReward 1,	  --分组奖励展示
    showDouble  =  1,-- repeated PB_ItemIdShowDouble 2,     --itemId是否有double标识
    ext  =  1,-- string ext 3, 						          --额外拓展数据 json格式
    bonusesReward  =  1,-- repeated PB_ItemInfo 4 ,         --bonuses区域奖励
    hasJokerMoreCoins  =  1,-- bool hasJokerMoreCoins 5,					  --是否获取到joker更多【双倍】金币
}
