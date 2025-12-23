-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_Marked.proto",
-- import"PB_SettleRank.proto",
-- import"PB_SettleAward.proto",
-- import"PB_GroupSettleReward.proto",

 PB_HangUpPreSettle_Req  =  {
    gameId  =  1,-- string gameId ,
}
--*******挂机游戏预结算***********--
 PB_HangUpPreSettle_Res  =  {
    gameId  =  1,-- string gameId , 						          --游戏ID
    chips  =  2,-- int32 chips , 						          --标题显示总奖励数量
    reward  =  3,--	repeated PB_ItemInfo  ,		          --游戏获取的最终全部奖励-不包括bingo框【tips】-快速奖励框【fastMarkReward】-完美奖励框【perfectMarkReward】
    fastMarkReward  =  4,--	repeated PB_ItemInfo  ,		  --快速点击奖励
    perfectMarkReward  =  5,--	repeated PB_ItemInfo  ,      --完美点击奖励
    ranks  =  6,--	repeated PB_SettleRank ,			      --结算排名
    tips  =  7,--	repeated PB_SettleAward ,			      --bingo奖励提示
    settleType  =  8,--	int32 settleType ,							  --结束模式 0正常结束  1 主动结束
    marked  =  9,--	repeated PB_Marked ,                    --涂抹数字
    totalBingoCount  =  1,--	int32 totalBingoCount 0,					      --总bingo数量
    groupSettleReward  =  1,--	PB_GroupSettleReward groupSettleReward 1,	  --分组奖励展示
}
