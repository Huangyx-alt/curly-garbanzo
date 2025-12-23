-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubPlayerInfo.proto",

--club卡面号码关联数据
 PB_ClubBingoCardNumberData  =  {
    number  =  1,-- int32 number ,--号码
    marked  =  2,-- int32 marked ,--0-未盖章
    info = 3,-- PB_ClubPlayerInfo info ,
}