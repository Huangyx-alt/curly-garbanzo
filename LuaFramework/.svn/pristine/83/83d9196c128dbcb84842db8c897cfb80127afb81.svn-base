-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubBingoCardNumberData.proto",
-- import"PB_ClubHelperData.proto",
-- import"PB_ItemInfo.proto",


--club卡面数据
 PB_ClubBingoCard_Req  =  {
}
 PB_ClubBingoCard_Res  =  {
    clubBingoCardNumberData = 1,-- repeated PB_ClubBingoCardNumberData ,-- 卡号码数据
    leftCallBalls  =  2,-- repeated int32  ,--剩余可以用叫号球
    clubHelperData = 3,-- repeated PB_ClubHelperData ,-- 卡号码数据 顺序【和loadGame一致】： 左列到右列，上到下
    full  =  4,-- bool full ,--是否全部盖满
    rewarded  =  5,-- bool rewarded ,--是否已经领奖
    avatar  =  6,-- repeated string ,--剩余可以用叫号球
    reward  = 7,-- repeated PB_ItemInfo , -- 奖励信息
}